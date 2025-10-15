; ModuleID = 'mingw_runtime_failure'
source_filename = "mingw_runtime_failure.ll"
target triple = "x86_64-pc-windows-msvc"

@.str.mingw = internal constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8* %stream, i8* %str)
declare i32 @sub_140002920(i8* %stream, i8* %format, i8* %ap)
declare void @abort() noreturn
declare void @llvm.va_start(i8*)
declare void @llvm.va_end(i8*)

define void @sub_140001AD0(i8* %format, ...) {
entry:
  %ap.addr = alloca i8*, align 8
  %ap.cast = bitcast i8** %ap.addr to i8*
  call void @llvm.va_start(i8* %ap.cast)

  %iob1 = call i8* @__acrt_iob_func(i32 2)
  %msg.ptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str.mingw, i64 0, i64 0
  %call1 = call i32 @sub_1400029C0(i8* %iob1, i8* %msg.ptr)

  %iob2 = call i8* @__acrt_iob_func(i32 2)
  %ap.val = load i8*, i8** %ap.addr, align 8
  %call2 = call i32 @sub_140002920(i8* %iob2, i8* %format, i8* %ap.val)

  call void @llvm.va_end(i8* %ap.cast)
  call void @abort()
  unreachable
}