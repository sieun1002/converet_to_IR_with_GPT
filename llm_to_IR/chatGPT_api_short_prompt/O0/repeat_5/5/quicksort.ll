; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x1189
; Intent: In-place quicksort (int32 array) using two-pointer partition and tail-recursion elimination (confidence=0.86). Evidence: median-of-interval pivot load, bidirectional i/j scan with swaps and recursive calls on subranges
; Preconditions: arr is valid; 0 <= lo <= hi < length (signed i64 indices within bounds)
; Postconditions: arr[lo..hi] sorted in nondecreasing order

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local void @quick_sort(i32* %arr, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  br label %while_head

while_head:                                           ; loop over larger partition
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.upd, %after_recurse ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.upd, %after_recurse ]
  %cmp = icmp slt i64 %lo.cur, %hi.cur
  br i1 %cmp, label %partition, label %return

partition:
  ; mid = lo + ((hi - lo + ((hi - lo) >> 63)) >> 1)
  %diff = sub i64 %hi.cur, %lo.cur
  %negbit = lshr i64 %diff, 63
  %bias = add i64 %diff, %negbit
  %half = ashr i64 %bias, 1
  %mid = add i64 %lo.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr
  %i0 = add i64 %lo.cur, 0
  %j0 = add i64 %hi.cur, 0
  br label %L

L:
  %iL = phi i64 [ %i0, %partition ], [ %i2, %swap ]
  %jL = phi i64 [ %j0, %partition ], [ %j2, %swap ]
  br label %inc_i

inc_i:
  %i.loop = phi i64 [ %iL, %L ], [ %i.next, %inc_i ]
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i.loop
  %val_i = load i32, i32* %ptr_i
  %cond_i = icmp slt i32 %val_i, %pivot
  %i.next = add nsw i64 %i.loop, 1
  br i1 %cond_i, label %inc_i, label %dec_j

dec_j:
  %j.loop = phi i64 [ %jL, %inc_i ], [ %j.next, %dec_j ]
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j.loop
  %val_j = load i32, i32* %ptr_j
  %cond_j = icmp sgt i32 %val_j, %pivot
  %j.next = add nsw i64 %j.loop, -1
  br i1 %cond_j, label %dec_j, label %check

check:
  %cmp_ij = icmp sle i64 %i.loop, %j.loop
  br i1 %cmp_ij, label %swap, label %break

swap:
  %ptr_i2 = getelementptr inbounds i32, i32* %arr, i64 %i.loop
  %ai2 = load i32, i32* %ptr_i2
  %ptr_j2 = getelementptr inbounds i32, i32* %arr, i64 %j.loop
  %aj2 = load i32, i32* %ptr_j2
  store i32 %aj2, i32* %ptr_i2
  store i32 %ai2, i32* %ptr_j2
  %i2 = add nsw i64 %i.loop, 1
  %j2 = add nsw i64 %j.loop, -1
  br label %L

break:
  %left = sub nsw i64 %j.loop, %lo.cur
  %right = sub nsw i64 %hi.cur, %i.loop
  %left_ge_right = icmp sge i64 %left, %right
  br i1 %left_ge_right, label %branch_left_ge, label %branch_left_lt

branch_left_lt:                                      ; recurse left (smaller), iterate right
  %lo_lt_j = icmp slt i64 %lo.cur, %j.loop
  br i1 %lo_lt_j, label %call_left, label %no_call_left

call_left:
  call void @quick_sort(i32* %arr, i64 %lo.cur, i64 %j.loop)
  br label %no_call_left

no_call_left:
  %lo.next = add i64 %i.loop, 0
  %hi.next = add i64 %hi.cur, 0
  br label %after_recurse

branch_left_ge:                                      ; recurse right (smaller), iterate left
  %i_lt_hi = icmp slt i64 %i.loop, %hi.cur
  br i1 %i_lt_hi, label %call_right, label %no_call_right

call_right:
  call void @quick_sort(i32* %arr, i64 %i.loop, i64 %hi.cur)
  br label %no_call_right

no_call_right:
  %lo.next2 = add i64 %lo.cur, 0
  %hi.next2 = add i64 %j.loop, 0
  br label %after_recurse

after_recurse:
  %lo.upd = phi i64 [ %lo.next, %no_call_left ], [ %lo.next2, %no_call_right ]
  %hi.upd = phi i64 [ %hi.next, %no_call_left ], [ %hi.next2, %no_call_right ]
  br label %while_head

return:
  ret void
}