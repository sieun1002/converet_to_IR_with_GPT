; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort  ; Address: 0x1189
; Intent: In-place quicksort of i32 array segment [left..right] using midpoint pivot and tail-recursion optimization (confidence=0.95). Evidence: median-of-interval pivot, partition with i/j scans and swap; recurse on smaller side.
; Preconditions: %a points to an array of at least (right+1) i32 elements; indices %left and %right are signed 64-bit and intended with %left <= %right when sorting.
; Postconditions: On return, elements in [%left..%right] are sorted in non-decreasing order by signed 32-bit comparison.

define dso_local void @quick_sort(i32* %a, i64 %left, i64 %right) local_unnamed_addr {
entry:
  br label %outer

outer:
  %L = phi i64 [ %left, %entry ], [ %L_next, %outer.next ]
  %R = phi i64 [ %right, %entry ], [ %R_next, %outer.next ]
  %cmp_lr = icmp slt i64 %L, %R
  br i1 %cmp_lr, label %partition.init, label %ret

partition.init:
  %diff = sub i64 %R, %L
  %half = lshr i64 %diff, 1
  %mid = add i64 %L, %half
  %mid.ptr = getelementptr inbounds i32, i32* %a, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  br label %i.loop

i.loop:
  %i_cur = phi i64 [ %L, %partition.init ], [ %i_inc, %i.inc ], [ %i_from_check, %back_to_i ]
  %j_cur = phi i64 [ %R, %partition.init ], [ %j_hold, %i.inc ], [ %j_from_check, %back_to_i ]
  %i.ptr = getelementptr inbounds i32, i32* %a, i64 %i_cur
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp_i = icmp slt i32 %i.val, %pivot
  br i1 %cmp_i, label %i.inc, label %j.loop

i.inc:
  %i_inc = add i64 %i_cur, 1
  %j_hold = add i64 %j_cur, 0
  br label %i.loop

j.loop:
  %i_fixed = phi i64 [ %i_cur, %i.loop ], [ %i_fixed, %j.dec ]
  %j_cur2 = phi i64 [ %j_cur, %i.loop ], [ %j_dec, %j.dec ]
  %j.ptr = getelementptr inbounds i32, i32* %a, i64 %j_cur2
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp_j = icmp sgt i32 %j.val, %pivot
  br i1 %cmp_j, label %j.dec, label %after.scan

j.dec:
  %j_dec = add i64 %j_cur2, -1
  br label %j.loop

after.scan:
  %i_after = phi i64 [ %i_fixed, %j.loop ]
  %j_after = phi i64 [ %j_cur2, %j.loop ]
  %cmp_ij = icmp sle i64 %i_after, %j_after
  br i1 %cmp_ij, label %do.swap, label %partition.done.pre

do.swap:
  %i.ptr2 = getelementptr inbounds i32, i32* %a, i64 %i_after
  %j.ptr2 = getelementptr inbounds i32, i32* %a, i64 %j_after
  %vi = load i32, i32* %i.ptr2, align 4
  %vj = load i32, i32* %j.ptr2, align 4
  store i32 %vj, i32* %i.ptr2, align 4
  store i32 %vi, i32* %j.ptr2, align 4
  %i_next = add i64 %i_after, 1
  %j_next = add i64 %j_after, -1
  br label %checkagain

checkagain:
  %cmp_again = icmp sle i64 %i_next, %j_next
  br i1 %cmp_again, label %back_to_i, label %partition.done.pre

back_to_i:
  %i_from_check = phi i64 [ %i_next, %checkagain ]
  %j_from_check = phi i64 [ %j_next, %checkagain ]
  br label %i.loop

partition.done.pre:
  %i_end = phi i64 [ %i_after, %after.scan ], [ %i_next, %checkagain ]
  %j_end = phi i64 [ %j_after, %after.scan ], [ %j_next, %checkagain ]
  %left_len = sub i64 %j_end, %L
  %right_len = sub i64 %R, %i_end
  %cmp_len = icmp sge i64 %left_len, %right_len
  br i1 %cmp_len, label %rightPath, label %leftPath

leftPath:
  %condLeftCall = icmp slt i64 %L, %j_end
  br i1 %condLeftCall, label %leftCall, label %leftAfterCall

leftCall:
  call void @quick_sort(i32* %a, i64 %L, i64 %j_end)
  br label %leftAfterCall

leftAfterCall:
  %L_next_left = add i64 %i_end, 0
  %R_next_left = add i64 %R, 0
  br label %outer.next

rightPath:
  %condRightCall = icmp slt i64 %i_end, %R
  br i1 %condRightCall, label %rightCall, label %rightAfterCall

rightCall:
  call void @quick_sort(i32* %a, i64 %i_end, i64 %R)
  br label %rightAfterCall

rightAfterCall:
  %L_next_right = add i64 %L, 0
  %R_next_right = add i64 %j_end, 0
  br label %outer.next

outer.next:
  %L_next = phi i64 [ %L_next_left, %leftAfterCall ], [ %L_next_right, %rightAfterCall ]
  %R_next = phi i64 [ %R_next_left, %leftAfterCall ], [ %R_next_right, %rightAfterCall ]
  br label %outer

ret:
  ret void
}