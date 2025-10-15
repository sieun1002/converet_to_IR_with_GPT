; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str.runtime = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @sub_1400029C0(i8* %stream, i8* %str)
declare dso_local i32 @sub_140002920(i8* %stream, i8* %fmt, i8* %ap)
declare dso_local void @abort() noreturn

declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local void @sub_140001AD0(i8* %fmt, ...) noreturn {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %ap.val = load i8*, i8** %ap, align 8
  %stderr1 = call i8* @__acrt_iob_func(i32 2)
  %str.ptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str.runtime, i64 0, i64 0
  %call.printhdr = call i32 @sub_1400029C0(i8* %stderr1, i8* %str.ptr)
  %stderr2 = call i8* @__acrt_iob_func(i32 2)
  %call.vfprintf = call i32 @sub_140002920(i8* %stderr2, i8* %fmt, i8* %ap.val)
  call void @llvm.va_end(i8* %ap.cast)
  call void @abort()
  unreachable
}