; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare i8* @__acrt_iob_func(i32)
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare i64* @sub_140002A10()

declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_140002960(i8* %format, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  %stream = call i8* @__acrt_iob_func(i32 1)
  %optptr = call i64* @sub_140002A10()
  %options = load i64, i64* %optptr, align 8
  call void @llvm.va_start(i8* %ap.cast)
  %apval = load i8*, i8** %ap, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %options, i8* %stream, i8* %format, i8* null, i8* %apval)
  call void @llvm.va_end(i8* %ap.cast)
  ret i32 %call
}