; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i8** @sub_140002AF0()
declare void @sub_140002BC8(i8*, i8*, i8*, i64, i8*)

define void @sub_140002AA0(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) {
entry:
  %stack.args = alloca [2 x i8*], align 8
  %slot0 = getelementptr inbounds [2 x i8*], [2 x i8*]* %stack.args, i64 0, i64 0
  store i8* %r8, i8** %slot0, align 8
  %slot1 = getelementptr inbounds [2 x i8*], [2 x i8*]* %stack.args, i64 0, i64 1
  store i8* %r9, i8** %slot1, align 8
  %p = call i8** @sub_140002AF0()
  %rcx_for_call = load i8*, i8** %p, align 8
  %fifth = bitcast i8** %slot0 to i8*
  call void @sub_140002BC8(i8* %rcx_for_call, i8* %rcx, i8* %rdx, i64 0, i8* %fifth)
  ret void
}