; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*)
declare i32 @sub_140002920(i8*, i8*, i8*)
declare void @abort() noreturn
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define void @sub_140001AD0(i8* %fmt, ...) {
entry:
  %stream1 = call i8* @__acrt_iob_func(i32 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 @sub_1400029C0(i8* %stream1, i8* %msgptr)
  %ap = alloca i8*, align 8
  %ap_cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap_cast)
  %apval = load i8*, i8** %ap, align 8
  %stream2 = call i8* @__acrt_iob_func(i32 2)
  %call2 = call i32 @sub_140002920(i8* %stream2, i8* %fmt, i8* %apval)
  call void @llvm.va_end(i8* %ap_cast)
  call void @abort()
  unreachable
}