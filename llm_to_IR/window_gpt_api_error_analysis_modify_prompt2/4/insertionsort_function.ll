; ModuleID = 'insertion_sort_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @insertion_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.end, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.end ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.cond
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %elem.ptr, align 4
  %j.init = add i64 %i, 0
  br label %inner.cond

inner.cond:                                       ; preds = %inner.shift, %outer.body
  %j = phi i64 [ %j.init, %outer.body ], [ %j.dec, %inner.shift ]
  %j.not.zero = icmp ne i64 %j, 0
  br i1 %j.not.zero, label %inner.cmp, label %inner.after

inner.cmp:                                        ; preds = %inner.cond
  %j.minus1 = add i64 %j, -1
  %prev.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %prev = load i32, i32* %prev.ptr, align 4
  %key.lt.prev = icmp slt i32 %key, %prev
  br i1 %key.lt.prev, label %inner.shift, label %inner.after

inner.shift:                                      ; preds = %inner.cmp
  %dest.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %prev, i32* %dest.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

inner.after:                                      ; preds = %inner.cmp, %inner.cond
  %j.final = phi i64 [ %j, %inner.cmp ], [ %j, %inner.cond ]
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %ins.ptr, align 4
  br label %outer.end

outer.end:                                        ; preds = %inner.after
  %i.next = add i64 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}