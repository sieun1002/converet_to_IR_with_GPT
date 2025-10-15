; ModuleID = 'printf_wrapper'
target triple = "x86_64-pc-windows-msvc"

@__local_stdio_printf_options = internal global i64 0, align 8

declare void @llvm.va_start.p0i8(i8*)
declare void @llvm.va_end.p0i8(i8*)

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

define dso_local i64* @sub_140002A10() {
entry:
  ret i64* @__local_stdio_printf_options
}

define dso_local i32 @sub_140002960(i8* %fmt, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start.p0i8(i8* %ap.cast)
  %file = call dso_local i8* @__acrt_iob_func(i32 1)
  %optptr = call dso_local i64* @sub_140002A10()
  %options = load i64, i64* %optptr, align 8
  %apval = load i8*, i8** %ap, align 8
  %res = call dso_local i32 @__stdio_common_vfprintf(i64 %options, i8* %file, i8* %fmt, i8* null, i8* %apval)
  call void @llvm.va_end.p0i8(i8* %ap.cast)
  ret i32 %res
}