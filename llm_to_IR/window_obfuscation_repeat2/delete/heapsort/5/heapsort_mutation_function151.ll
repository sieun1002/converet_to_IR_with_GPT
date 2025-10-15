; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32 noundef)
declare i32 @sub_1400029C0(i8* noundef, i8* noundef)
declare i32 @sub_140002920(i8* noundef, i8* noundef, i8* noundef)
declare void @abort() noreturn
declare void @llvm.va_start(i8*) nounwind

define void @sub_140001AD0(i8* noundef %0, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %call_iob_1 = call i8* @__acrt_iob_func(i32 noundef 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  %call_msg = call i32 @sub_1400029C0(i8* noundef %call_iob_1, i8* noundef %msgptr)
  %call_iob_2 = call i8* @__acrt_iob_func(i32 noundef 2)
  %apval = load i8*, i8** %ap, align 8
  %call_v = call i32 @sub_140002920(i8* noundef %call_iob_2, i8* noundef %0, i8* noundef %apval)
  call void @abort()
  unreachable
}