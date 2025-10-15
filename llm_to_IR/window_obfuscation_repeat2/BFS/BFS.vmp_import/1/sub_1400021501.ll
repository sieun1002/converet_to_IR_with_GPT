; ModuleID = 'm'
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_140002C48(i32, i32)
declare void @sub_1400025C0()

@qword_1400070D0 = external global i8*

define dso_local i32 @sub_140002150(i8** %rcx) {
entry:
  %rdx.ptr = load i8*, i8** %rcx, align 8
  %rdx.i32 = bitcast i8* %rdx.ptr to i32*
  %eax.val = load i32, i32* %rdx.i32, align 4
  %masked = and i32 %eax.val, 50331647
  %cmp.sig = icmp eq i32 %masked, 38231619
  br i1 %cmp.sig, label %sigcheck, label %range_cmp

sigcheck:                                            ; 0x140002200 path
  %second.ptr = getelementptr inbounds i32, i32* %rdx.i32, i64 1
  %second = load i32, i32* %second.ptr, align 4
  %second.bit = and i32 %second, 1
  %second.nz = icmp ne i32 %second.bit, 0
  br i1 %second.nz, label %range_cmp, label %ret_m1

range_cmp:                                           ; 0x140002171 path
  %ugt_96 = icmp ugt i32 %eax.val, 3221225622
  br i1 %ugt_96, label %loc_1BF, label %le_8B

le_8B:
  %ule_8B = icmp ule i32 %eax.val, 3221225611
  br i1 %ule_8B, label %loc_1E0, label %switch_range

switch_range:
  switch i32 %eax.val, label %ret_m1 [
    i32 3221225613, label %case_A         ; 0xC000008D
    i32 3221225614, label %case_A         ; 0xC000008E
    i32 3221225615, label %case_A         ; 0xC000008F
    i32 3221225616, label %case_A         ; 0xC0000090
    i32 3221225617, label %case_A         ; 0xC0000091
    i32 3221225618, label %ret_m1         ; 0xC0000092
    i32 3221225619, label %case_A         ; 0xC0000093
    i32 3221225620, label %case_260       ; 0xC0000094
    i32 3221225621, label %ret_m1         ; 0xC0000095
    i32 3221225622, label %case_22e       ; 0xC0000096
  ]

case_A:                                              ; 0x1400021A0
  %callA = call i64 @sub_140002C48(i32 8, i32 0)
  %is1A = icmp eq i64 %callA, 1
  br i1 %is1A, label %loc_2F4, label %case_A_test

case_A_test:
  %is0A = icmp eq i64 %callA, 0
  br i1 %is0A, label %loc_1BF, label %call_fun_8

call_fun_8:                                          ; 0x1400022C0
  %fp8 = inttoptr i64 %callA to void (i32)*
  call void %fp8(i32 8)
  br label %ret_m1

case_260:                                            ; 0x140002260
  %call260 = call i64 @sub_140002C48(i32 8, i32 0)
  %eq1_260 = icmp eq i64 %call260, 1
  br i1 %eq1_260, label %do_8_edx1_then_m1, label %case_260_test

case_260_test:                                       ; corresponds to 0x1400021B6 behavior
  %is0_260 = icmp eq i64 %call260, 0
  br i1 %is0_260, label %loc_1BF, label %call_fun_8_2

call_fun_8_2:
  %fp8b = inttoptr i64 %call260 to void (i32)*
  call void %fp8b(i32 8)
  br label %ret_m1

do_8_edx1_then_m1:                                   ; 0x140002276..280 then default
  %tmp8 = call i64 @sub_140002C48(i32 8, i32 1)
  br label %ret_m1

case_22e:                                            ; 0x14000222E
  %call4 = call i64 @sub_140002C48(i32 4, i32 0)
  %is1_4 = icmp eq i64 %call4, 1
  br i1 %is1_4, label %do_4_edx1_then_m1, label %case_22e_test

case_22e_test:
  %is0_4 = icmp eq i64 %call4, 0
  br i1 %is0_4, label %loc_1BF, label %call_fun_4

call_fun_4:                                          ; 0x14000224D..252
  %fp4 = inttoptr i64 %call4 to void (i32)*
  call void %fp4(i32 4)
  br label %ret_m1

do_4_edx1_then_m1:                                   ; 0x1400022E0
  %tmp4 = call i64 @sub_140002C48(i32 4, i32 1)
  br label %ret_m1

loc_1E0:                                             ; 0x1400021E0
  %eq_av = icmp eq i32 %eax.val, 3221225477
  br i1 %eq_av, label %loc_290, label %gt_av

gt_av:
  %ugt_av = icmp ugt i32 %eax.val, 3221225477
  br i1 %ugt_av, label %loc_220, label %check_80000002

check_80000002:
  %eq_80000002 = icmp eq i32 %eax.val, 2147483650
  br i1 %eq_80000002, label %ret_m1, label %loc_1BF

loc_220:                                             ; 0x140002220
  %eq_0008 = icmp eq i32 %eax.val, 3221225480
  br i1 %eq_0008, label %ret_m1, label %check_001D

check_001D:
  %eq_001D = icmp eq i32 %eax.val, 3221225501
  br i1 %eq_001D, label %case_22e, label %loc_1BF

loc_290:                                             ; 0x140002290
  %callB = call i64 @sub_140002C48(i32 11, i32 0)
  %is1_B = icmp eq i64 %callB, 1
  br i1 %is1_B, label %do_B_edx1_then_m1, label %loc_290_test

loc_290_test:
  %is0_B = icmp eq i64 %callB, 0
  br i1 %is0_B, label %loc_1BF, label %call_fun_B

call_fun_B:                                          ; 0x1400022AB..2B0
  %fpB = inttoptr i64 %callB to void (i32)*
  call void %fpB(i32 11)
  br label %ret_m1

do_B_edx1_then_m1:                                   ; 0x1400022CC
  %tmpB = call i64 @sub_140002C48(i32 11, i32 1)
  br label %ret_m1

loc_2F4:                                             ; 0x1400022F4
  %tmpC1 = call i64 @sub_140002C48(i32 8, i32 1)
  call void @sub_1400025C0()
  br label %ret_m1

loc_1BF:                                             ; 0x1400021BF
  %cb = load i8*, i8** @qword_1400070D0, align 8
  %cb_isnull = icmp eq i8* %cb, null
  br i1 %cb_isnull, label %ret_0, label %tailjmp

tailjmp:                                             ; 0x1400021CB..1D3
  %cb_typed = bitcast i8* %cb to i32 (i8**)*
  %res = tail call i32 %cb_typed(i8** %rcx)
  ret i32 %res

ret_m1:                                              ; default case return -1
  ret i32 -1

ret_0:
  ret i32 0
}