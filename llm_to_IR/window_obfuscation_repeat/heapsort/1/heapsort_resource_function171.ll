; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare ptr @__acrt_iob_func(i32)
declare i32 @fputs(ptr, ptr)
declare i32 @vfprintf(ptr, ptr, ptr)
declare void @abort()
declare void @llvm.va_start(ptr)
declare void @llvm.va_end(ptr)

define void @sub_140001AD0(ptr %format, ...) {
entry:
  %ap = alloca ptr, align 8
  call void @llvm.va_start(ptr %ap)
  %stream1 = call ptr @__acrt_iob_func(i32 2)
  %hdrptr = getelementptr inbounds [28 x i8], ptr @.str, i64 0, i64 0
  %callhdr = call i32 @fputs(ptr %hdrptr, ptr %stream1)
  %stream2 = call ptr @__acrt_iob_func(i32 2)
  %apval = load ptr, ptr %ap, align 8
  %callvf = call i32 @vfprintf(ptr %stream2, ptr %format, ptr %apval)
  call void @llvm.va_end(ptr %ap)
  call void @abort()
  unreachable
}