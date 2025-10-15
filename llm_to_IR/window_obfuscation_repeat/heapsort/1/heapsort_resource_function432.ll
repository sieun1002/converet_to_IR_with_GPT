; ModuleID = 'heapsort'
source_filename = "heapsort.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [9 x i8] c"Sorted:\0A\00", align 1
@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @printf(i8*, ...)

define internal void @heapify(i32* %a, i32 %n, i32 %i) {
entry:
  br label %loop

loop:
  %i.cur = phi i32 [ %i, %entry ], [ %best_idx1, %swap ]
  %l.mul = shl i32 %i.cur, 1
  %l = add i32 %l.mul, 1
  %r = add i32 %l.mul, 2
  %i.idx64 = sext i32 %i.cur to i64
  %i.ptr = getelementptr inbounds i32, i32* %a, i64 %i.idx64
  %val_i = load i32, i32* %i.ptr, align 4
  br label %lcmp

lcmp:
  %ltl = icmp slt i32 %l, %n
  br i1 %ltl, label %ltrue, label %lfalse

ltrue:
  %l.idx64 = sext i32 %l to i64
  %l.ptr = getelementptr inbounds i32, i32* %a, i64 %l.idx64
  %val_l = load i32, i32* %l.ptr, align 4
  %cmp_l_gt = icmp sgt i32 %val_l, %val_i
  br i1 %cmp_l_gt, label %lchoose, label %lnotchoose

lchoose:
  br label %lafter

lnotchoose:
  br label %lafter

lfalse:
  br label %lafter

lafter:
  %best_idx0 = phi i32 [ %l, %lchoose ], [ %i.cur, %lnotchoose ], [ %i.cur, %lfalse ]
  %best_val0 = phi i32 [ %val_l, %lchoose ], [ %val_i, %lnotchoose ], [ %val_i, %lfalse ]
  %rlt = icmp slt i32 %r, %n
  br i1 %rlt, label %rtrue, label %rafter

rtrue:
  %r.idx64 = sext i32 %r to i64
  %r.ptr = getelementptr inbounds i32, i32* %a, i64 %r.idx64
  %val_r = load i32, i32* %r.ptr, align 4
  %cmp_r_gt = icmp sgt i32 %val_r, %best_val0
  br i1 %cmp_r_gt, label %rchoose, label %rnotchoose

rchoose:
  br label %rafter

rnotchoose:
  br label %rafter

rafter:
  %best_idx1 = phi i32 [ %r, %rchoose ], [ %best_idx0, %rnotchoose ], [ %best_idx0, %lafter ]
  %best_val1 = phi i32 [ %val_r, %rchoose ], [ %best_val0, %rnotchoose ], [ %best_val0, %lafter ]
  %cmp_done = icmp eq i32 %best_idx1, %i.cur
  br i1 %cmp_done, label %exit, label %swap

swap:
  %best.idx64 = sext i32 %best_idx1 to i64
  %best.ptr = getelementptr inbounds i32, i32* %a, i64 %best.idx64
  store i32 %best_val1, i32* %i.ptr, align 4
  store i32 %val_i, i32* %best.ptr, align 4
  br label %loop

exit:
  ret void
}

define void @heapsort(i32* %a, i32 %n) {
entry:
  %cmp_n = icmp sgt i32 %n, 1
  %half = sdiv i32 %n, 2
  %i.start = add i32 %half, -1
  br label %build.loop

build.loop:
  %i.b = phi i32 [ %i.start, %entry ], [ %i.dec, %build.body ]
  %cond.b = icmp sge i32 %i.b, 0
  br i1 %cond.b, label %build.body, label %after.build

build.body:
  call void @heapify(i32* %a, i32 %n, i32 %i.b)
  %i.dec = add i32 %i.b, -1
  br label %build.loop

after.build:
  %nminus1 = add i32 %n, -1
  br label %sort.loop

sort.loop:
  %i.s = phi i32 [ %nminus1, %after.build ], [ %i2.dec, %sort.body ]
  %cond.s = icmp sgt i32 %i.s, 0
  br i1 %cond.s, label %sort.body, label %ret

sort.body:
  %a0.ptr = getelementptr inbounds i32, i32* %a, i64 0
  %a0.val = load i32, i32* %a0.ptr, align 4
  %i.s.idx64 = sext i32 %i.s to i64
  %ai.ptr = getelementptr inbounds i32, i32* %a, i64 %i.s.idx64
  %ai.val = load i32, i32* %ai.ptr, align 4
  store i32 %ai.val, i32* %a0.ptr, align 4
  store i32 %a0.val, i32* %ai.ptr, align 4
  call void @heapify(i32* %a, i32 %i.s, i32 0)
  %i2.dec = add i32 %i.s, -1
  br label %sort.loop

ret:
  ret void
}

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.gep0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0
  store i32 12, i32* %arr.gep0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr.gep0, i64 1
  store i32 11, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr.gep0, i64 2
  store i32 13, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr.gep0, i64 3
  store i32 5, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr.gep0, i64 4
  store i32 6, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr.gep0, i64 5
  store i32 7, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr.gep0, i64 6
  store i32 1, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr.gep0, i64 7
  store i32 9, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr.gep0, i64 8
  store i32 10, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr.gep0, i64 9
  store i32 2, i32* %p9, align 4

  call void @heapsort(i32* %arr.gep0, i32 10)

  %msg.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str, i32 0, i32 0
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i32 0, i32 0
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i32 0, i32 0
  %call0 = call i32 (i8*, ...) @printf(i8* %msg.ptr)

  br label %print.loop

print.loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %print.body ]
  %cond = icmp slt i32 %i, 10
  br i1 %cond, label %print.body, label %done

print.body:
  %i.idx64 = sext i32 %i to i64
  %val.ptr = getelementptr inbounds i32, i32* %arr.gep0, i64 %i.idx64
  %val = load i32, i32* %val.ptr, align 4
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %val)
  %i.next = add i32 %i, 1
  br label %print.loop

done:
  %call2 = call i32 (i8*, ...) @printf(i8* %nl.ptr)
  ret i32 0
}