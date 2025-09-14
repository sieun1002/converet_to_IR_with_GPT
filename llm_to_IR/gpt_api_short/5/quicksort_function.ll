; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x1189
; Intent: In-place quicksort on i32 array segment [l..r] using signed comparisons; tail-recursion elimination on larger partition (confidence=0.99). Evidence: middle pivot, bidirectional partition loops with signed jg/jl, recurse on smaller side and iterate on larger.
; Preconditions: arr != NULL; indices l and r are valid inclusive bounds (signed, l and r within array).
; Postconditions: Elements arr[l..r] sorted in nondecreasing order under signed 32-bit comparison.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local void @quick_sort(i32* nocapture %arr, i64 %l, i64 %r) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                          ; loop over the larger side (tail recursion eliminated)
  %l.cur = phi i64 [ %l, %entry ], [ %l.next, %loop.next ]
  %r.cur = phi i64 [ %r, %entry ], [ %r.next, %loop.next ]
  %cmp.lr = icmp slt i64 %l.cur, %r.cur
  br i1 %cmp.lr, label %partition.init, label %ret

partition.init:
  %i0 = %l.cur
  %j0 = %r.cur
  %delta = sub i64 %r.cur, %l.cur
  %half = udiv i64 %delta, 2
  %mid = add i64 %l.cur, %half
  %pivotptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivotptr, align 4
  br label %loop.top

loop.top:
  %i = phi i64 [ %i0, %partition.init ], [ %i.next2, %do.swap ]
  %j = phi i64 [ %j0, %partition.init ], [ %j.next2, %do.swap ]
  br label %inc.loop

inc.loop:                                            ; while (arr[i] < pivot) i++
  %i.cur = phi i64 [ %i, %loop.top ], [ %i.cur.next, %inc.loop.inc ]
  %ai.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %ai = load i32, i32* %ai.ptr, align 4
  %cmp.inc = icmp slt i32 %ai, %pivot
  br i1 %cmp.inc, label %inc.loop.inc, label %dec.loop

inc.loop.inc:
  %i.cur.next = add i64 %i.cur, 1
  br label %inc.loop

dec.loop:                                            ; while (arr[j] > pivot) j--
  %i.fixed = phi i64 [ %i.cur, %inc.loop ]
  %j.cur = phi i64 [ %j, %inc.loop ], [ %j.cur.next, %dec.loop.dec ]
  %aj.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %aj = load i32, i32* %aj.ptr, align 4
  %cmp.dec = icmp sgt i32 %aj, %pivot
  br i1 %cmp.dec, label %dec.loop.dec, label %cont

dec.loop.dec:
  %j.cur.next = add i64 %j.cur, -1
  br label %dec.loop

cont:
  %cmp.le = icmp sle i64 %i.fixed, %j.cur
  br i1 %cmp.le, label %do.swap, label %after.partition

do.swap:                                             ; swap arr[i] and arr[j]; i++; j--
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i.fixed
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %val.i = load i32, i32* %ptr.i, align 4
  %val.j = load i32, i32* %ptr.j, align 4
  store i32 %val.j, i32* %ptr.i, align 4
  store i32 %val.i, i32* %ptr.j, align 4
  %i.next2 = add i64 %i.fixed, 1
  %j.next2 = add i64 %j.cur, -1
  br label %loop.top

after.partition:
  %leftSize = sub i64 %j.cur, %l.cur
  %rightSize = sub i64 %r.cur, %i.fixed
  %leftSmaller = icmp slt i64 %leftSize, %rightSize
  br i1 %leftSmaller, label %leftCase, label %rightCase

leftCase:                                            ; recurse on [l..j], continue with [i..r]
  %needLeft = icmp slt i64 %l.cur, %j.cur
  br i1 %needLeft, label %callLeft, label %noCallLeft

callLeft:
  call void @quick_sort(i32* %arr, i64 %l.cur, i64 %j.cur)
  br label %noCallLeft

noCallLeft:
  br label %loop.next

rightCase:                                           ; recurse on [i..r], continue with [l..j]
  %needRight = icmp slt i64 %i.fixed, %r.cur
  br i1 %needRight, label %callRight, label %noCallRight

callRight:
  call void @quick_sort(i32* %arr, i64 %i.fixed, i64 %r.cur)
  br label %noCallRight

noCallRight:
  br label %loop.next

loop.next:
  %l.next = phi i64 [ %i.fixed, %noCallLeft ], [ %l.cur, %noCallRight ]
  %r.next = phi i64 [ %r.cur, %noCallLeft ], [ %j.cur, %noCallRight ]
  br label %outer.cond

ret:
  ret void
}