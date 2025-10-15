; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = global i32 0, align 4
@dword_1400070A4 = global i32 0, align 4
@qword_1400070A8 = global i64 0, align 8
@off_1400043B0 = global i8* null, align 8
@off_1400043C0 = global i8* null, align 8
@off_1400043A0 = global i8* null, align 8

declare i32 @sub_140002690()
declare void @sub_1400028E0(i64)
declare void @sub_140001B30(i8*)
declare void @sub_140001AD0(i8*, ...)

declare dllimport i8* @memcpy(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64)
declare dllimport i32 @VirtualProtect(i8*, i64, i32, i32*)

define void @sub_140001CA0() {
entry:
  %flag = load i32, i32* @dword_1400070A0, align 4
  %is_zero = icmp eq i32 %flag, 0
  br i1 %is_zero, label %set_flag, label %ret

set_flag:
  store i32 1, i32* @dword_1400070A0, align 4
  br label %ret

ret:
  ret void
}