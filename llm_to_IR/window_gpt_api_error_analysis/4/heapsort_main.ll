; ModuleID: heap_sort_module
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.after = private unnamed_addr constant [8 x i8] c"After: \00", align 1

declare dllimport i32 @printf(i8*, ...)
declare dllimport i32 @putchar(i32)

define internal void @sift_down(i32* %arr, i64 %n, i64 %i) {
entry:
  br label %loop

loop:
  %i.cur = phi i64 [ %i, %entry ], [ %i.next, %cont ]
  %mul = shl i64 %i.cur, 1
  %left = add i64 %mul, 1
  %has_left = icmp ult i64 %left, %n
  br i1 %has_left, label %with_left, label %exit

with_left:
  %right = add i64 %left, 1
  %leftptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %leftval = load i32, i32* %leftptr, align 4
  %has_right = icmp ult i64 %right, %n
  br i1 %has_right, label %cmp_lr, label %set_largest_left

cmp_lr:
  %rightptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %rightval = load i32, i32* %rightptr, align 4
  %is_right_gt_left = icmp sgt i32 %rightval, %leftval
  br i1 %is_right_gt_left, label %set_largest_right, label %set_largest_left

set_largest_left:
  br label %compare_root

set_largest_right:
  br label %compare_root

compare_root:
  %largest.index = phi i64 [ %left, %set_largest_left ], [ %right, %set_largest_right ]
  %largest.val = phi i32 [ %leftval, %set_largest_left ], [ %rightval, %set_largest_right ]
  %rootptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %rootval = load i32, i32* %rootptr, align 4
  %root_ge_largest = icmp sge i32 %rootval, %largest.val
  br i1 %root_ge_largest, label %exit, label %do_swap

do_swap:
  %lptr = getelementptr inbounds i32, i32* %arr, i64 %largest.index
  store i32 %largest.val, i32* %rootptr, align 4
  store i32 %rootval, i32* %lptr, align 4
  %i.next = add i64 %largest.index, 0
  br label %cont

cont:
  br label %loop

exit:
  ret void
}

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %n_le_1 = icmp ule i64 %n, 1
  br i1 %n_le_1, label %ret, label %build_init

build_init:
  %half = udiv i64 %n, 2
  br label %build_cond

build_cond:
  %i = phi i64 [ %half, %build_init ], [ %i.dec, %build_body ]
  %more = icmp ugt i64 %i, 0
  br i1 %more, label %build_body, label %sort_init

build_body:
  %i.idx = add i64 %i, -1
  call void @sift_down(i32* %arr, i64 %n, i64 %i.idx)
  %i.dec = add i64 %i, -1
  br label %build_cond

sort_init:
  br label %sort_cond

sort_cond:
  %end = phi i64 [ %n, %sort_init ], [ %end.next, %sort_body ]
  %gt1 = icmp ugt i64 %end, 1
  br i1 %gt1, label %sort_body, label %ret

sort_body:
  %last = add i64 %end, -1
  %rootptr = getelementptr inbounds i32, i32* %arr, i64 0
  %lastptr = getelementptr inbounds i32, i32* %arr, i64 %last
  %rootval = load i32, i32* %rootptr, align 4
  %lastval = load i32, i32* %lastptr, align 4
  store i32 %lastval, i32* %rootptr, align 4
  store i32 %rootval, i32* %lastptr, align 4
  %end.next = add i64 %end, -1
  call void @sift_down(i32* %arr, i64 %end.next, i64 0)
  br label %sort_cond

ret:
  ret void
}

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %e0 = getelementptr inbounds i32, i32* %arr0, i64 0
  store i32 7, i32* %e0, align 4
  %e1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %e1, align 4
  %e2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 9, i32* %e2, align 4
  %e3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 1, i32* %e3, align 4
  %e4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 4, i32* %e4, align 4
  %e5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 8, i32* %e5, align 4
  %e6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 2, i32* %e6, align 4
  %e7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %e7, align 4
  %e8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 5, i32* %e8, align 4
  %before.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.before, i64 0, i64 0
  %before.cast = bitcast i8* %before.ptr to i8*
  %call.before = call i32 (i8*, ...) @printf(i8* %before.cast)
  br label %print1.cond

print1.cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %print1.body ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %print1.body, label %after_print1

print1.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i
  %elem.val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %fmt.cast = bitcast i8* %fmt.ptr to i8*
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.cast, i32 %elem.val)
  %i.next = add i64 %i, 1
  br label %print1.cond

after_print1:
  %nl = call i32 @putchar(i32 10)
  call void @heap_sort(i32* %arr0, i64 9)
  %after.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.after, i64 0, i64 0
  %after.cast = bitcast i8* %after.ptr to i8*
  %call.after = call i32 (i8*, ...) @printf(i8* %after.cast)
  br label %print2.cond

print2.cond:
  %j = phi i64 [ 0, %after_print1 ], [ %j.next, %print2.body ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %print2.body, label %after_print2

print2.body:
  %elem2.ptr = getelementptr inbounds i32, i32* %arr0, i64 %j
  %elem2.val = load i32, i32* %elem2.ptr, align 4
  %fmt2.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %fmt2.cast = bitcast i8* %fmt2.ptr to i8*
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt2.cast, i32 %elem2.val)
  %j.next = add i64 %j, 1
  br label %print2.cond

after_print2:
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}