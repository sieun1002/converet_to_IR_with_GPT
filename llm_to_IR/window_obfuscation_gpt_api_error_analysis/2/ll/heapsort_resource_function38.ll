; Target: Windows x64 MSVC
target triple = "x86_64-pc-windows-msvc"

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i8* @sub_140002A10()
declare dso_local i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_140002960(i8* %format, ...) {
entry:
  %stream = call i8* @__acrt_iob_func(i32 1)
  %opts_base = call i8* @sub_140002A10()
  %opts_ptr = bitcast i8* %opts_base to i64*
  %opts = load i64, i64* %opts_ptr, align 8

  %ap = alloca i8*, align 8
  %ap_cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap_cast)
  %ap_val = load i8*, i8** %ap, align 8

  %ret = call i32 @__stdio_common_vfprintf(i64 %opts, i8* %stream, i8* %format, i8* null, i8* %ap_val)
  call void @llvm.va_end(i8* %ap_cast)
  ret i32 %ret
}