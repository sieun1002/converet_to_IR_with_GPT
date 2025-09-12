; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort  ; Address: 0x1189
; Intent: In-place insertion sort of i32 array in ascending (signed) order (confidence=0.95). Evidence: key/j inner shift loop with jl (signed) compare; 4-byte element addressing.
; Preconditions: a points to at least n 32-bit elements; n is the number of elements (0 ≤ n ≤ 2^64-1).
; Postconditions: a[0..n) is nondecreasing under signed 32-bit comparison; sort is stable.

define dso_local void @insertion_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp.n = icmp ugt i64 %n, 1
  br i1 %cmp.n, label %for.body, label %ret

for.body:                                         ; i loop
  %i = phi i64 [ 1, %entry ], [ %i.next, %while.end ]
  %elem.ptr = getelementptr inbounds i32, i32* %a, i64 %i
  %key = load i32, i32* %elem.ptr, align 4
  br label %while.cond

while.cond:                                       ; while (j > 0 && a[j-1] > key)
  %j = phi i64 [ %i, %for.body ], [ %j.dec, %while.body ]
  %j.gt0 = icmp ugt i64 %j, 0
  br i1 %j.gt0, label %while.cmp, label %while.end

while.cmp:
  %jm1 = add i64 %j, -1
  %prev.ptr = getelementptr inbounds i32, i32* %a, i64 %jm1
  %prev = load i32, i32* %prev.ptr, align 4
  %gt = icmp sgt i32 %prev, %key
  br i1 %gt, label %while.body, label %while.end

while.body:
  %j.ptr = getelementptr inbounds i32, i32* %a, i64 %j
  store i32 %prev, i32* %j.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

while.end:
  %j.final = phi i64 [ %j, %while.cond ], [ %j, %while.cmp ]
  %dst.ptr = getelementptr inbounds i32, i32* %a, i64 %j.final
  store i32 %key, i32* %dst.ptr, align 4
  %i.next = add i64 %i, 1
  %cont = icmp ult i64 %i.next, %n
  br i1 %cont, label %for.body, label %ret

ret:
  ret void
}