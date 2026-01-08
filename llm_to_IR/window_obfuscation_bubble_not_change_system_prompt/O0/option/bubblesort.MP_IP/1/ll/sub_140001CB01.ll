; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i8*

declare i8* @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define i32 @sub_140001CB0(i8** %0) {
entry:
  %1 = load i8*, i8** %0, align 8
  %2 = bitcast i8* %1 to i32*
  %3 = load i32, i32* %2, align 4
  %4 = and i32 %3, 553648127
  %5 = icmp eq i32 %4, 541541187
  br i1 %5, label %bb_1D60, label %bb_1CD1

bb_1D60:                                         ; 0x140001d60
  %6 = getelementptr inbounds i8, i8* %1, i64 4
  %7 = load i8, i8* %6, align 1
  %8 = and i8 %7, 1
  %9 = icmp ne i8 %8, 0
  br i1 %9, label %bb_1CD1, label %ret_m1

bb_1CD1:                                         ; 0x140001cd1
  %10 = icmp ugt i32 %3, 3221225622
  br i1 %10, label %bb_1D1F, label %bb_after_rng

bb_after_rng:                                    ; 0x140001cd8
  %11 = icmp ule i32 %3, 3221225611
  br i1 %11, label %bb_1D40, label %bb_switch

bb_1D40:                                         ; 0x140001d40
  %12 = icmp eq i32 %3, 3221225477
  br i1 %12, label %bb_DF0, label %bb_D4B

bb_D4B:                                          ; 0x140001d4b
  %13 = icmp ugt i32 %3, 3221225477
  br i1 %13, label %bb_1D80, label %bb_1D4D

bb_1D4D:                                         ; 0x140001d4d
  %14 = icmp eq i32 %3, 2147483650
  br i1 %14, label %ret_m1, label %bb_1D1F

bb_1D80:                                         ; 0x140001d80
  %15 = icmp eq i32 %3, 3221225480
  br i1 %15, label %ret_m1, label %bb_1D87

bb_1D87:                                         ; 0x140001d87
  %16 = icmp eq i32 %3, 3221225501
  br i1 %16, label %bb_1D8E, label %bb_1D1F

bb_switch:                                       ; 0x140001cdf .. jump table range
  %cmp_94 = icmp eq i32 %3, 3221225620
  br i1 %cmp_94, label %bb_1DC0, label %bb_switch_rest

bb_switch_rest:
  %cmp_93 = icmp eq i32 %3, 3221225619
  %cmp_91 = icmp eq i32 %3, 3221225617
  %or1 = or i1 %cmp_93, %cmp_91
  %cmp_90 = icmp eq i32 %3, 3221225616
  %or2 = or i1 %or1, %cmp_90
  %cmp_8F = icmp eq i32 %3, 3221225615
  %or3 = or i1 %or2, %cmp_8F
  %cmp_8E = icmp eq i32 %3, 3221225614
  %or4 = or i1 %or3, %cmp_8E
  %cmp_8D = icmp eq i32 %3, 3221225613
  %or5 = or i1 %or4, %cmp_8D
  br i1 %or5, label %bb_1D00, label %ret_m1

bb_1D00:                                         ; 0x140001d00
  %call8_0 = call i8* @sub_1400027A8(i32 8, i32 0)
  %pi8_0 = ptrtoint i8* %call8_0 to i64
  %is1_0 = icmp eq i64 %pi8_0, 1
  br i1 %is1_0, label %bb_E54, label %bb_1D16

bb_1D16:                                         ; 0x140001d16
  %p_phi = phi i8* [ %call8_0, %bb_1D00 ], [ %call8_1, %bb_1DC0 ]
  %nz = icmp ne i8* %p_phi, null
  br i1 %nz, label %bb_E20, label %bb_1D1F

bb_1D1F:                                         ; 0x140001d1f
  %17 = load i8*, i8** @qword_1400070D0, align 8
  %18 = icmp eq i8* %17, null
  br i1 %18, label %ret_0, label %tailjmp

tailjmp:                                          ; 0x140001d2b
  %fnptr = bitcast i8* %17 to i32 (i8**)*
  %res = tail call i32 %fnptr(i8** %0)
  ret i32 %res

bb_1D8E:                                         ; 0x140001d8e
  %call4_0 = call i8* @sub_1400027A8(i32 4, i32 0)
  %pi4_0 = ptrtoint i8* %call4_0 to i64
  %is1_4 = icmp eq i64 %pi4_0, 1
  br i1 %is1_4, label %bb_E40, label %bb_DA4

bb_DA4:                                          ; 0x140001da4
  %nz4 = icmp ne i8* %call4_0, null
  br i1 %nz4, label %bb_1DAD, label %bb_1D1F

bb_1DAD:                                         ; 0x140001dad
  %fp4 = bitcast i8* %call4_0 to void (i32)*
  call void %fp4(i32 4)
  br label %ret_m1

bb_1DC0:                                         ; 0x140001dc0
  %call8_1 = call i8* @sub_1400027A8(i32 8, i32 0)
  %pi8_1 = ptrtoint i8* %call8_1 to i64
  %is1_1 = icmp eq i64 %pi8_1, 1
  br i1 %is1_1, label %bb_1DD6, label %bb_1D16

bb_1DD6:                                         ; 0x140001dd6
  %call8_2 = call i8* @sub_1400027A8(i32 8, i32 1)
  br label %ret_m1

bb_DF0:                                          ; 0x140001df0
  %callB_0 = call i8* @sub_1400027A8(i32 11, i32 0)
  %piB_0 = ptrtoint i8* %callB_0 to i64
  %is1_B = icmp eq i64 %piB_0, 1
  br i1 %is1_B, label %bb_E2C, label %bb_E02

bb_E02:                                          ; 0x140001e02
  %nzB = icmp ne i8* %callB_0, null
  br i1 %nzB, label %bb_1E0B, label %bb_1D1F

bb_1E0B:                                         ; 0x140001e0b
  %fpB = bitcast i8* %callB_0 to void (i32)*
  call void %fpB(i32 11)
  br label %ret_m1

bb_E20:                                          ; 0x140001e20
  %fp8 = bitcast i8* %p_phi to void (i32)*
  call void %fp8(i32 8)
  br label %ret_m1

bb_E2C:                                          ; 0x140001e2c
  %callB_1 = call i8* @sub_1400027A8(i32 11, i32 1)
  br label %ret_m1

bb_E40:                                          ; 0x140001e40
  %call4_1 = call i8* @sub_1400027A8(i32 4, i32 1)
  br label %ret_m1

bb_E54:                                          ; 0x140001e54
  %call8_3 = call i8* @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %ret_m1

ret_m1:
  ret i32 -1

ret_0:
  ret i32 0
}