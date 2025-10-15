; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i8** @sub_1400029B0(i8*, i8*, i8*)
declare i64 @sub_140002A88(i8*, i8*, i8*, i32, i8*)

define dso_local i64 @sub_1400028C0(i8* %arg1, i8* %arg2, i8* %arg3) {
entry:
  %call29B0 = call i8** @sub_1400029B0(i8* %arg1, i8* %arg2, i8* %arg3)
  %loaded = load i8*, i8** %call29B0, align 8
  %call2A88 = call i64 @sub_140002A88(i8* %loaded, i8* %arg1, i8* %arg2, i32 0, i8* %arg3)
  ret i64 %call2A88
}