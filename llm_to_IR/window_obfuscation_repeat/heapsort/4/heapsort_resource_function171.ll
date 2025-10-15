; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @fprintf(i8*, i8*, ...)
declare dso_local i32 @vfprintf(i8*, i8*, i8*)
declare dso_local void @abort()
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local void @sub_140001AD0(i8* %format, ...) {
entry:
  %stream1 = call i8* @__acrt_iob_func(i32 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, i8*, ...) @fprintf(i8* %stream1, i8* %msgptr)
  %stream2 = call i8* @__acrt_iob_func(i32 2)
  %ap_storage = alloca i8*, align 8
  %ap_storage_cast = bitcast i8** %ap_storage to i8*
  call void @llvm.va_start(i8* %ap_storage_cast)
  %ap = load i8*, i8** %ap_storage, align 8
  %call2 = call i32 @vfprintf(i8* %stream2, i8* %format, i8* %ap)
  call void @llvm.va_end(i8* %ap_storage_cast)
  call void @abort()
  unreachable
}