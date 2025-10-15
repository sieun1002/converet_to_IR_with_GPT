; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i64* @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare void @llvm.va_start(i8*)

define i32 @sub_1400029C0(i8* %Stream, i8* %Format, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap_i8 = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap_i8)
  %optptr = call i64* @sub_140002A10()
  %options = load i64, i64* %optptr, align 8
  %apval = load i8*, i8** %ap, align 8
  %ret = call i32 @__stdio_common_vfprintf(i64 %options, i8* %Stream, i8* %Format, i8* null, i8* %apval)
  ret i32 %ret
}