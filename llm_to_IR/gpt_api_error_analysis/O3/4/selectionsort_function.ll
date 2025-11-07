target triple = "x86_64-unknown-linux-gnu"

define void @selection_sort(i32* nocapture %arr, i32 %n) local_unnamed_addr {
entry:
  %cmp0 = icmp sle i32 %n, 1
  br i1 %cmp0, label %ret, label %outer.preheader

outer.preheader:
  %n_minus_1 = add nsw i32 %n, -1
  br label %outer.loop

outer.loop:
  %i = phi i32 [ 0, %outer.preheader ], [ %i.next, %outer.latch ]
  %cmp_i_last = icmp sge i32 %i, %n_minus_1
  br i1 %cmp_i_last, label %ret, label %inner.init

inner.init:
  %ptr_i = getelementptr inbounds i32, i32* %arr, i32 %i
  %val_i = load i32, i32* %ptr_i, align 4
  %j0 = add nsw i32 %i, 1
  br label %inner.loop

inner.loop:
  %j = phi i32 [ %j0, %inner.init ], [ %j.next, %inner.body ]
  %cur_min_idx = phi i32 [ %i, %inner.init ], [ %cur_min_idx.next, %inner.body ]
  %cur_min_val = phi i32 [ %val_i, %inner.init ], [ %cur_min_val.next, %inner.body ]
  %cmp_j_end = icmp slt i32 %j, %n
  br i1 %cmp_j_end, label %inner.body, label %inner.end

inner.body:
  %ptr_j = getelementptr inbounds i32, i32* %arr, i32 %j
  %val_j = load i32, i32* %ptr_j, align 4
  %less = icmp slt i32 %val_j, %cur_min_val
  %cur_min_idx.next = select i1 %less, i32 %j, i32 %cur_min_idx
  %cur_min_val.next = select i1 %less, i32 %val_j, i32 %cur_min_val
  %j.next = add nsw i32 %j, 1
  br label %inner.loop

inner.end:
  store i32 %cur_min_val, i32* %ptr_i, align 4
  %ptr_min = getelementptr inbounds i32, i32* %arr, i32 %cur_min_idx
  store i32 %val_i, i32* %ptr_min, align 4
  br label %outer.latch

outer.latch:
  %i.next = add nsw i32 %i, 1
  br label %outer.loop

ret:
  ret void
}