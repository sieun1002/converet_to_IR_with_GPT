; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct._iobuf = type opaque

declare dso_local i64* @sub_140002A10()
declare dso_local i32 @__stdio_common_vfprintf(i64, %struct._iobuf*, i8*, i8*, i8*)

define dso_local i32 @sub_140002920(%struct._iobuf* %stream, i8* %format, i8* %arglist) {
entry:
  %opts_ptr = call i64* @sub_140002A10()
  %opts = load i64, i64* %opts_ptr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %opts, %struct._iobuf* %stream, i8* %format, i8* null, i8* %arglist)
  ret i32 %call
}