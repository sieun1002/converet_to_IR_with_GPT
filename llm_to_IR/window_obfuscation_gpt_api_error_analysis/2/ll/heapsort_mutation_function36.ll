; ModuleID = 'sub_140002960.ll'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i64* @sub_140002A10()
declare dso_local i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_140002960(i8* %format, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %stream = call i8* @__acrt_iob_func(i32 1)
  %opt.ptr = call i64* @sub_140002A10()
  %options = load i64, i64* %opt.ptr, align 8
  %ap.val = load i8*, i8** %ap, align 8
  %ret = call i32 @__stdio_common_vfprintf(i64 %options, i8* %stream, i8* %format, i8* null, i8* %ap.val)
  call void @llvm.va_end(i8* %ap.cast)
  ret i32 %ret
}