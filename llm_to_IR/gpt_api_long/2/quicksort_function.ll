; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort  ; Address: 0x1189
; Intent: In-place quicksort of a 32-bit integer array on index range [low, high] (inclusive) (confidence=0.95). Evidence: median pivot load via mid index, bidirectional partition loop with swaps, recursion on smaller partition with tail-loop on larger.

define dso_local void @quick_sort(i32* %base, i64 %low, i64 %high) local_unnamed_addr {
entry:
  br label %outer.loop

outer.loop:
  %cur_low = phi i64 [ %low, %entry ], [ %new_low, %after.recurse ]
  %cur_high = phi i64 [ %high, %entry ], [ %new_high, %after.recurse ]
  %cmp.outer = icmp slt i64 %cur_low, %cur_high
  br i1 %cmp.outer, label %part.init, label %ret

part.init:
  ; i = cur_low; j = cur_high; pivot = base[cur_low + ((cur_high - cur_low + ((cur_high - cur_low) >> 63)) >> 1)]
  %diff = sub nsw i64 %cur_high, %cur_low
  %sign = lshr i64 %diff, 63
  %t = add i64 %diff, %sign
  %mid_off = ashr i64 %t, 1
  %mid = add nsw i64 %cur_low, %mid_off
  %pivot.ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %scan.left

scan.left:
  %i.phi = phi i64 [ %cur_low, %part.init ], [ %i.inc, %left.inc ], [ %i.after.swap, %do.swap ]
  %j.phi = phi i64 [ %cur_high, %part.init ], [ %j.phi, %left.inc ], [ %j.after.swap, %do.swap ]
  %iptr = getelementptr inbounds i32, i32* %base, i64 %i.phi
  %ival = load i32, i32* %iptr, align 4
  %cmp.left = icmp sgt i32 %pivot, %ival
  br i1 %cmp.left, label %left.inc, label %scan.right

left.inc:
  %i.inc = add nsw i64 %i.phi, 1
  br label %scan.left

scan.right:
  %i.keep = phi i64 [ %i.phi, %scan.left ], [ %i.keep, %right.dec ]
  %j.phi2 = phi i64 [ %j.phi, %scan.left ], [ %j.dec, %right.dec ]
  %jptr = getelementptr inbounds i32, i32* %base, i64 %j.phi2
  %jval = load i32, i32* %jptr, align 4
  %cmp.right = icmp slt i32 %pivot, %jval
  br i1 %cmp.right, label %right.dec, label %compare

right.dec:
  %j.dec = add nsw i64 %j.phi2, -1
  br label %scan.right

compare:
  %i.now = phi i64 [ %i.keep, %scan.right ]
  %j.now = phi i64 [ %j.phi2, %scan.right ]
  %cmp.ij = icmp sle i64 %i.now, %j.now
  br i1 %cmp.ij, label %do.swap, label %split

do.swap:
  %iptr.s = getelementptr inbounds i32, i32* %base, i64 %i.now
  %ival.s = load i32, i32* %iptr.s, align 4
  %jptr.s = getelementptr inbounds i32, i32* %base, i64 %j.now
  %jval.s = load i32, i32* %jptr.s, align 4
  store i32 %jval.s, i32* %iptr.s, align 4
  store i32 %ival.s, i32* %jptr.s, align 4
  %i.after.swap = add nsw i64 %i.now, 1
  %j.after.swap = add nsw i64 %j.now, -1
  br label %scan.left

split:
  %left.size = sub nsw i64 %j.now, %cur_low
  %right.size = sub nsw i64 %cur_high, %i.now
  %left.lt.right = icmp slt i64 %left.size, %right.size
  br i1 %left.lt.right, label %left.small, label %right.small.or.eq

left.small:
  %need.call.left = icmp slt i64 %cur_low, %j.now
  br i1 %need.call.left, label %call.left, label %skip.left

call.left:
  call void @quick_sort(i32* %base, i64 %cur_low, i64 %j.now)
  br label %skip.left

skip.left:
  %new_low_left = %i.now
  %new_high_left = %cur_high
  br label %after.recurse

right.small.or.eq:
  %need.call.right = icmp slt i64 %i.now, %cur_high
  br i1 %need.call.right, label %call.right, label %skip.right

call.right:
  call void @quick_sort(i32* %base, i64 %i.now, i64 %cur_high)
  br label %skip.right

skip.right:
  %new_low_right = %cur_low
  %new_high_right = %j.now
  br label %after.recurse

after.recurse:
  %new_low = phi i64 [ %new_low_left, %skip.left ], [ %new_low_right, %skip.right ]
  %new_high = phi i64 [ %new_high_left, %skip.left ], [ %new_high_right, %skip.right ]
  br label %outer.loop

ret:
  ret void
}