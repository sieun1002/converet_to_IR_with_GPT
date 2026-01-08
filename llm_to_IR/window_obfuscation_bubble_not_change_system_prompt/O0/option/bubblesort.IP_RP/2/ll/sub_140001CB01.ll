; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare dso_local i8* @sub_1400027A8(i32, i32)
declare dso_local void @sub_140002120()

@qword_1400070D0 = external dso_local global i8*

define dso_local i32 @sub_140001CB0(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx, align 8
  %p32 = bitcast i8* %rdx to i32*
  %eax0 = load i32, i32* %p32, align 4
  %masked = and i32 %eax0, 553648127
  %cmpmagic = icmp eq i32 %masked, 541348803
  br i1 %cmpmagic, label %check_flag, label %range_checks

check_flag:                                       ; preds = %entry
  %flagptr = getelementptr inbounds i8, i8* %rdx, i64 4
  %flagbyte = load i8, i8* %flagptr, align 1
  %flagbit = and i8 %flagbyte, 1
  %nz = icmp ne i8 %flagbit, 0
  br i1 %nz, label %range_checks, label %ret_m1

range_checks:                                     ; preds = %check_flag, %entry
  %cmp_ja = icmp ugt i32 %eax0, 3221225622
  br i1 %cmp_ja, label %fallback, label %cmp2

cmp2:                                             ; preds = %range_checks
  %cmp_jbe = icmp ule i32 %eax0, 3221225611
  br i1 %cmp_jbe, label %D40, label %range_fp

D40:                                              ; preds = %cmp2
  %is_av = icmp eq i32 %eax0, 3221225477
  br i1 %is_av, label %DF0, label %afterD40

afterD40:                                         ; preds = %D40
  %gt_av = icmp ugt i32 %eax0, 3221225477
  br i1 %gt_av, label %D80, label %D40_low

D40_low:                                          ; preds = %afterD40
  %is_80000002 = icmp eq i32 %eax0, 2147483650
  br i1 %is_80000002, label %ret_m1, label %fallback

D80:                                              ; preds = %afterD40
  %is_invhandle = icmp eq i32 %eax0, 3221225480
  br i1 %is_invhandle, label %ret_m1, label %D80_next

D80_next:                                         ; preds = %D80
  %is_illegal = icmp eq i32 %eax0, 3221225501
  br i1 %is_illegal, label %D8E, label %fallback

range_fp:                                         ; preds = %cmp2
  %t = add i32 %eax0, 1073741683
  %t_le_9 = icmp ule i32 %t, 9
  br i1 %t_le_9, label %dispatch_fp, label %ret_m1

dispatch_fp:                                      ; preds = %range_fp
  %is_0094 = icmp eq i32 %eax0, 3221225620
  br i1 %is_0094, label %DC0, label %check_ret_m1_fp

check_ret_m1_fp:                                  ; preds = %dispatch_fp
  %is_0092 = icmp eq i32 %eax0, 3221225618
  %is_0095 = icmp eq i32 %eax0, 3221225621
  %or_defaultcases = or i1 %is_0092, %is_0095
  br i1 %or_defaultcases, label %ret_m1, label %D00

D00:                                              ; preds = %check_ret_m1_fp
  %callD00 = call i8* @sub_1400027A8(i32 8, i32 0)
  %callD00_int = ptrtoint i8* %callD00 to i64
  %is_one_D00 = icmp eq i64 %callD00_int, 1
  br i1 %is_one_D00, label %E54, label %D16_from_D00

D16_from_D00:                                     ; preds = %D00
  %is_nonzero_D00 = icmp ne i8* %callD00, null
  br i1 %is_nonzero_D00, label %E20_from_D00, label %fallback

E20_from_D00:                                     ; preds = %D16_from_D00
  %fp_cast_D00 = bitcast i8* %callD00 to void (i32)*
  call void %fp_cast_D00(i32 8)
  br label %ret_m1

DC0:                                              ; preds = %dispatch_fp
  %callDC0 = call i8* @sub_1400027A8(i32 8, i32 0)
  %callDC0_int = ptrtoint i8* %callDC0 to i64
  %is_one_DC0 = icmp eq i64 %callDC0_int, 1
  br i1 %is_one_DC0, label %DC0_eq1, label %D16_from_DC0

DC0_eq1:                                          ; preds = %DC0
  %tmpDC0_2 = call i8* @sub_1400027A8(i32 8, i32 1)
  br label %ret_m1

D16_from_DC0:                                     ; preds = %DC0
  %nonzero_DC0 = icmp ne i8* %callDC0, null
  br i1 %nonzero_DC0, label %E20_from_DC0, label %fallback

E20_from_DC0:                                     ; preds = %D16_from_DC0
  %fp_cast_DC0 = bitcast i8* %callDC0 to void (i32)*
  call void %fp_cast_DC0(i32 8)
  br label %ret_m1

D8E:                                              ; preds = %D80_next
  %callD8E = call i8* @sub_1400027A8(i32 4, i32 0)
  %callD8E_int = ptrtoint i8* %callD8E to i64
  %is_one_D8E = icmp eq i64 %callD8E_int, 1
  br i1 %is_one_D8E, label %E40, label %D8E_test

D8E_test:                                         ; preds = %D8E
  %nz_D8E = icmp ne i8* %callD8E, null
  br i1 %nz_D8E, label %callfp4, label %fallback

callfp4:                                          ; preds = %D8E_test
  %fp_cast4 = bitcast i8* %callD8E to void (i32)*
  call void %fp_cast4(i32 4)
  br label %ret_m1

DF0:                                              ; preds = %D40
  %callDF0 = call i8* @sub_1400027A8(i32 11, i32 0)
  %callDF0_int = ptrtoint i8* %callDF0 to i64
  %is_one_DF0 = icmp eq i64 %callDF0_int, 1
  br i1 %is_one_DF0, label %E2C, label %DF0_test

DF0_test:                                         ; preds = %DF0
  %nz_DF0 = icmp ne i8* %callDF0, null
  br i1 %nz_DF0, label %callfp11, label %fallback

callfp11:                                         ; preds = %DF0_test
  %fp_cast11 = bitcast i8* %callDF0 to void (i32)*
  call void %fp_cast11(i32 11)
  br label %ret_m1

E2C:                                              ; preds = %DF0
  %tmpE2C = call i8* @sub_1400027A8(i32 11, i32 1)
  br label %ret_m1

E40:                                              ; preds = %D8E
  %tmpE40 = call i8* @sub_1400027A8(i32 4, i32 1)
  br label %ret_m1

E54:                                              ; preds = %D00
  %tmpE54 = call i8* @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %ret_m1

fallback:                                         ; preds = %DF0_test, %D8E_test, %D16_from_DC0, %D16_from_D00, %D80_next, %D40_low, %range_checks
  %handler = load i8*, i8** @qword_1400070D0, align 8
  %isnull = icmp eq i8* %handler, null
  br i1 %isnull, label %ret0, label %tailcall

tailcall:                                         ; preds = %fallback
  %fp_tail = bitcast i8* %handler to i32 (i8**)*
  %res = tail call i32 %fp_tail(i8** %rcx)
  ret i32 %res

ret0:                                             ; preds = %fallback
  ret i32 0

ret_m1:                                           ; preds = %E54, %E40, %E2C, %callfp11, %callfp4, %E20_from_DC0, %DC0_eq1, %E20_from_D00, %D40_low, %range_fp, %check_flag, %D80, %check_ret_m1_fp
  ret i32 -1
}