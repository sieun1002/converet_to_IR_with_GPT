; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort  ; Address: 0x1189
; Intent: In-place quicksort of a 32-bit integer array segment [left, right] using Hoare partition and tail recursion elimination (confidence=0.98). Evidence: mid-pivot selection, signed comparisons, swap, recursive calls on subranges with tail-update of bounds.
; Preconditions: %base points to an array of at least (right+1) i32 elements; 0 <= left <= right are inclusive indices within the array segment.
; Postconditions: The subarray base[left..right] is sorted in non-decreasing order (signed 32-bit).

define dso_local void @quick_sort(i32* %base, i64 %left, i64 %right) local_unnamed_addr {
entry:
  br label %outer

outer:
  %lcur = phi i64 [ %left, %entry ], [ %i_fin, %tail_left ], [ %lcur, %tail_right ]
  %rcur = phi i64 [ %right, %entry ], [ %rcur, %tail_left ], [ %j_fin, %tail_right ]
  %cmp_lr = icmp slt i64 %lcur, %rcur
  br i1 %cmp_lr, label %part.init, label %ret

ret:
  ret void

part.init:
  %diff = sub i64 %rcur, %lcur
  %half = sdiv i64 %diff, 2
  %mid = add i64 %lcur, %half
  %ptr_mid = getelementptr inbounds i32, i32* %base, i64 %mid
  %pivot = load i32, i32* %ptr_mid, align 4
  br label %scan.entry

scan.entry:
  %i.start = phi i64 [ %lcur, %part.init ], [ %i_after_swap, %after.swap ]
  %j.start = phi i64 [ %rcur, %part.init ], [ %j_after_swap, %after.swap ]
  br label %scan.i

scan.i:
  %i.cur = phi i64 [ %i.start, %scan.entry ], [ %i.next, %scan.i ]
  %ptr_i = getelementptr inbounds i32, i32* %base, i64 %i.cur
  %val_i = load i32, i32* %ptr_i, align 4
  %cmp_i = icmp slt i32 %val_i, %pivot
  br i1 %cmp_i, label %i.inc, label %scan.j.entry

i.inc:
  %i.next = add nsw i64 %i.cur, 1
  br label %scan.i

scan.j.entry:
  br label %scan.j

scan.j:
  %i.stop = phi i64 [ %i.cur, %scan.j.entry ], [ %i.stop, %j.dec ]
  %j.cur = phi i64 [ %j.start, %scan.j.entry ], [ %j.next, %j.dec ]
  %ptr_j = getelementptr inbounds i32, i32* %base, i64 %j.cur
  %val_j = load i32, i32* %ptr_j, align 4
  %cmp_j = icmp sgt i32 %val_j, %pivot
  br i1 %cmp_j, label %j.dec, label %decide

j.dec:
  %j.next = add nsw i64 %j.cur, -1
  br label %scan.j

decide:
  %cond_le = icmp sle i64 %i.stop, %j.cur
  br i1 %cond_le, label %do.swap, label %after.partition

do.swap:
  %ptr_i2 = getelementptr inbounds i32, i32* %base, i64 %i.stop
  %val_i2 = load i32, i32* %ptr_i2, align 4
  store i32 %val_j, i32* %ptr_i2, align 4
  store i32 %val_i2, i32* %ptr_j, align 4
  %i_after_swap = add nsw i64 %i.stop, 1
  %j_after_swap = add nsw i64 %j.cur, -1
  br label %after.swap

after.swap:
  br label %scan.entry

after.partition:
  %i_fin = %i.stop
  %j_fin = %j.cur
  %leftLen = sub i64 %j_fin, %lcur
  %rightLen = sub i64 %rcur, %i_fin
  %cmpLen = icmp sge i64 %leftLen, %rightLen
  br i1 %cmpLen, label %case_right_smaller_or_equal, label %case_left_smaller

case_left_smaller:
  %cond_left_nonempty = icmp slt i64 %lcur, %j_fin
  br i1 %cond_left_nonempty, label %recurse_left, label %skip_left

recurse_left:
  call void @quick_sort(i32* %base, i64 %lcur, i64 %j_fin)
  br label %skip_left

skip_left:
  br label %tail_left

tail_left:
  br label %outer

case_right_smaller_or_equal:
  %cond_right_nonempty = icmp slt i64 %i_fin, %rcur
  br i1 %cond_right_nonempty, label %recurse_right, label %skip_right

recurse_right:
  call void @quick_sort(i32* %base, i64 %i_fin, i64 %rcur)
  br label %skip_right

skip_right:
  br label %tail_right

tail_right:
  br label %outer
}