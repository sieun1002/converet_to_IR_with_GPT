; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare %struct._iobuf* @__acrt_iob_func(i32)
declare void @sub_140002AA0(%struct._iobuf*, i8*)
declare void @sub_140002A00(%struct._iobuf*, i8*, i8*)
declare void @abort()
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define void @sub_140001BA0(i8* %format, ...) {
entry:
  %va = alloca i8*, align 8
  %va_i8 = bitcast i8** %va to i8*
  call void @llvm.va_start(i8* %va_i8)

  %stream1 = call %struct._iobuf* @__acrt_iob_func(i32 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002AA0(%struct._iobuf* %stream1, i8* %strptr)

  %valist = load i8*, i8** %va, align 8
  %stream2 = call %struct._iobuf* @__acrt_iob_func(i32 2)
  call void @sub_140002A00(%struct._iobuf* %stream2, i8* %format, i8* %valist)

  call void @llvm.va_end(i8* %va_i8)
  call void @abort()
  unreachable
}