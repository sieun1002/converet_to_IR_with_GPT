; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002700()
declare i32 @sub_140002708(i8*, i8*, i32)

define i8* @sub_1400021B0(i8* %arg) {
entry:
  %call0 = call i64 @sub_140002700()
  %cmp0 = icmp ugt i64 %call0, 8
  br i1 %cmp0, label %ret_null, label %check_mz

check_mz:                                            ; preds = %entry
  %base = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %pe_setup, label %ret_null

pe_setup:                                            ; preds = %check_mz
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %base, i64 %e_lfanew_sext
  %sigptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sigptr, align 1
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %check_magic, label %ret_null

check_magic:                                         ; preds = %pe_setup
  %magic_ptr_i8 = getelementptr i8, i8* %pehdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %magic_ok = icmp eq i16 %magic, 523
  br i1 %magic_ok, label %check_nsects, label %ret_null

check_nsects:                                        ; preds = %check_magic
  %nsects_ptr_i8 = getelementptr i8, i8* %pehdr, i64 6
  %nsects_ptr = bitcast i8* %nsects_ptr_i8 to i16*
  %nsects = load i16, i16* %nsects_ptr, align 1
  %nsects_is_zero = icmp eq i16 %nsects, 0
  br i1 %nsects_is_zero, label %ret_null, label %calc_section_base

calc_section_base:                                   ; preds = %check_nsects
  %sizeopt_ptr_i8 = getelementptr i8, i8* %pehdr, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_ptr_i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt_ptr, align 1
  %sizeopt64 = zext i16 %sizeopt16 to i64
  %sect_base_off = add i64 %sizeopt64, 24
  %sect_base_ptr = getelementptr i8, i8* %pehdr, i64 %sect_base_off
  br label %loop

loop:                                                ; preds = %loop_next, %calc_section_base
  %idx = phi i32 [ 0, %calc_section_base ], [ %idx_next, %loop_next ]
  %sect_ptr = phi i8* [ %sect_base_ptr, %calc_section_base ], [ %sect_ptr_next, %loop_next ]
  %call1 = call i32 @sub_140002708(i8* %sect_ptr, i8* %arg, i32 8)
  %is_zero = icmp eq i32 %call1, 0
  br i1 %is_zero, label %return_found, label %loop_next

loop_next:                                           ; preds = %loop
  %nsects2_ptr_i8 = getelementptr i8, i8* %pehdr, i64 6
  %nsects2_ptr = bitcast i8* %nsects2_ptr_i8 to i16*
  %nsects2 = load i16, i16* %nsects2_ptr, align 1
  %idx_next = add i32 %idx, 1
  %sect_ptr_next = getelementptr i8, i8* %sect_ptr, i64 40
  %nsects2_z = zext i16 %nsects2 to i32
  %cond_loop = icmp ult i32 %idx_next, %nsects2_z
  br i1 %cond_loop, label %loop, label %ret_null

return_found:                                        ; preds = %loop
  ret i8* %sect_ptr

ret_null:                                            ; preds = %loop_next, %check_nsects, %check_magic, %pe_setup, %check_mz, %entry
  ret i8* null
}