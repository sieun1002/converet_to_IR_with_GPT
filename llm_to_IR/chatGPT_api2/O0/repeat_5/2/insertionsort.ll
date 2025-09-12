; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort  ; Address: 0x1189
; Intent: In-place insertion sort (ascending, 32-bit signed) (confidence=0.98). Evidence: 4-byte element shifts; signed jl compare; i from 1 to n-1.
; Preconditions: a points to at least n contiguous i32 elements.
; Postconditions: a[0..n) sorted ascending by signed 32-bit comparison.

define dso_local void @insertion_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; i loop condition
  %i = phi i64 [ 1, entry ], [ %i.next, %outer.inc ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %outer.body, label %return

outer.body:
  %key.ptr = getelementptr inbounds i32, i32* %a, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  br label %inner.cond

inner.cond:
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.shift ]
  %j.ne.zero = icmp ne i64 %j, 0
  br i1 %j.ne.zero, label %inner.cmp, label %after.inner.from.zero

inner.cmp:
  %jm1 = add i64 %j, -1
  %prev.ptr = getelementptr inbounds i32, i32* %a, i64 %jm1
  %prev = load i32, i32* %prev.ptr, align 4
  %key.lt.prev = icmp slt i32 %key, %prev
  br i1 %key.lt.prev, label %inner.shift, label %after.inner.from.cmp

inner.shift:
  %j.ptr = getelementptr inbounds i32, i32* %a, i64 %j
  store i32 %prev, i32* %j.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

after.inner.from.zero:
  br label %after.inner.join

after.inner.from.cmp:
  br label %after.inner.join

after.inner.join:
  %j.final = phi i64 [ %j, %after.inner.from.zero ], [ %j, %after.inner.from.cmp ]
  %dst.ptr = getelementptr inbounds i32, i32* %a, i64 %j.final
  store i32 %key, i32* %dst.ptr, align 4
  br label %outer.inc

outer.inc:
  %i.next = add i64 %i, 1
  br label %outer.cond

return:
  ret void
}