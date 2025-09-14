; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort  ; Address: 0x1189
; Intent: In-place ascending insertion sort of 32-bit integers (confidence=0.98). Evidence: 4-byte element indexing; outer loop from index 1 with inner shifting while key < a[j-1]
; Preconditions: %a points to at least %n contiguous i32 elements
; Postconditions: %a[0..n) sorted in non-decreasing order (stable)

define dso_local void @insertion_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %more_than_one = icmp ugt i64 %n, 1
  br i1 %more_than_one, label %outer.preheader, label %return

outer.preheader:
  br label %outer.header

outer.header:
  %i = phi i64 [ 1, %outer.preheader ], [ %i.next, %outer.latch ]
  %a_i_ptr = getelementptr inbounds i32, i32* %a, i64 %i
  %key = load i32, i32* %a_i_ptr, align 4
  br label %inner.check

inner.check:
  %j.cur = phi i64 [ %i, %outer.header ], [ %j.dec, %inner.body ]
  %j_is_zero = icmp eq i64 %j.cur, 0
  br i1 %j_is_zero, label %inner.exit, label %inner.cmp

inner.cmp:
  %jm1 = add i64 %j.cur, -1
  %ptr_jm1 = getelementptr inbounds i32, i32* %a, i64 %jm1
  %prev = load i32, i32* %ptr_jm1, align 4
  %cmp_key_prev = icmp slt i32 %key, %prev
  br i1 %cmp_key_prev, label %inner.body, label %inner.exit

inner.body:
  %ptr_j = getelementptr inbounds i32, i32* %a, i64 %j.cur
  store i32 %prev, i32* %ptr_j, align 4
  %j.dec = add i64 %j.cur, -1
  br label %inner.check

inner.exit:
  %j.out = phi i64 [ %j.cur, %inner.check ], [ %j.cur, %inner.cmp ]
  %ptr_j_out = getelementptr inbounds i32, i32* %a, i64 %j.out
  store i32 %key, i32* %ptr_j_out, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i64 %i, 1
  %cont = icmp ult i64 %i.next, %n
  br i1 %cont, label %outer.header, label %return

return:
  ret void
}