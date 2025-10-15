; ModuleID = 'msvc_printf_wrapper'
source_filename = "msvc_printf_wrapper.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct._iobuf = type { i8* }

@__local_stdio_printf_options_storage = internal global i64 0, align 8

declare void @llvm.va_start(i8*) nounwind
declare void @llvm.va_end(i8*) nounwind

declare dso_local i32 @__stdio_common_vfprintf(i64, %struct._iobuf*, i8*, i8*, i8*)

define dso_local i64* @sub_140002A10() {
entry:
  ret i64* @__local_stdio_printf_options_storage
}

define dso_local i32 @sub_1400029C0(%struct._iobuf* %stream, i8* %format, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap.i8 = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.i8)
  %optptr = call i64* @sub_140002A10()
  %opts = load i64, i64* %optptr, align 8
  %apval = load i8*, i8** %ap, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %opts, %struct._iobuf* %stream, i8* %format, i8* null, i8* %apval)
  call void @llvm.va_end(i8* %ap.i8)
  ret i32 %call
}