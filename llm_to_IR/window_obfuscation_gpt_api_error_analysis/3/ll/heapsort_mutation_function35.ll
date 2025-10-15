; ModuleID = 'sub_140002920.ll'
target triple = "x86_64-pc-windows-msvc"

declare dso_local i64* @sub_140002A10()
declare dso_local i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

define dso_local i32 @sub_140002920(i8* %stream, i8* %format, i8* %arglist) local_unnamed_addr {
entry:
  %opts.ptr = call i64* @sub_140002A10()
  %opts = load i64, i64* %opts.ptr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %opts, i8* %stream, i8* %format, i8* null, i8* %arglist)
  ret i32 %call
}