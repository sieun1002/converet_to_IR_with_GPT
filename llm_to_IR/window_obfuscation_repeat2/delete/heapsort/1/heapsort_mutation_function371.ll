; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare dllimport i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare i64* @sub_140002A10()
declare void @llvm.va_start(i8*)

define dso_local i32 @sub_1400029C0(i8* %stream, i8* %format, ...) {
entry:
  %optptr = call i64* @sub_140002A10()
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %opt = load i64, i64* %optptr, align 8
  %ap.val = load i8*, i8** %ap, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %opt, i8* %stream, i8* %format, i8* null, i8* %ap.val)
  ret i32 %call
}