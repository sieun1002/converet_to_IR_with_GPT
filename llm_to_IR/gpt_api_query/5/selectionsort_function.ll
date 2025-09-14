; ModuleID = 'selection_sort'
source_filename = "selection_sort.ll"

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.after_swap, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.after_swap ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp = icmp slt i32 %i, %n.minus1
  br i1 %cmp, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.cond
  %min.init = add nsw i32 %i, 0
  %j.init = add nsw i32 %i, 1
  br label %inner.cond

inner.cond:                                       ; preds = %inner.update_end, %outer.body
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.update_end ]
  %min = phi i32 [ %min.init, %outer.body ], [ %min.next, %inner.update_end ]
  %j.cmp = icmp slt i32 %j, %n
  br i1 %j.cmp, label %inner.body, label %inner.end

inner.body:                                       ; preds = %inner.cond
  %j.idx64 = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %val.j = load i32, i32* %j.ptr, align 4
  %min.idx64 = sext i32 %min to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx64
  %val.min = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %val.j, %val.min
  br i1 %lt, label %inner.update, label %inner.no_update

inner.update:                                     ; preds = %inner.body
  %min.updated = add nsw i32 %j, 0
  br label %inner.update_end

inner.no_update:                                  ; preds = %inner.body
  %min.no = add nsw i32 %min, 0
  br label %inner.update_end

inner.update_end:                                 ; preds = %inner.no_update, %inner.update
  %min.next = phi i32 [ %min.updated, %inner.update ], [ %min.no, %inner.no_update ]
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

inner.end:                                        ; preds = %inner.cond
  %i.idx64 = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx64
  %tmp = load i32, i32* %i.ptr, align 4
  %min.idx64.end = sext i32 %min to i64
  %min.ptr.end = getelementptr inbounds i32, i32* %arr, i64 %min.idx64.end
  %val.min.end = load i32, i32* %min.ptr.end, align 4
  store i32 %val.min.end, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.ptr.end, align 4
  br label %outer.after_swap

outer.after_swap:                                 ; preds = %inner.end
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}