; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort  ; Address: 0x1189
; Intent: In-place insertion sort of 32-bit integers in ascending order (confidence=0.98). Evidence: key save, shifting arr[j]=arr[j-1] while key<arr[j-1], then insert and increment i.
; Preconditions: If %n > 0, %a must point to at least %n contiguous 32-bit integers.
; Postconditions: First %n elements at %a are sorted in nondecreasing order (stable).

define dso_local void @insertion_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; i loop: for (i=1; i<n; ++i)
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %outer.body, label %exit

outer.body:
  %key.ptr = getelementptr inbounds i32, i32* %a, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  br label %inner.cond

inner.cond:                                       ; while (j>0 && key < a[j-1])
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.shift ]
  %j.ne0 = icmp ne i64 %j, 0
  br i1 %j.ne0, label %inner.check, label %insert

inner.check:
  %jminus1 = add i64 %j, -1
  %addr.jm1 = getelementptr inbounds i32, i32* %a, i64 %jminus1
  %ajm1 = load i32, i32* %addr.jm1, align 4
  %cmp.slt = icmp slt i32 %key, %ajm1
  br i1 %cmp.slt, label %inner.shift, label %insert

inner.shift:
  %dest.addr = getelementptr inbounds i32, i32* %a, i64 %j
  store i32 %ajm1, i32* %dest.addr, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

insert:
  %dest.addr2 = getelementptr inbounds i32, i32* %a, i64 %j
  store i32 %key, i32* %dest.addr2, align 4
  br label %outer.inc

outer.inc:
  %i.next = add i64 %i, 1
  br label %outer.cond

exit:
  ret void
}