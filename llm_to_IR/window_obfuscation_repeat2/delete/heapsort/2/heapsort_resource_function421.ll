; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@aRuntimeErrorD = internal unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare i8* @__acrt_iob_func(i32 noundef)
declare i32 @sub_1400029C0(i8* noundef, i8* noundef, i32 noundef)
declare void @_exit(i32 noundef) noreturn

define void @sub_140002A30(i32 noundef %0) noreturn {
entry:
  %call = call i8* @__acrt_iob_func(i32 noundef 2)
  %fmtptr = getelementptr inbounds [18 x i8], [18 x i8]* @aRuntimeErrorD, i64 0, i64 0
  %call2 = call i32 @sub_1400029C0(i8* noundef %call, i8* noundef %fmtptr, i32 noundef %0)
  call void @_exit(i32 noundef 255)
  unreachable
}