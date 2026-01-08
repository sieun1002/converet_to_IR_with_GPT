; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070D0 = external global i64

declare i64 @sub_1400027A8(i32, i32)
declare void @sub_140002120()

define i32 @sub_140001CB0(i8* %arg) local_unnamed_addr {
entry:
  %p = bitcast i8* %arg to i8**
  %rdx = load i8*, i8** %p, align 8
  %rdx_i32p = bitcast i8* %rdx to i32*
  %eax0 = load i32, i32* %rdx_i32p, align 4
  %and = and i32 %eax0, 553648127
  %cmpMagic = icmp eq i32 %and, 541343691
  br i1 %cmpMagic, label %magic, label %chainStart

magic:
  %rdx_plus4 = getelementptr i8, i8* %rdx, i64 4
  %b = load i8, i8* %rdx_plus4, align 1
  %b1 = and i8 %b, 1
  %bitSet = icmp ne i8 %b1, 0
  br i1 %bitSet, label %chainStart, label %defaultReturn

chainStart:
  %cmp_ja = icmp ugt i32 %eax0, 3221225622
  br i1 %cmp_ja, label %fallback, label %cmpTo8B

cmpTo8B:
  %cmp_jbe = icmp ule i32 %eax0, 3221225611
  br i1 %cmp_jbe, label %D40, label %switchRange

D40:
  %is_0005 = icmp eq i32 %eax0, 3221225477
  br i1 %is_0005, label %DF0, label %D40_after

D40_after:
  %ugt_0005 = icmp ugt i32 %eax0, 3221225477
  br i1 %ugt_0005, label %D80, label %D40_else

D40_else:
  %is_80000002 = icmp eq i32 %eax0, 2147483650
  br i1 %is_80000002, label %defaultReturn, label %fallback

D80:
  %is_0008 = icmp eq i32 %eax0, 3221225480
  br i1 %is_0008, label %defaultReturn, label %D80_cmp2

D80_cmp2:
  %is_001D = icmp eq i32 %eax0, 3221225501
  br i1 %is_001D, label %D8E, label %fallback

switchRange:
  %add = add i32 %eax0, 1073741683
  %ugt9 = icmp ugt i32 %add, 9
  br i1 %ugt9, label %defaultReturn, label %switch

switch:
  switch i32 %add, label %defaultReturn [
    i32 0, label %D00
    i32 1, label %D00
    i32 2, label %D00
    i32 3, label %D00
    i32 4, label %D00
    i32 5, label %defaultReturn
    i32 6, label %DC0
    i32 7, label %defaultReturn
    i32 8, label %defaultReturn
    i32 9, label %defaultReturn
  ]

D00:
  %call1 = call i64 @sub_1400027A8(i32 8, i32 0)
  %eq1 = icmp eq i64 %call1, 1
  br i1 %eq1, label %E54, label %D00_test

D00_test:
  %isZero = icmp eq i64 %call1, 0
  br i1 %isZero, label %fallback, label %E20

DC0:
  %callDC0 = call i64 @sub_1400027A8(i32 8, i32 0)
  %neq1 = icmp ne i64 %callDC0, 1
  br i1 %neq1, label %D16_path, label %DC0_then

D16_path:
  %isZero2 = icmp eq i64 %callDC0, 0
  br i1 %isZero2, label %fallback, label %E20

DC0_then:
  %callDC0b = call i64 @sub_1400027A8(i32 8, i32 1)
  br label %defaultReturn

D8E:
  %call4 = call i64 @sub_1400027A8(i32 4, i32 0)
  %eq1_4 = icmp eq i64 %call4, 1
  br i1 %eq1_4, label %E40, label %D8E_test

D8E_test:
  %isZero4 = icmp eq i64 %call4, 0
  br i1 %isZero4, label %fallback, label %call_indirect_4

call_indirect_4:
  %fp4 = inttoptr i64 %call4 to void (i32)*
  call void %fp4(i32 4)
  br label %defaultReturn

DF0:
  %callB = call i64 @sub_1400027A8(i32 11, i32 0)
  %eq1_B = icmp eq i64 %callB, 1
  br i1 %eq1_B, label %E2C, label %DF0_test

DF0_test:
  %isZeroB = icmp eq i64 %callB, 0
  br i1 %isZeroB, label %fallback, label %call_indirect_B

call_indirect_B:
  %fpB = inttoptr i64 %callB to void (i32)*
  call void %fpB(i32 11)
  br label %defaultReturn

E20:
  %phiE20 = phi i64 [ %call1, %D00_test ], [ %callDC0, %D16_path ]
  %fpE20 = inttoptr i64 %phiE20 to void (i32)*
  call void %fpE20(i32 8)
  br label %defaultReturn

E2C:
  %callB2 = call i64 @sub_1400027A8(i32 11, i32 1)
  br label %defaultReturn

E40:
  %call4b = call i64 @sub_1400027A8(i32 4, i32 1)
  br label %defaultReturn

E54:
  %call8b = call i64 @sub_1400027A8(i32 8, i32 1)
  call void @sub_140002120()
  br label %defaultReturn

defaultReturn:
  ret i32 -1

fallback:
  %fp64 = load i64, i64* @qword_1400070D0, align 8
  %isNull = icmp eq i64 %fp64, 0
  br i1 %isNull, label %ret0, label %do_tail

ret0:
  ret i32 0

do_tail:
  %fp = inttoptr i64 %fp64 to i32 (i8*)*
  %ret = call i32 %fp(i8* %arg)
  ret i32 %ret
}