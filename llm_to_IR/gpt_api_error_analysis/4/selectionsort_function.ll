; ModuleID = 'selection_sort'
target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* nocapture %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer.loop

outer.loop:                                        ; preds = %entry, %outer.after.swap
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.after.swap ]
  %n.sub = add nsw i32 %n, -1
  %cond.outer = icmp slt i32 %i, %n.sub
  br i1 %cond.outer, label %outer.body, label %exit

outer.body:                                        ; preds = %outer.loop
  %min.init = phi i32 [ %i, %outer.loop ]
  %j.init = add nsw i32 %i, 1
  br label %inner.loop

inner.loop:                                        ; preds = %inner.inc, %outer.body
  %min.cur = phi i32 [ %min.init, %outer.body ], [ %min.next, %inner.inc ]
  %j.cur = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.inc ]
  %cmp.j = icmp slt i32 %j.cur, %n
  br i1 %cmp.j, label %inner.compare, label %inner.end

inner.compare:                                     ; preds = %inner.loop
  %j.ext = sext i32 %j.cur to i64
  %min.ext = sext i32 %min.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %val.j = load i32, i32* %j.ptr, align 4
  %val.min = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %val.j, %val.min
  br i1 %lt, label %inner.update, label %inner.inc

inner.update:                                      ; preds = %inner.compare
  br label %inner.inc

inner.inc:                                         ; preds = %inner.update, %inner.compare
  %min.next = phi i32 [ %j.cur, %inner.update ], [ %min.cur, %inner.compare ]
  %j.next = add nsw i32 %j.cur, 1
  br label %inner.loop

inner.end:                                         ; preds = %inner.loop
  %min.final = phi i32 [ %min.cur, %inner.loop ]
  %i.ext = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %min.final.ext = sext i32 %min.final to i64
  %min.final.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.final.ext
  %val.min2 = load i32, i32* %min.final.ptr, align 4
  store i32 %val.min2, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.final.ptr, align 4
  br label %outer.after.swap

outer.after.swap:                                  ; preds = %inner.end
  %i.next = add nsw i32 %i, 1
  br label %outer.loop

exit:                                              ; preds = %outer.loop
  ret void
}