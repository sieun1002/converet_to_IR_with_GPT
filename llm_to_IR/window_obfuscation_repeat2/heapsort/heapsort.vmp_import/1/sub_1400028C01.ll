; ModuleID = 'm'
target triple = "x86_64-pc-windows-msvc"

declare i8** @sub_1400029B0(i8*, i8*, i8*, i8*)
declare void @sub_140002A88(i8*, i8*, i8*, i64, i8*)

define void @sub_1400028C0(i8* %arg1, i8* %arg2, i8* %arg3, i8* %arg4) {
entry:
  %call1 = call i8** @sub_1400029B0(i8* %arg1, i8* %arg2, i8* %arg3, i8* %arg4)
  %rcx_val = load i8*, i8** %call1, align 8
  call void @sub_140002A88(i8* %rcx_val, i8* %arg1, i8* %arg2, i64 0, i8* %arg3)
  ret void
}