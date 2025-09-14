; quick_sort(int32_t* arr, int64_t left, int64_t right)
; Partitioning and tail-recursive quicksort matching the provided x86-64 logic

define dso_local void @quick_sort(i32* nocapture %arr, i64 %left, i64 %right) {
entry:
  br label %outer.loop

outer.loop:                                             ; while (left < right)
  %left.cur = phi i64 [ %left, %entry ], [ %left.next.L, %left.update ], [ %left.next.R, %right.update ]
  %right.cur = phi i64 [ %right, %entry ], [ %right.next.L, %left.update ], [ %right.next.R, %right.update ]
  %cmp.outer = icmp slt i64 %left.cur, %right.cur
  br i1 %cmp.outer, label %partition.entry, label %return

partition.entry:
  %i.init = add i64 %left.cur, 0
  %j.init = add i64 %right.cur, 0
  %diff = sub i64 %right.cur, %left.cur
  %sign = lshr i64 %diff, 63
  %sum = add i64 %diff, %sign
  %half = ashr i64 %sum, 1
  %mid = add i64 %left.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot.val = load i32, i32* %pivot.ptr, align 4
  br label %inc.i.check

inc.i.check:                                            ; while (arr[i] < pivot) i++
  %i.cur = phi i64 [ %i.init, %partition.entry ], [ %i.next, %inc.i.body ], [ %i.inc, %do.swap ]
  %j.forinc = phi i64 [ %j.init, %partition.entry ], [ %j.init, %inc.i.body ], [ %j.dec, %do.swap ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %i.val, %pivot.val
  br i1 %cmp.i, label %inc.i.body, label %dec.j.check

inc.i.body:
  %i.next = add i64 %i.cur, 1
  br label %inc.i.check

dec.j.check:                                            ; while (arr[j] > pivot) j--
  %i.afterinc = phi i64 [ %i.cur, %inc.i.check ], [ %i.cur, %dec.j.body ]
  %j.cur = phi i64 [ %j.forinc, %inc.i.check ], [ %j.next, %dec.j.body ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp sgt i32 %j.val, %pivot.val
  br i1 %cmp.j, label %dec.j.body, label %partition.compare

dec.j.body:
  %j.next = add i64 %j.cur, -1
  br label %dec.j.check

partition.compare:
  %cmp.le = icmp sle i64 %i.afterinc, %j.cur
  br i1 %cmp.le, label %do.swap, label %after.partition

do.swap:                                                ; swap arr[i] and arr[j], i++, j--
  %ptr.i.swap = getelementptr inbounds i32, i32* %arr, i64 %i.afterinc
  %val.i.swap = load i32, i32* %ptr.i.swap, align 4
  %ptr.j.swap = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %val.j.swap = load i32, i32* %ptr.j.swap, align 4
  store i32 %val.j.swap, i32* %ptr.i.swap, align 4
  store i32 %val.i.swap, i32* %ptr.j.swap, align 4
  %i.inc = add i64 %i.afterinc, 1
  %j.dec = add i64 %j.cur, -1
  br label %inc.i.check

after.partition:                                        ; choose smaller side to recurse
  %i.final = add i64 %i.afterinc, 0
  %j.final = add i64 %j.cur, 0
  %left.span = sub i64 %j.final, %left.cur
  %right.span = sub i64 %right.cur, %i.final
  %cmp.sizes = icmp sge i64 %left.span, %right.span
  br i1 %cmp.sizes, label %right.branch, label %left.branch

left.branch:                                            ; recurse on [left, j] if needed; then left = i
  %need.left = icmp slt i64 %left.cur, %j.final
  br i1 %need.left, label %left.recurse, label %left.update

left.recurse:
  call void @quick_sort(i32* %arr, i64 %left.cur, i64 %j.final)
  br label %left.update

left.update:
  %left.next.L = add i64 %i.final, 0
  %right.next.L = add i64 %right.cur, 0
  br label %outer.loop

right.branch:                                           ; recurse on [i, right] if needed; then right = j
  %need.right = icmp slt i64 %i.final, %right.cur
  br i1 %need.right, label %right.recurse, label %right.update

right.recurse:
  call void @quick_sort(i32* %arr, i64 %i.final, i64 %right.cur)
  br label %right.update

right.update:
  %left.next.R = add i64 %left.cur, 0
  %right.next.R = add i64 %j.final, 0
  br label %outer.loop

return:
  ret void
}