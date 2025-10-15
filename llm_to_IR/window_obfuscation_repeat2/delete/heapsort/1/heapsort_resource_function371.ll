; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

define i32 @sub_140002920(i8* %stream, i8* %format, i8* %arglist) {
entry:
  %opts_ptr_raw = call i8* @sub_140002A10()
  %opts_ptr = bitcast i8* %opts_ptr_raw to i64*
  %opts = load i64, i64* %opts_ptr
  %call = call i32 @__stdio_common_vfprintf(i64 %opts, i8* %stream, i8* %format, i8* null, i8* %arglist)
  ret i32 %call
}