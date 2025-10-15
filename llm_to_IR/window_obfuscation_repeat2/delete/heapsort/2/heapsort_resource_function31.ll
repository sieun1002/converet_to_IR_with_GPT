; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external dso_local global i32*, align 8
@qword_1400070D0 = external dso_local global i32 (i8*)*, align 8

declare dso_local void @sub_140001010()
declare dso_local void (i32)* @signal(i32, void (i32)*)
declare dso_local void @sub_1400024E0()

define dso_local void @sub_1400013E0() {
entry:
  %0 = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %0, align 4
  call void @sub_140001010()
  ret void
}

define dso_local i32 @sub_140002080(i8** %rcx) {
entry:
  %ptr = load i8*, i8** %rcx, align 8
  %codep = bitcast i8* %ptr to i32*
  %code = load i32, i32* %codep, align 4
  %mask = and i32 %code, 553648127
  %cmp_magic = icmp eq i32 %mask, 541541187
  br i1 %cmp_magic, label %blk_cgc, label %blk_main

blk_cgc:                                           ; preds = %entry
  %p4 = getelementptr inbounds i8, i8* %ptr, i64 4
  %b = load i8, i8* %p4, align 1
  %b1 = and i8 %b, 1
  %b1z = icmp ne i8 %b1, 0
  br i1 %b1z, label %blk_main, label %ret_default

blk_main:                                          ; preds = %blk_cgc, %entry
  %cmp_u_ugt = icmp ugt i32 %code, 3221225622
  br i1 %cmp_u_ugt, label %fallback, label %blk_a8

blk_a8:                                            ; preds = %blk_main
  %cmp_u_ule = icmp ule i32 %code, 3221225611
  br i1 %cmp_u_ule, label %blk_2110, label %blk_switchrange

blk_2110:                                          ; preds = %blk_a8
  %is_av = icmp eq i32 %code, 3221225477
  br i1 %is_av, label %blk_sigsegv, label %blk_2110_2

blk_2110_2:                                        ; preds = %blk_2110
  %cmp_u_gt_av = icmp ugt i32 %code, 3221225477
  br i1 %cmp_u_gt_av, label %blk_2150, label %blk_check80000002

blk_check80000002:                                 ; preds = %blk_2110_2
  %is_80000002 = icmp eq i32 %code, 2147483650
  br i1 %is_80000002, label %ret_minus1, label %fallback

blk_2150:                                          ; preds = %blk_2110_2
  %is_c0000008 = icmp eq i32 %code, 3221225480
  br i1 %is_c0000008, label %ret_default, label %blk_check_c000001d

blk_check_c000001d:                                ; preds = %blk_2150
  %is_c000001d = icmp eq i32 %code, 3221225501
  br i1 %is_c000001d, label %blk_sigill, label %fallback

blk_switchrange:                                   ; preds = %blk_a8
  br label %blk_fpe1

blk_fpe1:                                          ; preds = %blk_switchrange
  %sig_dfl = inttoptr i64 0 to void (i32)*
  %prev1 = call void (i32)* @signal(i32 8, void (i32)* %sig_dfl)
  %sig_ign = inttoptr i64 1 to void (i32)*
  %is_one1 = icmp eq void (i32)* %prev1, %sig_ign
  br i1 %is_one1, label %blk_2224, label %blk_fpe1_test

blk_fpe1_test:                                     ; preds = %blk_fpe1
  %is_not_null1 = icmp ne void (i32)* %prev1, null
  br i1 %is_not_null1, label %blk_call_prev_fpe, label %fallback

blk_call_prev_fpe:                                 ; preds = %blk_fpe1_test
  call void %prev1(i32 8)
  br label %ret_default

blk_2224:                                          ; preds = %blk_fpe1
  %tmp_set1 = call void (i32)* @signal(i32 8, void (i32)* %sig_ign)
  call void @sub_1400024E0()
  br label %ret_default

blk_sigill:                                        ; preds = %blk_check_c000001d
  %sig_dfl2 = inttoptr i64 0 to void (i32)*
  %prev2 = call void (i32)* @signal(i32 4, void (i32)* %sig_dfl2)
  %sig_ign2 = inttoptr i64 1 to void (i32)*
  %is_one2 = icmp eq void (i32)* %prev2, %sig_ign2
  br i1 %is_one2, label %blk_2210, label %blk_sigill_test

blk_sigill_test:                                   ; preds = %blk_sigill
  %is_null2 = icmp eq void (i32)* %prev2, null
  br i1 %is_null2, label %fallback, label %blk_call_prev_4

blk_call_prev_4:                                   ; preds = %blk_sigill_test
  call void %prev2(i32 4)
  br label %ret_default

blk_2210:                                          ; preds = %blk_sigill
  %tmp_set2 = call void (i32)* @signal(i32 4, void (i32)* %sig_ign2)
  br label %ret_default

blk_sigsegv:                                       ; preds = %blk_2110
  %sig_dfl3 = inttoptr i64 0 to void (i32)*
  %prev3 = call void (i32)* @signal(i32 11, void (i32)* %sig_dfl3)
  %sig_ign3 = inttoptr i64 1 to void (i32)*
  %is_one3 = icmp eq void (i32)* %prev3, %sig_ign3
  br i1 %is_one3, label %blk_21fc, label %blk_sigsegv_test

blk_sigsegv_test:                                  ; preds = %blk_sigsegv
  %is_null3 = icmp eq void (i32)* %prev3, null
  br i1 %is_null3, label %fallback, label %blk_call_prev_11

blk_call_prev_11:                                  ; preds = %blk_sigsegv_test
  call void %prev3(i32 11)
  br label %ret_default

blk_21fc:                                          ; preds = %blk_sigsegv
  %tmp_set3 = call void (i32)* @signal(i32 11, void (i32)* %sig_ign3)
  br label %ret_default

fallback:                                          ; preds = %blk_sigsegv_test, %blk_sigill_test, %blk_fpe1_test, %blk_check80000002, %blk_check_c000001d, %blk_2150, %blk_main
  %fp = load i32 (i8*)*, i32 (i8*)** @qword_1400070D0, align 8
  %is_null_fp = icmp eq i32 (i8*)* %fp, null
  br i1 %is_null_fp, label %ret_zero, label %call_fp

call_fp:                                           ; preds = %fallback
  %rcx_as_i8p = bitcast i8** %rcx to i8*
  %res = tail call i32 %fp(i8* %rcx_as_i8p)
  ret i32 %res

ret_zero:                                          ; preds = %fallback
  ret i32 0

ret_minus1:                                        ; preds = %blk_check80000002
  ret i32 -1

ret_default:                                       ; preds = %blk_21fc, %blk_call_prev_11, %blk_2210, %blk_call_prev_4, %blk_2224, %blk_call_prev_fpe, %blk_cgc, %blk_2150
  ret i32 -1
}