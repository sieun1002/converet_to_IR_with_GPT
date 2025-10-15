; ModuleID = 'm'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare %struct._iobuf* @__acrt_iob_func(i32)
declare void @sub_1400029C0(%struct._iobuf*, i8*)
declare void @sub_140002920(%struct._iobuf*, i8*, i8*)
declare void @abort() noreturn
declare void @llvm.va_start(i8*)

define void @sub_140001AD0(i8* %format, ...) {
entry:
  %s1 = call %struct._iobuf* @__acrt_iob_func(i32 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_1400029C0(%struct._iobuf* %s1, i8* %msgptr)
  %s2 = call %struct._iobuf* @__acrt_iob_func(i32 2)
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %ap.val = load i8*, i8** %ap, align 8
  call void @sub_140002920(%struct._iobuf* %s2, i8* %format, i8* %ap.val)
  call void @abort()
  unreachable
}