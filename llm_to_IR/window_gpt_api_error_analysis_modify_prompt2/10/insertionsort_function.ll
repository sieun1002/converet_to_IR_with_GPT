; ModuleID = 'insertion_sort'
target triple = "x86_64-pc-windows-msvc"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:                                         ; preds = %outer.latch, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %outer.body, label %exit

outer.body:                                         ; preds = %outer.cond
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %ptr_i, align 4
  br label %inner.cond

inner.cond:                                         ; preds = %inner.shift, %outer.body
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.shift ]
  %j_not0 = icmp ne i64 %j, 0
  br i1 %j_not0, label %inner.check, label %inner.exit

inner.check:                                        ; preds = %inner.cond
  %jminus1 = add i64 %j, -1
  %ptr_jminus1 = getelementptr inbounds i32, i32* %arr, i64 %jminus1
  %val_jminus1 = load i32, i32* %ptr_jminus1, align 4
  %cmp_key = icmp slt i32 %key, %val_jminus1
  br i1 %cmp_key, label %inner.shift, label %inner.exit

inner.shift:                                        ; preds = %inner.check
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val_jminus1, i32* %ptr_j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

inner.exit:                                         ; preds = %inner.check, %inner.cond
  %j.final = phi i64 [ %j, %inner.cond ], [ %j, %inner.check ]
  %ptr_j_final = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %ptr_j_final, align 4
  br label %outer.latch

outer.latch:                                        ; preds = %inner.exit
  %i.next = add i64 %i, 1
  br label %outer.cond

exit:                                               ; preds = %outer.cond
  ret void
}