; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043B0 = external global i8*
@off_1400043C0 = external global i8*
@off_1400043A0 = external global i8*

@aUnknownPseudoR = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@aDBitPseudoRelo = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@aUnknownPseudoR_0 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare i32 @sub_140002690()
declare i64 @sub_1400028E0()
declare void @sub_140001B30(i8*)
declare void @sub_140002B78(i8*, i8*, i32)
declare void @loc_1400298F9()
declare void @sub_140001AD0(...)

define void @sub_140001CA0() {
entry:
  %guard = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %guard, 0
  br i1 %iszero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %r = call i32 @sub_140002690()
  %r64 = sext i32 %r to i64
  %mul5 = mul i64 %r64, 5
  %mul40 = mul i64 %mul5, 8
  %add15 = add i64 %mul40, 15
  %aligned = and i64 %add15, -16
  %stackbuf = alloca i8, i64 %aligned, align 16
  %var50 = alloca [8 x i64], align 16
  %var50.ptr = bitcast [8 x i64]* %var50 to i8*
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %var50.ptr, i8** @qword_1400070A8, align 8
  br label %ret

ret:
  ret void
}