; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*, ...)
declare void @_exit(i32) noreturn

define void @sub_140002A30(i32 %code) noreturn {
entry:
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [18 x i8], [18 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, i8*, ...) @sub_1400029C0(i8* %stream, i8* %fmt, i32 %code)
  call void @_exit(i32 255)
  unreachable
}