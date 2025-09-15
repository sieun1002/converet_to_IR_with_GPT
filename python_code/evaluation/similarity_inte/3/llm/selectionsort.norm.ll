; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/3/selectionsort.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr0ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0ptr, align 16
  %arr1ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2ptr, align 8
  %arr3ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4ptr, align 16
  call void @selection_sort(i32* nonnull %arr0ptr, i32 5)
  %call0 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0))
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp ult i32 %i.0, 5
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %i.ext = zext i32 %i.0 to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %i.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %call1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 %elem)
  %inc = add nuw nsw i32 %i.0, 1
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  ret i32 0
}

declare i32 @printf(i8*, ...)

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.header

outer.header:                                     ; preds = %inner.exit, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inner.exit ]
  %nminus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %nminus1
  br i1 %cmp.outer, label %inner.header, label %exit

inner.header:                                     ; preds = %outer.header, %inner.inc
  %j.in = phi i32 [ %j, %inner.inc ], [ %i, %outer.header ]
  %minIndex = phi i32 [ %minIndex.next, %inner.inc ], [ %i, %outer.header ]
  %j = add nuw nsw i32 %j.in, 1
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.inc, label %inner.exit

inner.inc:                                        ; preds = %inner.header
  %j64 = zext i32 %j to i64
  %ptrj = getelementptr inbounds i32, i32* %arr, i64 %j64
  %valj = load i32, i32* %ptrj, align 4
  %min64 = sext i32 %minIndex to i64
  %ptrmin = getelementptr inbounds i32, i32* %arr, i64 %min64
  %valmin = load i32, i32* %ptrmin, align 4
  %is_less = icmp slt i32 %valj, %valmin
  %minIndex.next = select i1 %is_less, i32 %j, i32 %minIndex
  br label %inner.header

inner.exit:                                       ; preds = %inner.header
  %i64 = zext i32 %i to i64
  %ptri = getelementptr inbounds i32, i32* %arr, i64 %i64
  %tmp = load i32, i32* %ptri, align 4
  %min64b = sext i32 %minIndex to i64
  %ptrmin2 = getelementptr inbounds i32, i32* %arr, i64 %min64b
  %valmin2 = load i32, i32* %ptrmin2, align 4
  store i32 %valmin2, i32* %ptri, align 4
  store i32 %tmp, i32* %ptrmin2, align 4
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.header

exit:                                             ; preds = %outer.header
  ret void
}
