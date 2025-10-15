; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare void @sub_140002960(i8*, i8*)
declare void @sub_1400028C0(i8*, i8*, i8*)
declare void @abort()

define void @sub_140001A70(i8* %format, i64 %arg1, i64 %arg2, i64 %arg3) {
entry:
  %arglist = alloca [3 x i64], align 16
  %arglist.elem0 = getelementptr inbounds [3 x i64], [3 x i64]* %arglist, i64 0, i64 0
  store i64 %arg1, i64* %arglist.elem0, align 8
  %arglist.elem1 = getelementptr inbounds [3 x i64], [3 x i64]* %arglist, i64 0, i64 1
  store i64 %arg2, i64* %arglist.elem1, align 8
  %arglist.elem2 = getelementptr inbounds [3 x i64], [3 x i64]* %arglist, i64 0, i64 2
  store i64 %arg3, i64* %arglist.elem2, align 8
  %stream1 = call i8* @__acrt_iob_func(i32 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002960(i8* %stream1, i8* %msgptr)
  %arglist.i8 = bitcast [3 x i64]* %arglist to i8*
  %stream2 = call i8* @__acrt_iob_func(i32 2)
  call void @sub_1400028C0(i8* %stream2, i8* %format, i8* %arglist.i8)
  call void @abort()
  ret void
}