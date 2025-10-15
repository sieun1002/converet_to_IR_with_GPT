; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*)
declare i32 @sub_140002920(i8*, i8*, i8*)
declare void @abort()
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define void @sub_140001AD0(i8* %format, ...) {
entry:
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %stderr1 = call i8* @__acrt_iob_func(i32 2)
  %str.ptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  %call1 = call i32 @sub_1400029C0(i8* %stderr1, i8* %str.ptr)
  %apval = load i8*, i8** %ap, align 8
  %stderr2 = call i8* @__acrt_iob_func(i32 2)
  %call2 = call i32 @sub_140002920(i8* %stderr2, i8* %format, i8* %apval)
  call void @abort()
  unreachable
}