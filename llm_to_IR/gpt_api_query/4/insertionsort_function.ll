; ModuleID = 'insertion_sort'
target triple = "x86_64-pc-linux-gnu"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %for.header

for.header:
  %i = phi i64 [ 1, entry ], [ %i.next, %for.latch ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %for.body, label %exit

for.body:
  %eltptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %eltptr, align 4
  br label %inner.header

inner.header:
  %j = phi i64 [ %i, %for.body ], [ %j.dec, %shift ]
  %j.nonzero = icmp ne i64 %j, 0
  br i1 %j.nonzero, label %inner.check, label %insert

inner.check:
  %jm1 = add i64 %j, -1
  %ptr_jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val_jm1 = load i32, i32* %ptr_jm1, align 4
  %lt = icmp slt i32 %key, %val_jm1
  br i1 %lt, label %shift, label %insert

shift:
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val_jm1, i32* %ptr_j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.header

insert:
  %ptr_j2 = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %ptr_j2, align 4
  br label %for.latch

for.latch:
  %i.next = add i64 %i, 1
  br label %for.header

exit:
  ret void
}