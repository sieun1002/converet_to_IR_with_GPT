; ModuleID = 'selectionsort.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private constant [4 x i8] c"%d \00", align 1

; Function Attrs: sspstrong
define i32 @main() local_unnamed_addr #0 {
entry:
  %array = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  %array.elem0.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  store i32 29, i32* %array.elem0.ptr, align 4
  %array.elem1.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 1
  store i32 10, i32* %array.elem1.ptr, align 4
  %array.elem2.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 2
  store i32 14, i32* %array.elem2.ptr, align 4
  %array.elem3.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 3
  store i32 37, i32* %array.elem3.ptr, align 4
  %array.elem4.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 4
  store i32 13, i32* %array.elem4.ptr, align 4
  %arraydecay = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  call void @selection_sort(i32* noundef %arraydecay, i32 noundef 5)
  %p.str = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* noundef %p.str)
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %iv, 5
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %idx.ext = sext i32 %iv to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %p.str1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* noundef %p.str1, i32 noundef %elem)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

done:                                             ; preds = %loop
  ret i32 0
}

declare i32 @printf(i8*, ...)

define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  br label %outer.header

outer.header:                                     ; preds = %outer.latch, %entry
  %i.cur = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i.cur, %n.minus1
  br i1 %cmp.outer, label %prep.inner, label %exit

prep.inner:                                       ; preds = %outer.header
  %j.init = add nsw i32 %i.cur, 1
  br label %inner.header

inner.header:                                     ; preds = %inner.latch, %prep.inner
  %min.cur = phi i32 [ %i.cur, %prep.inner ], [ %min.next, %inner.latch ]
  %j.cur = phi i32 [ %j.init, %prep.inner ], [ %j.next, %inner.latch ]
  %cmp.inner = icmp slt i32 %j.cur, %n
  br i1 %cmp.inner, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.header
  %j.ext = sext i32 %j.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %j.val = load i32, i32* %j.ptr, align 4
  %min.ext = sext i32 %min.cur to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %min.val = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %j.val, %min.val
  %min.sel = select i1 %lt, i32 %j.cur, i32 %min.cur
  br label %inner.latch

inner.latch:                                      ; preds = %inner.body
  %min.next = phi i32 [ %min.sel, %inner.body ]
  %j.next = add nsw i32 %j.cur, 1
  br label %inner.header

after.inner:                                      ; preds = %inner.header
  %i.ext = sext i32 %i.cur to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %min.exit.ext = sext i32 %min.cur to i64
  %min.exit.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.exit.ext
  %min.load = load i32, i32* %min.exit.ptr, align 4
  store i32 %min.load, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.exit.ptr, align 4
  br label %outer.latch

outer.latch:                                      ; preds = %after.inner
  %i.next = add nsw i32 %i.cur, 1
  br label %outer.header

exit:                                             ; preds = %outer.header
  ret void
}

attributes #0 = { sspstrong }
