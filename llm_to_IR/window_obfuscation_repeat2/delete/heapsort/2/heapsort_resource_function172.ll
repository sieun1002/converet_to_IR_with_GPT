; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

@aMingwW64Runtim = internal constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare %struct._iobuf* @__acrt_iob_func(i32 noundef)
declare void @sub_1400029C0(%struct._iobuf* noundef, i8* noundef)
declare i32 @sub_140002920(%struct._iobuf* noundef, i8* noundef, i8** noundef)
declare void @abort() noreturn

define dso_local void @sub_140001AD0(i8* noundef %rcx_fmt, i8* noundef %rdx_arg, i8* noundef %r8_arg, i8* noundef %r9_arg) {
entry:
  %arr = alloca [3 x i8*], align 8
  %p0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i32 0, i32 0
  store i8* %rdx_arg, i8** %p0, align 8
  %p1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i32 0, i32 1
  store i8* %r8_arg, i8** %p1, align 8
  %p2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i32 0, i32 2
  store i8* %r9_arg, i8** %p2, align 8
  %stream1 = call %struct._iobuf* @__acrt_iob_func(i32 noundef 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_1400029C0(%struct._iobuf* noundef %stream1, i8* noundef %strptr)
  %stream2 = call %struct._iobuf* @__acrt_iob_func(i32 noundef 2)
  call i32 @sub_140002920(%struct._iobuf* noundef %stream2, i8* noundef %rcx_fmt, i8** noundef %p0)
  call void @abort()
  unreachable
}