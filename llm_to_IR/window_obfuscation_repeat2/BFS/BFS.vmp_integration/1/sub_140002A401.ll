; ModuleID = 'm'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002BB0(i32)
declare i8** @sub_140002AF0()
declare void @sub_140002BC8(i8*, i8*, i8*, i64, i8**)

define void @sub_140002A40(i8* %arg1, i8* %arg2, i8* %arg3, i8* %arg4) {
entry:
  %arr = alloca [3 x i8*], align 8
  %arr.first = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i64 0, i64 0
  store i8* %arg2, i8** %arr.first, align 8
  %arr.idx1 = getelementptr inbounds i8*, i8** %arr.first, i64 1
  store i8* %arg3, i8** %arr.idx1, align 8
  %arr.idx2 = getelementptr inbounds i8*, i8** %arr.first, i64 2
  store i8* %arg4, i8** %arr.idx2, align 8
  %call.bb0 = call i8* @sub_140002BB0(i32 1)
  %call.af0 = call i8** @sub_140002AF0()
  %loaded = load i8*, i8** %call.af0, align 8
  call void @sub_140002BC8(i8* %loaded, i8* %call.bb0, i8* %arg1, i64 0, i8** %arr.first)
  ret void
}