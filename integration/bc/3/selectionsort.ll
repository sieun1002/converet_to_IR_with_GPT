; ModuleID = 'selectionsort.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %arr0ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4ptr, align 4
  store i32 5, i32* %n, align 4
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arrdecay, i32 %nval)
  %fmtptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmtptr)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.cur = load i32, i32* %i, align 4
  %n.cur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i.cur, %n.cur
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %i.ext = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %i.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %elem)
  %inc = add nsw i32 %i.cur, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  ret i32 0
}

declare i32 @printf(i8*, ...)

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.header

outer.header:                                     ; preds = %outer.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %nminus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %nminus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.header
  %j.start = add nsw i32 %i, 1
  br label %inner.header

inner.header:                                     ; preds = %inner.inc, %outer.body
  %j = phi i32 [ %j.start, %outer.body ], [ %j.next, %inner.inc ]
  %minIndex = phi i32 [ %i, %outer.body ], [ %minIndex.next, %inner.inc ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %inner.exit

inner.body:                                       ; preds = %inner.header
  %j64 = sext i32 %j to i64
  %ptrj = getelementptr inbounds i32, i32* %arr, i64 %j64
  %valj = load i32, i32* %ptrj, align 4
  %min64 = sext i32 %minIndex to i64
  %ptrmin = getelementptr inbounds i32, i32* %arr, i64 %min64
  %valmin = load i32, i32* %ptrmin, align 4
  %is_less = icmp slt i32 %valj, %valmin
  %minIndex.next = select i1 %is_less, i32 %j, i32 %minIndex
  br label %inner.inc

inner.inc:                                        ; preds = %inner.body
  %j.next = add nsw i32 %j, 1
  br label %inner.header

inner.exit:                                       ; preds = %inner.header
  %i64 = sext i32 %i to i64
  %ptri = getelementptr inbounds i32, i32* %arr, i64 %i64
  %tmp = load i32, i32* %ptri, align 4
  %min64b = sext i32 %minIndex to i64
  %ptrmin2 = getelementptr inbounds i32, i32* %arr, i64 %min64b
  %valmin2 = load i32, i32* %ptrmin2, align 4
  store i32 %valmin2, i32* %ptri, align 4
  store i32 %tmp, i32* %ptrmin2, align 4
  br label %outer.latch

outer.latch:                                      ; preds = %inner.exit
  %i.next = add nsw i32 %i, 1
  br label %outer.header

exit:                                             ; preds = %outer.header
  ret void
}
