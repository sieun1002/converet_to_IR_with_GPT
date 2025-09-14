; ModuleID = 'insertion_sort'
source_filename = "insertion_sort"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %outer.loop

outer.loop:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %outer.body, label %exit

outer.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %elem.ptr, align 4
  br label %inner.loop

inner.loop:
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %shift ]
  %j_is_zero = icmp eq i64 %j, 0
  br i1 %j_is_zero, label %insert, label %check

check:
  %jm1 = add i64 %j, -1
  %jm1.ptr = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val_jm1 = load i32, i32* %jm1.ptr, align 4
  %key_lt = icmp slt i32 %key, %val_jm1
  br i1 %key_lt, label %shift, label %insert

shift:
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val_jm1, i32* %j.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %inner.loop

insert:
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %ins.ptr, align 4
  br label %outer.inc

outer.inc:
  %i.next = add i64 %i, 1
  br label %outer.loop

exit:
  ret void
}