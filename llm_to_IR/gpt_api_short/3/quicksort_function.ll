; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x1189
; Intent: In-place quicksort on int32 array segment [lo, hi] (confidence=0.96). Evidence: median pivot selection, two-pointer partition, recursive calls on subranges with tail-loop.
; Preconditions: base points to at least [min(lo,hi) .. max(lo,hi)] of i32 elements.
; Postconditions: Array segment [lo, hi] sorted ascending (signed compare).

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local void @quick_sort(i32* nocapture %base, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  br label %while.head

while.head:                                           ; loop: while (lo < hi)
  %lo.cur = phi i64 [ %lo, %entry ], [ %i.final.tl, %tail.left ], [ %lo.pass.tr, %tail.right ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.pass.tl, %tail.left ], [ %j.final.tr, %tail.right ]
  %cmp.lohi = icmp slt i64 %lo.cur, %hi.cur
  br i1 %cmp.lohi, label %partition.entry, label %ret

partition.entry:
  ; i = lo.cur; j = hi.cur
  ; pivot = base[(lo + ((hi-lo) + sign) >> 1)]
  %diff = sub i64 %hi.cur, %lo.cur
  %sign = lshr i64 %diff, 63
  %add = add i64 %diff, %sign
  %half = ashr i64 %add, 1
  %mid = add i64 %lo.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  %i0 = %lo.cur
  %j0 = %hi.cur
  br label %partition.loop

partition.loop:
  ; scan i forward while a[i] < pivot
  %i.in = phi i64 [ %i0, %partition.entry ], [ %i.inc1, %swap ]
  %j.in = phi i64 [ %j0, %partition.entry ], [ %j.dec1, %swap ]
  br label %scan.i.loop

scan.i.loop:
  %i.scan = phi i64 [ %i.in, %partition.loop ], [ %i.plus, %scan.i.inc ]
  %i.ptr = getelementptr inbounds i32, i32* %base, i64 %i.scan
  %val.i = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %val.i, %pivot
  br i1 %cmp.i, label %scan.i.inc, label %scan.j.entry

scan.i.inc:
  %i.plus = add i64 %i.scan, 1
  br label %scan.i.loop

scan.j.entry:
  br label %scan.j.loop

scan.j.loop:
  %j.scan = phi i64 [ %j.in, %scan.j.entry ], [ %j.minus, %scan.j.inc ]
  %j.ptr = getelementptr inbounds i32, i32* %base, i64 %j.scan
  %val.j = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp sgt i32 %val.j, %pivot
  br i1 %cmp.j, label %scan.j.inc, label %check.swap

scan.j.inc:
  %j.minus = add i64 %j.scan, -1
  br label %scan.j.loop

check.swap:
  %cmp.ij = icmp sle i64 %i.scan, %j.scan
  br i1 %cmp.ij, label %swap, label %partition.done

swap:
  ; swap a[i.scan] and a[j.scan]
  %i.ptr.s = getelementptr inbounds i32, i32* %base, i64 %i.scan
  %j.ptr.s = getelementptr inbounds i32, i32* %base, i64 %j.scan
  store i32 %val.j, i32* %i.ptr.s, align 4
  store i32 %val.i, i32* %j.ptr.s, align 4
  %i.inc1 = add i64 %i.scan, 1
  %j.dec1 = add i64 %j.scan, -1
  br label %partition.loop

partition.done:
  ; i.final = i.scan, j.final = j.scan
  %i.final = phi i64 [ %i.scan, %check.swap ]
  %j.final = phi i64 [ %j.scan, %check.swap ]
  ; Choose smaller side for recursion
  %left.len = sub i64 %j.final, %lo.cur
  %right.len = sub i64 %hi.cur, %i.final
  %left.ge.right = icmp sge i64 %left.len, %right.len
  br i1 %left.ge.right, label %right.smaller, label %left.smaller

left.smaller:
  ; if (lo.cur < j.final) quick_sort(base, lo.cur, j.final);
  %left.nonempty = icmp slt i64 %lo.cur, %j.final
  br i1 %left.nonempty, label %recur.left, label %skip.left

recur.left:
  call void @quick_sort(i32* %base, i64 %lo.cur, i64 %j.final)
  br label %skip.left

skip.left:
  ; Tail update: lo = i.final; hi unchanged
  br label %tail.left

tail.left:
  %i.final.tl = phi i64 [ %i.final, %skip.left ]
  %hi.pass.tl = phi i64 [ %hi.cur, %skip.left ]
  br label %while.head

right.smaller:
  ; if (i.final < hi.cur) quick_sort(base, i.final, hi.cur);
  %right.nonempty = icmp slt i64 %i.final, %hi.cur
  br i1 %right.nonempty, label %recur.right, label %skip.right

recur.right:
  call void @quick_sort(i32* %base, i64 %i.final, i64 %hi.cur)
  br label %skip.right

skip.right:
  ; Tail update: hi = j.final; lo unchanged
  br label %tail.right

tail.right:
  %j.final.tr = phi i64 [ %j.final, %skip.right ]
  %lo.pass.tr = phi i64 [ %lo.cur, %skip.right ]
  br label %while.head

ret:
  ret void
}