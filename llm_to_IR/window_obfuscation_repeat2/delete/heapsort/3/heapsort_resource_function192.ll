; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i64*
@off_1400043B0 = external global i8*
@off_1400043C0 = external global i8*
@off_1400043A0 = external global i8*
@__imp_VirtualProtect = external global i8*

declare i32 @sub_140002690()
declare i64 @sub_1400028E0()

define void @sub_140001CA0() {
entry:
  %flag = load i32, i32* @dword_1400070A0, align 4
  %cmp = icmp eq i32 %flag, 0
  br i1 %cmp, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %call2690 = call i32 @sub_140002690()
  %sext = sext i32 %call2690 to i64
  %mul5 = mul i64 %sext, 5
  %mul8 = mul i64 %mul5, 8
  %add15 = add i64 %mul8, 15
  %aligned = and i64 %add15, -16
  %call28e0 = call i64 @sub_1400028E0()
  %buf = alloca [8 x i64], align 16
  store i32 0, i32* @dword_1400070A4, align 4
  %buf_gep0 = getelementptr inbounds [8 x i64], [8 x i64]* %buf, i64 0, i64 0
  store i64* %buf_gep0, i64** @qword_1400070A8, align 8
  %endptr = load i8*, i8** @off_1400043B0, align 8
  %startptr = load i8*, i8** @off_1400043C0, align 8
  %endint = ptrtoint i8* %endptr to i64
  %startint = ptrtoint i8* %startptr to i64
  %diff = sub i64 %endint, %startint
  br label %ret

ret:
  ret void
}