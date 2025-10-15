; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @fputs(i8*, i8*)
declare i32 @vfprintf(i8*, i8*, i8*)
declare void @abort()
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define i32 @sub_1400029C0(i8* %stream, i8* %msg) {
entry:
  %call = call i32 @fputs(i8* %msg, i8* %stream)
  ret i32 %call
}

define i32 @sub_140002920(i8* %stream, i8* %fmt, i8* %ap) {
entry:
  %call = call i32 @vfprintf(i8* %stream, i8* %fmt, i8* %ap)
  ret i32 %call
}

define void @sub_140001AD0(i8* %format, ...) {
entry:
  %stream1 = call i8* @__acrt_iob_func(i32 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str, i64 0, i64 0
  %callprint = call i32 @sub_1400029C0(i8* %stream1, i8* %strptr)
  %ap = alloca i8*, align 8
  %ap_cast = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap_cast)
  %stream2 = call i8* @__acrt_iob_func(i32 2)
  %apval = load i8*, i8** %ap, align 8
  %callv = call i32 @sub_140002920(i8* %stream2, i8* %format, i8* %apval)
  call void @llvm.va_end(i8* %ap_cast)
  call void @abort()
  ret void
}