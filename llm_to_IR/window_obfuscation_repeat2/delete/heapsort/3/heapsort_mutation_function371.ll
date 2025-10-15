; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

declare i64* @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_1400029C0(i8* %stream, i8* %format, ...) {
entry:
  %va = alloca i8*, align 8
  %va.cast = bitcast i8** %va to i8*
  call void @llvm.va_start(i8* %va.cast)
  %opts.ptr = call i64* @sub_140002A10()
  %opts = load i64, i64* %opts.ptr, align 8
  %arglist = load i8*, i8** %va, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %opts, i8* %stream, i8* %format, i8* null, i8* %arglist)
  call void @llvm.va_end(i8* %va.cast)
  ret i32 %call
}