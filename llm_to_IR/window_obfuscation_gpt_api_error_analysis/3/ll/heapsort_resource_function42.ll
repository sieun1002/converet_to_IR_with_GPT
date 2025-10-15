; ModuleID = 'sub_140002A30'
source_filename = "sub_140002A30.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str.runtime_error = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*, ...)
declare void @_exit(i32) noreturn

define dso_local void @sub_140002A30(i32 %code) noreturn {
entry:
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.runtime_error, i64 0, i64 0
  %call.print = call i32 (i8*, i8*, ...) @sub_1400029C0(i8* %stream, i8* %fmt.ptr, i32 %code)
  call void @_exit(i32 255)
  unreachable
}