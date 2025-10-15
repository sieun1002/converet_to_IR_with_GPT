; ModuleID = 'module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@aRuntimeErrorD = internal constant [18 x i8] c"runtime error %d\0A\00"

declare dllimport i8* @__acrt_iob_func(i32)
declare dso_local i32 @sub_140002AA0(i8*, i8*, ...)
declare dllimport void @_exit(i32) noreturn

define dso_local void @sub_140002B10(i32 %arg) {
entry:
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmtptr = getelementptr inbounds [18 x i8], [18 x i8]* @aRuntimeErrorD, i64 0, i64 0
  %call = call i32 (i8*, i8*, ...) @sub_140002AA0(i8* %stream, i8* %fmtptr, i32 %arg)
  call void @_exit(i32 255)
  unreachable
}