; ModuleID = 'insertion_sort'
target triple = "x86_64-pc-windows-msvc"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %loop.cond

loop.cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %after.body ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %loop.body, label %end

loop.body:
  %arr_i_ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %arr_i_ptr, align 4
  br label %inner.cond

inner.cond:
  %j = phi i64 [ %i, %loop.body ], [ %j.dec, %inner.shift ]
  %j_is_zero = icmp eq i64 %j, 0
  br i1 %j_is_zero, label %insert, label %check.shift

check.shift:
  %jm1 = add i64 %j, -1
  %ptr_jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val_jm1 = load i32, i32* %ptr_jm1, align 4
  %cmp.key = icmp slt i32 %key, %val_jm1
  br i1 %cmp.key, label %inner.shift, label %insert

inner.shift:
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val_jm1, i32* %ptr_j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

insert:
  %j.ins = phi i64 [ %j, %inner.cond ], [ %j, %check.shift ]
  %ptr_j.ins = getelementptr inbounds i32, i32* %arr, i64 %j.ins
  store i32 %key, i32* %ptr_j.ins, align 4
  br label %after.body

after.body:
  %i.next = add i64 %i, 1
  br label %loop.cond

end:
  ret void
}