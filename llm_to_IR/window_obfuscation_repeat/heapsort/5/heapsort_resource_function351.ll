; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i8* @sub_140002820(i64 %rva, i32 %idx) local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %base_mz_ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %base_mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

check_pe:                                            ; preds = %entry
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew = sext i32 %e_lfanew32 to i64
  %nt_ptr = getelementptr i8, i8* %baseptr, i64 %e_lfanew
  %nt_sig_ptr = bitcast i8* %nt_ptr to i32*
  %nt_sig = load i32, i32* %nt_sig_ptr, align 1
  %is_pe = icmp eq i32 %nt_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:                                         ; preds = %check_pe
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %check_dir, label %ret_null

check_dir:                                           ; preds = %check_magic
  %dir_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 144
  %dir_ptr = bitcast i8* %dir_ptr_i8 to i32*
  %dir_val = load i32, i32* %dir_ptr, align 1
  %dir_zero = icmp eq i32 %dir_val, 0
  br i1 %dir_zero, label %ret_null, label %check_sections

check_sections:                                      ; preds = %check_dir
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec = zext i16 %numsec16 to i32
  %numsec_zero = icmp eq i32 %numsec, 0
  br i1 %numsec_zero, label %ret_null, label %calc_section_table

calc_section_table:                                  ; preds = %check_sections
  %soh_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh = zext i16 %soh16 to i64
  %sect_table_i8_pre = getelementptr i8, i8* %nt_ptr, i64 24
  %sect_table_i8 = getelementptr i8, i8* %sect_table_i8_pre, i64 %soh
  %numsec64 = zext i32 %numsec to i64
  %numsecMul40 = mul nuw nsw i64 %numsec64, 40
  %end_ptr = getelementptr i8, i8* %sect_table_i8, i64 %numsecMul40
  br label %sect_loop

sect_loop:                                           ; preds = %sect_advance, %calc_section_table
  %cur_ptr = phi i8* [ %sect_table_i8, %calc_section_table ], [ %next_ptr, %sect_advance ]
  %va_ptr_i8 = getelementptr i8, i8* %cur_ptr, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %sect_advance, label %check_within

check_within:                                        ; preds = %sect_loop
  %vsize_ptr_i8 = getelementptr i8, i8* %cur_ptr, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %vsize64 = zext i32 %vsize32 to i64
  %endva = add i64 %va64, %vsize64
  %rva_lt_end = icmp ult i64 %rva, %endva
  br i1 %rva_lt_end, label %found_section, label %sect_advance

sect_advance:                                        ; preds = %check_within, %sect_loop
  %next_ptr = getelementptr i8, i8* %cur_ptr, i64 40
  %done = icmp eq i8* %next_ptr, %end_ptr
  br i1 %done, label %ret_null, label %sect_loop

found_section:                                       ; preds = %check_within
  %p_i8 = getelementptr i8, i8* %baseptr, i64 %rva
  br label %desc_loop

desc_loop:                                           ; preds = %desc_next, %found_section
  %p = phi i8* [ %p_i8, %found_section ], [ %p_next, %desc_next ]
  %idx_phi = phi i32 [ %idx, %found_section ], [ %idx_next, %desc_next ]
  %p_plus4 = getelementptr i8, i8* %p, i64 4
  %val4_ptr = bitcast i8* %p_plus4 to i32*
  %val4 = load i32, i32* %val4_ptr, align 1
  %is_val4_zero = icmp eq i32 %val4, 0
  br i1 %is_val4_zero, label %check_c_zero, label %check_idx

check_c_zero:                                        ; preds = %desc_loop
  %p_plusC = getelementptr i8, i8* %p, i64 12
  %valC_ptr = bitcast i8* %p_plusC to i32*
  %valC = load i32, i32* %valC_ptr, align 1
  %is_valC_zero = icmp eq i32 %valC, 0
  br i1 %is_valC_zero, label %ret_null, label %check_idx

check_idx:                                           ; preds = %check_c_zero, %desc_loop
  %idx_gt_zero = icmp sgt i32 %idx_phi, 0
  br i1 %idx_gt_zero, label %desc_next, label %return_value

desc_next:                                           ; preds = %check_idx
  %idx_next = add nsw i32 %idx_phi, -1
  %p_next = getelementptr i8, i8* %p, i64 20
  br label %desc_loop

return_value:                                        ; preds = %check_idx
  %p_plusC2 = getelementptr i8, i8* %p, i64 12
  %valC2_ptr = bitcast i8* %p_plusC2 to i32*
  %valC2 = load i32, i32* %valC2_ptr, align 1
  %valC2_64 = zext i32 %valC2 to i64
  %ret_ptr = getelementptr i8, i8* %baseptr, i64 %valC2_64
  ret i8* %ret_ptr

ret_null:                                            ; preds = %sect_advance, %check_sections, %check_dir, %check_magic, %check_pe, %check_c_zero, %entry
  ret i8* null
}