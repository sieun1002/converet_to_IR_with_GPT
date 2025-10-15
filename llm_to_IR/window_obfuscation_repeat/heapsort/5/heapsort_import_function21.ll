; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-windows-msvc"

define void @sub_140001450(i32* %arr, i64 %n) {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %exit, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_dec

build_dec:
  %i.cur = phi i64 [ %half, %build_init ], [ %i.next, %build_body_end ]
  %i.nonzero = icmp ne i64 %i.cur, 0
  br i1 %i.nonzero, label %sift_pre, label %outer_init

sift_pre:
  %i.start = add i64 %i.cur, -1
  br label %sift_loop

sift_loop:
  %j = phi i64 [ %i.start, %sift_pre ], [ %largest.idx, %do_swap ]
  %j.shl1 = shl i64 %j, 1
  %child = add i64 %j.shl1, 1
  %child.in = icmp ult i64 %child, %n
  br i1 %child.in, label %child_body, label %build_body_end

child_body:
  %right = add i64 %child, 1
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %child
  %left.val = load i32, i32* %left.ptr, align 4
  %right.in = icmp ult i64 %right, %n
  br i1 %right.in, label %have_right, label %no_right

have_right:
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %cmp.lr = icmp sgt i32 %right.val, %left.val
  %largest.idx.pre = select i1 %cmp.lr, i64 %right, i64 %child
  br label %select_largest

no_right:
  br label %select_largest

select_largest:
  %largest.idx = phi i64 [ %largest.idx.pre, %have_right ], [ %child, %no_right ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j.val = load i32, i32* %j.ptr, align 4
  %largest.ptr = getelementptr inbounds i32, i32* %arr, i64 %largest.idx
  %largest.val = load i32, i32* %largest.ptr, align 4
  %cmp.j.lt = icmp slt i32 %j.val, %largest.val
  br i1 %cmp.j.lt, label %do_swap, label %build_body_end

do_swap:
  store i32 %largest.val, i32* %j.ptr, align 4
  store i32 %j.val, i32* %largest.ptr, align 4
  br label %sift_loop

build_body_end:
  %i.next = add i64 %i.cur, -1
  br label %build_dec

outer_init:
  %limit0 = add i64 %n, -1
  br label %outer_check

outer_check:
  %limit = phi i64 [ %limit0, %outer_init ], [ %limit.next, %outer_after_decrement ]
  %limit.nonzero = icmp ne i64 %limit, 0
  br i1 %limit.nonzero, label %outer_body, label %exit

outer_body:
  %root.ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root.val = load i32, i32* %root.ptr, align 4
  %last.ptr = getelementptr inbounds i32, i32* %arr, i64 %limit
  %last.val = load i32, i32* %last.ptr, align 4
  store i32 %last.val, i32* %root.ptr, align 4
  store i32 %root.val, i32* %last.ptr, align 4
  br label %sift2_loop

sift2_loop:
  %j.b = phi i64 [ 0, %outer_body ], [ %largest.idx.b, %do_swap2 ]
  %j.b.shl1 = shl i64 %j.b, 1
  %child.b = add i64 %j.b.shl1, 1
  %child.in.b = icmp ult i64 %child.b, %limit
  br i1 %child.in.b, label %child_body_b, label %outer_after_decrement

child_body_b:
  %right.b = add i64 %child.b, 1
  %left.ptr.b = getelementptr inbounds i32, i32* %arr, i64 %child.b
  %left.val.b = load i32, i32* %left.ptr.b, align 4
  %right.in.b = icmp ult i64 %right.b, %limit
  br i1 %right.in.b, label %have_right_b, label %no_right_b

have_right_b:
  %right.ptr.b = getelementptr inbounds i32, i32* %arr, i64 %right.b
  %right.val.b = load i32, i32* %right.ptr.b, align 4
  %cmp.lr.b = icmp sgt i32 %right.val.b, %left.val.b
  %largest.idx.pre.b = select i1 %cmp.lr.b, i64 %right.b, i64 %child.b
  br label %select_largest_b

no_right_b:
  br label %select_largest_b

select_largest_b:
  %largest.idx.b = phi i64 [ %largest.idx.pre.b, %have_right_b ], [ %child.b, %no_right_b ]
  %j.ptr.b = getelementptr inbounds i32, i32* %arr, i64 %j.b
  %j.val.b = load i32, i32* %j.ptr.b, align 4
  %largest.ptr.b = getelementptr inbounds i32, i32* %arr, i64 %largest.idx.b
  %largest.val.b = load i32, i32* %largest.ptr.b, align 4
  %cmp.j.lt.b = icmp slt i32 %j.val.b, %largest.val.b
  br i1 %cmp.j.lt.b, label %do_swap2, label %outer_after_decrement

do_swap2:
  store i32 %largest.val.b, i32* %j.ptr.b, align 4
  store i32 %j.val.b, i32* %largest.ptr.b, align 4
  br label %sift2_loop

outer_after_decrement:
  %limit.next = add i64 %limit, -1
  br label %outer_check

exit:
  ret void
}