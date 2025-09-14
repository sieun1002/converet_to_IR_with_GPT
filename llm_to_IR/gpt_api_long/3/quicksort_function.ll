; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort  ; Address: 0x1189
; Intent: in-place quicksort (signed 32-bit ints) with tail-recursion optimization (confidence=0.95). Evidence: Hoare-style partition, swap with i/j, recurse on smaller side.
; Preconditions: a is a valid i32 array; 0 <= lo <= hi are inclusive indices within bounds.
; Postconditions: a[lo..hi] sorted ascending (signed)

define dso_local void @quick_sort(i32* %a, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  br label %outer

outer:                                            ; loop header
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.next, %loop.update ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.next, %loop.update ]
  %cmp.outer = icmp slt i64 %lo.cur, %hi.cur
  br i1 %cmp.outer, label %part, label %ret

part:
  %i0 = phi i64 [ %lo.cur, %outer ]
  %j0 = phi i64 [ %hi.cur, %outer ]
  %diff = sub i64 %hi.cur, %lo.cur
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %a, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %scan_i

scan_i:
  %i = phi i64 [ %i0, %part ], [ %i.next, %scan_i.inc ], [ %i.new, %check_cont ]
  %j = phi i64 [ %j0, %part ], [ %j, %scan_i.inc ], [ %j.new, %check_cont ]
  %ai.ptr = getelementptr inbounds i32, i32* %a, i64 %i
  %ai = load i32, i32* %ai.ptr, align 4
  %cond.i = icmp sgt i32 %pivot, %ai
  br i1 %cond.i, label %scan_i.inc, label %scan_j

scan_i.inc:
  %i.next = add i64 %i, 1
  br label %scan_i

scan_j:
  %i2 = phi i64 [ %i, %scan_i ], [ %i2, %scan_j.dec ]
  %j2 = phi i64 [ %j, %scan_i ], [ %j.dec, %scan_j.dec ]
  %aj.ptr = getelementptr inbounds i32, i32* %a, i64 %j2
  %aj = load i32, i32* %aj.ptr, align 4
  %cond.j = icmp slt i32 %pivot, %aj
  br i1 %cond.j, label %scan_j.dec, label %check_swap

scan_j.dec:
  %j.dec = add i64 %j2, -1
  br label %scan_j

check_swap:
  %ij.gt = icmp sgt i64 %i2, %j2
  br i1 %ij.gt, label %after_part, label %do_swap

do_swap:
  %ai.ptr2 = getelementptr inbounds i32, i32* %a, i64 %i2
  %aj.ptr2 = getelementptr inbounds i32, i32* %a, i64 %j2
  %ai.val2 = load i32, i32* %ai.ptr2, align 4
  %aj.val2 = load i32, i32* %aj.ptr2, align 4
  store i32 %aj.val2, i32* %ai.ptr2, align 4
  store i32 %ai.val2, i32* %aj.ptr2, align 4
  %i.new = add i64 %i2, 1
  %j.new = add i64 %j2, -1
  br label %check_cont

check_cont:
  %cont = icmp sle i64 %i.new, %j.new
  br i1 %cont, label %scan_i, label %after_part

after_part:
  %i.fin = phi i64 [ %i2, %check_swap ], [ %i.new, %check_cont ]
  %j.fin = phi i64 [ %j2, %check_swap ], [ %j.new, %check_cont ]
  %left.size = sub i64 %j.fin, %lo.cur
  %right.size = sub i64 %hi.cur, %i.fin
  %left_ge_right = icmp sge i64 %left.size, %right.size
  br i1 %left_ge_right, label %recurse_right, label %recurse_left

recurse_left:
  %needL = icmp slt i64 %lo.cur, %j.fin
  br i1 %needL, label %call_left, label %skip_left

call_left:
  call void @quick_sort(i32* %a, i64 %lo.cur, i64 %j.fin)
  br label %skip_left

skip_left:
  %lo.next.L = phi i64 [ %i.fin, %call_left ], [ %i.fin, %recurse_left ]
  %hi.next.L = phi i64 [ %hi.cur, %call_left ], [ %hi.cur, %recurse_left ]
  br label %loop.update

recurse_right:
  %needR = icmp slt i64 %i.fin, %hi.cur
  br i1 %needR, label %call_right, label %skip_right

call_right:
  call void @quick_sort(i32* %a, i64 %i.fin, i64 %hi.cur)
  br label %skip_right

skip_right:
  %lo.next.R = phi i64 [ %lo.cur, %call_right ], [ %lo.cur, %recurse_right ]
  %hi.next.R = phi i64 [ %j.fin, %call_right ], [ %j.fin, %recurse_right ]
  br label %loop.update

loop.update:
  %lo.next = phi i64 [ %lo.next.L, %skip_left ], [ %lo.next.R, %skip_right ]
  %hi.next = phi i64 [ %hi.next.L, %skip_left ], [ %hi.next.R, %skip_right ]
  br label %outer

ret:
  ret void
}