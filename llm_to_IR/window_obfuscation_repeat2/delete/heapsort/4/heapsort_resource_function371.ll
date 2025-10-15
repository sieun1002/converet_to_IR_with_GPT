; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare dllimport i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)
declare i64* @sub_140002A10()

define i32 @sub_140002920(i8* %stream, i8* %format, i8* %arglist) local_unnamed_addr {
entry:
  %p = call i64* @sub_140002A10()
  %opt = load i64, i64* %p, align 8
  %res = call i32 @__stdio_common_vfprintf(i64 %opt, i8* %stream, i8* %format, i8* null, i8* %arglist)
  ret i32 %res
}