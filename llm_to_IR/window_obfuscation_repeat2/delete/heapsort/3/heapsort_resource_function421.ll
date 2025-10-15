; ModuleID = 'module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@aRuntimeErrorD = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*, i32)
declare void @_exit(i32) noreturn

define void @sub_140002A30(i32 %0) noreturn {
entry:
  %1 = call i8* @__acrt_iob_func(i32 2)
  %2 = getelementptr inbounds [18 x i8], [18 x i8]* @aRuntimeErrorD, i64 0, i64 0
  %3 = call i32 @sub_1400029C0(i8* %1, i8* %2, i32 %0)
  call void @_exit(i32 255)
  unreachable
}