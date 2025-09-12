; ModuleID = 'insertion_sort'
source_filename = "insertion_sort"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                           ; i from 1 to n-1 (unsigned)
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.inc ]
  %lt = icmp ult i64 %i, %n
  br i1 %lt, label %outer.body, label %exit

outer.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %elem.ptr, align 4
  %j.init = add i64 %i, 0
  br label %inner.cond

inner.cond:
  %j = phi i64 [ %j.init, %outer.body ], [ %j.dec, %inner.shift ]
  %j.not.zero = icmp ne i64 %j, 0
  br i1 %j.not.zero, label %inner.check, label %inner.exit

inner.check:
  %jm1 = add i64 %j, -1
  %prev.ptr = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %prev = load i32, i32* %prev.ptr, align 4
  %cmp = icmp slt i32 %key, %prev
  br i1 %cmp, label %inner.shift, label %inner.exit

inner.shift:
  %dest.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %prev, i32* %dest.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

inner.exit:
  %j.final = phi i64 [ %j, %inner.cond ], [ %j, %inner.check ]
  %dest2 = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %dest2, align 4
  br label %outer.inc

outer.inc:
  %i.next = add i64 %i, 1
  br label %outer.cond

exit:
  ret void
}