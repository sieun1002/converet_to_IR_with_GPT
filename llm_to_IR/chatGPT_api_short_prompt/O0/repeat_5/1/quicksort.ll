; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x1189
; Intent: In-place quicksort on int array over inclusive index range [low, high], with recursion on smaller partition (tail recursion elimination). Evidence: median-of-range pivot load; two-sided scan with swaps and recursive calls on [low..j] / [i..high].
; Preconditions: arr != NULL; indices low and high are valid within arr and comparable as signed 64-bit; sorts only when low < high.
; Postconditions: Elements in arr[low..high] are sorted ascending (signed int).

define dso_local void @quick_sort(i32* nocapture %arr, i64 %low, i64 %high) local_unnamed_addr {
entry:
  br label %outer.check

outer.check:                                            ; preds = %after.recurse, %entry
  %lo.cur = phi i64 [ %low, %entry ], [ %lo.next.phi, %after.recurse ]
  %hi.cur = phi i64 [ %high, %entry ], [ %hi.next.phi, %after.recurse ]
  %cmp.lohi = icmp slt i64 %lo.cur, %hi.cur
  br i1 %cmp.lohi, label %partition.init, label %exit

partition.init:                                         ; preds = %outer.check
  %i0 = %lo.cur
  %j0 = %hi.cur
  %diff = sub nsw i64 %hi.cur, %lo.cur
  %half = ashr i64 %diff, 1
  %mid = add nsw i64 %lo.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %part.loop.header

part.loop.header:                                       ; preds = %after.swap, %partition.init
  %i.iter = phi i64 [ %i0, %partition.init ], [ %i.after.swap.inc, %after.swap ]
  %j.iter = phi i64 [ %j0, %partition.init ], [ %j.after.swap.dec, %after.swap ]
  br label %incI

incI:                                                   ; preds = %incI, %part.loop.header
  %i.scan = phi i64 [ %i.iter, %part.loop.header ], [ %i.scan.next, %incI ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.scan
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %i.val, %pivot
  br i1 %cmp.i, label %incI.cont, label %decJ

incI.cont:                                              ; preds = %incI
  %i.scan.next = add nsw i64 %i.scan, 1
  br label %incI

decJ:                                                   ; preds = %incI
  %i.after.inc = %i.scan
  br label %decJ.loop

decJ.loop:                                              ; preds = %decJ.loop, %decJ
  %j.scan = phi i64 [ %j.iter, %decJ ], [ %j.scan.dec, %decJ.loop ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.scan
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp sgt i32 %j.val, %pivot
  br i1 %cmp.j, label %decJ.dec, label %compare.ij

decJ.dec:                                               ; preds = %decJ.loop
  %j.scan.dec = add nsw i64 %j.scan, -1
  br label %decJ.loop

compare.ij:                                             ; preds = %decJ.loop
  %cmp.ilej = icmp sle i64 %i.after.inc, %j.scan
  br i1 %cmp.ilej, label %do.swap, label %partition.done

do.swap:                                                ; preds = %compare.ij
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i.after.inc
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j.scan
  %vi = load i32, i32* %pi, align 4
  %vj = load i32, i32* %pj, align 4
  store i32 %vj, i32* %pi, align 4
  store i32 %vi, i32* %pj, align 4
  %i.after.swap.inc = add nsw i64 %i.after.inc, 1
  %j.after.swap.dec = add nsw i64 %j.scan, -1
  br label %after.swap

after.swap:                                             ; preds = %do.swap
  br label %part.loop.header

partition.done:                                         ; preds = %compare.ij
  ; i.after.inc is i, j.scan is j at exit
  %left.size = sub nsw i64 %j.scan, %lo.cur
  %right.size = sub nsw i64 %hi.cur, %i.after.inc
  %left.smaller = icmp slt i64 %left.size, %right.size
  br i1 %left.smaller, label %left.first, label %right.first

left.first:                                             ; preds = %partition.done
  %need.left = icmp slt i64 %lo.cur, %j.scan
  br i1 %need.left, label %recurse.left, label %skip.left

recurse.left:                                           ; preds = %left.first
  call void @quick_sort(i32* %arr, i64 %lo.cur, i64 %j.scan)
  br label %skip.left

skip.left:                                              ; preds = %recurse.left, %left.first
  %lo.next = %i.after.inc
  %hi.next = %hi.cur
  br label %after.recurse

right.first:                                            ; preds = %partition.done
  %need.right = icmp slt i64 %i.after.inc, %hi.cur
  br i1 %need.right, label %recurse.right, label %skip.right

recurse.right:                                          ; preds = %right.first
  call void @quick_sort(i32* %arr, i64 %i.after.inc, i64 %hi.cur)
  br label %skip.right

skip.right:                                             ; preds = %recurse.right, %right.first
  %lo.next.2 = %lo.cur
  %hi.next.2 = %j.scan
  br label %after.recurse

after.recurse:                                          ; preds = %skip.right, %skip.left
  %lo.next.phi = phi i64 [ %lo.next, %skip.left ], [ %lo.next.2, %skip.right ]
  %hi.next.phi = phi i64 [ %hi.next, %skip.left ], [ %hi.next.2, %skip.right ]
  br label %outer.check

exit:                                                   ; preds = %outer.check
  ret void
}