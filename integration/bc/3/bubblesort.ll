; ModuleID = 'bubblesort.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %p0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %p0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %p0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %p0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %p0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %p0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %p0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %p0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %p0, i64 9
  store i32 0, i32* %p9, align 4
  store i64 10, i64* %n, align 8
  %len = load i64, i64* %n, align 8
  call void @bubble_sort(i32* %p0, i64 %len)
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp ult i64 %i, %len
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %epp = getelementptr inbounds i32, i32* %p0, i64 %i
  %val = load i32, i32* %epp, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
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
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %exit, label %outer.init

outer.init:                                       ; preds = %entry
  br label %outer.header

outer.header:                                     ; preds = %outer.update, %outer.init
  %upper = phi i64 [ %n, %outer.init ], [ %last, %outer.update ]
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
  br i1 %need.swap, label %do.swap, label %no.swap

do.swap:                                          ; preds = %inner.body
  store i32 %b, i32* %ptr.prev, align 4
  store i32 %a, i32* %ptr.curr, align 4
  br label %inner.latch

no.swap:                                          ; preds = %inner.body
  br label %inner.latch

inner.latch:                                      ; preds = %no.swap, %do.swap
  %last.sel = phi i64 [ %i, %do.swap ], [ %last, %no.swap ]
  %i.next = add i64 %i, 1
  br label %inner.header

inner.exit:                                       ; preds = %inner.header
  %no.swaps = icmp eq i64 %last, 0
  br i1 %no.swaps, label %exit, label %outer.update

outer.update:                                     ; preds = %inner.exit
  br label %outer.header

exit:                                             ; preds = %inner.exit, %outer.header, %entry
  ret void
}
