; ModuleID = 'msvc_x64_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque
%struct._locale = type opaque

@g_stdio_options = internal global i64 0, align 8

declare dllimport i32 @__stdio_common_vfprintf(i64, %struct._iobuf*, i8*, %struct._locale*, i8*)

define dso_local i64* @sub_140002A10() {
entry:
  ret i64* @g_stdio_options
}

define dso_local i32 @sub_140002920(%struct._iobuf* %stream, i8* %format, i8* %arglist) {
entry:
  %opts_ptr = call i64* @sub_140002A10()
  %opts = load i64, i64* %opts_ptr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %opts, %struct._iobuf* %stream, i8* %format, %struct._locale* null, i8* %arglist)
  ret i32 %call
}