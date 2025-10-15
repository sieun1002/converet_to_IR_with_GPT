; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:x-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare i64* @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

define i32 @sub_1400029C0(i8* %stream, i8* %format, i64 %arg1, i64 %arg2) {
entry:
  %va = alloca [2 x i64], align 16
  %va0ptr = getelementptr inbounds [2 x i64], [2 x i64]* %va, i64 0, i64 0
  store i64 %arg1, i64* %va0ptr, align 8
  %va1ptr = getelementptr inbounds [2 x i64], [2 x i64]* %va, i64 0, i64 1
  store i64 %arg2, i64* %va1ptr, align 8
  %va_i8 = bitcast i64* %va0ptr to i8*
  %opts_ptr = call i64* @sub_140002A10()
  %options = load i64, i64* %opts_ptr, align 8
  %call = call i32 @__stdio_common_vfprintf(i64 %options, i8* %stream, i8* %format, i8* null, i8* %va_i8)
  ret i32 %call
}