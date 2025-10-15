; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare void @sub_1400029C0(i8*, i8*)
declare void @sub_140002920(i8*, i8*, i8*)
declare void @abort() noreturn

define void @sub_140001AD0(i8* %format, ...) {
entry:
  %stderr1 = call i8* @__acrt_iob_func(i32 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_1400029C0(i8* %stderr1, i8* %msgptr)
  %ap = alloca i8*, align 8
  %ap_i8 = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap_i8)
  %stderr2 = call i8* @__acrt_iob_func(i32 2)
  %ap_val = load i8*, i8** %ap, align 8
  call void @sub_140002920(i8* %stderr2, i8* %format, i8* %ap_val)
  call void @llvm.va_end(i8* %ap_i8)
  call void @abort()
  unreachable
}