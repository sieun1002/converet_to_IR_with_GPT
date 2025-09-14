; ModuleID = 'insertion_sort.ll'
source_filename = "insertion_sort.c"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.inc, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %outer.body, label %ret

outer.body:                                       ; preds = %outer.cond
  %idx.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %idx.ptr, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %inner.shift, %outer.body
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.shift ]
  %j.gt.zero = icmp ugt i64 %j, 0
  br i1 %j.gt.zero, label %check, label %place

check:                                            ; preds = %inner.cond
  %jminus1 = add i64 %j, -1
  %ptr_jminus1 = getelementptr inbounds i32, i32* %arr, i64 %jminus1
  %val_jminus1 = load i32, i32* %ptr_jminus1, align 4
  %cond = icmp slt i32 %key, %val_jminus1
  br i1 %cond, label %inner.shift, label %place

inner.shift:                                      ; preds = %check
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val_jminus1, i32* %ptr_j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

place:                                            ; preds = %check, %inner.cond
  %ptr_j.place = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %ptr_j.place, align 4
  br label %outer.inc

outer.inc:                                        ; preds = %place
  %i.next = add i64 %i, 1
  br label %outer.cond

ret:                                              ; preds = %outer.cond
  ret void
}