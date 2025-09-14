; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %min = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %inner.end, %entry
  %i.val = load i32, i32* %i, align 4
  %nminus = add i32 %n, -1
  %cmpouter = icmp slt i32 %i.val, %nminus
  br i1 %cmpouter, label %outer.body, label %outer.end

outer.body:                                       ; preds = %outer.cond
  store i32 %i.val, i32* %min, align 4
  %ip1 = add i32 %i.val, 1
  store i32 %ip1, i32* %j, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %no_update, %outer.body
  %j.val = load i32, i32* %j, align 4
  %cmpj = icmp slt i32 %j.val, %n
  br i1 %cmpj, label %inner.body, label %inner.end

inner.body:                                       ; preds = %inner.cond
  %j.idx64 = sext i32 %j.val to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %vj = load i32, i32* %j.ptr, align 4
  %min.val = load i32, i32* %min, align 4
  %min.idx64 = sext i32 %min.val to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx64
  %vmin = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %vj, %vmin
  br i1 %lt, label %update_min, label %no_update

update_min:                                       ; preds = %inner.body
  store i32 %j.val, i32* %min, align 4
  br label %no_update

no_update:                                        ; preds = %update_min, %inner.body
  %j.next = add i32 %j.val, 1
  store i32 %j.next, i32* %j, align 4
  br label %inner.cond

inner.end:                                        ; preds = %inner.cond
  %i.idx64 = sext i32 %i.val to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx64
  %vi = load i32, i32* %i.ptr, align 4
  store i32 %vi, i32* %tmp, align 4
  %min2.val = load i32, i32* %min, align 4
  %min2.idx64 = sext i32 %min2.val to i64
  %min2.ptr = getelementptr inbounds i32, i32* %arr, i64 %min2.idx64
  %vmin2 = load i32, i32* %min2.ptr, align 4
  store i32 %vmin2, i32* %i.ptr, align 4
  %tmpval = load i32, i32* %tmp, align 4
  store i32 %tmpval, i32* %min2.ptr, align 4
  %i.next = add i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %outer.cond

outer.end:                                        ; preds = %outer.cond
  ret void
}

define dso_local i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  store i32 5, i32* %n, align 4
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0, align 16
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 10, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 14, i32* %arr2, align 8
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 37, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 13, i32* %arr4, align 16
  %n.load = load i32, i32* %n, align 4
  call void @selection_sort(i32* noundef %arr0, i32 noundef %n.load)
  %p.sorted = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  %0 = call i32 (i8*, ...) @printf(i8* noundef %p.sorted)
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %i.val = load i32, i32* %i, align 4
  %n.cur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i.val, %n.cur
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %idx.ext = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %p.d = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %1 = call i32 (i8*, ...) @printf(i8* noundef %p.d, i32 noundef %elem)
  %inc = add nsw i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

done:                                             ; preds = %loop
  ret i32 0
}

declare dso_local i32 @printf(i8* noundef, ...)
