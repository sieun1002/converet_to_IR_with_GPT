; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

define dso_local i32 @sub_140002920(i8* %stream, i8* %format, i8* %arglist) {
entry:
  %t0 = call i8* @sub_140002A10()
  %p = bitcast i8* %t0 to i64*
  %options = load i64, i64* %p, align 8
  %res = call i32 @__stdio_common_vfprintf(i64 %options, i8* %stream, i8* %format, i8* null, i8* %arglist)
  ret i32 %res
}