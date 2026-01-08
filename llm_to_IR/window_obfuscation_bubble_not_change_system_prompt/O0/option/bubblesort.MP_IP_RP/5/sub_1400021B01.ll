; ModuleID = 'sub_1400021B0'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

declare i64 @sub_140002700()
declare i32 @sub_140002708(i8*, i8*, i32)

define i8* @sub_1400021B0(i8* %arg_rcx) {
entry:
  %call0 = call i64 @sub_140002700()
  %cmp0 = icmp ugt i64 %call0, 8
  br i1 %cmp0, label %fail, label %after_cmp8

after_cmp8:                                        ; preds = %entry
  %baseptr = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 2
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_nt, label %fail

check_nt:                                          ; preds = %after_cmp8
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_ptr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %nt_ptr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 4
  %cmp_pe = icmp eq i32 %pe_sig, 17744
  br i1 %cmp_pe, label %check_magic, label %fail

check_magic:                                       ; preds = %check_nt
  %magic_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 2
  %cmp_magic = icmp eq i16 %magic, 523
  br i1 %cmp_magic, label %check_numsec, label %fail

check_numsec:                                      ; preds = %check_magic
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec_val = load i16, i16* %numsec_ptr, align 2
  %is_zero = icmp eq i16 %numsec_val, 0
  br i1 %is_zero, label %fail, label %prep_loop

prep_loop:                                         ; preds = %check_numsec
  %size_opt_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %size_opt_ptr = bitcast i8* %size_opt_ptr_i8 to i16*
  %size_opt = load i16, i16* %size_opt_ptr, align 2
  %size_opt_zext = zext i16 %size_opt to i64
  %first_sec_base = getelementptr i8, i8* %nt_ptr, i64 24
  %first_sec_ptr = getelementptr i8, i8* %first_sec_base, i64 %size_opt_zext
  br label %loop

loop:                                              ; preds = %loop_continue, %prep_loop
  %rbx_current = phi i8* [ %first_sec_ptr, %prep_loop ], [ %rbx_next, %loop_continue ]
  %i = phi i32 [ 0, %prep_loop ], [ %i_next, %loop_continue ]
  %ret2 = call i32 @sub_140002708(i8* %rbx_current, i8* %arg_rcx, i32 8)
  %is_zero2 = icmp eq i32 %ret2, 0
  br i1 %is_zero2, label %ret_success, label %loop_post_test

ret_success:                                       ; preds = %loop
  ret i8* %rbx_current

loop_post_test:                                    ; preds = %loop
  %numsec_val2 = load i16, i16* %numsec_ptr, align 2
  %numsec2 = zext i16 %numsec_val2 to i32
  %i_next = add i32 %i, 1
  %cmp_jb = icmp ult i32 %i_next, %numsec2
  br i1 %cmp_jb, label %loop_continue, label %fail

loop_continue:                                     ; preds = %loop_post_test
  %rbx_next = getelementptr i8, i8* %rbx_current, i64 40
  br label %loop

fail:                                              ; preds = %loop_post_test, %check_numsec, %check_magic, %check_nt, %after_cmp8, %entry
  ret i8* null
}