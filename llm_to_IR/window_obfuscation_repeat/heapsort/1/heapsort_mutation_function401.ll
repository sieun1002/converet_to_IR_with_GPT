; ModuleID = 'module'
source_filename = "module"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare i8* @__acrt_iob_func(i32 noundef)
declare i32 @sub_1400029C0(i8* noundef, i8* noundef, ...)
declare void @_exit(i32 noundef) noreturn

define dso_local void @sub_140002A30(i32 noundef %code) noreturn {
entry:
  %stream = call i8* @__acrt_iob_func(i32 noundef 2)
  %fmtptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, i8*, ...) @sub_1400029C0(i8* noundef %stream, i8* noundef %fmtptr, i32 noundef %code)
  call void @_exit(i32 noundef 255)
  unreachable
}