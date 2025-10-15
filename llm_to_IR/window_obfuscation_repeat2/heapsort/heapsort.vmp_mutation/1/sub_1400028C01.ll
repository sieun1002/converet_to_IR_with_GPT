; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i64* @sub_1400029B0()
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

define i32 @sub_1400028C0(i8* %stream, i8* %format, i8* %arglist) {
entry:
  %optptr = call i64* @sub_1400029B0()
  %options = load i64, i64* %optptr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %options, i8* %stream, i8* %format, i8* null, i8* %arglist)
  ret i32 %call
}