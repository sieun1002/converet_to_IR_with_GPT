; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare ptr @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64, ptr, ptr, ptr, ptr)
declare void @llvm.va_start(ptr)
declare void @llvm.va_end(ptr)

define i32 @sub_1400029C0(ptr %stream, ptr %format, ...) {
entry:
  %va = alloca ptr, align 8
  call void @llvm.va_start(ptr %va)
  %valist = load ptr, ptr %va, align 8
  %optptr = call ptr @sub_140002A10()
  %opts = load i64, ptr %optptr, align 8
  %res = call i32 @__stdio_common_vfprintf(i64 %opts, ptr %stream, ptr %format, ptr null, ptr %valist)
  call void @llvm.va_end(ptr %va)
  ret i32 %res
}