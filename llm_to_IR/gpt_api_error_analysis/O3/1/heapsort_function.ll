; ModuleID = 'heapsort'
source_filename = "heapsort.c"
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %build_init

ret:
  ret void

build_init:
  %half = lshr i64 %n, 1
  br label %build_header

build_header:
  %i.curr = phi i64 [ %half, %build_init ], [ %i.prev, %build_latch ]
  %cond1 = icmp ne i64 %i.curr, 0
  %i.prev = add i64 %i.curr, -1
  br i1 %cond1, label %sift_build, label %build_done

sift_build:
  br label %sift_build_loop

sift_build_loop:
  %j = phi i64 [ %i.prev, %sift_build ], [ %j.next, %sift_swap ]
  %j.shl = shl i64 %j, 1
  %left = add i64 %j.shl, 1
  %left.oob = icmp uge i64 %left, %n
  br i1 %left.oob, label %build_latch, label %choose_child

choose_child:
  %right = add i64 %left, 1
  %right.in = icmp ult i64 %right, %n
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  br i1 %right.in, label %cmp_right, label %largest_is_left

cmp_right:
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %cmp.gt = icmp sgt i32 %right.val, %left.val
  br i1 %cmp.gt, label %choose_right, label %largest_is_left

choose_right:
  br label %after_choose

largest_is_left:
  br label %after_choose

after_choose:
  %largest = phi i64 [ %right, %choose_right ], [ %left, %largest_is_left ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j.val = load i32, i32* %j.ptr, align 4
  %largest.ptr = getelementptr inbounds i32, i32* %arr, i64 %largest
  %largest.val = load i32, i32* %largest.ptr, align 4
  %cmp.ge = icmp sge i32 %j.val, %largest.val
  br i1 %cmp.ge, label %build_latch, label %sift_swap

sift_swap:
  store i32 %largest.val, i32* %j.ptr, align 4
  store i32 %j.val, i32* %largest.ptr, align 4
  %j.next = add i64 %largest, 0
  br label %sift_build_loop

build_latch:
  br label %build_header

build_done:
  %end0 = add i64 %n, -1
  br label %extract_header

extract_header:
  %heap_end = phi i64 [ %end0, %build_done ], [ %heap_end.next, %extract_latch ]
  %end.cmp = icmp ne i64 %heap_end, 0
  br i1 %end.cmp, label %extract_body, label %ret

extract_body:
  %root.ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root.val = load i32, i32* %root.ptr, align 4
  %end.ptr = getelementptr inbounds i32, i32* %arr, i64 %heap_end
  %end.val = load i32, i32* %end.ptr, align 4
  store i32 %end.val, i32* %root.ptr, align 4
  store i32 %root.val, i32* %end.ptr, align 4
  br label %sift_extract_loop

sift_extract_loop:
  %j2 = phi i64 [ 0, %extract_body ], [ %j2.next, %sift_extract_swap ]
  %j2.shl = shl i64 %j2, 1
  %left2 = add i64 %j2.shl, 1
  %left2.oob = icmp uge i64 %left2, %heap_end
  br i1 %left2.oob, label %extract_latch, label %choose_child2

choose_child2:
  %right2 = add i64 %left2, 1
  %right2.in = icmp ult i64 %right2, %heap_end
  %left2.ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2.val = load i32, i32* %left2.ptr, align 4
  br i1 %right2.in, label %cmp_right2, label %largest_is_left2

cmp_right2:
  %right2.ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2.val = load i32, i32* %right2.ptr, align 4
  %cmp.gt2 = icmp sgt i32 %right2.val, %left2.val
  br i1 %cmp.gt2, label %choose_right2, label %largest_is_left2

choose_right2:
  br label %after_choose2

largest_is_left2:
  br label %after_choose2

after_choose2:
  %largest2 = phi i64 [ %right2, %choose_right2 ], [ %left2, %largest_is_left2 ]
  %j2.ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j2.val = load i32, i32* %j2.ptr, align 4
  %largest2.ptr = getelementptr inbounds i32, i32* %arr, i64 %largest2
  %largest2.val = load i32, i32* %largest2.ptr, align 4
  %cmp.ge2 = icmp sge i32 %j2.val, %largest2.val
  br i1 %cmp.ge2, label %extract_latch, label %sift_extract_swap

sift_extract_swap:
  store i32 %largest2.val, i32* %j2.ptr, align 4
  store i32 %j2.val, i32* %largest2.ptr, align 4
  %j2.next = add i64 %largest2, 0
  br label %sift_extract_loop

extract_latch:
  %heap_end.next = add i64 %heap_end, -1
  br label %extract_header
}