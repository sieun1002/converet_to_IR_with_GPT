target triple = "x86_64-pc-windows-msvc"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %end, label %outer.cond.pre

outer.cond.pre:
  br label %outer.cond

outer.cond:
  %outerBound = phi i64 [ %n, %outer.cond.pre ], [ %last, %outer.update ]
  %cmp_ob_gt1 = icmp ugt i64 %outerBound, 1
  br i1 %cmp_ob_gt1, label %outer.init, label %end

outer.init:
  br label %inner.cond

inner.cond:
  %i = phi i64 [ 1, %outer.init ], [ %iNext, %inner.latch ]
  %last = phi i64 [ 0, %outer.init ], [ %lastNext, %inner.latch ]
  %bound = phi i64 [ %outerBound, %outer.init ], [ %bound, %inner.latch ]
  %cmp_i_lt_bound = icmp ult i64 %i, %bound
  br i1 %cmp_i_lt_bound, label %inner.body, label %afterInner

inner.body:
  %iMinus1 = add i64 %i, -1
  %ptrPrev = getelementptr inbounds i32, i32* %arr, i64 %iMinus1
  %ptrCurr = getelementptr inbounds i32, i32* %arr, i64 %i
  %valPrev = load i32, i32* %ptrPrev, align 4
  %valCurr = load i32, i32* %ptrCurr, align 4
  %cmp_gt = icmp sgt i32 %valPrev, %valCurr
  br i1 %cmp_gt, label %doSwap, label %noSwap

doSwap:
  store i32 %valCurr, i32* %ptrPrev, align 4
  store i32 %valPrev, i32* %ptrCurr, align 4
  br label %inner.latch

noSwap:
  br label %inner.latch

inner.latch:
  %lastNext = phi i64 [ %i, %doSwap ], [ %last, %noSwap ]
  %iNext = add i64 %i, 1
  br label %inner.cond

afterInner:
  %noSwapDone = icmp eq i64 %last, 0
  br i1 %noSwapDone, label %end, label %outer.update

outer.update:
  br label %outer.cond

end:
  ret void
}