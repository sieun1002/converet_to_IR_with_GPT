; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @__acrt_iob_func(i32)
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare i64* @sub_140002A10()
declare void @llvm.va_start(i8*)

define dso_local i32 @sub_140002960(i8* %format, ...) {
entry:
  %stream = call i8* @__acrt_iob_func(i32 1)
  %opts_ptr = call i64* @sub_140002A10()
  %opts = load i64, i64* %opts_ptr, align 8
  %ap = alloca i8*, align 8
  %ap_i8 = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap_i8)
  %apval = load i8*, i8** %ap, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %opts, i8* %stream, i8* %format, i8* null, i8* %apval)
  ret i32 %call
}