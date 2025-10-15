; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare ptr @__acrt_iob_func(i32 noundef)
declare void @sub_1400029C0(ptr noundef, ptr noundef)
declare i32 @sub_140002920(ptr noundef, ptr noundef, ptr noundef)
declare void @abort() noreturn

define dso_local void @sub_140001AD0(ptr noundef %rcx_fmt, ptr noundef %rdx_arg, ptr noundef %r8_arg, ptr noundef %r9_arg) {
entry:
  %arr = alloca [3 x ptr], align 8
  %p0 = getelementptr inbounds [3 x ptr], ptr %arr, i32 0, i32 0
  store ptr %rdx_arg, ptr %p0, align 8
  %p1 = getelementptr inbounds [3 x ptr], ptr %arr, i32 0, i32 1
  store ptr %r8_arg, ptr %p1, align 8
  %p2 = getelementptr inbounds [3 x ptr], ptr %arr, i32 0, i32 2
  store ptr %r9_arg, ptr %p2, align 8
  %stream1 = call ptr @__acrt_iob_func(i32 noundef 2)
  %strptr = getelementptr inbounds [28 x i8], ptr @aMingwW64Runtim, i64 0, i64 0
  call void @sub_1400029C0(ptr noundef %stream1, ptr noundef %strptr)
  %stream2 = call ptr @__acrt_iob_func(i32 noundef 2)
  call i32 @sub_140002920(ptr noundef %stream2, ptr noundef %rcx_fmt, ptr noundef %p0)
  call void @abort()
  unreachable
}