; ModuleID = 'sub_140001AD0'
target triple = "x86_64-w64-windows-gnu"

@.str.mingw = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local void @sub_1400029C0(i8*, i8*)
declare dso_local void @sub_140002920(i8*, i8*, i8*)
declare dso_local void @abort() noreturn

define dso_local void @sub_140001AD0(i8* %fmt, i64 %arg1, i64 %arg2, i64 %arg3) {
entry:
  %arglist.arr = alloca [3 x i64], align 16
  %arr.ptr0 = getelementptr inbounds [3 x i64], [3 x i64]* %arglist.arr, i32 0, i32 0
  store i64 %arg1, i64* %arr.ptr0, align 8
  %arr.ptr1 = getelementptr inbounds [3 x i64], [3 x i64]* %arglist.arr, i32 0, i32 1
  store i64 %arg2, i64* %arr.ptr1, align 8
  %arr.ptr2 = getelementptr inbounds [3 x i64], [3 x i64]* %arglist.arr, i32 0, i32 2
  store i64 %arg3, i64* %arr.ptr2, align 8
  %io1 = call i8* @__acrt_iob_func(i32 2)
  %msg.ptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str.mingw, i32 0, i32 0
  call void @sub_1400029C0(i8* %io1, i8* %msg.ptr)
  %io2 = call i8* @__acrt_iob_func(i32 2)
  %arglist.i8 = bitcast [3 x i64]* %arglist.arr to i8*
  call void @sub_140002920(i8* %io2, i8* %fmt, i8* %arglist.i8)
  call void @abort()
  unreachable
}