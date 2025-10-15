; ModuleID = 'qs_print.ll'
source_filename = "qs_print.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.v0 = private unnamed_addr constant <4 x i32> <i32 9, i32 5, i32 3, i32 7>, align 16
@.v1 = private unnamed_addr constant <4 x i32> <i32 2, i32 8, i32 1, i32 6>, align 16

declare void @quick_sort(i32*, i64, i64)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0
  %vecptr0 = bitcast i32* %p0 to <4 x i32>*
  %v0 = load <4 x i32>, <4 x i32>* @.v0, align 16
  store <4 x i32> %v0, <4 x i32>* %vecptr0, align 16
  %p4 = getelementptr inbounds i32, i32* %p0, i64 4
  %vecptr1 = bitcast i32* %p4 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @.v1, align 16
  store <4 x i32> %v1, <4 x i32>* %vecptr1, align 16
  %p8 = getelementptr inbounds i32, i32* %p0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %p0, i64 9
  store i32 0, i32* %p9, align 4
  call void @quick_sort(i32* %p0, i64 0, i64 9)
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %idxptr = getelementptr inbounds i32, i32* %p0, i64 %i
  %val = load i32, i32* %idxptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %printres = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmtptr, i32 %val)
  br label %loop.inc

loop.inc:
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp ult i64 %i.next, 10
  br i1 %cond, label %loop, label %after

after:
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %printnl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nlptr)
  ret i32 0
}