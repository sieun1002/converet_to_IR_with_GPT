; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070A0 = external dso_local global i32
@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@off_1400043B0 = external dso_local global i8*
@off_1400043C0 = external dso_local global i8*
@off_1400043A0 = external dso_local global i8*

declare dso_local i64 @sub_140002690()
declare dso_local i64 @sub_1400028E0()
declare dso_local void @sub_140001B30(i8* noundef)
declare dso_local void @sub_140001AD0(i8* noundef)

declare dllimport i32 @VirtualProtect(i8* noundef, i64 noundef, i32 noundef, i32* noundef)
declare dllimport i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)

define dso_local void @sub_140001CA0() {
entry:
  %flag = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %flag, 0
  br i1 %iszero, label %init, label %exit

init:
  store i32 1, i32* @dword_1400070A0, align 4
  br label %exit

exit:
  ret void
}