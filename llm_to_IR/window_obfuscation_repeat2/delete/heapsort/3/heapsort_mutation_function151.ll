; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@str.Mingw = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*)
declare i32 @sub_140002920(i8*, i8*, i8*)
declare void @abort()
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define void @sub_140001AD0(i8* %fmt, ...) {
entry:
  %stream1 = call i8* @__acrt_iob_func(i32 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @str.Mingw, i64 0, i64 0
  %call1 = call i32 @sub_1400029C0(i8* %stream1, i8* %msgptr)
  %stream2 = call i8* @__acrt_iob_func(i32 2)
  %va = alloca i8*, align 8
  %va_cast = bitcast i8** %va to i8*
  call void @llvm.va_start(i8* %va_cast)
  %list = load i8*, i8** %va, align 8
  %call2 = call i32 @sub_140002920(i8* %stream2, i8* %fmt, i8* %list)
  call void @llvm.va_end(i8* %va_cast)
  call void @abort()
  unreachable
}