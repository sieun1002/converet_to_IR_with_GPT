; Target: Windows x64 (MinGW-w64/UCRT)
target triple = "x86_64-w64-windows-gnu"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @sub_1400029C0(i8*, i8*)
declare dso_local i32 @sub_140002920(i8*, i8*, i8*)
declare dso_local void @abort() noreturn
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local void @sub_140001AD0(i8* %format, ...) noreturn {
entry:
  %stderr1 = call i8* @__acrt_iob_func(i32 2)
  %msg.ptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  %preamble.write = call i32 @sub_1400029C0(i8* %stderr1, i8* %msg.ptr)
  %ap.storage = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap.storage to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %stderr2 = call i8* @__acrt_iob_func(i32 2)
  %ap.val = load i8*, i8** %ap.storage, align 8
  %vf.write = call i32 @sub_140002920(i8* %stderr2, i8* %format, i8* %ap.val)
  call void @llvm.va_end(i8* %ap.cast)
  call void @abort()
  unreachable
}