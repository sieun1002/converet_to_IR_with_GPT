; ModuleID = 'insertion_sort'
source_filename = "insertion_sort.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %entry, %outer.latch
  %i.ph = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cmp.i.n = icmp ult i64 %i.ph, %n
  br i1 %cmp.i.n, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.cond
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ph
  %key = load i32, i32* %elem.ptr, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %outer.body, %inner.body
  %j.ph = phi i64 [ %i.ph, %outer.body ], [ %j.dec, %inner.body ]
  %j.is.zero = icmp eq i64 %j.ph, 0
  br i1 %j.is.zero, label %inner.end, label %inner.check

inner.check:                                      ; preds = %inner.cond
  %j.minus1 = add i64 %j.ph, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %key.lt.jm1 = icmp slt i32 %key, %val.jm1
  br i1 %key.lt.jm1, label %inner.body, label %inner.end

inner.body:                                       ; preds = %inner.check
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.ph
  store i32 %val.jm1, i32* %ptr.j, align 4
  %j.dec = add i64 %j.ph, -1
  br label %inner.cond

inner.end:                                        ; preds = %inner.cond, %inner.check
  %j.final = phi i64 [ %j.ph, %inner.cond ], [ %j.ph, %inner.check ]
  %ptr.j.final = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %ptr.j.final, align 4
  br label %outer.latch

outer.latch:                                      ; preds = %inner.end
  %i.next = add i64 %i.ph, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}