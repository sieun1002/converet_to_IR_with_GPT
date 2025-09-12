; ModuleID = 'quicksort.ll'
source_filename = "quicksort"
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)

define dso_local void @quick_sort(i32* nocapture %a, i64 %l, i64 %r) local_unnamed_addr {
entry:
  %cmp = icmp sge i64 %l, %r
  br i1 %cmp, label %ret, label %init

init:
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  store i64 %l, i64* %i, align 8
  store i64 %r, i64* %j, align 8
  %diff = sub i64 %r, %l
  %half = ashr i64 %diff, 1
  %mid = add i64 %l, %half
  %midptr = getelementptr inbounds i32, i32* %a, i64 %mid
  %pivot = load i32, i32* %midptr, align 4
  br label %outer

outer:
  br label %advance_i

advance_i:
  %iv = load i64, i64* %i, align 8
  %iptr = getelementptr inbounds i32, i32* %a, i64 %iv
  %ival = load i32, i32* %iptr, align 4
  %lt = icmp slt i32 %ival, %pivot
  br i1 %lt, label %inc_i, label %advance_j

inc_i:
  %iv.next = add i64 %iv, 1
  store i64 %iv.next, i64* %i, align 8
  br label %advance_i

advance_j:
  %jv = load i64, i64* %j, align 8
  %jptr = getelementptr inbounds i32, i32* %a, i64 %jv
  %jval = load i32, i32* %jptr, align 4
  %gt = icmp sgt i32 %jval, %pivot
  br i1 %gt, label %dec_j, label %check

dec_j:
  %jv.next = add i64 %jv, -1
  store i64 %jv.next, i64* %j, align 8
  br label %advance_j

check:
  %ic = load i64, i64* %i, align 8
  %jc = load i64, i64* %j, align 8
  %le = icmp sle i64 %ic, %jc
  br i1 %le, label %swap, label %after_partition

swap:
  %ip = getelementptr inbounds i32, i32* %a, i64 %ic
  %jp = getelementptr inbounds i32, i32* %a, i64 %jc
  %vi = load i32, i32* %ip, align 4
  %vj = load i32, i32* %jp, align 4
  store i32 %vj, i32* %ip, align 4
  store i32 %vi, i32* %jp, align 4
  %ic.inc = add i64 %ic, 1
  %jc.dec = add i64 %jc, -1
  store i64 %ic.inc, i64* %i, align 8
  store i64 %jc.dec, i64* %j, align 8
  br label %outer

after_partition:
  %jfin = load i64, i64* %j, align 8
  %left_nonempty = icmp slt i64 %l, %jfin
  br i1 %left_nonempty, label %call_left, label %skip_left

call_left:
  call void @quick_sort(i32* %a, i64 %l, i64 %jfin)
  br label %skip_left

skip_left:
  %if_right = load i64, i64* %i, align 8
  %right_nonempty = icmp slt i64 %if_right, %r
  br i1 %right_nonempty, label %call_right, label %ret

call_right:
  call void @quick_sort(i32* %a, i64 %if_right, i64 %r)
  br label %ret

ret:
  ret void
}

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %1 = getelementptr inbounds i32, i32* %0, i64 0
  store i32 9, i32* %1, align 4
  %2 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 1, i32* %2, align 4
  %3 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 5, i32* %3, align 4
  %4 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 3, i32* %4, align 4
  %5 = getelementptr inbounds i32, i32* %0, i64 4
  store i32 7, i32* %5, align 4
  %6 = getelementptr inbounds i32, i32* %0, i64 5
  store i32 2, i32* %6, align 4
  %7 = getelementptr inbounds i32, i32* %0, i64 6
  store i32 8, i32* %7, align 4
  %8 = getelementptr inbounds i32, i32* %0, i64 7
  store i32 6, i32* %8, align 4
  %9 = getelementptr inbounds i32, i32* %0, i64 8
  store i32 4, i32* %9, align 4
  %10 = getelementptr inbounds i32, i32* %0, i64 9
  store i32 0, i32* %10, align 4

  call void @quick_sort(i32* %0, i64 0, i64 9)

  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body.end ]
  %cond = icmp slt i64 %i, 10
  br i1 %cond, label %loop.body, label %after.loop

loop.body:
  %eptr = getelementptr inbounds i32, i32* %0, i64 %i
  %val = load i32, i32* %eptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtptr, i32 %val)
  %i.next = add i64 %i, 1
  br label %loop.body.end

loop.body.end:
  br label %loop

after.loop:
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlptr)
  ret i32 0
}