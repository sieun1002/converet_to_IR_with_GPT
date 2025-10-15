; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type { i8* }

@.str = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare %struct._iobuf* @__acrt_iob_func(i32 noundef)
declare i32 @sub_1400029C0(%struct._iobuf* noundef, i8* noundef)
declare i32 @sub_140002920(%struct._iobuf* noundef, i8* noundef, i8* noundef)
declare void @abort() noreturn
declare void @llvm.va_start(i8*)

define void @sub_140001AD0(i8* noundef %fmt, ...) noreturn nounwind {
entry:
  %stream1 = call %struct._iobuf* @__acrt_iob_func(i32 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str, i64 0, i64 0
  %ignore1 = call i32 @sub_1400029C0(%struct._iobuf* %stream1, i8* %strptr)
  %stream2 = call %struct._iobuf* @__acrt_iob_func(i32 2)
  %ap = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap.cast)
  %ap.load = load i8*, i8** %ap, align 8
  %ignore2 = call i32 @sub_140002920(%struct._iobuf* %stream2, i8* %fmt, i8* %ap.load)
  call void @abort()
  unreachable
}