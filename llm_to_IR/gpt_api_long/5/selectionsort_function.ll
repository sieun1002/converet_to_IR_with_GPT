; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort  ; Address: 0x1169
; Intent: In-place selection sort ascending on an int array (confidence=0.95). Evidence: nested min-search loop and swap of a[i] with a[min]
; Preconditions: a points to at least n contiguous i32 elements; n >= 0
; Postconditions: a[0..n-1] sorted in non-decreasing order

; Only the needed extern declarations:

define dso_local void @selection_sort(i32* %a, i32 %n) local_unnamed_addr {
entry:
  %n_minus1 = add nsw i32 %n, -1
  br label %loop_i

loop_i:
  %i = phi i32 [ 0, entry ], [ %i.next, %after_swap ]
  %cmp_i = icmp slt i32 %i, %n_minus1
  br i1 %cmp_i, label %init_j, label %exit

init_j:
  %min0 = %i
  %j0 = add nsw i32 %i, 1
  br label %loop_j

loop_j:
  %j = phi i32 [ %j0, init_j ], [ %j.next, %after_compare ]
  %min.cur = phi i32 [ %min0, init_j ], [ %min.next, %after_compare ]
  %cmp_j = icmp slt i32 %j, %n
  br i1 %cmp_j, label %compare, label %after_j

compare:
  %j64 = sext i32 %j to i64
  %ptr_j = getelementptr inbounds i32, i32* %a, i64 %j64
  %val_j = load i32, i32* %ptr_j, align 4
  %min64 = sext i32 %min.cur to i64
  %ptr_min = getelementptr inbounds i32, i32* %a, i64 %min64
  %val_min = load i32, i32* %ptr_min, align 4
  %lt = icmp slt i32 %val_j, %val_min
  br i1 %lt, label %update_min, label %no_update

update_min:
  br label %after_compare

no_update:
  br label %after_compare

after_compare:
  %min.next = phi i32 [ %j, %update_min ], [ %min.cur, %no_update ]
  %j.next = add nsw i32 %j, 1
  br label %loop_j

after_j:
  %min.final = phi i32 [ %min.cur, %loop_j ]
  %i64 = sext i32 %i to i64
  %ptr_i = getelementptr inbounds i32, i32* %a, i64 %i64
  %tmp = load i32, i32* %ptr_i, align 4
  %minf64 = sext i32 %min.final to i64
  %ptr_min2 = getelementptr inbounds i32, i32* %a, i64 %minf64
  %val_at_min = load i32, i32* %ptr_min2, align 4
  store i32 %val_at_min, i32* %ptr_i, align 4
  store i32 %tmp, i32* %ptr_min2, align 4
  br label %after_swap

after_swap:
  %i.next = add nsw i32 %i, 1
  br label %loop_i

exit:
  ret void
}