; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x1189
; Intent: In-place quicksort with tail recursion optimization (confidence=0.90). Evidence: median-of-range pivot, bidirectional partition, recurse on smaller side.
; Preconditions: arr is valid; indices low..high refer to a valid subrange (0-based, inclusive).
; Postconditions: arr[low..high] sorted in non-decreasing order.

define dso_local void @quick_sort(i32* nocapture %arr, i64 %low, i64 %high) local_unnamed_addr {
entry:
  br label %loop.hdr

loop.hdr:                                         ; top-level while (low < high)
  %lo = phi i64 [ %low, %entry ], [ %lo.next.R, %right.done ], [ %lo.next.L, %left.done ]
  %hi = phi i64 [ %high, %entry ], [ %hi.next.R, %right.done ], [ %hi.next.L, %left.done ]
  %cmp = icmp slt i64 %lo, %hi
  br i1 %cmp, label %part.pre, label %ret

part.pre:                                         ; initialize partition
  %i0 = %lo
  %j0 = %hi
  %diff = sub i64 %hi, %lo
  %half = ashr i64 %diff, 1
  %mid = add i64 %lo, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %adv.i

adv.i:                                            ; while (arr[i] < pivot) i++
  %i.cur = phi i64 [ %i0, %part.pre ], [ %i.inc, %adv.i ], [ %i.after, %after.swap ]
  %j.cur.from.pre = phi i64 [ %j0, %part.pre ], [ %j.stay, %adv.i ], [ %j.after, %after.swap ]
  %ai.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %ai = load i32, i32* %ai.ptr, align 4
  %lt = icmp slt i32 %ai, %pivot
  %i.inc = add i64 %i.cur, 1
  %j.stay = %j.cur.from.pre
  br i1 %lt, label %adv.i, label %adv.j

adv.j:                                            ; while (arr[j] > pivot) j--
  %i.keep = phi i64 [ %i.cur, %adv.i ], [ %i.keep.next, %adv.j ]
  %j.cur = phi i64 [ %j.cur.from.pre, %adv.i ], [ %j.dec, %adv.j ]
  %aj.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %aj = load i32, i32* %aj.ptr, align 4
  %gt = icmp sgt i32 %aj, %pivot
  %j.dec = add i64 %j.cur, -1
  %i.keep.next = %i.keep
  br i1 %gt, label %adv.j, label %cmp.swap

cmp.swap:                                         ; if (i <= j) swap, i++, j--
  %i.fin = phi i64 [ %i.keep, %adv.j ]
  %j.fin = phi i64 [ %j.cur, %adv.j ]
  %le = icmp sle i64 %i.fin, %j.fin
  br i1 %le, label %do.swap, label %part.exit

do.swap:
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i.fin
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j.fin
  %vi = load i32, i32* %pi, align 4
  %vj = load i32, i32* %pj, align 4
  store i32 %vj, i32* %pi, align 4
  store i32 %vi, i32* %pj, align 4
  %i.after = add i64 %i.fin, 1
  %j.after = add i64 %j.fin, -1
  br label %after.swap

after.swap:
  br label %adv.i

part.exit:                                        ; choose smaller side to recurse
  %left.size = sub i64 %j.fin, %lo
  %right.size = sub i64 %hi, %i.fin
  %left.ge.right = icmp sge i64 %left.size, %right.size
  br i1 %left.ge.right, label %right.case, label %left.case

right.case:                                       ; recurse on right, loop on left
  %need.right = icmp slt i64 %i.fin, %hi
  br i1 %need.right, label %right.call, label %right.skip

right.call:
  call void @quick_sort(i32* %arr, i64 %i.fin, i64 %hi)
  br label %right.skip

right.skip:
  %lo.next.R = %lo
  %hi.next.R = %j.fin
  br label %right.done

right.done:
  br label %loop.hdr

left.case:                                        ; recurse on left, loop on right
  %need.left = icmp slt i64 %lo, %j.fin
  br i1 %need.left, label %left.call, label %left.skip

left.call:
  call void @quick_sort(i32* %arr, i64 %lo, i64 %j.fin)
  br label %left.skip

left.skip:
  %lo.next.L = %i.fin
  %hi.next.L = %hi
  br label %left.done

left.done:
  br label %loop.hdr

ret:
  ret void
}