; ModuleID = 'selection_sort'
source_filename = "selection_sort.ll"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer

outer:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.end ]
  %n_minus1 = add i32 %n, -1
  %cond.outer = icmp slt i32 %i, %n_minus1
  br i1 %cond.outer, label %outer.body, label %exit

outer.body:
  %min.init = %i
  %j.init = add i32 %i, 1
  br label %inner

inner:
  %min.cur = phi i32 [ %min.init, %outer.body ], [ %min.next, %inner.iter ]
  %j.cur = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.iter ]
  %cond.inner = icmp slt i32 %j.cur, %n
  br i1 %cond.inner, label %inner.body, label %after_inner

inner.body:
  %j.idx64 = sext i32 %j.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %valj = load i32, i32* %j.ptr, align 4
  %min.idx64 = sext i32 %min.cur to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx64
  %valmin = load i32, i32* %min.ptr, align 4
  %less = icmp slt i32 %valj, %valmin
  %min.next = select i1 %less, i32 %j.cur, i32 %min.cur
  %j.next = add i32 %j.cur, 1
  br label %inner.iter

inner.iter:
  br label %inner

after_inner:
  %min.final = phi i32 [ %min.cur, %inner ]
  %i64 = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %min64 = sext i32 %min.final to i64
  %min.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min64
  %tmp = load i32, i32* %i.ptr, align 4
  %valmin2 = load i32, i32* %min.ptr2, align 4
  store i32 %valmin2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.ptr2, align 4
  br label %outer.end

outer.end:
  %i.next = add i32 %i, 1
  br label %outer

exit:
  ret void
}