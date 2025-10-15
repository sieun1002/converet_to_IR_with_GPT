; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_140004400 = external global i32*
@qword_1400070D0 = external global i32 (i8**)*

declare void @sub_140001010()
declare i8* @signal(i32, i8*)
declare void @sub_1400024E0()

define void @sub_1400013E0() {
entry:
  %0 = load i32*, i32** @off_140004400
  store i32 1, i32* %0, align 4
  call void @sub_140001010()
  ret void
}

define i32 @sub_140002080(i8** %rcx) {
entry:
  %rdx = load i8*, i8** %rcx
  %rdx_i32p = bitcast i8* %rdx to i32*
  %status = load i32, i32* %rdx_i32p, align 4
  %masked = and i32 %status, 553648127
  %cmpMasked = icmp eq i32 %masked, 541541187
  br i1 %cmpMasked, label %bb130, label %bbA1

bb130:                                            ; 0x140002130
  %byteptr = getelementptr i8, i8* %rdx, i32 4
  %flag = load i8, i8* %byteptr, align 1
  %flag1 = and i8 %flag, 1
  %nbz = icmp ne i8 %flag1, 0
  br i1 %nbz, label %bbA1, label %ret_m1

bbA1:                                             ; 0x1400020A1
  %cmp_ja = icmp ugt i32 %status, 3221225622
  br i1 %cmp_ja, label %L0EF, label %cont1

cont1:
  %cmp_jbe = icmp ule i32 %status, 3221225611
  br i1 %cmp_jbe, label %L110, label %switchprep

switchprep:
  %idx_add = add i32 %status, 1073741683
  %idx_cmp = icmp ugt i32 %idx_add, 9
  br i1 %idx_cmp, label %ret_m1, label %switch

switch:
  switch i32 %idx_add, label %ret_m1 [
    i32 0, label %L20D0
    i32 1, label %L20D0
    i32 2, label %L20D0
    i32 3, label %L20D0
    i32 4, label %L20D0
    i32 5, label %ret_m1
    i32 6, label %L20D0
    i32 7, label %L2190
    i32 8, label %ret_m1
    i32 9, label %L215E
  ]

L20D0:                                            ; 0x1400020D0
  %old0 = call i8* @signal(i32 8, i8* null)
  %old0_int = ptrtoint i8* %old0 to i64
  %isOne0 = icmp eq i64 %old0_int, 1
  br i1 %isOne0, label %L2224, label %L20E6

L20E6:                                            ; 0x1400020E6
  %old0_is_null = icmp eq i8* %old0, null
  br i1 %old0_is_null, label %L0EF, label %L21F0_from_d0

L21F0_from_d0:                                    ; 0x1400021F0
  %handler_f_d0 = bitcast i8* %old0 to void (i32)*
  call void %handler_f_d0(i32 8)
  br label %ret_m1

L2224:                                            ; 0x140002224
  %sigign = inttoptr i64 1 to i8*
  %call_sig_set = call i8* @signal(i32 8, i8* %sigign)
  call void @sub_1400024E0()
  br label %ret_m1

L2190:                                            ; 0x140002190
  %old1 = call i8* @signal(i32 8, i8* null)
  %old1_int = ptrtoint i8* %old1 to i64
  %isOne1 = icmp eq i64 %old1_int, 1
  br i1 %isOne1, label %L2190_setign, label %L20E6_2190

L2190_setign:                                     ; 0x1400021A6
  %sigign2 = inttoptr i64 1 to i8*
  %call_sig_set2 = call i8* @signal(i32 8, i8* %sigign2)
  br label %ret_m1

L20E6_2190:
  %old1_is_null = icmp eq i8* %old1, null
  br i1 %old1_is_null, label %L0EF, label %L21F0_2190

L21F0_2190:
  %handler1 = bitcast i8* %old1 to void (i32)*
  call void %handler1(i32 8)
  br label %ret_m1

L215E:                                            ; 0x14000215E
  %old2 = call i8* @signal(i32 4, i8* null)
  %old2_int = ptrtoint i8* %old2 to i64
  %isOne2 = icmp eq i64 %old2_int, 1
  br i1 %isOne2, label %L2210, label %L215E_test

L215E_test:
  %old2_is_null = icmp eq i8* %old2, null
  br i1 %old2_is_null, label %L0EF, label %L21F0_4

L21F0_4:
  %handler2 = bitcast i8* %old2 to void (i32)*
  call void %handler2(i32 4)
  br label %ret_m1

L2210:                                            ; 0x140002210
  %sigign3 = inttoptr i64 1 to i8*
  %call_set3 = call i8* @signal(i32 4, i8* %sigign3)
  br label %ret_m1

L110:                                             ; 0x140002110
  %eq_av = icmp eq i32 %status, 3221225477
  br i1 %eq_av, label %L21C0, label %after_av_cmp

after_av_cmp:
  %gt_av = icmp ugt i32 %status, 3221225477
  br i1 %gt_av, label %L150, label %lt_branch

lt_branch:
  %eq_80000002 = icmp eq i32 %status, 2147483650
  br i1 %eq_80000002, label %ret_m1, label %L0EF

L150:                                             ; 0x140002150
  %eq_c0000008 = icmp eq i32 %status, 3221225480
  br i1 %eq_c0000008, label %ret_m1, label %after_c0000008

after_c0000008:
  %eq_c000001d = icmp eq i32 %status, 3221225501
  br i1 %eq_c000001d, label %L215E, label %L0EF

L21C0:                                            ; 0x1400021C0
  %old3 = call i8* @signal(i32 11, i8* null)
  %old3_int = ptrtoint i8* %old3 to i64
  %isOne3 = icmp eq i64 %old3_int, 1
  br i1 %isOne3, label %L21FC, label %L21C0_test

L21C0_test:
  %old3_is_null = icmp eq i8* %old3, null
  br i1 %old3_is_null, label %L0EF, label %L21F0_11

L21F0_11:
  %handler3 = bitcast i8* %old3 to void (i32)*
  call void %handler3(i32 11)
  br label %ret_m1

L21FC:                                            ; 0x1400021FC
  %sigign4 = inttoptr i64 1 to i8*
  %set4 = call i8* @signal(i32 11, i8* %sigign4)
  br label %ret_m1

L0EF:                                             ; 0x1400020EF
  %fp = load i32 (i8**)*, i32 (i8**)** @qword_1400070D0
  %isnullfp = icmp eq i32 (i8**)* %fp, null
  br i1 %isnullfp, label %L140, label %tail

L140:                                             ; 0x140002140
  ret i32 0

tail:
  %res = call i32 %fp(i8** %rcx)
  ret i32 %res

ret_m1:
  ret i32 -1
}