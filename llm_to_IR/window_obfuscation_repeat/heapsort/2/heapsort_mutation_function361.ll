; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type { i8* }

declare dso_local %struct._iobuf* @__acrt_iob_func(i32)
declare dso_local i64* @sub_140002A10()
declare dso_local i32 @__stdio_common_vfprintf(i64, %struct._iobuf*, i8*, i8*, i8*)
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_140002960(i8* %format, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap_i8 = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap_i8)
  %stream = call %struct._iobuf* @__acrt_iob_func(i32 1)
  %opts_ptr = call i64* @sub_140002A10()
  %opts = load i64, i64* %opts_ptr, align 8
  %ap_val = load i8*, i8** %ap, align 8
  %res = call i32 @__stdio_common_vfprintf(i64 %opts, %struct._iobuf* %stream, i8* %format, i8* null, i8* %ap_val)
  call void @llvm.va_end(i8* %ap_i8)
  ret i32 %res
}