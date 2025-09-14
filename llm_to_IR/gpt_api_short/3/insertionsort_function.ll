; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort ; Address: 0x1189
; Intent: In-place insertion sort of a 32-bit int array (confidence=0.98). Evidence: 4-byte element stride; inner loop shifts while key < previous (signed); outer loop i from 1 to n-1 (unsigned bound).
; Preconditions: arr points to at least n 32-bit integers.
; Postconditions: arr[0..n) sorted in nondecreasing (ascending) order by signed comparison.

; Only the necessary external declarations:

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; i loop condition
  %i = phi i64 [ 1, entry ], [ %i.next, %outer.end ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %outer.body, label %ret

outer.body:
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %i.ptr, align 4
  br label %inner.cond

inner.cond:                                       ; while (j != 0 && key < a[j-1])
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.shift ]
  %j.is0 = icmp eq i64 %j, 0
  br i1 %j.is0, label %inner.exit, label %inner.check

inner.check:
  %j.minus1 = add i64 %j, -1
  %jm1.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %jm1.val = load i32, i32* %jm1.ptr, align 4
  %cmp.key.jm1 = icmp slt i32 %key, %jm1.val
  br i1 %cmp.key.jm1, label %inner.shift, label %inner.exit

inner.shift:                                      ; a[j] = a[j-1]; --j;
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %jm1.val, i32* %j.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

inner.exit:
  %j.exit = phi i64 [ %j, %inner.cond ], [ %j, %inner.check ]
  %dest.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.exit
  store i32 %key, i32* %dest.ptr, align 4
  br label %outer.end

outer.end:
  %i.next = add i64 %i, 1
  br label %outer.cond

ret:
  ret void
}