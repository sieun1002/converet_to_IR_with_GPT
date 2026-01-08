; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32 noundef)
declare void @sub_140002600(i8* noundef, i8* noundef)
declare void @sub_140002560(i8* noundef, i8* noundef, i8* noundef)
declare void @abort() noreturn

define void @sub_140001700(i8* noundef %format, i64 noundef %arg1, i64 noundef %arg2, i64 noundef %arg3) local_unnamed_addr {
entry:
  %arr = alloca [3 x i64], align 8
  %arr0 = getelementptr inbounds [3 x i64], [3 x i64]* %arr, i64 0, i64 0
  store i64 %arg1, i64* %arr0, align 8
  %arr1 = getelementptr inbounds i64, i64* %arr0, i64 1
  store i64 %arg2, i64* %arr1, align 8
  %arr2 = getelementptr inbounds i64, i64* %arr1, i64 1
  store i64 %arg3, i64* %arr2, align 8
  %stream1 = call i8* @__acrt_iob_func(i32 noundef 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* noundef %stream1, i8* noundef %msgptr)
  %stream2 = call i8* @__acrt_iob_func(i32 noundef 2)
  %arglist_ptr = bitcast i64* %arr0 to i8*
  call void @sub_140002560(i8* noundef %stream2, i8* noundef %format, i8* noundef %arglist_ptr)
  call void @abort()
  unreachable
}