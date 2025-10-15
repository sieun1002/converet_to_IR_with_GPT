; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i8* @loc_140002A6D_3(i32)
declare i8* @sub_1400029B0()
declare void @sub_140002A88(i8*, i8*, i8*, i32, i8*)

define void @sub_140002900(i8* %rcx_in, i8* %rdx_in, i8* %r8_in, i8* %r9_in) {
entry:
  %stack = alloca [3 x i8*], align 8
  %rsi.ptr = bitcast [3 x i8*]* %stack to i8*
  %stack.idx0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %stack, i64 0, i64 0
  store i8* %rdx_in, i8** %stack.idx0, align 8
  %stack.idx1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %stack, i64 0, i64 1
  store i8* %r8_in, i8** %stack.idx1, align 8
  %stack.idx2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %stack, i64 0, i64 2
  store i8* %r9_in, i8** %stack.idx2, align 8
  %call1 = call i8* @loc_140002A6D_3(i32 1)
  %p_raw = call i8* @sub_1400029B0()
  %p_cast = bitcast i8* %p_raw to i8**
  %p0 = load i8*, i8** %p_cast, align 8
  call void @sub_140002A88(i8* %p0, i8* %call1, i8* %rcx_in, i32 0, i8* %rsi.ptr)
  ret void
}