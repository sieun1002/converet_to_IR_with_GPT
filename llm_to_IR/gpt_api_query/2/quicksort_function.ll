; ModuleID = 'quick_sort.ll'
source_filename = "quick_sort"

define void @quick_sort(i32* %arr, i64 %low, i64 %high) {
entry:
  br label %tail.loop

tail.loop:                                            ; preds = %tail.loop.latch, %entry
  %low.cur = phi i64 [ %low, %entry ], [ %low.next, %tail.loop.latch ]
  %high.cur = phi i64 [ %high, %entry ], [ %high.next, %tail.loop.latch ]
  %cond = icmp slt i64 %low.cur, %high.cur
  br i1 %cond, label %partition.init, label %ret

partition.init:                                       ; preds = %tail.loop
  %i.init = %low.cur
  %j.init = %high.cur
  %diff = sub i64 %high.cur, %low.cur
  %shr63 = lshr i64 %diff, 63
  %addtmp = add i64 %diff, %shr63
  %half = ashr i64 %addtmp, 1
  %mid = add i64 %low.cur, %half
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  br label %partition.loop.header

partition.loop.header:                                ; preds = %do_swap, %partition.init
  %i.cur = phi i64 [ %i.init, %partition.init ], [ %i.next, %do_swap ]
  %j.cur = phi i64 [ %j.init, %partition.init ], [ %j.next, %do_swap ]
  br label %scan_i

scan_i:                                               ; preds = %scan_i.inc, %partition.loop.header
  %i.scan.idx = phi i64 [ %i.cur, %partition.loop.header ], [ %i.scan.inc, %scan_i.inc ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.scan.idx
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %i.val, %pivot
  br i1 %cmp.i, label %scan_i.inc, label %scan_j.entry

scan_i.inc:                                           ; preds = %scan_i
  %i.scan.inc = add nsw i64 %i.scan.idx, 1
  br label %scan_i

scan_j.entry:                                         ; preds = %scan_i
  br label %scan_j

scan_j:                                               ; preds = %scan_j.dec, %scan_j.entry
  %i.fixed = phi i64 [ %i.scan.idx, %scan_j.entry ], [ %i.fixed, %scan_j.dec ]
  %j.scan.idx = phi i64 [ %j.cur, %scan_j.entry ], [ %j.scan.dec, %scan_j.dec ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.scan.idx
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp sgt i32 %j.val, %pivot
  br i1 %cmp.j, label %scan_j.dec, label %after_scans

scan_j.dec:                                           ; preds = %scan_j
  %j.scan.dec = add nsw i64 %j.scan.idx, -1
  br label %scan_j

after_scans:                                          ; preds = %scan_j
  %cmp.ilej = icmp sle i64 %i.fixed, %j.scan.idx
  br i1 %cmp.ilej, label %do_swap, label %partition.done

do_swap:                                              ; preds = %after_scans
  %iptr2 = getelementptr inbounds i32, i32* %arr, i64 %i.fixed
  %jptr2 = getelementptr inbounds i32, i32* %arr, i64 %j.scan.idx
  %ival2 = load i32, i32* %iptr2, align 4
  %jval2 = load i32, i32* %jptr2, align 4
  store i32 %jval2, i32* %iptr2, align 4
  store i32 %ival2, i32* %jptr2, align 4
  %i.next = add nsw i64 %i.fixed, 1
  %j.next = add nsw i64 %j.scan.idx, -1
  br label %partition.loop.header

partition.done:                                       ; preds = %after_scans
  %left.size = sub nsw i64 %j.scan.idx, %low.cur
  %right.size = sub nsw i64 %high.cur, %i.fixed
  %left_ge_right = icmp sge i64 %left.size, %right.size
  br i1 %left_ge_right, label %recurse_right, label %recurse_left

recurse_left:                                         ; preds = %partition.done
  %has_left = icmp slt i64 %low.cur, %j.scan.idx
  br i1 %has_left, label %call_left, label %skip_left

call_left:                                            ; preds = %recurse_left
  call void @quick_sort(i32* %arr, i64 %low.cur, i64 %j.scan.idx)
  br label %skip_left

skip_left:                                            ; preds = %call_left, %recurse_left
  br label %tail.loop.latch

recurse_right:                                        ; preds = %partition.done
  %has_right = icmp slt i64 %i.fixed, %high.cur
  br i1 %has_right, label %call_right, label %skip_right

call_right:                                           ; preds = %recurse_right
  call void @quick_sort(i32* %arr, i64 %i.fixed, i64 %high.cur)
  br label %skip_right

skip_right:                                           ; preds = %call_right, %recurse_right
  br label %tail.loop.latch

tail.loop.latch:                                      ; preds = %skip_right, %skip_left
  %low.next = phi i64 [ %low.cur, %skip_right ], [ %i.fixed, %skip_left ]
  %high.next = phi i64 [ %j.scan.idx, %skip_right ], [ %high.cur, %skip_left ]
  br label %tail.loop

ret:                                                  ; preds = %tail.loop
  ret void
}