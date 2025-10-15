; ModuleID = 'module'
source_filename = "module"
target triple = "x86_64-pc-windows-msvc"

declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

declare i8* @__acrt_iob_func(i32)
declare i64* @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

define i32 @sub_140002960(i8* %format, ...) {
entry:
  %va = alloca i8*, align 8
  %va.cast = bitcast i8** %va to i8*
  call void @llvm.va_start(i8* %va.cast)
  %stream = call i8* @__acrt_iob_func(i32 1)
  %optptr = call i64* @sub_140002A10()
  %opts = load i64, i64* %optptr, align 8
  %arglist = load i8*, i8** %va, align 8
  %res = call i32 @__stdio_common_vfprintf(i64 %opts, i8* %stream, i8* %format, i8* null, i8* %arglist)
  call void @llvm.va_end(i8* %va.cast)
  ret i32 %res
}