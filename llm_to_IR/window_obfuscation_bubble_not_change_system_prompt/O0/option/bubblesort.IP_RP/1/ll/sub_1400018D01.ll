; ModuleID = 'sub_1400018D0'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external dso_local global i32
@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@off_1400043D0 = external dso_local global i8*
@off_1400043E0 = external dso_local global i8*
@off_1400043C0 = external dso_local global i8*

@aUnknownPseudoR = external dso_local global i8
@aDBitPseudoRelo = external dso_local global i8
@aUnknownPseudoR_0 = external dso_local global i8

declare dso_local i32 @sub_1400022D0()
declare dso_local i64 @sub_140002520(i64)
declare dso_local void @sub_140001760(i8*)
declare dso_local void @sub_1400027B8(i8*, i8*, i32)
declare dso_local i32 @sub_140001700(i8*, ...)

define dso_local void @sub_1400018D0() local_unnamed_addr {
entry:
  %t0 = load i32, i32* @dword_1400070A0, align 4
  %t1 = icmp eq i32 %t0, 0
  br i1 %t1, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %t2 = call i32 @sub_1400022D0()
  %t3 = sext i32 %t2 to i64
  %t4 = mul i64 %t3, 5
  %t5 = shl i64 %t4, 3
  %t6 = add i64 %t5, 15
  %t7 = and i64 %t6, -16
  %t8 = call i64 @sub_140002520(i64 %t7)
  %t9 = load i8*, i8** @off_1400043D0, align 8
  %t10 = load i8*, i8** @off_1400043E0, align 8
  store i32 0, i32* @dword_1400070A4, align 4
  %buf = alloca i8, i64 1, align 8
  store i8* %buf, i8** @qword_1400070A8, align 8
  %t11 = ptrtoint i8* %t9 to i64
  %t12 = ptrtoint i8* %t10 to i64
  %t13 = sub i64 %t11, %t12
  %t14 = icmp sle i64 %t13, 7
  br i1 %t14, label %ret, label %post

post:
  %t15 = icmp sgt i64 %t13, 11
  br label %ret

ret:
  ret void
}