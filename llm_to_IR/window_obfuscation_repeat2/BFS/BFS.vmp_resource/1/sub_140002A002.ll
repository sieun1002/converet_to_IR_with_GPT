; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare dso_local i64* @sub_140002AF0()
declare dllimport i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

define dso_local i32 @sub_140002A00(i8* %stream, i8* %format, i8* %arglist) {
entry:
  %optptr = call i64* @sub_140002AF0()
  %opt = load i64, i64* %optptr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %opt, i8* %stream, i8* %format, i8* null, i8* %arglist)
  ret i32 %call
}