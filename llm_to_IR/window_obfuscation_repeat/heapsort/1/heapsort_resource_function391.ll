; ModuleID = 'msvc_wrapper'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

@.local_stdio_printf_options = internal global i64 0, align 8

declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

declare dso_local i32 @__stdio_common_vfprintf(i64, %struct._iobuf*, i8*, i8*, i8*)

define dso_local i64* @sub_140002A10() {
entry:
  ret i64* @.local_stdio_printf_options
}

define dso_local i32 @sub_1400029C0(%struct._iobuf* %stream, i8* %format, ...) {
entry:
  %optptr = call i64* @sub_140002A10()
  %options = load i64, i64* %optptr, align 8
  %ap = alloca i8*, align 8
  %ap_cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap_cast)
  %ap_val = load i8*, i8** %ap, align 8
  %ret = call i32 @__stdio_common_vfprintf(i64 %options, %struct._iobuf* %stream, i8* %format, i8* null, i8* %ap_val)
  call void @llvm.va_end(i8* %ap_cast)
  ret i32 %ret
}