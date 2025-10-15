; ModuleID = 'msvc_printf_wrapper'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare i8* @__acrt_iob_func(i32 noundef)
declare i64* @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64 noundef, i8* noundef, i8* noundef, i8* noundef, i8* noundef)

declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_140002960(i8* noundef %format, ...) {
entry:
  %ap.addr = alloca i8*, align 8
  %ap.addr.i8 = bitcast i8** %ap.addr to i8*
  call void @llvm.va_start(i8* %ap.addr.i8)
  %stream = call i8* @__acrt_iob_func(i32 noundef 1)
  %opt.ptr = call i64* @sub_140002A10()
  %options = load i64, i64* %opt.ptr, align 8
  %ap.val = load i8*, i8** %ap.addr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 noundef %options, i8* noundef %stream, i8* noundef %format, i8* noundef null, i8* noundef %ap.val)
  call void @llvm.va_end(i8* %ap.addr.i8)
  ret i32 %call
}