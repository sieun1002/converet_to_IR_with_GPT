; ModuleID = 'sub_1400025A0_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @__acrt_iob_func(i32)
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare i64* @sub_140002650()

declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_1400025A0(i8* %Format, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)

  %stream = call i8* @__acrt_iob_func(i32 1)
  %opt.ptr = call i64* @sub_140002650()
  %opt = load i64, i64* %opt.ptr, align 8
  %ap.val = load i8*, i8** %ap, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %opt, i8* %stream, i8* %Format, i8* null, i8* %ap.val)

  call void @llvm.va_end(i8* %ap.cast)
  ret i32 %call
}