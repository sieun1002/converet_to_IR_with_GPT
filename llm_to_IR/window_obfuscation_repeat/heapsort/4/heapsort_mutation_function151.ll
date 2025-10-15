; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str.mingw_fail = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @sub_1400029C0(i8*, i8*)
declare dso_local i32 @sub_140002920(i8*, i8*, i8*)
declare dso_local void @abort()
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local void @sub_140001AD0(i8* %fmt, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  %stream1 = call i8* @__acrt_iob_func(i32 2)
  %prefix.ptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str.mingw_fail, i64 0, i64 0
  %call1 = call i32 @sub_1400029C0(i8* %stream1, i8* %prefix.ptr)
  call void @llvm.va_start(i8* %ap.cast)
  %stream2 = call i8* @__acrt_iob_func(i32 2)
  %apval = load i8*, i8** %ap, align 8
  %call2 = call i32 @sub_140002920(i8* %stream2, i8* %fmt, i8* %apval)
  call void @llvm.va_end(i8* %ap.cast)
  call void @abort()
  unreachable
}