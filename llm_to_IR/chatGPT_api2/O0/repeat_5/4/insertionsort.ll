; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort  ; Address: 0x1189
; Intent: In-place ascending insertion sort of 32-bit int array (confidence=0.95). Evidence: 4-byte element stride and signed jl comparison in inner loop.
; Preconditions: a points to at least n 32-bit elements; n is the element count.
; Postconditions: a[0..n-1] sorted in non-decreasing order by signed 32-bit comparison.

; Only the needed extern declarations:

define dso_local void @insertion_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  br label %for.cond

for.cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %for.body, label %ret

for.body:
  %ai.ptr = getelementptr inbounds i32, i32* %a, i64 %i
  %key = load i32, i32* %ai.ptr, align 4
  br label %while.cond

while.cond:
  %j = phi i64 [ %i, %for.body ], [ %j.dec, %while.body ]
  %j_is_zero = icmp eq i64 %j, 0
  br i1 %j_is_zero, label %while.end, label %while.cmp

while.cmp:
  %jm1 = add i64 %j, -1
  %ptr_jm1 = getelementptr inbounds i32, i32* %a, i64 %jm1
  %val_jm1 = load i32, i32* %ptr_jm1, align 4
  %cmp2 = icmp slt i32 %key, %val_jm1
  br i1 %cmp2, label %while.body, label %while.end

while.body:
  %ptr_j = getelementptr inbounds i32, i32* %a, i64 %j
  store i32 %val_jm1, i32* %ptr_j, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

while.end:
  %j.final = phi i64 [ %j, %while.cmp ], [ %j, %while.cond ]
  %ptr_j_final = getelementptr inbounds i32, i32* %a, i64 %j.final
  store i32 %key, i32* %ptr_j_final, align 4
  br label %for.inc

for.inc:
  %i.next = add i64 %i, 1
  br label %for.cond

ret:
  ret void
}