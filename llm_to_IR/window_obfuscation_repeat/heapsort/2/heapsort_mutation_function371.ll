; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

declare dso_local i64* @sub_140002A10()
declare dso_local i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

@__security_cookie = external dso_local global i64
declare dso_local void @__security_check_cookie(i64)

define dso_local i32 @sub_1400029C0(i8* %stream, i8* %format, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %optptr = call dso_local i64* @sub_140002A10()
  %opt = load i64, i64* %optptr, align 8
  %apval = load i8*, i8** %ap, align 8
  %call = call dso_local i32 @__stdio_common_vfprintf(i64 %opt, i8* %stream, i8* %format, i8* null, i8* %apval)
  call void @llvm.va_end(i8* %ap.cast)
  ret i32 %call
}