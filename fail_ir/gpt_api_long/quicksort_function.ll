; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort  ; Address: 0x1189
; Intent: In-place quicksort (Hoare partition) on int32 array within inclusive [low, high], tail-recursing on smaller partition (confidence=0.95). Evidence: partition with pivot mid element; two-pointer scan with swaps; recursive calls on subranges with tail-loop optimization.
; Preconditions: base points to an array of i32; indices low and high are valid inclusive bounds (low/high can be equal or low > high for empty range).
; Postconditions: base[low..high] sorted in non-decreasing order.

define dso_local void @quick_sort(i32* %base, i64 %low, i64 %high) local_unnamed_addr {
entry:
  br label %outer

outer:                                            ; loop over current [low.cur, high.cur]
  %low.cur = phi i64 [ %low, %entry ], [ %low.next, %back ]
  %high.cur = phi i64 [ %high, %entry ], [ %high.next, %back ]
  %cond = icmp slt i64 %low.cur, %high.cur
  br i1 %cond, label %part_init, label %exit

part_init:
  ; pivot index: low + ashr((high-low) + lshr(high-low,63), 1)
  %diff = sub i64 %high.cur, %low.cur
  %negbit = lshr i64 %diff, 63
  %sum = add i64 %diff, %negbit
  %half = ashr i64 %sum, 1
  %mid = add i64 %low.cur, %half
  %midptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %pivot = load i32, i32* %midptr, align 4
  br label %scanL

scanL:
  %R.sl = phi i64 [ %high.cur, %part_init ], [ %R2, %do_swap ]
  %L.cur = phi i64 [ %low.cur, %part_init ], [ %L2, %do_swap ]
  %Lptr = getelementptr inbounds i32, i32* %base, i64 %L.cur
  %Lval = load i32, i32* %Lptr, align 4
  %keep_incing_L = icmp sgt i32 %pivot, %Lval
  br i1 %keep_incing_L, label %scanL.inc, label %to_scanR

scanL.inc:
  %L.inc = add nsw i64 %L.cur, 1
  br label %scanL

to_scanR:
  br label %scanR

scanR:
  %R.cur = phi i64 [ %R.sl, %to_scanR ], [ %R.dec, %scanR ]
  %L.pass = phi i64 [ %L.cur, %to_scanR ], [ %L.pass, %scanR ]
  %Rptr = getelementptr inbounds i32, i32* %base, i64 %R.cur
  %Rval = load i32, i32* %Rptr, align 4
  %keep_decing_R = icmp slt i32 %pivot, %Rval
  br i1 %keep_decing_R, label %scanR.dec, label %compare

scanR.dec:
  %R.dec = add nsw i64 %R.cur, -1
  br label %scanR

compare:
  %le = icmp sle i64 %L.pass, %R.cur
  br i1 %le, label %do_swap, label %part_done

do_swap:
  %Lptr2 = getelementptr inbounds i32, i32* %base, i64 %L.pass
  %Rptr2 = getelementptr inbounds i32, i32* %base, i64 %R.cur
  %valL = load i32, i32* %Lptr2, align 4
  %valR = load i32, i32* %Rptr2, align 4
  store i32 %valR, i32* %Lptr2, align 4
  store i32 %valL, i32* %Rptr2, align 4
  %L2 = add nsw i64 %L.pass, 1
  %R2 = add nsw i64 %R.cur, -1
  br label %scanL

part_done:
  %left_size = sub i64 %R.cur, %low.cur
  %right_size = sub i64 %high.cur, %L.pass
  %left_smaller = icmp slt i64 %left_size, %right_size
  br i1 %left_smaller, label %maybe_left, label %maybe_right

maybe_left:
  %need_left = icmp slt i64 %low.cur, %R.cur
  br i1 %need_left, label %call_left, label %skip_left

call_left:
  call void @quick_sort(i32* %base, i64 %low.cur, i64 %R.cur)
  br label %skip_left

skip_left:
  br label %back

maybe_right:
  %need_right = icmp slt i64 %L.pass, %high.cur
  br i1 %need_right, label %call_right, label %skip_right

call_right:
  call void @quick_sort(i32* %base, i64 %L.pass, i64 %high.cur)
  br label %skip_right

skip_right:
  br label %back

back:
  %low.next = phi i64 [ %L.pass, %skip_left ], [ %low.cur, %skip_right ]
  %high.next = phi i64 [ %high.cur, %skip_left ], [ %R.cur, %skip_right ]
  br label %outer

exit:
  ret void
}