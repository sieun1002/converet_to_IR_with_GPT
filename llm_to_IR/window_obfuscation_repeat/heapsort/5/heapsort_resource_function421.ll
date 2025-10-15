; ModuleID = 'fixed'
source_filename = "fixed"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@aRuntimeErrorD = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare dllimport i8* @__acrt_iob_func(i32)
declare dllimport i32 @fprintf(i8*, i8*, ...)
declare dllimport void @_exit(i32) noreturn

define dso_local void @sub_140002A30(i32 %code) {
entry:
  %stderr.ptr = call i8* @__acrt_iob_func(i32 2)
  %fmt.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @aRuntimeErrorD, i64 0, i64 0
  %call.fprintf = call i32 (i8*, i8*, ...) @fprintf(i8* %stderr.ptr, i8* %fmt.ptr, i32 %code)
  call void @_exit(i32 255)
  unreachable
}