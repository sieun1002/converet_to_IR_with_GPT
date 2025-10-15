; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

%struct._iobuf = type opaque

declare i64* @sub_140002A10()

declare dllimport i32 @__stdio_common_vfprintf(i64, %struct._iobuf*, i8*, i8*, i8*)

define dso_local i32 @sub_140002920(%struct._iobuf* %stream, i8* %format, i8* %arglist) {
entry:
  %optptr = call i64* @sub_140002A10()
  %options = load i64, i64* %optptr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %options, %struct._iobuf* %stream, i8* %format, i8* null, i8* %arglist)
  ret i32 %call
}