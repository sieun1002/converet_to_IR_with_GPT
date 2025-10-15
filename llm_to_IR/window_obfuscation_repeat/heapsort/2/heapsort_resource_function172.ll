; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

@.str = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare dllimport %struct._iobuf* @__acrt_iob_func(i32)
declare dso_local void @sub_1400029C0(%struct._iobuf*, i8*)
declare dso_local void @sub_140002920(%struct._iobuf*, i8*, i8*)
declare dllimport void @abort()
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define dso_local void @sub_140001AD0(i8* %format, ...) {
entry:
  %stream1 = call %struct._iobuf* @__acrt_iob_func(i32 2)
  %msg.ptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str, i64 0, i64 0
  call void @sub_1400029C0(%struct._iobuf* %stream1, i8* %msg.ptr)
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %ap.val = load i8*, i8** %ap, align 8
  %stream2 = call %struct._iobuf* @__acrt_iob_func(i32 2)
  call void @sub_140002920(%struct._iobuf* %stream2, i8* %format, i8* %ap.val)
  call void @llvm.va_end(i8* %ap.cast)
  call void @abort()
  unreachable
}