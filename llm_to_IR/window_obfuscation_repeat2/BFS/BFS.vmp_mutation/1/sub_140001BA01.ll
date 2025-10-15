; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_140002AA0(i8*, i8*)
declare i32 @sub_140002A00(i8*, i8*, i8*)
declare void @abort()

define void @sub_140001BA0(i8* %fmt, i64 %a2, i64 %a3, i64 %a4) {
entry:
  %argbuf = alloca [3 x i64], align 8
  %argbuf0 = getelementptr inbounds [3 x i64], [3 x i64]* %argbuf, i64 0, i64 0
  store i64 %a2, i64* %argbuf0, align 8
  %argbuf1 = getelementptr inbounds [3 x i64], [3 x i64]* %argbuf, i64 0, i64 1
  store i64 %a3, i64* %argbuf1, align 8
  %argbuf2 = getelementptr inbounds [3 x i64], [3 x i64]* %argbuf, i64 0, i64 2
  store i64 %a4, i64* %argbuf2, align 8
  %stream1 = call i8* @__acrt_iob_func(i32 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  %call1 = call i32 @sub_140002AA0(i8* %stream1, i8* %msgptr)
  %stream2 = call i8* @__acrt_iob_func(i32 2)
  %arglistptr = bitcast i64* %argbuf0 to i8*
  %call2 = call i32 @sub_140002A00(i8* %stream2, i8* %fmt, i8* %arglistptr)
  call void @abort()
  unreachable
}