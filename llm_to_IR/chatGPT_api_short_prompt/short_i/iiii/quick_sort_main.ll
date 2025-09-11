; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x0000000000001240
; Intent: In-place quicksort of 32-bit int array slice [lo..hi] inclusive (confidence=0.98). Evidence: pivot = mid element, bidirectional partition, recurse smaller half/tail-loop larger.
; Preconditions: arr points to an array of at least hi+1 elements; 0 <= lo <= hi (indices are 0-based, inclusive range).
; Postconditions: Elements arr[lo..hi] sorted ascending in-place.

; Only the necessary external declarations:
; (none)

define dso_local void @quick_sort(i32* nocapture %arr, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  %cmp0 = icmp sge i64 %lo, %hi
  br i1 %cmp0, label %ret, label %loop

loop:
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.next, %afterTail ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.next, %afterTail ]
  %cmp1 = icmp sge i64 %lo.cur, %hi.cur
  br i1 %cmp1, label %ret, label %part.init

part.init:
  %diff = sub i64 %hi.cur, %lo.cur
  %half = sdiv i64 %diff, 2
  %mid = add i64 %lo.cur, %half
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  %i0 = add i64 %lo.cur, 0
  %j0 = add i64 %hi.cur, 0
  br label %part.loop

part.loop:                                            ; i/j advance and partition
  %i.cur = phi i64 [ %i0, %part.init ], [ %i.next, %swap.cont ]
  %j.cur = phi i64 [ %j0, %part.init ], [ %j.next, %swap.cont ]
  br label %incI

incI:
  %i.it = phi i64 [ %i.cur, %part.loop ], [ %i.it.next, %incI.cont ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.it
  %vi = load i32, i32* %i.ptr, align 4
  %il = icmp slt i32 %vi, %pivot
  br i1 %il, label %incI.cont, label %incI.exit

incI.cont:
  %i.it.next = add i64 %i.it, 1
  %i.tooHigh = icmp sgt i64 %i.it.next, %hi.cur
  br i1 %i.tooHigh, label %incI.exit, label %incI

incI.exit:
  %i2 = phi i64 [ %i.it, %incI ], [ %i.it.next, %incI.cont ]
  br label %decJ

decJ:
  %j.it = phi i64 [ %j.cur, %incI.exit ], [ %j.it.next, %decJ.cont ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.it
  %vj = load i32, i32* %j.ptr, align 4
  %jg = icmp sgt i32 %vj, %pivot
  br i1 %jg, label %decJ.cont, label %decJ.exit

decJ.cont:
  %j.it.next = add i64 %j.it, -1
  %j.tooLow = icmp slt i64 %j.it.next, %lo.cur
  br i1 %j.tooLow, label %decJ.exit, label %decJ

decJ.exit:
  %j2 = phi i64 [ %j.it, %decJ ], [ %j.it.next, %decJ.cont ]
  %ijcmp = icmp sle i64 %i2, %j2
  br i1 %ijcmp, label %doSwap, label %break

doSwap:
  %i.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %i2
  %j.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  %vi2 = load i32, i32* %i.ptr2, align 4
  %vj2 = load i32, i32* %j.ptr2, align 4
  store i32 %vj2, i32* %i.ptr2, align 4
  store i32 %vi2, i32* %j.ptr2, align 4
  %i.next = add i64 %i2, 1
  %j.next = add i64 %j2, -1
  br label %swap.cont

swap.cont:
  br label %part.loop

break:                                                ; partition done: i2, j2 with i2 > j2
  %left.size = sub i64 %j2, %lo.cur
  %right.size = sub i64 %hi.cur, %i2
  %lo_lt_j = icmp slt i64 %lo.cur, %j2
  %i_lt_hi = icmp slt i64 %i2, %hi.cur
  %cmpSizes = icmp slt i64 %left.size, %right.size
  br i1 %cmpSizes, label %recurse_left_first, label %recurse_right_first

recurse_left_first:
  br i1 %lo_lt_j, label %call_left, label %skip_left

call_left:
  call void @quick_sort(i32* %arr, i64 %lo.cur, i64 %j2)
  br label %skip_left

skip_left:
  ; Tail on right: [i2 .. hi.cur]
  %lo.next.r = phi i64 [ %i2, %skip_left ], [ %i2, %call_left ]
  %hi.next.r = phi i64 [ %hi.cur, %skip_left ], [ %hi.cur, %call_left ]
  br label %afterTail

recurse_right_first:
  br i1 %i_lt_hi, label %call_right, label %skip_right

call_right:
  call void @quick_sort(i32* %arr, i64 %i2, i64 %hi.cur)
  br label %skip_right

skip_right:
  ; Tail on left: [lo.cur .. j2]
  %lo.next.l = phi i64 [ %lo.cur, %skip_right ], [ %lo.cur, %call_right ]
  %hi.next.l = phi i64 [ %j2, %skip_right ], [ %j2, %call_right ]
  br label %afterTail

afterTail:
  %lo.next = phi i64 [ %lo.next.r, %skip_left ], [ %lo.next.l, %skip_right ]
  %hi.next = phi i64 [ %hi.next.r, %skip_left ], [ %hi.next.l, %skip_right ]
  br label %loop

ret:
  ret void
}