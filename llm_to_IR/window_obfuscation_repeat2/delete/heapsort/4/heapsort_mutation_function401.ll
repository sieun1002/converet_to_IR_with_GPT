; ModuleID: 'module'
source_filename = "module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@aRuntimeErrorD = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare i8* @__acrt_iob_func(i32 noundef)
declare i32 @sub_1400029C0(i8* noundef, i8* noundef, i32 noundef)
declare void @_exit(i32 noundef) noreturn

define dso_local void @sub_140002A30(i32 noundef %0) noreturn {
entry:
  %1 = call i8* @__acrt_iob_func(i32 noundef 2)
  %2 = getelementptr inbounds [18 x i8], [18 x i8]* @aRuntimeErrorD, i64 0, i64 0
  %3 = call i32 @sub_1400029C0(i8* noundef %1, i8* noundef %2, i32 noundef %0)
  call void @_exit(i32 noundef 255)
  unreachable
}