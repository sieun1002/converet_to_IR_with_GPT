; ModuleID = 'insertion_sort_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

define void @insertion_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr nounwind {
entry:
  %n_gt1 = icmp ugt i64 %n, 1
  br i1 %n_gt1, label %outer.check, label %exit

outer.check:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %outer.body, label %exit

outer.body:
  %gep_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %gep_i, align 4
  br label %inner.check

inner.check:
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.shift ]
  %j_gt_zero = icmp ne i64 %j, 0
  br i1 %j_gt_zero, label %inner.compare, label %inner.after

inner.compare:
  %jm1 = add i64 %j, -1
  %ptr_jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val_jm1 = load i32, i32* %ptr_jm1, align 4
  %cmp_key = icmp slt i32 %key, %val_jm1
  br i1 %cmp_key, label %inner.shift, label %inner.after

inner.shift:
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val_jm1, i32* %ptr_j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.check

inner.after:
  %j.place = phi i64 [ %j, %inner.check ], [ %j, %inner.compare ]
  %ptr_j_place = getelementptr inbounds i32, i32* %arr, i64 %j.place
  store i32 %key, i32* %ptr_j_place, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i64 %i, 1
  br label %outer.check

exit:
  ret void
}