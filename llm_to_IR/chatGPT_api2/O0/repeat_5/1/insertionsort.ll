; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort  ; Address: 0x1189
; Intent: In-place insertion sort of 32-bit signed integers in ascending order (confidence=0.95). Evidence: key temp, backward shift loop with j--, signed compare against arr[j-1].
; Preconditions: arr points to at least n i32 elements.
; Postconditions: arr[0..n) is sorted in nondecreasing (signed i32) order.

; Only the needed extern declarations:

define dso_local void @insertion_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                        ; i loop: for (i=1; i<n; ++i)
  %i = phi i64 [ 1, %entry ], [ %i.next, %inner.end ]
  %cmp.out = icmp ult i64 %i, %n
  br i1 %cmp.out, label %outer.body, label %exit

outer.body:
  %key.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %j0 = %i
  br label %inner.cond

inner.cond:                                        ; while (j>0 && key < arr[j-1])
  %j = phi i64 [ %j0, %outer.body ], [ %j.dec, %inner.shift ]
  %j.gt0 = icmp ugt i64 %j, 0
  br i1 %j.gt0, label %inner.compare, label %inner.end

inner.compare:
  %jm1 = add i64 %j, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %lt = icmp slt i32 %key, %val.jm1
  br i1 %lt, label %inner.shift, label %inner.end

inner.shift:
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %ptr.j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

inner.end:
  %j.end = phi i64 [ %j, %inner.cond ], [ %j, %inner.compare ]
  %dst = getelementptr inbounds i32, i32* %arr, i64 %j.end
  store i32 %key, i32* %dst, align 4
  %i.next = add i64 %i, 1
  br label %outer.cond

exit:
  ret void
}