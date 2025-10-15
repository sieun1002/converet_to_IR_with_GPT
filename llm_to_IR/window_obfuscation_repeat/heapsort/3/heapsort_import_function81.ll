; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070A0 = dso_local global i32 0, align 4
@dword_1400070A4 = dso_local global i32 0, align 4
@qword_1400070A8 = dso_local global i64 0, align 8

@off_1400043A0 = dso_local global i8* null, align 8
@off_1400043B0 = dso_local global i8* null, align 8
@off_1400043C0 = dso_local global i8* null, align 8

declare dso_local i32 @sub_140002690()
declare dso_local i64 @sub_1400028E0(i64)
declare dso_local void @sub_140001B30(i8*)
declare dso_local void @sub_140002B78(i8*, i8*, i32)
declare dso_local void @sub_140001AD0(i8*, ...)
declare dso_local void @loc_1400298F9()

define dso_local void @sub_140001CA0() {
entry:
  %guard = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %guard, 0
  br i1 %iszero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %t0 = call i32 @sub_140002690()
  %t1 = sext i32 %t0 to i64
  %t2 = mul nsw i64 %t1, 5
  %t3 = shl i64 %t2, 3
  %t4 = add i64 %t3, 15
  %t5 = and i64 %t4, -16
  %t6 = call i64 @sub_1400028E0(i64 %t5)
  store i32 0, i32* @dword_1400070A4, align 4
  store i64 0, i64* @qword_1400070A8, align 8
  br label %ret

ret:
  ret void
}