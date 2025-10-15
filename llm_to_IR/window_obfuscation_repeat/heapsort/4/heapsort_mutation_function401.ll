; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str.runtime_error = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @fprintf(i8*, i8*, ...)
declare dso_local void @_exit(i32) noreturn

define dso_local void @sub_140002A30(i32 %arg0) noreturn {
entry:
  %io = call i8* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [18 x i8], [18 x i8]* @.str.runtime_error, i64 0, i64 0
  %call = call i32 (i8*, i8*, ...) @fprintf(i8* %io, i8* %fmt, i32 %arg0)
  call void @_exit(i32 255)
  unreachable
}