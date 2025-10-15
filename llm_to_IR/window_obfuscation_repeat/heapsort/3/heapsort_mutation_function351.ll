; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"

declare dso_local i64* @sub_140002A10()
declare dso_local i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

define dso_local i32 @sub_140002920(i8* %Stream, i8* %Format, i8* %ArgList) local_unnamed_addr {
entry:
  %optptr = call i64* @sub_140002A10()
  %options = load i64, i64* %optptr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %options, i8* %Stream, i8* %Format, i8* null, i8* %ArgList)
  ret i32 %call
}