; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

declare i8** @sub_140002AF0(i8*)
declare void @sub_140002BC8(i8*, i8*, i8*, i32, i8*)

define void @sub_140002A00(i8* %arg1, i8* %arg2, i8* %arg3) {
entry:
  %call = call i8** @sub_140002AF0(i8* %arg1)
  %ld = load i8*, i8** %call, align 8
  call void @sub_140002BC8(i8* %ld, i8* %arg1, i8* %arg2, i32 0, i8* %arg3)
  ret void
}