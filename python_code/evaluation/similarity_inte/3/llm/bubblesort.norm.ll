; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/3/bubblesort.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 16
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 8
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 16
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 8
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 16
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4
  call void @bubble_sort(i32* nonnull %p0, i64 10)
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %epp = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %epp, align 4
  %call = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %val)
  %inc = add i64 %i, 1
  br label %loop

after:                                            ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @bubble_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp0 = icmp ult i64 %n, 2
  br i1 %cmp0, label %exit, label %outer.header

outer.header:                                     ; preds = %inner.exit, %entry
  %upper = phi i64 [ %n, %entry ], [ %last, %inner.exit ]
  %outer.cond = icmp ugt i64 %upper, 1
  br i1 %outer.cond, label %inner.header, label %exit

inner.header:                                     ; preds = %inner.latch, %outer.header
  %i = phi i64 [ 1, %outer.header ], [ %i.next, %inner.latch ]
  %last = phi i64 [ 0, %outer.header ], [ %last.sel, %inner.latch ]
  %i.cmp = icmp ult i64 %i, %upper
  br i1 %i.cmp, label %inner.body, label %inner.exit

inner.body:                                       ; preds = %inner.header
  %i.minus1 = add i64 %i, -1
  %ptr.prev = getelementptr inbounds i32, i32* %arr, i64 %i.minus1
  %a = load i32, i32* %ptr.prev, align 4
  %ptr.curr = getelementptr inbounds i32, i32* %arr, i64 %i
  %b = load i32, i32* %ptr.curr, align 4
  %need.swap = icmp sgt i32 %a, %b
  br i1 %need.swap, label %do.swap, label %inner.latch

do.swap:                                          ; preds = %inner.body
  store i32 %b, i32* %ptr.prev, align 4
  store i32 %a, i32* %ptr.curr, align 4
  br label %inner.latch

inner.latch:                                      ; preds = %inner.body, %do.swap
  %last.sel = phi i64 [ %i, %do.swap ], [ %last, %inner.body ]
  %i.next = add i64 %i, 1
  br label %inner.header

inner.exit:                                       ; preds = %inner.header
  %no.swaps = icmp eq i64 %last, 0
  br i1 %no.swaps, label %exit, label %outer.header

exit:                                             ; preds = %inner.exit, %outer.header, %entry
  ret void
}
