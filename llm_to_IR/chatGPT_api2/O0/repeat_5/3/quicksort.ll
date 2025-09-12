; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort  ; Address: 0x1189
; Intent: In-place quicksort on i32 array within inclusive indices [lo, hi] (confidence=0.95). Evidence: element access via base+index*4, Hoare partition with i/j scans and recursive calls on subranges.
; Preconditions: base points to an array of at least hi+1 elements; 0 <= lo, hi use 64-bit indices; elements are 32-bit signed integers.
; Postconditions: array segment [lo, hi] is sorted in non-decreasing order.

; Only the needed extern declarations:
; (none)

define dso_local void @quick_sort(i32* %base, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                      ; loop over current [cur_lo, cur_hi]
  %cur_lo = phi i64 [ %lo, %entry ], [ %next_lo, %outer.latch ]
  %cur_hi = phi i64 [ %hi, %entry ], [ %next_hi, %outer.latch ]
  %cmp.lohi = icmp slt i64 %cur_lo, %cur_hi
  br i1 %cmp.lohi, label %partition.init, label %exit

partition.init:
  ; mid = cur_lo + ((cur_hi - cur_lo + sign) >> 1) to match assembly behavior
  %delta = sub i64 %cur_hi, %cur_lo
  %sign = lshr i64 %delta, 63
  %adj = add i64 %delta, %sign
  %half = ashr i64 %adj, 1
  %mid = add i64 %cur_lo, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %inner.iter

inner.iter:
  %i.cur = phi i64 [ %cur_lo, %partition.init ], [ %i.next2, %after.swap ]
  %j.cur = phi i64 [ %cur_hi, %partition.init ], [ %j.next2, %after.swap ]
  br label %advance.i

advance.i:
  %i1 = phi i64 [ %i.cur, %inner.iter ], [ %i.inc, %advance.i ]
  %ai.ptr = getelementptr inbounds i32, i32* %base, i64 %i1
  %ai = load i32, i32* %ai.ptr, align 4
  %cmp.i = icmp slt i32 %ai, %pivot
  %i.inc = add i64 %i1, 1
  br i1 %cmp.i, label %advance.i, label %advance.j.entry

advance.j.entry:
  ; carry fixed i value into j-advance loop
  br label %advance.j

advance.j:
  %j1 = phi i64 [ %j.cur, %advance.j.entry ], [ %j.dec, %advance.j ]
  %aj.ptr = getelementptr inbounds i32, i32* %base, i64 %j1
  %aj = load i32, i32* %aj.ptr, align 4
  %cmp.j = icmp sgt i32 %aj, %pivot
  %j.dec = add i64 %j1, -1
  br i1 %cmp.j, label %advance.j, label %compare.ij

compare.ij:
  ; compare i1 (from advance.i) and j1
  ; i1 is dominated by advance.j.entry and thus available here
  %ilej = icmp sle i64 %i1, %j1
  br i1 %ilej, label %do.swap, label %post.partition

do.swap:
  ; swap a[i1], a[j1]
  %ptr.i = getelementptr inbounds i32, i32* %base, i64 %i1
  %ptr.j = getelementptr inbounds i32, i32* %base, i64 %j1
  %val.i = load i32, i32* %ptr.i, align 4
  %val.j = load i32, i32* %ptr.j, align 4
  store i32 %val.j, i32* %ptr.i, align 4
  store i32 %val.i, i32* %ptr.j, align 4
  %i.next2 = add i64 %i1, 1
  %j.next2 = add i64 %j1, -1
  br label %after.swap

after.swap:
  br label %inner.iter

post.partition:
  ; choose smaller partition to recurse on
  %left.size = sub i64 %j1, %cur_lo
  %right.size = sub i64 %cur_hi, %i1
  %left.smaller = icmp slt i64 %left.size, %right.size
  br i1 %left.smaller, label %recurse.left, label %recurse.right

recurse.left:
  ; recurse on [cur_lo, j1] if cur_lo < j1; then continue with [i1, cur_hi]
  %need.left = icmp slt i64 %cur_lo, %j1
  br i1 %need.left, label %call.left, label %after.left

call.left:
  call void @quick_sort(i32* %base, i64 %cur_lo, i64 %j1)
  br label %after.left

after.left:
  %next_lo.left = %i1
  %next_hi.left = %cur_hi
  br label %outer.latch

recurse.right:
  ; recurse on [i1, cur_hi] if i1 < cur_hi; then continue with [cur_lo, j1]
  %need.right = icmp slt i64 %i1, %cur_hi
  br i1 %need.right, label %call.right, label %after.right

call.right:
  call void @quick_sort(i32* %base, i64 %i1, i64 %cur_hi)
  br label %after.right

after.right:
  %next_lo.right = %cur_lo
  %next_hi.right = %j1
  br label %outer.latch

outer.latch:
  %next_lo = phi i64 [ %next_lo.left, %after.left ], [ %next_lo.right, %after.right ]
  %next_hi = phi i64 [ %next_hi.left, %after.left ], [ %next_hi.right, %after.right ]
  br label %outer.cond

exit:
  ret void
}