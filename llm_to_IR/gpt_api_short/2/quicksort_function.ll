; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x1189
; Intent: In-place quicksort over 32-bit int array using indices [low, high] (confidence=0.95). Evidence: median-of-interval pivot, bidirectional partition, swapping, recursive calls on subranges with tail recursion on larger side.
; Preconditions: base is a valid i32*; indices low/high are valid and within the same array segment.
; Postconditions: Elements in [low, high] are sorted in non-decreasing order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @quick_sort(i32* nocapture noundef %base, i64 noundef %low, i64 noundef %high) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                           ; while (low < high)
  %cur_low = phi i64 [ %low, %entry ], [ %next_low, %outer.iter_end ]
  %cur_high = phi i64 [ %high, %entry ], [ %next_high, %outer.iter_end ]
  %cmp.outer = icmp slt i64 %cur_low, %cur_high
  br i1 %cmp.outer, label %partition.init, label %return

partition.init:
  %i0 = add i64 %cur_low, 0
  %j0 = add i64 %cur_high, 0
  %delta = sub i64 %cur_high, %cur_low
  %midOff = sdiv i64 %delta, 2
  %midIndex = add i64 %cur_low, %midOff
  %midPtr = getelementptr inbounds i32, i32* %base, i64 %midIndex
  %pivot = load i32, i32* %midPtr, align 4
  br label %left.loop

left.loop:
  %i = phi i64 [ %i0, %partition.init ], [ %i.inc, %inc_i ], [ %i2, %swap ]
  %j = phi i64 [ %j0, %partition.init ], [ %j.pass, %inc_i ], [ %j2, %swap ]
  %ptr_i = getelementptr inbounds i32, i32* %base, i64 %i
  %val_i = load i32, i32* %ptr_i, align 4
  %cmp.left = icmp sgt i32 %pivot, %val_i
  br i1 %cmp.left, label %inc_i, label %right.loop.entry

inc_i:
  %i.inc = add i64 %i, 1
  %j.pass = add i64 %j, 0
  br label %left.loop

right.loop.entry:
  br label %right.loop

right.loop:
  %i.r = phi i64 [ %i, %right.loop.entry ], [ %i.pass, %dec_j ]
  %j.r = phi i64 [ %j, %right.loop.entry ], [ %j.dec, %dec_j ]
  %ptr_j = getelementptr inbounds i32, i32* %base, i64 %j.r
  %val_j = load i32, i32* %ptr_j, align 4
  %cmp.right = icmp slt i32 %pivot, %val_j
  br i1 %cmp.right, label %dec_j, label %compare

dec_j:
  %j.dec = add i64 %j.r, -1
  %i.pass = add i64 %i.r, 0
  br label %right.loop

compare:
  %cmp.ij = icmp sle i64 %i.r, %j.r
  br i1 %cmp.ij, label %swap, label %partition.done

swap:
  %ptr_i2 = getelementptr inbounds i32, i32* %base, i64 %i.r
  %tmp_i = load i32, i32* %ptr_i2, align 4
  %ptr_j2 = getelementptr inbounds i32, i32* %base, i64 %j.r
  %val_j2 = load i32, i32* %ptr_j2, align 4
  store i32 %val_j2, i32* %ptr_i2, align 4
  store i32 %tmp_i, i32* %ptr_j2, align 4
  %i2 = add i64 %i.r, 1
  %j2 = add i64 %j.r, -1
  br label %left.loop

partition.done:
  %leftLen = sub i64 %j.r, %cur_low
  %rightLen = sub i64 %cur_high, %i.r
  %left.smaller = icmp slt i64 %leftLen, %rightLen
  br i1 %left.smaller, label %left.first, label %right.first

left.first:
  %need.left = icmp slt i64 %cur_low, %j.r
  br i1 %need.left, label %call.left, label %skip.left

call.left:
  call void @quick_sort(i32* %base, i64 %cur_low, i64 %j.r)
  br label %skip.left

skip.left:
  %next_low_L = add i64 %i.r, 0
  %next_high_L = add i64 %cur_high, 0
  br label %outer.iter_end

right.first:
  %need.right = icmp slt i64 %i.r, %cur_high
  br i1 %need.right, label %call.right, label %skip.right

call.right:
  call void @quick_sort(i32* %base, i64 %i.r, i64 %cur_high)
  br label %skip.right

skip.right:
  %next_low_R = add i64 %cur_low, 0
  %next_high_R = add i64 %j.r, 0
  br label %outer.iter_end

outer.iter_end:
  %next_low = phi i64 [ %next_low_L, %skip.left ], [ %next_low_R, %skip.right ]
  %next_high = phi i64 [ %next_high_L, %skip.left ], [ %next_high_R, %skip.right ]
  br label %outer.cond

return:
  ret void
}