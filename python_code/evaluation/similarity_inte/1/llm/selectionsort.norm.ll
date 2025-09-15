; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/1/selectionsort.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %0, align 16
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %1, align 4
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %2, align 8
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %3, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %4, align 16
  call void @selection_sort(i32* nonnull %0, i32 5)
  %5 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i64 0, i64 0))
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp ult i32 %i, 5
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %idxext = zext i32 %i to i64
  %6 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idxext
  %elem = load i32, i32* %6, align 4
  %7 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i64 0, i64 0), i32 %elem)
  %inc = add nuw nsw i32 %i, 1
  br label %loop

done:                                             ; preds = %loop
  ret i32 0
}

declare i32 @printf(i8*, ...)

define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  br label %outer.header

outer.header:                                     ; preds = %after.inner, %entry
  %i.ph = phi i32 [ 0, %entry ], [ %i.next, %after.inner ]
  %n.minus1 = add nsw i32 %n, -1
  %outer.cond = icmp slt i32 %i.ph, %n.minus1
  br i1 %outer.cond, label %inner.header, label %exit

inner.header:                                     ; preds = %outer.header, %inner.body
  %minidx.ph = phi i32 [ %min.cand, %inner.body ], [ %i.ph, %outer.header ]
  %j.ph.in = phi i32 [ %j.ph, %inner.body ], [ %i.ph, %outer.header ]
  %j.ph = add nuw nsw i32 %j.ph.in, 1
  %j.cmp = icmp slt i32 %j.ph, %n
  br i1 %j.cmp, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.header
  %j.ext = zext i32 %j.ph to i64
  %minidx.ext = sext i32 %minidx.ph to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %minidx.ext
  %valj = load i32, i32* %j.ptr, align 4
  %valmin = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %valj, %valmin
  %min.cand = select i1 %lt, i32 %j.ph, i32 %minidx.ph
  br label %inner.header

after.inner:                                      ; preds = %inner.header
  %i.ext = zext i32 %i.ph to i64
  %minidx2.ext = sext i32 %minidx.ph to i64
  %iptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %minptr2 = getelementptr inbounds i32, i32* %arr, i64 %minidx2.ext
  %tmp = load i32, i32* %iptr, align 4
  %minval = load i32, i32* %minptr2, align 4
  store i32 %minval, i32* %iptr, align 4
  store i32 %tmp, i32* %minptr2, align 4
  %i.next = add nuw nsw i32 %i.ph, 1
  br label %outer.header

exit:                                             ; preds = %outer.header
  ret void
}
