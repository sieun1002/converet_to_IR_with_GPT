; ModuleID = 'mergesort.ll'
source_filename = "mergesort.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.strnl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main(i32 %argc, i8** %argv, i8** %envp) {
entry:
  ; local array of 10 ints with the constants initialized like the binary
  %arr = alloca [10 x i32], align 16
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  ; initialize: 9, 1, 5, 3, 7, 2, 8, 6, 4, 0
  store i32 9,  i32* %arr.base, align 4
  %p1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1,  i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5,  i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3,  i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7,  i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2,  i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8,  i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6,  i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4,  i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0,  i32* %p9, align 4

  ; tmp buffer for merges
  %mem = call noalias i8* @malloc(i64 40)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %print, label %sort.init

; bottom-up mergesort: 4 passes, width doubles each pass
sort.init:
  %dst.base = bitcast i8* %mem to i32*
  br label %outer

outer:
  %w = phi i32 [ 1, %sort.init ], [ %w2, %swap ]
  %passes = phi i32 [ 4, %sort.init ], [ %passes.dec, %swap ]
  %src = phi i32* [ %arr.base, %sort.init ], [ %src.next, %swap ]
  %dst = phi i32* [ %dst.base, %sort.init ], [ %dst.next, %swap ]
  %done = icmp eq i32 %passes, 0
  br i1 %done, label %afterSort, label %inner.init

inner.init:
  %i = phi i32 [ 0, %outer ], [ %i.next, %inner.afterMerge ]
  %cond.i = icmp sle i32 %i, 9
  br i1 %cond.i, label %prepare, label %swap

prepare:
  %i_plus_w = add nsw i32 %i, %w
  %lt10a = icmp slt i32 %i_plus_w, 10
  %mid = select i1 %lt10a, i32 %i_plus_w, i32 10

  %i_plus_2w = add nsw i32 %i_plus_w, %w
  %lt10b = icmp slt i32 %i_plus_2w, 10
  %right = select i1 %lt10b, i32 %i_plus_2w, i32 10

  br label %merge.loop1.cond

; while (l < mid && r < right) merge by comparisons
merge.loop1.cond:
  %l = phi i32 [ %i, %prepare ], [ %l.next, %merge.loop1.body ]
  %r = phi i32 [ %mid, %prepare ], [ %r.next, %merge.loop1.body ]
  %k = phi i32 [ %i, %prepare ], [ %k.next, %merge.loop1.body ]
  %l.lt.mid = icmp slt i32 %l, %mid
  %r.lt.right = icmp slt i32 %r, %right
  %both = and i1 %l.lt.mid, %r.lt.right
  br i1 %both, label %merge.loop1.body, label %after.loop1

merge.loop1.body:
  ; load values
  %l64 = sext i32 %l to i64
  %lp = getelementptr inbounds i32, i32* %src, i64 %l64
  %lv = load i32, i32* %lp, align 4

  %r64 = sext i32 %r to i64
  %rp = getelementptr inbounds i32, i32* %src, i64 %r64
  %rv = load i32, i32* %rp, align 4

  %takeL = icmp sle i32 %lv, %rv
  %k64 = sext i32 %k to i64
  %dp = getelementptr inbounds i32, i32* %dst, i64 %k64
  ; store min(lv, rv)
  %val.sel = select i1 %takeL, i32 %lv, i32 %rv
  store i32 %val.sel, i32* %dp, align 4

  ; advance indices
  %l.next = select i1 %takeL, i32 (add i32 %l, 1), i32 %l
  %r.next = select i1 %takeL, i32 %r, i32 (add i32 %r, 1)
  %k.next = add nsw i32 %k, 1
  br label %merge.loop1.cond

after.loop1:
  br label %left.cond

; copy remaining left half
left.cond:
  %l2 = phi i32 [ %l, %after.loop1 ], [ %l3, %left.body ]
  %k2 = phi i32 [ %k, %after.loop1 ], [ %k3, %left.body ]
  %l.rem = icmp slt i32 %l2, %mid
  br i1 %l.rem, label %left.body, label %right.cond

left.body:
  %l264 = sext i32 %l2 to i64
  %lp2 = getelementptr inbounds i32, i32* %src, i64 %l264
  %lv2 = load i32, i32* %lp2, align 4
  %k264 = sext i32 %k2 to i64
  %dp2 = getelementptr inbounds i32, i32* %dst, i64 %k264
  store i32 %lv2, i32* %dp2, align 4
  %l3 = add nsw i32 %l2, 1
  %k3 = add nsw i32 %k2, 1
  br label %left.cond

; copy remaining right half
right.cond:
  %r2 = phi i32 [ %r, %left.cond ], [ %r3, %right.body ]
  %k4 = phi i32 [ %k2, %left.cond ], [ %k5, %right.body ]
  %r.rem = icmp slt i32 %r2, %right
  br i1 %r.rem, label %right.body, label %inner.afterMerge

right.body:
  %r264 = sext i32 %r2 to i64
  %rp2 = getelementptr inbounds i32, i32* %src, i64 %r264
  %rv2 = load i32, i32* %rp2, align 4
  %k464 = sext i32 %k4 to i64
  %dp3 = getelementptr inbounds i32, i32* %dst, i64 %k464
  store i32 %rv2, i32* %dp3, align 4
  %r3 = add nsw i32 %r2, 1
  %k5 = add nsw i32 %k4, 1
  br label %right.cond

inner.afterMerge:
  %twoW = shl i32 %w, 1
  %i.next = add nsw i32 %i, %twoW
  br label %inner.init

swap:
  %w2 = shl i32 %w, 1
  %passes.dec = add nsw i32 %passes, -1
  %src.next = %dst
  %dst.next = %src
  br label %outer

afterSort:
  ; if last source isn't the stack array, copy back 10 ints
  %src.is.arr = icmp eq i32* %src, %arr.base
  br i1 %src.is.arr, label %free.tmp, label %copy.init

copy.init:
  %ci = phi i32 [ 0, %afterSort ], [ %ci.next, %copy.loop ]
  %ci.cond = icmp slt i32 %ci, 10
  br i1 %ci.cond, label %copy.loop, label %free.tmp

copy.loop:
  %ci64 = sext i32 %ci to i64
  %sp = getelementptr inbounds i32, i32* %src, i64 %ci64
  %valc = load i32, i32* %sp, align 4
  %dp.arr = getelementptr inbounds i32, i32* %arr.base, i64 %ci64
  store i32 %valc, i32* %dp.arr, align 4
  %ci.next = add nsw i32 %ci, 1
  br label %copy.init

free.tmp:
  call void @free(i8* %mem)
  br label %print

print:
  %pi = phi i32 [ 0, %free.tmp ], [ 0, %entry ]
  br label %print.loop

print.loop:
  %pi.cond = icmp slt i32 %pi, 10
  br i1 %pi.cond, label %print.body, label %print.end

print.body:
  %pi64 = sext i32 %pi to i64
  %pp = getelementptr inbounds i32, i32* %arr.base, i64 %pi64
  %v = load i32, i32* %pp, align 4
  %fmt = bitcast [4 x i8]* @.str to i8*
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt, i32 %v)
  %pi.next = add nsw i32 %pi, 1
  br label %print.loop

print.end:
  %fmt2 = bitcast [2 x i8]* @.strnl to i8*
  %calln = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt2)
  ret i32 0
}