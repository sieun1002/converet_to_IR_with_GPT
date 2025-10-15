; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

@.str = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare %struct._iobuf* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(%struct._iobuf*, i8*)
declare i32 @sub_140002920(%struct._iobuf*, i8*, i8*)
declare void @abort() noreturn
declare void @llvm.va_start(i8*) nounwind

define void @sub_140001AD0(i8* %format, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %stream1 = call %struct._iobuf* @__acrt_iob_func(i32 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 @sub_1400029C0(%struct._iobuf* %stream1, i8* %msgptr)
  %stream2 = call %struct._iobuf* @__acrt_iob_func(i32 2)
  %apval = load i8*, i8** %ap, align 8
  %call2 = call i32 @sub_140002920(%struct._iobuf* %stream2, i8* %format, i8* %apval)
  call void @abort()
  unreachable
}