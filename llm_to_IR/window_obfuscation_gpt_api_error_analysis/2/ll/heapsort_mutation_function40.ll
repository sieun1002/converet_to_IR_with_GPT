; ModuleID = 'sub_140002A30.ll'
target triple = "x86_64-pc-windows-msvc"

@str_runtime_error = internal constant [18 x i8] c"runtime error %d\0A\00", align 1

declare dso_local i8* @__acrt_iob_func(i32 noundef) local_unnamed_addr
declare dso_local i32 @sub_1400029C0(i8* noundef, i8* noundef, i32 noundef) local_unnamed_addr
declare dso_local void @_exit(i32 noundef) noreturn

define dso_local void @sub_140002A30(i32 noundef %code) local_unnamed_addr noreturn {
entry:
  %call.iob = call i8* @__acrt_iob_func(i32 noundef 2)
  %fmt.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @str_runtime_error, i64 0, i64 0
  %call.print = call i32 @sub_1400029C0(i8* noundef %call.iob, i8* noundef %fmt.ptr, i32 noundef %code)
  call void @_exit(i32 noundef 255)
  unreachable
}