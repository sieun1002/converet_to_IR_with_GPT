; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@xmmword_2020 = internal constant <4 x i32> <i32 12, i32 4, i32 9, i32 1>, align 16

declare void @selection_sort(i32*, i32)
declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %vecptr = bitcast i32* %arr0 to <4 x i32>*
  %vinit = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %vinit, <4 x i32>* %vecptr, align 16
  %fifth = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 13, i32* %fifth, align 4
  call void @selection_sort(i32* %arr0, i32 5)
  %msgptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %call0 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %msgptr)
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i, 5
  br i1 %cmp, label %loop.body, label %done

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0
  %call1 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmtptr, i32 %val)
  %i.next = add nuw nsw i64 %i, 1
  br label %loop

done:
  ret i32 0
}