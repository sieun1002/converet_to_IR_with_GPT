; ModuleID = 'sub_140002920_module'
source_filename = "sub_140002920_module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare dso_local i64* @__local_stdio_printf_options()
declare dso_local i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

define dso_local i32 @sub_140002920(i8* %stream, i8* %format, i8* %arglist) local_unnamed_addr {
entry:
  %opts_ptr = call i64* @__local_stdio_printf_options()
  %opts = load i64, i64* %opts_ptr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %opts, i8* %stream, i8* %format, i8* null, i8* %arglist)
  ret i32 %call
}