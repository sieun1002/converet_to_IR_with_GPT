; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/5/insertionsort.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Function Attrs: sspstrong
define dso_local i32 @main() #0 {
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
  call void @insertion_sort(i32* nonnull %p0, i64 10)
  br label %loop

loop:                                             ; preds = %loop.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %after

loop.body:                                        ; preds = %loop
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %printf.call = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @format, i64 0, i64 0), i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop

after:                                            ; preds = %loop
  %pcall = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define dso_local void @insertion_sort(i32* nocapture noundef %arr, i64 noundef %n) {
entry:
  br label %for.cond

for.cond:                                         ; preds = %while.end, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %while.end ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %key.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.body
  %j = phi i64 [ %i, %for.body ], [ %j.minus1, %while.body ]
  %j.is.zero = icmp eq i64 %j, 0
  br i1 %j.is.zero, label %while.end, label %check.swap

check.swap:                                       ; preds = %while.cond
  %j.minus1 = add i64 %j, -1
  %jm1.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %jm1.val = load i32, i32* %jm1.ptr, align 4
  %need.shift = icmp slt i32 %key, %jm1.val
  br i1 %need.shift, label %while.body, label %while.end

while.body:                                       ; preds = %check.swap
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %jm1.val, i32* %j.ptr, align 4
  br label %while.cond

while.end:                                        ; preds = %check.swap, %while.cond
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %ins.ptr, align 4
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

attributes #0 = { sspstrong }
