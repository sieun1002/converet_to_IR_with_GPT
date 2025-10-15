; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare dso_local i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare dso_local i64* @__local_stdio_printf_options()

define dso_local i64* @sub_140002A10() {
entry:
  %p = call i64* @__local_stdio_printf_options()
  ret i64* %p
}

define dso_local i32 @sub_140002920(i8* %stream, i8* %format, i8* %arglist) {
entry:
  %options_ptr = call i64* @sub_140002A10()
  %options = load i64, i64* %options_ptr, align 8
  %res = call i32 @__stdio_common_vfprintf(i64 %options, i8* %stream, i8* %format, i8* null, i8* %arglist)
  ret i32 %res
}