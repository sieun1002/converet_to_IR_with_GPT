; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@qword_140008280 = external global i8*, align 8

declare void @sub_140033F45()
declare void @sub_140039010()
declare i32 @sub_140001626()
declare void @loc_140001430()

define void @sub_140002CA0() {
entry:
  call void @sub_140033F45()
  call void @sub_140039010()
  %r0 = call i32 @sub_140001626()
  %masked = and i32 %r0, 1743294608
  %cmp = icmp sle i32 %masked, 0
  br i1 %cmp, label %jd00, label %cont

cont:
  %p = load i8*, i8** @qword_140008280, align 8
  %fp = bitcast i8* %p to void ()*
  call void %fp()
  unreachable

jd00:
  call void @loc_140001430()
  unreachable
}