; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare void @sub_1400029C0(i8*, i8*)
declare void @sub_140002920(i8*, i8*, i8*)
declare void @abort()

define void @sub_140001AD0(i8* %fmt, i64 %arg1, i64 %arg2, i64 %arg3) {
entry:
  %arr = alloca [3 x i64], align 16
  %p0 = getelementptr inbounds [3 x i64], [3 x i64]* %arr, i32 0, i32 0
  store i64 %arg1, i64* %p0, align 8
  %p1 = getelementptr inbounds [3 x i64], [3 x i64]* %arr, i32 0, i32 1
  store i64 %arg2, i64* %p1, align 8
  %p2 = getelementptr inbounds [3 x i64], [3 x i64]* %arr, i32 0, i32 2
  store i64 %arg3, i64* %p2, align 8
  %stderr1 = call i8* @__acrt_iob_func(i32 2)
  %prefix = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i32 0, i32 0
  call void @sub_1400029C0(i8* %stderr1, i8* %prefix)
  %stderr2 = call i8* @__acrt_iob_func(i32 2)
  %arglist_ptr = bitcast [3 x i64]* %arr to i8*
  call void @sub_140002920(i8* %stderr2, i8* %fmt, i8* %arglist_ptr)
  call void @abort()
  unreachable
}