; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8

declare i32 @sub_140002770()
declare void @sub_1400029C0()

define void @sub_140001D70() {
entry:
  %g = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %g, 0
  br i1 %iszero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %c = call i32 @sub_140002770()
  %c64 = sext i32 %c to i64
  %mul5 = mul i64 %c64, 5
  %mul8 = shl i64 %mul5, 3
  %add15 = add i64 %mul8, 15
  %aligned = and i64 %add15, -16
  call void @sub_1400029C0()
  %buf = alloca [64 x i8], align 16
  %buf_i8 = bitcast [64 x i8]* %buf to i8*
  store i8* %buf_i8, i8** @qword_1400070A8, align 8
  br label %ret

ret:
  ret void
}