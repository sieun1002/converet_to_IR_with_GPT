; ModuleID = 'module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i64* @sub_140002A10()

declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

define dso_local i32 @sub_140002920(i8* %stream, i8* %format, i8* %arglist) {
entry:
  %opts_ptr = call i64* @sub_140002A10()
  %opts = load i64, i64* %opts_ptr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %opts, i8* %stream, i8* %format, i8* null, i8* %arglist)
  ret i32 %call
}