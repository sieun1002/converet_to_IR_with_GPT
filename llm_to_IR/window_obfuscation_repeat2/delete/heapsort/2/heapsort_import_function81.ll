; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = global i32 0, align 4
@dword_1400070A4 = global i32 0, align 4
@qword_1400070A8 = global i8* null, align 8

declare i32 @sub_140002690()
declare i64 @sub_1400028E0()

define void @sub_140001CA0() {
entry:
  %flag = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %flag, 0
  br i1 %iszero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %n32 = call i32 @sub_140002690()
  %n64 = sext i32 %n32 to i64
  %mul4 = mul i64 %n64, 4
  %sum5 = add i64 %mul4, %n64
  %mul8 = mul i64 %sum5, 8
  %plusF = add i64 %mul8, 15
  %mask = and i64 %plusF, -16
  %_unused_size = call i64 @sub_1400028E0()
  %var50 = alloca i8, i64 80, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %var50, i8** @qword_1400070A8, align 8
  br label %ret

ret:
  ret void
}