; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_1400025B0(i8* %rcx) local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %base_i16_ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %base_i16_ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:                                        ; preds = %entry
  %off_3C_ptr = getelementptr i8, i8* %baseptr, i64 60
  %off_3C_i32p = bitcast i8* %off_3C_ptr to i32*
  %e_lfanew = load i32, i32* %off_3C_i32p, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_ptr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %nt_sig_ptr = bitcast i8* %nt_ptr to i32*
  %nt_sig = load i32, i32* %nt_sig_ptr, align 4
  %is_pe = icmp eq i32 %nt_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:                                       ; preds = %check_pe
  %opt_magic_ptr8 = getelementptr i8, i8* %nt_ptr, i64 24
  %opt_magic_ptr16 = bitcast i8* %opt_magic_ptr8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr16, align 2
  %is_pe32p = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32p, label %cont1, label %ret0

cont1:                                           ; preds = %check_opt
  %numsec_ptr8 = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_ptr16 = bitcast i8* %numsec_ptr8 to i16*
  %numsec = load i16, i16* %numsec_ptr16, align 2
  %numsec_is_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_is_zero, label %ret0, label %cont2

cont2:                                           ; preds = %cont1
  %soh_ptr8 = getelementptr i8, i8* %nt_ptr, i64 20
  %soh_ptr16 = bitcast i8* %soh_ptr8 to i16*
  %soh16 = load i16, i16* %soh_ptr16, align 2
  %rcx_int = ptrtoint i8* %rcx to i64
  %base_int = ptrtoint i8* %baseptr to i64
  %rva = sub i64 %rcx_int, %base_int
  %soh_zext = zext i16 %soh16 to i64
  %first_sec_ptr_base = getelementptr i8, i8* %nt_ptr, i64 24
  %first_sec_ptr = getelementptr i8, i8* %first_sec_ptr_base, i64 %soh_zext
  %numsec_i32 = zext i16 %numsec to i32
  %numsec_i64 = zext i32 %numsec_i32 to i64
  %mul40 = mul i64 %numsec_i64, 40
  %end_ptr = getelementptr i8, i8* %first_sec_ptr, i64 %mul40
  br label %loop

loop:                                             ; preds = %loop_continue, %cont2
  %cur = phi i8* [ %first_sec_ptr, %cont2 ], [ %next, %loop_continue ]
  %cmp_done = icmp eq i8* %cur, %end_ptr
  br i1 %cmp_done, label %loop_end, label %in_loop

in_loop:                                          ; preds = %loop
  %va_ptr8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr32 = bitcast i8* %va_ptr8 to i32*
  %va = load i32, i32* %va_ptr32, align 4
  %va64 = zext i32 %va to i64
  %is_below_va = icmp ult i64 %rva, %va64
  br i1 %is_below_va, label %loop_continue, label %check_upper

check_upper:                                      ; preds = %in_loop
  %vs_ptr8 = getelementptr i8, i8* %cur, i64 8
  %vs_ptr32 = bitcast i8* %vs_ptr8 to i32*
  %vs = load i32, i32* %vs_ptr32, align 4
  %va_plus_vs32 = add i32 %va, %vs
  %va_plus_vs64 = zext i32 %va_plus_vs32 to i64
  %in_range = icmp ult i64 %rva, %va_plus_vs64
  br i1 %in_range, label %ret0, label %loop_continue

loop_continue:                                    ; preds = %check_upper, %in_loop
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

loop_end:                                         ; preds = %loop
  ret i32 0

ret0:                                             ; preds = %check_upper, %cont1, %check_opt, %check_pe, %entry
  ret i32 0
}