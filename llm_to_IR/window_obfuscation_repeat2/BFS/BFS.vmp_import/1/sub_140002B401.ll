; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002C10()
declare void @sub_140002BF8(i32)
declare i32* @sub_140002BE0()
declare i8** @loc_140002BE8()
declare i8** @loc_140002CA0()
declare void @sub_140002C80(i32)

define i32 @sub_140002B40(i32* %arg1, i8** %arg2, i8** %arg3, i32 %arg4, i32* %arg5) {
entry:
  call void @sub_140002C10()
  %cmp = icmp eq i32 %arg4, 0
  %sel = select i1 %cmp, i32 1, i32 2
  call void @sub_140002BF8(i32 %sel)
  %p32 = call i32* @sub_140002BE0()
  %v32 = load i32, i32* %p32, align 4
  store i32 %v32, i32* %arg1, align 4
  %pp1 = call i8** @loc_140002BE8()
  %p1 = load i8*, i8** %pp1, align 8
  store i8* %p1, i8** %arg2, align 8
  %pp2 = call i8** @loc_140002CA0()
  %p2 = load i8*, i8** %pp2, align 8
  store i8* %p2, i8** %arg3, align 8
  %v = load i32, i32* %arg5, align 4
  call void @sub_140002C80(i32 %v)
  ret i32 0
}