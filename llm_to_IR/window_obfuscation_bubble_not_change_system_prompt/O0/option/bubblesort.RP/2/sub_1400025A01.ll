; ModuleID = 'sub_1400025A0'
target triple = "x86_64-pc-windows-msvc"

declare i8* @__acrt_iob_func(i32)
declare i64* @sub_140002650()
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare void @llvm.va_start(i8*)

define dso_local i32 @sub_1400025A0(i8* %Format, ...) {
entry:
  %stream = call i8* @__acrt_iob_func(i32 1)
  %optptr = call i64* @sub_140002650()
  %options = load i64, i64* %optptr, align 8
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %va = load i8*, i8** %ap, align 8
  %ret = call i32 @__stdio_common_vfprintf(i64 %options, i8* %stream, i8* %Format, i8* null, i8* %va)
  ret i32 %ret
}