; ModuleID = 'fixed_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@aRuntimeErrorD = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare dllimport i8* @__acrt_iob_func(i32 noundef)
declare i32 @sub_1400029C0(i8* noundef, i8* noundef, i32 noundef)
declare dllimport void @_exit(i32 noundef) noreturn

define dso_local void @sub_140002A30(i32 noundef %err) noreturn {
entry:
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmtptr = getelementptr inbounds [18 x i8], [18 x i8]* @aRuntimeErrorD, i64 0, i64 0
  %call = call i32 @sub_1400029C0(i8* %stream, i8* %fmtptr, i32 %err)
  call void @_exit(i32 255)
  unreachable
}