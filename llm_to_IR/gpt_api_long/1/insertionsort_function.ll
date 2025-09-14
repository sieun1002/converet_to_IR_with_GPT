; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort  ; Address: 0x1189
; Intent: In-place ascending insertion sort of 32-bit integers (confidence=0.95). Evidence: 4-byte element scaling and signed compare (jl) shifting larger predecessors.
; Preconditions: a points to at least n 32-bit elements; if n > 0, a is non-null.
; Postconditions: a[0..n) is sorted in non-decreasing order (stable).

define dso_local void @insertion_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  br label %for.cond

for.cond:                                           ; i loop condition
  %i = phi i64 [ 1, entry ], [ %i.next, %for.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %loop.body.entry, label %ret

loop.body.entry:                                    ; load key and init j
  %key.ptr = getelementptr inbounds i32, i32* %a, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  br label %while.cond

while.cond:                                         ; while (j > 0 && key < a[j-1])
  %j = phi i64 [ %i, %loop.body.entry ], [ %j.dec, %while.body ]
  %j_nonzero = icmp ne i64 %j, 0
  br i1 %j_nonzero, label %while.check2, label %while.end

while.check2:
  %jm1 = add i64 %j, -1
  %ptr_jm1 = getelementptr inbounds i32, i32* %a, i64 %jm1
  %val_jm1 = load i32, i32* %ptr_jm1, align 4
  %cond = icmp slt i32 %key, %val_jm1
  br i1 %cond, label %while.body, label %while.end

while.body:                                         ; shift a[j-1] to a[j]
  %ptr_j = getelementptr inbounds i32, i32* %a, i64 %j
  store i32 %val_jm1, i32* %ptr_j, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

while.end:                                          ; place key at a[j]
  %j.end = phi i64 [ 0, %while.cond ], [ %j, %while.check2 ]
  %dst = getelementptr inbounds i32, i32* %a, i64 %j.end
  store i32 %key, i32* %dst, align 4
  br label %for.inc

for.inc:
  %i.next = add i64 %i, 1
  br label %for.cond

ret:
  ret void
}