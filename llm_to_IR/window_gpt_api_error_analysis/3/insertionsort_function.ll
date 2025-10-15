; ModuleID = 'insertion_sort'
source_filename = "insertion_sort.ll"
target triple = "x86_64-pc-windows-msvc"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %for.i

for.i:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.body.end ]
  %i.cmp = icmp ult i64 %i, %n
  br i1 %i.cmp, label %outer.body, label %exit

outer.body:
  %key.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  br label %inner.check

inner.check:
  %j = phi i64 [ %i, %outer.body ], [ %j.next, %inner.shift ]
  %j_is_zero = icmp eq i64 %j, 0
  br i1 %j_is_zero, label %inner.done, label %inner.compareprep

inner.compareprep:
  %jminus1 = add i64 %j, -1
  %prev.ptr = getelementptr inbounds i32, i32* %arr, i64 %jminus1
  %prev = load i32, i32* %prev.ptr, align 4
  %cmp = icmp slt i32 %key, %prev
  br i1 %cmp, label %inner.shift, label %inner.done

inner.shift:
  %dest.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %prev, i32* %dest.ptr, align 4
  %j.next = add i64 %j, -1
  br label %inner.check

inner.done:
  %j.final = phi i64 [ %j, %inner.check ], [ %j, %inner.compareprep ]
  %dest2.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %dest2.ptr, align 4
  br label %outer.body.end

outer.body.end:
  %i.next = add i64 %i, 1
  br label %for.i

exit:
  ret void
}