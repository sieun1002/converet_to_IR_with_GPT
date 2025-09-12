; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort  ; Address: 0x1189
; Intent: In-place quicksort (Hoare partition) over i32 array segment [lo, hi] inclusive (confidence=0.95). Evidence: mid-pivot selection, bidirectional scan with signed compares and swaps, recursive calls on subranges with tail-iteration on the larger side.
; Preconditions: %a points to a valid array of at least max(lo,hi)+1 i32 elements; indices are within bounds.
; Postconditions: The subarray [lo, hi] is sorted in nondecreasing order (signed).

define dso_local void @quick_sort(i32* %a, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  br label %outer_check

outer_check:
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.next, %after_left ], [ %lo.next2, %after_right ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.next, %after_left ], [ %hi.next2, %after_right ]
  %cmp.lohi = icmp slt i64 %lo.cur, %hi.cur
  br i1 %cmp.lohi, label %partition_init, label %exit

partition_init:
  %i0 = %lo.cur
  %j0 = %hi.cur
  %diff = sub i64 %hi.cur, %lo.cur
  %sign = lshr i64 %diff, 63
  %adj = add i64 %diff, %sign
  %half = ashr i64 %adj, 1
  %pivotIndex = add i64 %lo.cur, %half
  %pivotPtr = getelementptr inbounds i32, i32* %a, i64 %pivotIndex
  %pivot = load i32, i32* %pivotPtr, align 4
  br label %loop_top

loop_top:
  %i.phi = phi i64 [ %i0, %partition_init ], [ %i2, %do_swap ]
  %j.phi = phi i64 [ %j0, %partition_init ], [ %j2, %do_swap ]
  br label %scan_left

scan_left:
  %iL = phi i64 [ %i.phi, %loop_top ], [ %i.inc, %inc_left ]
  %valLptr = getelementptr inbounds i32, i32* %a, i64 %iL
  %valL = load i32, i32* %valLptr, align 4
  %cmpL = icmp slt i32 %valL, %pivot
  br i1 %cmpL, label %inc_left, label %scan_right_prep

inc_left:
  %i.inc = add i64 %iL, 1
  br label %scan_left

scan_right_prep:
  br label %scan_right

scan_right:
  %iR = phi i64 [ %iL, %scan_right_prep ], [ %iR, %dec_right ]
  %jR = phi i64 [ %j.phi, %scan_right_prep ], [ %j.dec, %dec_right ]
  %valRptr = getelementptr inbounds i32, i32* %a, i64 %jR
  %valR = load i32, i32* %valRptr, align 4
  %cmpR = icmp sgt i32 %valR, %pivot
  br i1 %cmpR, label %dec_right, label %partition_check

dec_right:
  %j.dec = add i64 %jR, -1
  br label %scan_right

partition_check:
  %le = icmp sle i64 %iR, %jR
  br i1 %le, label %do_swap, label %after_partition

do_swap:
  %li.ptr = getelementptr inbounds i32, i32* %a, i64 %iR
  %ri.ptr = getelementptr inbounds i32, i32* %a, i64 %jR
  %li = load i32, i32* %li.ptr, align 4
  %ri = load i32, i32* %ri.ptr, align 4
  store i32 %ri, i32* %li.ptr, align 4
  store i32 %li, i32* %ri.ptr, align 4
  %i2 = add i64 %iR, 1
  %j2 = add i64 %jR, -1
  br label %loop_top

after_partition:
  %left_len = sub i64 %jR, %lo.cur
  %right_len = sub i64 %hi.cur, %iR
  %left_smaller = icmp slt i64 %left_len, %right_len
  br i1 %left_smaller, label %left_case, label %right_case

left_case:
  %need_left = icmp slt i64 %lo.cur, %jR
  br i1 %need_left, label %call_left, label %skip_left

call_left:
  call void @quick_sort(i32* %a, i64 %lo.cur, i64 %jR)
  br label %skip_left

skip_left:
  %lo.next = %iR
  %hi.next = %hi.cur
  br label %after_left

after_left:
  br label %outer_check

right_case:
  %need_right = icmp slt i64 %iR, %hi.cur
  br i1 %need_right, label %call_right, label %skip_right

call_right:
  call void @quick_sort(i32* %a, i64 %iR, i64 %hi.cur)
  br label %skip_right

skip_right:
  %lo.next2 = %lo.cur
  %hi.next2 = %jR
  br label %after_right

after_right:
  br label %outer_check

exit:
  ret void
}