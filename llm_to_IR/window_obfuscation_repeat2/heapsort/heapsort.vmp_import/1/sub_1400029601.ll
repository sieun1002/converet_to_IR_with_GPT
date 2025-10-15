; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

declare i8** @sub_1400029B0(i8*, i8*, i8*, i8*)
declare void @sub_140002A88(i8*, i8*, i8*, i8*)

define void @sub_140002960(i8* %arg1, i8* %arg2, i8* %arg3, i8* %arg4) {
entry:
  %call = call i8** @sub_1400029B0(i8* %arg1, i8* %arg2, i8* %arg3, i8* %arg4)
  %loaded = load i8*, i8** %call, align 8
  call void @sub_140002A88(i8* %loaded, i8* %arg1, i8* %arg2, i8* null)
  ret void
}