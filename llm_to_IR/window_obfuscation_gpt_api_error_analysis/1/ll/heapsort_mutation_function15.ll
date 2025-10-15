; ModuleID = 'sub_140001AD0.ll'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-w64-windows-gnu"

@.str = private unnamed_addr constant [29 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @fputs(i8*, i8*)
declare i32 @vfprintf(i8*, i8*, i8*)
declare void @abort()
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define void @sub_140001AD0(i8* %fmt, ...) {
entry:
  %ap = alloca i8*, align 8
  %stderr1 = call i8* @__acrt_iob_func(i32 2)
  %msgptr = getelementptr inbounds [29 x i8], [29 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 @fputs(i8* %msgptr, i8* %stderr1)
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %apval = load i8*, i8** %ap, align 8
  %stderr2 = call i8* @__acrt_iob_func(i32 2)
  %call2 = call i32 @vfprintf(i8* %stderr2, i8* %fmt, i8* %apval)
  call void @llvm.va_end(i8* %ap.cast)
  call void @abort()
  unreachable
}