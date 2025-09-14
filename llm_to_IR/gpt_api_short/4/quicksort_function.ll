; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x00001189
; Intent: in-place quicksort (ascending) on i32 array over inclusive [low, high] (confidence=0.92). Evidence: Hoare partition with i/j, pivot at mid, recurse smaller side first
; Preconditions: 0 <= low, high within array bounds; low/high are inclusive indices
; Postconditions: array segment [low..high] sorted ascending

define dso_local void @quick_sort(i32* %arr, i64 %low, i64 %high) local_unnamed_addr {
entry:
  br label %outer

outer:                                            ; loop over current [lo, hi]
  %lo = phi i64 [ %low, %entry ], [ %i_tail, %cont_right ], [ %lo, %cont_left ]
  %hi = phi i64 [ %high, %entry ], [ %hi, %cont_right ], [ %j_tail, %cont_left ]
  %cmp_outer = icmp slt i64 %lo, %hi
  br i1 %cmp_outer, label %partition_prep, label %exit

partition_prep:
  ; i = lo; j = hi; pivot = arr[ mid(lo,hi) ]
  %i.init = add i64 %lo, 0
  %j.init = add i64 %hi, 0
  %diff = sub i64 %hi, %lo
  %signbit = lshr i64 %diff, 63
  %adj = add i64 %diff, %signbit
  %half = ashr i64 %adj, 1
  %mid = add i64 %lo, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %scan_i

scan_i:                                           ; while (pivot > arr[i]) i++
  %i = phi i64 [ %i.init, %partition_prep ], [ %i.inc, %i_inc ], [ %i.swap, %after_swap ]
  %j = phi i64 [ %j.init, %partition_prep ], [ %j, %i_inc ], [ %j.swap, %after_swap ]
  %p.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %v.i = load i32, i32* %p.i, align 4
  %cmp_i = icmp sgt i32 %pivot, %v.i
  br i1 %cmp_i, label %i_inc, label %scan_j

i_inc:
  %i.inc = add i64 %i, 1
  br label %scan_i

scan_j:                                           ; while (pivot < arr[j]) j--
  %i2 = phi i64 [ %i, %scan_i ], [ %i2, %j_dec ]
  %j2 = phi i64 [ %j, %scan_i ], [ %j.dec, %j_dec ]
  %p.j = getelementptr inbounds i32, i32* %arr, i64 %j2
  %v.j = load i32, i32* %p.j, align 4
  %cmp_j = icmp slt i32 %pivot, %v.j
  br i1 %cmp_j, label %j_dec, label %check_swap

j_dec:
  %j.dec = add i64 %j2, -1
  br label %scan_j

check_swap:
  %le = icmp sle i64 %i2, %j2
  br i1 %le, label %do_swap, label %after_partition

do_swap:
  ; swap arr[i2] and arr[j2]
  %pi2 = getelementptr inbounds i32, i32* %arr, i64 %i2
  %pj2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  %vi2 = load i32, i32* %pi2, align 4
  %vj2 = load i32, i32* %pj2, align 4
  store i32 %vj2, i32* %pi2, align 4
  store i32 %vi2, i32* %pj2, align 4
  br label %after_swap

after_swap:
  %i.swap = add i64 %i2, 1
  %j.swap = add i64 %j2, -1
  br label %scan_i

after_partition:
  ; here: i = i2, j = j2, and i > j
  %i.part = add i64 %i2, 0
  %j.part = add i64 %j2, 0
  %left_len = sub i64 %j.part, %lo
  %right_len = sub i64 %hi, %i.part
  %left_smaller = icmp slt i64 %left_len, %right_len
  br i1 %left_smaller, label %left_first, label %right_first

left_first:
  ; sort left if non-empty: [lo..j.part]
  %need_left = icmp slt i64 %lo, %j.part
  br i1 %need_left, label %call_left, label %skip_left

call_left:
  call void @quick_sort(i32* %arr, i64 %lo, i64 %j.part)
  br label %skip_left

skip_left:
  ; tail on right: lo = i.part
  %i_tail = add i64 %i.part, 0
  br label %cont_right

right_first:
  ; sort right if non-empty: [i.part..hi]
  %need_right = icmp slt i64 %i.part, %hi
  br i1 %need_right, label %call_right, label %skip_right

call_right:
  call void @quick_sort(i32* %arr, i64 %i.part, i64 %hi)
  br label %skip_right

skip_right:
  ; tail on left: hi = j.part
  %j_tail = add i64 %j.part, 0
  br label %cont_left

cont_right:
  br label %outer

cont_left:
  br label %outer

exit:
  ret void
}