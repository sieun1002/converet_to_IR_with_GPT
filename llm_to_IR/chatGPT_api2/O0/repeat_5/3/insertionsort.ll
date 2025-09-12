; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort  ; Address: 0x1189
; Intent: In-place insertion sort of i32 array in ascending (signed) order (confidence=0.98). Evidence: 4-byte stride shifts, key compare using jl (signed), outer i from 1..n-1.
; Preconditions: %arr points to at least %n 32-bit elements; %n >= 0.
; Postconditions: %arr[0..n) sorted nondecreasing w.r.t. signed 32-bit comparison.

; Only the needed extern declarations:

define dso_local void @insertion_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  br label %for.cond

for.cond:
  %i = phi i64 [ 1, entry ], [ %i.next, %for.inc ]
  %cmp.i = icmp ult i64 %i, %n
  br i1 %cmp.i, label %for.body, label %ret

for.body:
  %keyptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %keyptr, align 4
  br label %while.cond

while.cond:
  %j = phi i64 [ %i, %for.body ], [ %j.dec, %while.body ]
  %j_gt0 = icmp ne i64 %j, 0
  br i1 %j_gt0, label %while.check2, label %while.end

while.check2:
  %jminus1 = add i64 %j, -1
  %prevptr = getelementptr inbounds i32, i32* %arr, i64 %jminus1
  %prev = load i32, i32* %prevptr, align 4
  %key_lt_prev = icmp slt i32 %key, %prev
  br i1 %key_lt_prev, label %while.body, label %while.end

while.body:
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %prev, i32* %j.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

while.end:
  %j.end = phi i64 [ %j, %while.cond ], [ %j, %while.check2 ]
  %dstptr = getelementptr inbounds i32, i32* %arr, i64 %j.end
  store i32 %key, i32* %dstptr, align 4
  br label %for.inc

for.inc:
  %i.next = add i64 %i, 1
  br label %for.cond

ret:
  ret void
}