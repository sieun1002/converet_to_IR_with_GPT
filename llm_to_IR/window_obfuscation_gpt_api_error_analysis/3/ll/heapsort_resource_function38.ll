target triple = "x86_64-pc-windows-msvc"

declare i8* @__acrt_iob_func(i32 noundef)
declare i64* @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64 noundef, i8* noundef, i8* noundef, i8* noundef, i8* noundef)
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_140002960(i8* noundef %Format, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap_i8 = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap_i8)
  %stream = call i8* @__acrt_iob_func(i32 1)
  %opt_ptr = call i64* @sub_140002A10()
  %options = load i64, i64* %opt_ptr, align 8
  %ap_val = load i8*, i8** %ap, align 8
  %ret = call i32 @__stdio_common_vfprintf(i64 %options, i8* %stream, i8* %Format, i8* null, i8* %ap_val)
  call void @llvm.va_end(i8* %ap_i8)
  ret i32 %ret
}