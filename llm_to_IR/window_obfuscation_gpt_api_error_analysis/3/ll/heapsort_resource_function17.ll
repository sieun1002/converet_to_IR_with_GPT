; ModuleID = 'sub_140001AD0.ll'
target triple = "x86_64-w64-windows-gnu"

@.str.mingwfail = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*)
declare i32 @sub_140002920(i8*, i8*, i8*)
declare void @abort()
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local void @sub_140001AD0(i8* %fmt, ...) noreturn {
entry:
  %va = alloca i8*, align 8
  %stderr1 = call i8* @__acrt_iob_func(i32 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str.mingwfail, i32 0, i32 0
  %call1 = call i32 @sub_1400029C0(i8* %stderr1, i8* %msgptr)
  %va.cast = bitcast i8** %va to i8*
  call void @llvm.va_start(i8* %va.cast)
  %stderr2 = call i8* @__acrt_iob_func(i32 2)
  %va.val = load i8*, i8** %va, align 8
  %call2 = call i32 @sub_140002920(i8* %stderr2, i8* %fmt, i8* %va.val)
  call void @llvm.va_end(i8* %va.cast)
  call void @abort()
  unreachable
}