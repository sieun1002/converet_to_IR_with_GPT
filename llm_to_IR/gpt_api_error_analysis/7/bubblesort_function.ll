; ModuleID = 'bubble_sort'
target triple = "x86_64-pc-linux-gnu"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %outer.check

outer.check:
  %ub = phi i64 [ %n, %entry ], [ %new_ub, %outer.latch ]
  %cmp_ub_gt1 = icmp ugt i64 %ub, 1
  br i1 %cmp_ub_gt1, label %outer.body, label %ret

outer.body:
  br label %inner.check

inner.check:
  %i = phi i64 [ 1, %outer.body ], [ %i.next, %inner.latch ]
  %last = phi i64 [ 0, %outer.body ], [ %last.phi, %inner.latch ]
  %cmp_i_lt_ub = icmp ult i64 %i, %ub
  br i1 %cmp_i_lt_ub, label %inner.body, label %inner.exit

inner.body:
  %im1 = add i64 %i, -1
  %p1 = getelementptr inbounds i32, i32* %arr, i64 %im1
  %v1 = load i32, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr, i64 %i
  %v2 = load i32, i32* %p2, align 4
  %cmp_gt = icmp sgt i32 %v1, %v2
  br i1 %cmp_gt, label %swap, label %inner.latch

swap:
  store i32 %v2, i32* %p1, align 4
  store i32 %v1, i32* %p2, align 4
  br label %inner.latch

inner.latch:
  %last.phi = phi i64 [ %i, %swap ], [ %last, %inner.body ]
  %i.next = add nuw i64 %i, 1
  br label %inner.check

inner.exit:
  %no_swaps = icmp eq i64 %last, 0
  br i1 %no_swaps, label %ret, label %outer.latch

outer.latch:
  %new_ub = phi i64 [ %last, %inner.exit ]
  br label %outer.check

ret:
  ret void
}