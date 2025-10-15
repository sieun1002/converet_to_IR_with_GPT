; ModuleID = 'heapsort_module'
source_filename = "heapsort_module.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@fmt_elem = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@fmt_newline = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@fmt_before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@fmt_after = private unnamed_addr constant [8 x i8] c"After: \00", align 1

declare dso_local i32 @printf(i8*, ...)

define dso_local void @print_array(i32* %arr, i32 %n, i8* %prefix) {
entry:
  %callprefix = call i32 (i8*, ...) @printf(i8* %prefix)
  br label %loop.header

loop.header:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cond = icmp slt i32 %i, %n
  br i1 %cond, label %loop.body, label %after

loop.body:
  %i64 = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @fmt_elem, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %val)
  br label %loop.latch

loop.latch:
  %i.next = add nsw i32 %i, 1
  br label %loop.header

after:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @fmt_newline, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %nl.ptr)
  ret void
}

define dso_local void @heapify(i32* %arr, i32 %n, i32 %i) {
entry:
  br label %loop

loop:
  %i.cur = phi i32 [ %i, %entry ], [ %largest_final, %do_swap ]
  %mul2 = shl nsw i32 %i.cur, 1
  %l = add nsw i32 %mul2, 1
  %r = add nsw i32 %l, 1
  %l_cmp = icmp slt i32 %l, %n
  br i1 %l_cmp, label %check_l, label %after_l

check_l:
  %l64 = sext i32 %l to i64
  %lptr = getelementptr inbounds i32, i32* %arr, i64 %l64
  %lval = load i32, i32* %lptr, align 4
  %i64a = sext i32 %i.cur to i64
  %iptr = getelementptr inbounds i32, i32* %arr, i64 %i64a
  %ival = load i32, i32* %iptr, align 4
  %l_gt_i = icmp sgt i32 %lval, %ival
  br i1 %l_gt_i, label %set_largest_l, label %set_largest_i

set_largest_l:
  br label %after_l

set_largest_i:
  br label %after_l

after_l:
  %largest_after_l = phi i32 [ %l, %set_largest_l ], [ %i.cur, %set_largest_i ], [ %i.cur, %loop ]
  %r_cmp = icmp slt i32 %r, %n
  br i1 %r_cmp, label %check_r, label %after_r

check_r:
  %r64 = sext i32 %r to i64
  %rptr = getelementptr inbounds i32, i32* %arr, i64 %r64
  %rval = load i32, i32* %rptr, align 4
  %largest64 = sext i32 %largest_after_l to i64
  %largest_ptr = getelementptr inbounds i32, i32* %arr, i64 %largest64
  %largest_val = load i32, i32* %largest_ptr, align 4
  %r_gt_largest = icmp sgt i32 %rval, %largest_val
  br i1 %r_gt_largest, label %set_largest_r, label %keep_largest

set_largest_r:
  br label %after_r

keep_largest:
  br label %after_r

after_r:
  %largest_final = phi i32 [ %r, %set_largest_r ], [ %largest_after_l, %keep_largest ], [ %largest_after_l, %after_l ]
  %nochange = icmp eq i32 %largest_final, %i.cur
  br i1 %nochange, label %end, label %do_swap

do_swap:
  %i64b = sext i32 %i.cur to i64
  %iptr2 = getelementptr inbounds i32, i32* %arr, i64 %i64b
  %lf64 = sext i32 %largest_final to i64
  %lfptr = getelementptr inbounds i32, i32* %arr, i64 %lf64
  %ival2 = load i32, i32* %iptr2, align 4
  %lfval2 = load i32, i32* %lfptr, align 4
  store i32 %lfval2, i32* %iptr2, align 4
  store i32 %ival2, i32* %lfptr, align 4
  br label %loop

end:
  ret void
}

define dso_local void @heapsort(i32* %arr, i32 %n) {
entry:
  %half = sdiv i32 %n, 2
  %start = add nsw i32 %half, -1
  br label %build.cond

build.cond:
  %i = phi i32 [ %start, %entry ], [ %i.next, %build.body ]
  %cmp_ge0 = icmp sge i32 %i, 0
  br i1 %cmp_ge0, label %build.body, label %build.after

build.body:
  call void @heapify(i32* %arr, i32 %n, i32 %i)
  %i.next = add nsw i32 %i, -1
  br label %build.cond

build.after:
  %init = add nsw i32 %n, -1
  br label %sort.cond

sort.cond:
  %j = phi i32 [ %init, %build.after ], [ %j.next, %sort.body.done ]
  %cmp_gt0 = icmp sgt i32 %j, 0
  br i1 %cmp_gt0, label %sort.body, label %sort.after

sort.body:
  %j64 = sext i32 %j to i64
  %ptr0 = getelementptr inbounds i32, i32* %arr, i64 0
  %ptrj = getelementptr inbounds i32, i32* %arr, i64 %j64
  %val0 = load i32, i32* %ptr0, align 4
  %valj = load i32, i32* %ptrj, align 4
  store i32 %valj, i32* %ptr0, align 4
  store i32 %val0, i32* %ptrj, align 4
  call void @heapify(i32* %arr, i32 %j, i32 0)
  br label %sort.body.done

sort.body.done:
  %j.next = add nsw i32 %j, -1
  br label %sort.cond

sort.after:
  ret void
}

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %p0 = getelementptr inbounds i32, i32* %arr0, i64 0
  store i32 12, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 17, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 8, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 34, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 25, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 1, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 9, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 0, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 5, i32* %p9, align 4
  %n = add nsw i32 0, 10
  %before.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @fmt_before, i64 0, i64 0
  call void @print_array(i32* %arr0, i32 %n, i8* %before.ptr)
  call void @heapsort(i32* %arr0, i32 %n)
  %after.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @fmt_after, i64 0, i64 0
  call void @print_array(i32* %arr0, i32 %n, i8* %after.ptr)
  ret i32 0
}