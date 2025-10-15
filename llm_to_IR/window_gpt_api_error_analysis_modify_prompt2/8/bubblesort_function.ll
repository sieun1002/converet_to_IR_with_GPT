target triple = "x86_64-pc-windows-msvc"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %exit, label %outer.header

outer.header:
  %bound = phi i64 [ %n, %entry ], [ %last, %outer.latch ]
  %cmp.bound = icmp ugt i64 %bound, 1
  br i1 %cmp.bound, label %outer.body, label %exit

outer.body:
  br label %inner.header

inner.header:
  %i = phi i64 [ 1, %outer.body ], [ %i.next, %inner.latch ]
  %last = phi i64 [ 0, %outer.body ], [ %last.sel, %inner.latch ]
  %cond = icmp ult i64 %i, %bound
  br i1 %cond, label %inner.body, label %inner.exit

inner.body:
  %im1 = add i64 %i, -1
  %p_im1 = getelementptr inbounds i32, i32* %arr, i64 %im1
  %p_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %v_im1 = load i32, i32* %p_im1, align 4
  %v_i = load i32, i32* %p_i, align 4
  %cmp.sle = icmp sle i32 %v_im1, %v_i
  br i1 %cmp.sle, label %no_swap, label %do_swap

no_swap:
  br label %inner.latch

do_swap:
  store i32 %v_i, i32* %p_im1, align 4
  store i32 %v_im1, i32* %p_i, align 4
  br label %inner.latch

inner.latch:
  %last.sel = phi i64 [ %last, %no_swap ], [ %i, %do_swap ]
  %i.next = add i64 %i, 1
  br label %inner.header

inner.exit:
  %noSwaps = icmp eq i64 %last, 0
  br i1 %noSwaps, label %exit, label %outer.latch

outer.latch:
  br label %outer.header

exit:
  ret void
}