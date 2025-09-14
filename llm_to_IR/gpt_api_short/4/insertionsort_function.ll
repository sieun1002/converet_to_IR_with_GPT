; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort ; Address: 0x1189
; Intent: In-place ascending insertion sort on int32 array (confidence=0.94). Evidence: 4-byte stride, key compare with jl (signed), shifting elements until key >= previous.
; Preconditions: a != NULL; n is the number of 32-bit elements.
; Postconditions: a[0..n) is sorted in non-decreasing order (signed int32).

; Only the necessary external declarations:

define dso_local void @insertion_sort(i32* nocapture %a, i64 %n) local_unnamed_addr {
entry:
  br label %for.cond

for.cond:                                           ; preds = %for.inc, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %for.body, label %return

for.body:                                           ; preds = %for.cond
  %key.ptr = getelementptr i32, i32* %a, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  br label %while.cond

while.cond:                                         ; preds = %while.body, %for.body
  %j = phi i64 [ %i, %for.body ], [ %j.dec, %while.body ]
  %j.is.zero = icmp eq i64 %j, 0
  br i1 %j.is.zero, label %insert, label %cmp2

cmp2:                                               ; preds = %while.cond
  %jminus1 = add i64 %j, -1
  %ptr_jm1 = getelementptr i32, i32* %a, i64 %jminus1
  %val_jm1 = load i32, i32* %ptr_jm1, align 4
  %need.shift = icmp slt i32 %key, %val_jm1
  br i1 %need.shift, label %while.body, label %insert

while.body:                                         ; preds = %cmp2
  %ptr_j = getelementptr i32, i32* %a, i64 %j
  store i32 %val_jm1, i32* %ptr_j, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

insert:                                             ; preds = %cmp2, %while.cond
  %ptr_j.final = getelementptr i32, i32* %a, i64 %j
  store i32 %key, i32* %ptr_j.final, align 4
  br label %for.inc

for.inc:                                            ; preds = %insert
  %i.next = add i64 %i, 1
  br label %for.cond

return:                                             ; preds = %for.cond
  ret void
}