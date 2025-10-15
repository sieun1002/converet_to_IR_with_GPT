; ModuleID = 'insertion_sort'
source_filename = "insertion_sort.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  br label %outer.check

outer.check:                                      ; preds = %outer.inc, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.inc ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.check
  %key.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  br label %inner.check

inner.check:                                      ; preds = %inner.body, %outer.body
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.body ]
  %j_gt0 = icmp ugt i64 %j, 0
  br i1 %j_gt0, label %inner.cmpkey, label %inner.after

inner.cmpkey:                                     ; preds = %inner.check
  %jm1 = add i64 %j, -1
  %addr_jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val_jm1 = load i32, i32* %addr_jm1, align 4
  %cmpkey = icmp slt i32 %key, %val_jm1
  br i1 %cmpkey, label %inner.body, label %inner.after

inner.body:                                       ; preds = %inner.cmpkey
  %addr_j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val_jm1, i32* %addr_j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.check

inner.after:                                      ; preds = %inner.cmpkey, %inner.check
  %j.after = phi i64 [ %j, %inner.check ], [ %j, %inner.cmpkey ]
  %addr_j_after = getelementptr inbounds i32, i32* %arr, i64 %j.after
  store i32 %key, i32* %addr_j_after, align 4
  br label %outer.inc

outer.inc:                                        ; preds = %inner.after
  %i.next = add i64 %i, 1
  br label %outer.check

exit:                                             ; preds = %outer.check
  ret void
}