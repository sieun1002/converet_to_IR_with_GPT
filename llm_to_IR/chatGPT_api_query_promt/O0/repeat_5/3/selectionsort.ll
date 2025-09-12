; ModuleID = 'selection_sort'
source_filename = "selection_sort"
target triple = "x86_64-unknown-linux-gnu"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %n1 = add nsw i32 %n, -1
  %cmp = icmp slt i32 %i, %n1
  br i1 %cmp, label %outer.body, label %exit

outer.body:
  %minIdx0 = add i32 %i, 0
  %j0 = add nsw i32 %i, 1
  br label %inner.cond

inner.cond:
  %minIdx = phi i32 [ %minIdx0, %outer.body ], [ %minIdx.next, %inner.inc ]
  %j = phi i32 [ %j0, %outer.body ], [ %j.next, %inner.inc ]
  %cmpj = icmp slt i32 %j, %n
  br i1 %cmpj, label %inner.body, label %inner.end

inner.body:
  %j64 = sext i32 %j to i64
  %p_j = getelementptr inbounds i32, i32* %arr, i64 %j64
  %vj = load i32, i32* %p_j, align 4
  %min64 = sext i32 %minIdx to i64
  %p_min = getelementptr inbounds i32, i32* %arr, i64 %min64
  %vmin = load i32, i32* %p_min, align 4
  %lt = icmp slt i32 %vj, %vmin
  %minIdx.next = select i1 %lt, i32 %j, i32 %minIdx
  br label %inner.inc

inner.inc:
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

inner.end:
  %i64 = sext i32 %i to i64
  %p_i = getelementptr inbounds i32, i32* %arr, i64 %i64
  %vi = load i32, i32* %p_i, align 4
  %min64.2 = sext i32 %minIdx to i64
  %p_min2 = getelementptr inbounds i32, i32* %arr, i64 %min64.2
  %vmin2 = load i32, i32* %p_min2, align 4
  store i32 %vmin2, i32* %p_i, align 4
  store i32 %vi, i32* %p_min2, align 4
  br label %outer.inc

outer.inc:
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

exit:
  ret void
}