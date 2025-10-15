; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @__acrt_iob_func(i32)
declare i64* @sub_140002A10()
declare i64 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define i64 @sub_140002960(i8* %Format, ...) {
entry:
  %stream = call i8* @__acrt_iob_func(i32 1)
  %optptr = call i64* @sub_140002A10()
  %Options = load i64, i64* %optptr, align 8
  %ap = alloca i8*
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %ap.val = load i8*, i8** %ap, align 8
  %res = call i64 @__stdio_common_vfprintf(i64 %Options, i8* %stream, i8* %Format, i8* null, i8* %ap.val)
  call void @llvm.va_end(i8* %ap.cast)
  ret i64 %res
}