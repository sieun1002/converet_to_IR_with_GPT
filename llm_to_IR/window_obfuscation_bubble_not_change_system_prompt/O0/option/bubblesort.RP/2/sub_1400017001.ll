target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_140002600(i8*, i8*)
declare i32 @sub_140002560(i8*, i8*, i8*)
declare void @abort() noreturn

define dso_local void @sub_140001700(i8* %format, i64 %arg1, i64 %arg2, i64 %arg3) {
entry:
  %argbuf = alloca [3 x i64], align 16
  %argbuf.idx0 = getelementptr inbounds [3 x i64], [3 x i64]* %argbuf, i64 0, i64 0
  store i64 %arg1, i64* %argbuf.idx0, align 8
  %argbuf.idx1 = getelementptr inbounds [3 x i64], [3 x i64]* %argbuf, i64 0, i64 1
  store i64 %arg2, i64* %argbuf.idx1, align 8
  %argbuf.idx2 = getelementptr inbounds [3 x i64], [3 x i64]* %argbuf, i64 0, i64 2
  store i64 %arg3, i64* %argbuf.idx2, align 8
  %arglist.ptr = bitcast i64* %argbuf.idx0 to i8*

  %stderr1 = call i8* @__acrt_iob_func(i32 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  %call1 = call i32 @sub_140002600(i8* %stderr1, i8* %msgptr)

  %stderr2 = call i8* @__acrt_iob_func(i32 2)
  %call2 = call i32 @sub_140002560(i8* %stderr2, i8* %format, i8* %arglist.ptr)

  call void @abort()
  unreachable
}