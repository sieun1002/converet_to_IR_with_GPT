; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x1189
; Intent: in-place quicksort over arr[low..high] ascending by signed i32 compare (confidence=0.96). Evidence: median pivot of (low+high)/2, signed cmp/jg/jl, recursive subrange calls with smaller-first strategy.
; Preconditions: arr valid for indices [low..high] (inclusive) if low <= high.
; Postconditions: arr[orig_low..orig_high] sorted ascending (signed 32-bit).

; Only the necessary external declarations:
; (none)

define dso_local void @quick_sort(i32* nocapture %arr, i64 %low, i64 %high) local_unnamed_addr {
entry:
  br label %loop.check

loop.check:                                           ; while (low < high)
  %lo = phi i64 [ %low, %entry ], [ %lo.next, %loop.cont ]
  %hi = phi i64 [ %high, %entry ], [ %hi.next, %loop.cont ]
  %cmp.loop = icmp slt i64 %lo, %hi
  br i1 %cmp.loop, label %partition.init, label %ret

partition.init:
  %i0 = %lo
  %j0 = %hi
  %diff = sub i64 %hi, %lo
  %half = sdiv i64 %diff, 2
  %mid = add i64 %lo, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %inc_i

inc_i:
  %i.cur = phi i64 [ %i0, %partition.init ], [ %i.next, %inc_i.inc ], [ %i.after, %do_swap ]
  %val.i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %val.i = load i32, i32* %val.i.ptr, align 4
  %cmp.i = icmp slt i32 %val.i, %pivot
  br i1 %cmp.i, label %inc_i.inc, label %dec_j

inc_i.inc:
  %i.next = add nsw i64 %i.cur, 1
  br label %inc_i

dec_j:
  %j.cur = phi i64 [ %j0, %inc_i ], [ %j.next, %dec_j.dec ]
  %val.j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %val.j = load i32, i32* %val.j.ptr, align 4
  %cmp.j = icmp sgt i32 %val.j, %pivot
  br i1 %cmp.j, label %dec_j.dec, label %check_swap

dec_j.dec:
  %j.next = add nsw i64 %j.cur, -1
  br label %dec_j

check_swap:
  %le.ij = icmp sle i64 %i.cur, %j.cur
  br i1 %le.ij, label %do_swap, label %partition.break

do_swap:
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %a.i = load i32, i32* %ptr.i, align 4
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %a.j = load i32, i32* %ptr.j, align 4
  store i32 %a.j, i32* %ptr.i, align 4
  store i32 %a.i, i32* %ptr.j, align 4
  %i.after = add nsw i64 %i.cur, 1
  %j.after = add nsw i64 %j.cur, -1
  br label %inc_i

partition.break:
  %left.size = sub i64 %j.cur, %lo
  %right.size = sub i64 %hi, %i.cur
  %left.ge.right = icmp sge i64 %left.size, %right.size
  br i1 %left.ge.right, label %rightFirst, label %leftFirst

leftFirst:
  %needL = icmp slt i64 %lo, %j.cur
  br i1 %needL, label %callLeft, label %skipLeft

callLeft:
  call void @quick_sort(i32* %arr, i64 %lo, i64 %j.cur)
  br label %skipLeft

skipLeft:
  %lo.next.lf = %i.cur
  %hi.next.lf = %hi
  br label %loop.cont

rightFirst:
  %needR = icmp slt i64 %i.cur, %hi
  br i1 %needR, label %callRight, label %skipRight

callRight:
  call void @quick_sort(i32* %arr, i64 %i.cur, i64 %hi)
  br label %skipRight

skipRight:
  %lo.next.rf = %lo
  %hi.next.rf = %j.cur
  br label %loop.cont

loop.cont:
  %lo.next = phi i64 [ %lo.next.lf, %skipLeft ], [ %lo.next.rf, %skipRight ]
  %hi.next = phi i64 [ %hi.next.lf, %skipLeft ], [ %hi.next.rf, %skipRight ]
  br label %loop.check

ret:
  ret void
}