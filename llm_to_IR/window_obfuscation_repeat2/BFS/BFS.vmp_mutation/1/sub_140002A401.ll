; ModuleID = 'm'
target triple = "x86_64-pc-windows-msvc"

declare i8* @__acrt_iob_func(i32)
declare i64* @sub_140002AF0()
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define i32 @sub_140002A40(i8* %fmt, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)

  %stdout = call i8* @__acrt_iob_func(i32 1)
  %optptr = call i64* @sub_140002AF0()
  %options = load i64, i64* %optptr, align 8
  %ap.val = load i8*, i8** %ap, align 8

  %call = call i32 @__stdio_common_vfprintf(i64 %options, i8* %stdout, i8* %fmt, i8* null, i8* %ap.val)
  call void @llvm.va_end(i8* %ap.cast)
  ret i32 %call
}