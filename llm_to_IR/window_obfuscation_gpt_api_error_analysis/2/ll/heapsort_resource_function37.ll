; ModuleID = 'wrapper'
target triple = "x86_64-pc-windows-msvc"

declare i64* @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

define dso_local i32 @sub_140002920(i8* %stream, i8* %format, i8* %arglist) local_unnamed_addr {
entry:
  %opt_ptr = call i64* @sub_140002A10()
  %options = load i64, i64* %opt_ptr, align 8
  %res = call i32 @__stdio_common_vfprintf(i64 %options, i8* %stream, i8* %format, i8* null, i8* %arglist)
  ret i32 %res
}