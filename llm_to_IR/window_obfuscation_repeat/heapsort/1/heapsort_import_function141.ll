; ModuleID = 'pe_section_check'
source_filename = "pe_section_check.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002610(i8* %p) local_unnamed_addr {
entry:
  %base_ptr_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr16 = bitcast i8* %base_ptr_ptr to i16*
  %mz_val = load i16, i16* %mz_ptr16, align 1
  %is_mz = icmp eq i16 %mz_val, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:                                           ; preds = %entry
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base_ptr_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_hdr = getelementptr i8, i8* %base_ptr_ptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %nt_hdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:                                        ; preds = %check_pe
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32p = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32p, label %prepare_loop, label %ret0

prepare_loop:                                       ; preds = %check_magic
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec = zext i16 %numsec16 to i32
  %has_secs = icmp ne i32 %numsec, 0
  br i1 %has_secs, label %continue_loop_setup, label %ret0

continue_loop_setup:                                ; preds = %prepare_loop
  %sizeopt_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_ptr_i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt_ptr, align 1
  %sizeopt32 = zext i16 %sizeopt16 to i32
  %sizeopt64 = zext i32 %sizeopt32 to i64
  %p_int = ptrtoint i8* %p to i64
  %base_int = ptrtoint i8* %base_ptr_ptr to i64
  %rva = sub i64 %p_int, %base_int
  %sect_start_pre = getelementptr i8, i8* %nt_hdr, i64 24
  %sect_start = getelementptr i8, i8* %sect_start_pre, i64 %sizeopt64
  %numsec_minus1 = add i32 %numsec, -1
  %mul5 = mul i32 %numsec_minus1, 5
  %mul5_64 = zext i32 %mul5 to i64
  %bytes_nminus1 = shl i64 %mul5_64, 3
  %end_minus1 = getelementptr i8, i8* %sect_start, i64 %bytes_nminus1
  %end_ptr = getelementptr i8, i8* %end_minus1, i64 40
  br label %loop

loop:                                               ; preds = %loop_continue, %continue_loop_setup
  %iter = phi i8* [ %sect_start, %continue_loop_setup ], [ %iter_next, %loop_continue ]
  %va_ptr_i8 = getelementptr i8, i8* %iter, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %loop_continue, label %check_in_section

check_in_section:                                   ; preds = %loop
  %vsize_ptr_i8 = getelementptr i8, i8* %iter, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %vsize64 = zext i32 %vsize32 to i64
  %va_plus_size = add i64 %va64, %vsize64
  %in_section = icmp ult i64 %rva, %va_plus_size
  br i1 %in_section, label %ret0, label %loop_continue

loop_continue:                                      ; preds = %check_in_section, %loop
  %iter_next = getelementptr i8, i8* %iter, i64 40
  %done = icmp eq i8* %iter_next, %end_ptr
  br i1 %done, label %ret0_end, label %loop

ret0_end:                                           ; preds = %loop_continue
  ret i32 0

ret0:                                               ; preds = %check_in_section, %prepare_loop, %check_magic, %check_pe, %entry
  ret i32 0
}