; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8**)*

declare void @sub_140001010()
declare void @sub_1400024E0()
declare i8* @signal(i32, i8*)

define void @sub_1400013E0() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %p, align 4
  call void @sub_140001010()
  ret void
}

define i32 @sub_140002080(i8** %rcx) {
entry:
  %rdx0 = load i8*, i8** %rcx, align 8
  %rdx_i32ptr = bitcast i8* %rdx0 to i32*
  %eax0 = load i32, i32* %rdx_i32ptr, align 4
  %and = and i32 %eax0, 553648127
  %cmp_cgc = icmp eq i32 %and, 541542723
  br i1 %cmp_cgc, label %checkflag, label %dispatch_pre

checkflag:                                        ; preds = %entry
  %rdx_plus4 = getelementptr i8, i8* %rdx0, i64 4
  %b = load i8, i8* %rdx_plus4, align 1
  %b1 = and i8 %b, 1
  %flag = icmp ne i8 %b1, 0
  br i1 %flag, label %dispatch_pre, label %ret_minus1

dispatch_pre:                                      ; preds = %checkflag, %entry
  %cmp_gt_0096 = icmp ugt i32 %eax0, 3221225622       ; 0xC0000096
  br i1 %cmp_gt_0096, label %translator_fallback, label %le_0096

le_0096:                                          ; preds = %dispatch_pre
  %cmp_le_008B = icmp ule i32 %eax0, 3221225611       ; 0xC000008B
  br i1 %cmp_le_008B, label %block_110, label %range_008C_0096

block_110:                                        ; preds = %le_0096
  %is_av = icmp eq i32 %eax0, 3221225477              ; 0xC0000005
  br i1 %is_av, label %sigsegv_path, label %after_av

after_av:                                         ; preds = %block_110
  %cmp_gt_0005 = icmp ugt i32 %eax0, 3221225477       ; 0xC0000005
  br i1 %cmp_gt_0005, label %block_150, label %below_eq_0005

below_eq_0005:                                    ; preds = %after_av
  %is_80000002 = icmp eq i32 %eax0, 2147483650        ; 0x80000002
  br i1 %is_80000002, label %ret_minus1, label %translator_fallback

block_150:                                        ; preds = %after_av
  %is_0008 = icmp eq i32 %eax0, 3221225480            ; 0xC0000008
  br i1 %is_0008, label %ret_minus1, label %check_001D

check_001D:                                       ; preds = %block_150
  %is_001D = icmp eq i32 %eax0, 3221225501            ; 0xC000001D
  br i1 %is_001D, label %sigill_path, label %translator_fallback

range_008C_0096:                                  ; preds = %le_0096
  %is_0094 = icmp eq i32 %eax0, 3221225620            ; 0xC0000094
  br i1 %is_0094, label %sigfpe_path_intdiv, label %sigfpe_path_others

sigfpe_path_others:                               ; preds = %range_008C_0096
  %sig8_null = call i8* @signal(i32 8, i8* null)
  %sig_ign_ptr = inttoptr i64 1 to i8*
  %is_ign = icmp eq i8* %sig8_null, %sig_ign_ptr
  br i1 %is_ign, label %sigfpe_special, label %sigfpe_test_prev

sigfpe_test_prev:                                 ; preds = %sigfpe_path_others
  %prev_nonnull = icmp ne i8* %sig8_null, null
  br i1 %prev_nonnull, label %call_prev_sig8, label %translator_fallback

sigfpe_special:                                   ; preds = %sigfpe_path_others
  %set_ign1 = call i8* @signal(i32 8, i8* %sig_ign_ptr)
  call void @sub_1400024E0()
  br label %ret_minus1

call_prev_sig8:                                   ; preds = %sigfpe_test_prev
  %prev8_fn = bitcast i8* %sig8_null to void (i32)*
  call void %prev8_fn(i32 8)
  br label %ret_minus1

sigfpe_path_intdiv:                               ; preds = %range_008C_0096
  %sig8_null2 = call i8* @signal(i32 8, i8* null)
  %is_ign2 = icmp eq i8* %sig8_null2, %sig_ign_ptr
  br i1 %is_ign2, label %sigfpe_intdiv_setign, label %sigfpe_intdiv_testprev

sigfpe_intdiv_setign:                             ; preds = %sigfpe_path_intdiv
  %set_ign2 = call i8* @signal(i32 8, i8* %sig_ign_ptr)
  br label %ret_minus1

sigfpe_intdiv_testprev:                           ; preds = %sigfpe_path_intdiv
  %prev_nonnull2 = icmp ne i8* %sig8_null2, null
  br i1 %prev_nonnull2, label %call_prev_sig8_b, label %translator_fallback

call_prev_sig8_b:                                 ; preds = %sigfpe_intdiv_testprev
  %prev8_fn_b = bitcast i8* %sig8_null2 to void (i32)*
  call void %prev8_fn_b(i32 8)
  br label %ret_minus1

sigill_path:                                      ; preds = %check_001D
  %sig4_null = call i8* @signal(i32 4, i8* null)
  %is_ign4 = icmp eq i8* %sig4_null, %sig_ign_ptr
  br i1 %is_ign4, label %sigill_setign, label %sigill_testprev

sigill_setign:                                    ; preds = %sigill_path
  %set_ign4 = call i8* @signal(i32 4, i8* %sig_ign_ptr)
  br label %ret_minus1

sigill_testprev:                                  ; preds = %sigill_path
  %prev_is_null4 = icmp eq i8* %sig4_null, null
  br i1 %prev_is_null4, label %translator_fallback, label %call_prev_sig4

call_prev_sig4:                                   ; preds = %sigill_testprev
  %prev4_fn = bitcast i8* %sig4_null to void (i32)*
  call void %prev4_fn(i32 4)
  br label %ret_minus1

sigsegv_path:                                     ; preds = %block_110
  %sig11_null = call i8* @signal(i32 11, i8* null)
  %is_ign11 = icmp eq i8* %sig11_null, %sig_ign_ptr
  br i1 %is_ign11, label %sigsegv_setign, label %sigsegv_testprev

sigsegv_setign:                                   ; preds = %sigsegv_path
  %set_ign11 = call i8* @signal(i32 11, i8* %sig_ign_ptr)
  br label %ret_minus1

sigsegv_testprev:                                 ; preds = %sigsegv_path
  %prev_is_null11 = icmp eq i8* %sig11_null, null
  br i1 %prev_is_null11, label %translator_fallback, label %call_prev_sig11

call_prev_sig11:                                  ; preds = %sigsegv_testprev
  %prev11_fn = bitcast i8* %sig11_null to void (i32)*
  call void %prev11_fn(i32 11)
  br label %ret_minus1

translator_fallback:                               ; preds = %sigsegv_testprev, %sigill_testprev, %sigfpe_intdiv_testprev, %sigfpe_test_prev, %below_eq_0005, %check_001D, %dispatch_pre
  %translator = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0, align 8
  %has_translator = icmp ne i32 (i8**)* %translator, null
  br i1 %has_translator, label %call_translator, label %ret_zero

call_translator:                                   ; preds = %translator_fallback
  %ret = call i32 %translator(i8** %rcx)
  ret i32 %ret

ret_zero:                                          ; preds = %translator_fallback
  ret i32 0

ret_minus1:                                        ; preds = %sigsegv_setign, %call_prev_sig11, %sigill_setign, %call_prev_sig4, %sigfpe_intdiv_setign, %call_prev_sig8_b, %sigfpe_special, %call_prev_sig8, %below_eq_0005, %checkflag
  ret i32 -1
}