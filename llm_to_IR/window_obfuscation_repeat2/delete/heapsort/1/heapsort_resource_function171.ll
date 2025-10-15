; ModuleID = 'reconstructed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*)
declare i32 @sub_140002920(i8*, i8*, i8*)
declare void @abort() noreturn

define void @sub_140001AD0(i8* %0, i64 %1, i64 %2, i64 %3) {
entry:
  %arr = alloca [3 x i64], align 16
  %ptr1 = getelementptr inbounds [3 x i64], [3 x i64]* %arr, i64 0, i64 0
  store i64 %1, i64* %ptr1, align 8
  %ptr2 = getelementptr inbounds [3 x i64], [3 x i64]* %arr, i64 0, i64 1
  store i64 %2, i64* %ptr2, align 8
  %ptr3 = getelementptr inbounds [3 x i64], [3 x i64]* %arr, i64 0, i64 2
  store i64 %3, i64* %ptr3, align 8
  %stream1 = call i8* @__acrt_iob_func(i32 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 @sub_1400029C0(i8* %stream1, i8* %msgptr)
  %stream2 = call i8* @__acrt_iob_func(i32 2)
  %arglist_i8 = bitcast [3 x i64]* %arr to i8*
  %call2 = call i32 @sub_140002920(i8* %stream2, i8* %0, i8* %arglist_i8)
  call void @abort()
  unreachable
}