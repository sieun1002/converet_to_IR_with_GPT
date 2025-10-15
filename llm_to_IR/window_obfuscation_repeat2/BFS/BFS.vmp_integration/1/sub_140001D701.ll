; ModuleID = 'sub_140001D70_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = dso_local global i32 0, align 4
@dword_1400070A4 = dso_local global i32 0, align 4
@qword_1400070A8 = dso_local global i8* null, align 8

declare dso_local i32 @sub_140002770()
declare dso_local void @sub_1400029C0(i64)

define dso_local void @sub_140001D70() local_unnamed_addr {
entry:
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %cmp0 = icmp eq i32 %g0, 0
  br i1 %cmp0, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %c1 = call i32 @sub_140002770()
  %c1_sext = sext i32 %c1 to i64
  %mul5 = mul nsw i64 %c1_sext, 5
  %mul8 = shl i64 %mul5, 3
  %add15 = add i64 %mul8, 15
  %aligned = and i64 %add15, -16
  call void @sub_1400029C0(i64 %aligned)
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* null, i8** @qword_1400070A8, align 8
  br label %ret

ret:
  ret void
}