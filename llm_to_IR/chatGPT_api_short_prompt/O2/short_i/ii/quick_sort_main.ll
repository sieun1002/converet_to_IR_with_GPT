; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x1240
; Intent: in-place quicksort of 32-bit int array over inclusive [lo, hi] (confidence=0.93). Evidence: pivot at (lo+hi)/2, Hoare partition, size-based recursion choice with loop for tail recursion.

; Only the necessary external declarations:
; (none)

define dso_local void @quick_sort(i32* nocapture %arr, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  ; if (lo >= hi) return;
  %cmp.entry = icmp sge i64 %lo, %hi
  br i1 %cmp.entry, label %ret, label %loop.test.entry

loop.test.entry:                                       ; preds = %entry
  br label %loop.test

loop.test:                                             ; preds = %loop.continue, %loop.test.entry
  %lo.cur = phi i64 [ %lo, %loop.test.entry ], [ %lo.next.merge, %loop.continue ]
  %hi.cur = phi i64 [ %hi, %loop.test.entry ], [ %hi.next.merge, %loop.continue ]
  %range.ok = icmp sgt i64 %hi.cur, %lo.cur
  br i1 %range.ok, label %partition.init, label %ret

partition.init:                                        ; preds = %loop.test
  ; pivot = arr[(lo.cur + hi.cur) / 2] computed as lo + ((hi-lo)>>1)
  %diff = sub i64 %hi.cur, %lo.cur
  %half = ashr i64 %diff, 1
  %mid = add i64 %lo.cur, %half
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  %i.init = %lo.cur
  %j.init = %hi.cur
  br label %left.scan

left.scan:                                             ; preds = %after.swap, %inc.left, %partition.init
  %i.l = phi i64 [ %i.init, %partition.init ], [ %i.l.next, %inc.left ], [ %i.after, %after.swap ]
  %j.l = phi i64 [ %j.init, %partition.init ], [ %j.l, %inc.left ], [ %j.after, %after.swap ]
  %iptr.l = getelementptr inbounds i32, i32* %arr, i64 %i.l
  %ival.l = load i32, i32* %iptr.l, align 4
  %lt.left = icmp slt i32 %ival.l, %pivot
  br i1 %lt.left, label %inc.left, label %right.scan.entry

inc.left:                                              ; preds = %left.scan
  %i.l.next = add i64 %i.l, 1
  br label %left.scan

right.scan.entry:                                      ; preds = %left.scan
  br label %right.scan

right.scan:                                            ; preds = %dec.right, %right.scan.entry
  %i.r = phi i64 [ %i.l, %right.scan.entry ], [ %i.r, %dec.right ]
  %j.r = phi i64 [ %j.l, %right.scan.entry ], [ %j.r.next, %dec.right ]
  %jptr.r = getelementptr inbounds i32, i32* %arr, i64 %j.r
  %jval.r = load i32, i32* %jptr.r, align 4
  %gt.right = icmp sgt i32 %jval.r, %pivot
  br i1 %gt.right, label %dec.right, label %check.swap

dec.right:                                             ; preds = %right.scan
  %j.r.next = add i64 %j.r, -1
  br label %right.scan

check.swap:                                            ; preds = %right.scan
  %le.ij = icmp sle i64 %i.r, %j.r
  br i1 %le.ij, label %do.swap, label %partition.done

do.swap:                                               ; preds = %check.swap
  %iptr2 = getelementptr inbounds i32, i32* %arr, i64 %i.r
  %ival2 = load i32, i32* %iptr2, align 4
  store i32 %jval.r, i32* %iptr2, align 4
  store i32 %ival2, i32* %jptr.r, align 4
  %i.inc = add i64 %i.r, 1
  %j.dec = add i64 %j.r, -1
  br label %after.swap

after.swap:                                            ; preds = %do.swap
  %i.after = phi i64 [ %i.inc, %do.swap ]
  %j.after = phi i64 [ %j.dec, %do.swap ]
  br label %left.scan

partition.done:                                        ; preds = %check.swap
  %i.fin = %i.r
  %j.fin = %j.r
  ; Choose smaller side to recurse, iterate on the larger (tail recursion elimination)
  %left.size = sub i64 %j.fin, %lo.cur
  %right.size = sub i64 %hi.cur, %i.fin
  %left.lt.right = icmp slt i64 %left.size, %right.size
  br i1 %left.lt.right, label %left.smaller, label %right.smaller.eq

left.smaller:                                          ; preds = %partition.done
  %has.left = icmp slt i64 %lo.cur, %j.fin
  br i1 %has.left, label %call.left, label %skip.left

call.left:                                             ; preds = %left.smaller
  call void @quick_sort(i32* %arr, i64 %lo.cur, i64 %j.fin)
  br label %skip.left

skip.left:                                             ; preds = %call.left, %left.smaller
  %lo.next.L = %i.fin
  %hi.next.L = %hi.cur
  br label %loop.continue

right.smaller.eq:                                      ; preds = %partition.done
  %has.right = icmp slt i64 %i.fin, %hi.cur
  br i1 %has.right, label %call.right, label %skip.right

call.right:                                            ; preds = %right.smaller.eq
  call void @quick_sort(i32* %arr, i64 %i.fin, i64 %hi.cur)
  br label %skip.right

skip.right:                                            ; preds = %call.right, %right.smaller.eq
  %lo.next.R = %lo.cur
  %hi.next.R = %j.fin
  br label %loop.continue

loop.continue:                                         ; preds = %skip.right, %skip.left
  %lo.next.merge = phi i64 [ %lo.next.L, %skip.left ], [ %lo.next.R, %skip.right ]
  %hi.next.merge = phi i64 [ %hi.next.L, %skip.left ], [ %hi.next.R, %skip.right ]
  br label %loop.test

ret:                                                  ; preds = %loop.test, %entry
  ret void
}