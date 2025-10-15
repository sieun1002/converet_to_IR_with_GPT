; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i8* @__acrt_iob_func(i32)
declare i64* @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local i32 @sub_140002960(i8* %fmt, ...) {
entry:
  %stream = call i8* @__acrt_iob_func(i32 1)
  %optptr = call i64* @sub_140002A10()
  %options = load i64, i64* %optptr, align 8
  %vl = alloca i8*, align 8
  %vl.cast = bitcast i8** %vl to i8*
  call void @llvm.va_start(i8* %vl.cast)
  %valist = load i8*, i8** %vl, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %options, i8* %stream, i8* %fmt, i8* null, i8* %valist)
  call void @llvm.va_end(i8* %vl.cast)
  ret i32 %call
}