; ModuleID = 'quick_sort_module'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @quick_sort(i32* %arr, i64 %lo, i64 %hi) {
entry:
  br label %loop.check

loop.check:                                          ; outer tail-recursive loop
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.next.left, %left.first ], [ %lo.next.right, %right.first ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.next.left, %left.first ], [ %hi.next.right, %right.first ]
  %cmp.lohi = icmp slt i64 %lo.cur, %hi.cur
  br i1 %cmp.lohi, label %partition.init, label %ret

partition.init:
  ; i = lo.cur, j = hi.cur
  %i.start = %lo.cur
  %j.start = %hi.cur

  ; mid = lo + floor((hi - lo)/2) using the same bit trick
  %diff = sub i64 %hi.cur, %lo.cur
  %sign = ashr i64 %diff, 63
  %adj  = add i64 %diff, %sign
  %half = ashr i64 %adj, 1
  %mid  = add i64 %lo.cur, %half

  ; pivot = arr[mid]
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4

  br label %loop.top

loop.top:
  %i.cur = phi i64 [ %i.start, %partition.init ], [ %i.after, %do.swap ]
  %j.cur = phi i64 [ %j.start, %partition.init ], [ %j.after, %do.swap ]
  br label %i.loop

i.loop:
  %i.tmp = phi i64 [ %i.cur, %loop.top ], [ %i.next, %i.inc ]
  %iptr = getelementptr inbounds i32, i32* %arr, i64 %i.tmp
  %ival = load i32, i32* %iptr, align 4
  %cmp.i = icmp sgt i32 %pivot, %ival          ; while (pivot > arr[i]) i++
  br i1 %cmp.i, label %i.inc, label %j.loop.enter

i.inc:
  %i.next = add i64 %i.tmp, 1
  br label %i.loop

j.loop.enter:
  br label %j.loop

j.loop:
  %j.tmp = phi i64 [ %j.cur, %j.loop.enter ], [ %j.next, %j.dec ]
  %i.fixed = phi i64 [ %i.tmp, %j.loop.enter ], [ %i.fixed, %j.dec ]
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j.tmp
  %jval = load i32, i32* %jptr, align 4
  %cmp.j = icmp slt i32 %pivot, %jval          ; while (pivot < arr[j]) j--
  br i1 %cmp.j, label %j.dec, label %compare

j.dec:
  %j.next = add i64 %j.tmp, -1
  br label %j.loop

compare:
  %ij.le = icmp sle i64 %i.fixed, %j.tmp
  br i1 %ij.le, label %do.swap, label %after.partition

do.swap:
  ; swap arr[i.fixed] and arr[j.tmp]
  %iptr2 = getelementptr inbounds i32, i32* %arr, i64 %i.fixed
  %jptr2 = getelementptr inbounds i32, i32* %arr, i64 %j.tmp
  %val.i = load i32, i32* %iptr2, align 4
  %val.j = load i32, i32* %jptr2, align 4
  store i32 %val.j, i32* %iptr2, align 4
  store i32 %val.i, i32* %jptr2, align 4
  %i.after = add i64 %i.fixed, 1
  %j.after = add i64 %j.tmp, -1
  br label %loop.top

after.partition:
  ; i_end = %i.fixed, j_end = %j.tmp
  %left.size  = sub i64 %j.tmp, %lo.cur       ; j - lo
  %right.size = sub i64 %hi.cur, %i.fixed     ; hi - i
  %left.ge.right = icmp sge i64 %left.size, %right.size
  br i1 %left.ge.right, label %right.first, label %left.first

left.first:
  ; if (lo.cur < j_end) quick_sort(arr, lo.cur, j_end)
  %call.left.cond = icmp slt i64 %lo.cur, %j.tmp
  br i1 %call.left.cond, label %do.call.left, label %skip.call.left

do.call.left:
  call void @quick_sort(i32* %arr, i64 %lo.cur, i64 %j.tmp)
  br label %skip.call.left

skip.call.left:
  ; tail-iterate on right: lo = i_end, hi = hi.cur
  %lo.next.left = %i.fixed
  %hi.next.left = %hi.cur
  br label %loop.check

right.first:
  ; if (i_end < hi.cur) quick_sort(arr, i_end, hi.cur)
  %call.right.cond = icmp slt i64 %i.fixed, %hi.cur
  br i1 %call.right.cond, label %do.call.right, label %skip.call.right

do.call.right:
  call void @quick_sort(i32* %arr, i64 %i.fixed, i64 %hi.cur)
  br label %skip.call.right

skip.call.right:
  ; tail-iterate on left: lo = lo.cur, hi = j_end
  %lo.next.right = %lo.cur
  %hi.next.right = %j.tmp
  br label %loop.check

ret:
  ret void
}