; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/5/selectionsort.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.int = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0, align 16
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2, align 8
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4, align 16
  call void @selection_sort(i32* noundef nonnull %arr0, i32 noundef 5)
  %call0 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0))
  br label %for.cond

for.cond:                                         ; preds = %for.body, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp ult i32 %i, 5
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %idx.ext = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %val = load i32, i32* %elem.ptr, align 4
  %call1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.int, i64 0, i64 0), i32 noundef %val)
  %inc = add nuw nsw i32 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

define void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %after.inner, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %after.inner ]
  %n.sub1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %n.sub1
  br i1 %cmp.outer, label %inner.cond, label %exit

inner.cond:                                       ; preds = %outer.cond, %inner.latch
  %j.in = phi i32 [ %j, %inner.latch ], [ %i, %outer.cond ]
  %minIdx = phi i32 [ %minIdx.next, %inner.latch ], [ %i, %outer.cond ]
  %j = add i32 %j.in, 1
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.latch, label %after.inner

inner.latch:                                      ; preds = %inner.cond
  %j.sext = sext i32 %j to i64
  %j.ptr = getelementptr i32, i32* %arr, i64 %j.sext
  %j.val = load i32, i32* %j.ptr, align 4
  %min.sext = sext i32 %minIdx to i64
  %min.ptr = getelementptr i32, i32* %arr, i64 %min.sext
  %min.val = load i32, i32* %min.ptr, align 4
  %isless = icmp slt i32 %j.val, %min.val
  %minIdx.next = select i1 %isless, i32 %j, i32 %minIdx
  br label %inner.cond

after.inner:                                      ; preds = %inner.cond
  %i.sext = sext i32 %i to i64
  %i.ptr = getelementptr i32, i32* %arr, i64 %i.sext
  %i.val = load i32, i32* %i.ptr, align 4
  %minA.sext = sext i32 %minIdx to i64
  %minA.ptr = getelementptr i32, i32* %arr, i64 %minA.sext
  %minA.val = load i32, i32* %minA.ptr, align 4
  store i32 %minA.val, i32* %i.ptr, align 4
  store i32 %i.val, i32* %minA.ptr, align 4
  %i.next = add i32 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}
