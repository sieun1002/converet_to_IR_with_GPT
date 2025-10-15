; Target: Windows x86_64 (MinGW-w64/UCRT style)
target triple = "x86_64-w64-windows-gnu"

@.str.mingw_failure = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare dso_local i8* @__acrt_iob_func(i32 noundef)
declare dso_local i32 @sub_1400029C0(i8* noundef, i8* noundef)
declare dso_local i32 @sub_140002920(i8* noundef, i8* noundef, i8* noundef)
declare dso_local void @abort() noreturn nounwind
declare void @llvm.va_start(i8*) nounwind
declare void @llvm.va_end(i8*) nounwind

define dso_local void @sub_140001AD0(i8* noundef %format, ...) {
entry:
  %stream0 = call i8* @__acrt_iob_func(i32 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str.mingw_failure, i64 0, i64 0
  %call0 = call i32 @sub_1400029C0(i8* %stream0, i8* %msgptr)
  %stream1 = call i8* @__acrt_iob_func(i32 2)
  %ap.storage = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap.storage to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %ap.load = load i8*, i8** %ap.storage, align 8
  %call1 = call i32 @sub_140002920(i8* %stream1, i8* %format, i8* %ap.load)
  call void @llvm.va_end(i8* %ap.cast)
  call void @abort()
  unreachable
}