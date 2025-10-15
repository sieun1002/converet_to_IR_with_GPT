; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = global i32 0
@dword_1400070A4 = global i32 0
@qword_1400070A8 = global i8* null

@off_1400043B0 = external global i8*
@off_1400043C0 = external global i8*
@off_1400043A0 = external global i8*

@__imp_VirtualProtect = external global i8*

@aUnknownPseudoR = external global i8
@aDBitPseudoRelo = external global i8
@aUnknownPseudoR_0 = external global i8

declare i32 @sub_140002690()
declare i64 @sub_1400028E0()
declare void @sub_140001B30(i8*)
declare i8* @memcpy(i8*, i8*, i64)
declare i32 @sub_140001AD0(i8*, ...)

define void @sub_140001CA0() {
entry:
  %guard = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %guard, 0
  br i1 %iszero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %r0 = call i32 @sub_140002690()
  %rax = sext i32 %r0 to i64
  %mul1 = mul i64 %rax, 5
  %mul2 = mul i64 %mul1, 8
  %add = add i64 %mul2, 15
  %align = and i64 %add, -16
  %stk = call i64 @sub_1400028E0()
  %b0 = load i8*, i8** @off_1400043B0, align 8
  %b1 = load i8*, i8** @off_1400043C0, align 8
  %buf = alloca [24 x i8], align 8
  %bufptr = bitcast [24 x i8]* %buf to i8*
  store i8* %bufptr, i8** @qword_1400070A8, align 8
  store i32 0, i32* @dword_1400070A4, align 4
  br label %ret

ret:
  ret void
}