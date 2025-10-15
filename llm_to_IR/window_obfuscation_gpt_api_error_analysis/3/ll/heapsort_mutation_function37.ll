; ModuleID = 'sub_1400029C0_module'
target triple = "x86_64-pc-windows-msvc"

declare i64* @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_1400029C0(i8* %stream, i8* %format, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %opts.ptr = call i64* @sub_140002A10()
  %opts = load i64, i64* %opts.ptr, align 8
  %ap.val = load i8*, i8** %ap, align 8
  %ret = call i32 @__stdio_common_vfprintf(i64 %opts, i8* %stream, i8* %format, i8* null, i8* %ap.val)
  call void @llvm.va_end(i8* %ap.cast)
  ret i32 %ret
}