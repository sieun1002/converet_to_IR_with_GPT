; ModuleID = 'quick_sort.ll'
source_filename = "quick_sort"

define dso_local void @quick_sort(i32* %arr, i64 %low, i64 %high) {
entry:
  br label %outer.cond

outer.cond:                                      ; preds = %outer.cont, %entry
  %lo = phi i64 [ %low, %entry ], [ %lo.next, %outer.cont ]
  %hi = phi i64 [ %high, %entry ], [ %hi.next, %outer.cont ]
  %cmp.outer = icmp slt i64 %lo, %hi
  br i1 %cmp.outer, label %partition.entry, label %ret

partition.entry:                                 ; preds = %outer.cond
  %diff = sub i64 %hi, %lo
  %half = sdiv i64 %diff, 2
  %mid = add i64 %lo, %half
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %mid.ptr, align 4
  br label %partition.loop

partition.loop:                                  ; preds = %do.swap, %partition.entry
  %i.phi = phi i64 [ %lo, %partition.entry ], [ %i2, %do.swap ]
  %j.phi = phi i64 [ %hi, %partition.entry ], [ %j2, %do.swap ]
  br label %left.loop

left.loop:                                       ; preds = %left.inc, %partition.loop
  %i.cur = phi i64 [ %i.phi, %partition.loop ], [ %i.inc, %left.inc ]
  %pi.l = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %vi.l = load i32, i32* %pi.l, align 4
  %cmp.left = icmp slt i32 %vi.l, %pivot
  br i1 %cmp.left, label %left.inc, label %left.done

left.inc:                                        ; preds = %left.loop
  %i.inc = add nsw i64 %i.cur, 1
  br label %left.loop

left.done:                                       ; preds = %left.loop
  br label %right.loop

right.loop:                                      ; preds = %right.dec, %left.done
  %i.keep = phi i64 [ %i.cur, %left.done ], [ %i.keep, %right.dec ]
  %j.cur = phi i64 [ %j.phi, %left.done ], [ %j.dec, %right.dec ]
  %pj.r = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %vj.r = load i32, i32* %pj.r, align 4
  %cmp.right = icmp sgt i32 %vj.r, %pivot
  br i1 %cmp.right, label %right.dec, label %right.done

right.dec:                                       ; preds = %right.loop
  %j.dec = add nsw i64 %j.cur, -1
  br label %right.loop

right.done:                                      ; preds = %right.loop
  %cmp.ij = icmp sle i64 %i.keep, %j.cur
  br i1 %cmp.ij, label %do.swap, label %partition.break

do.swap:                                         ; preds = %right.done
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i.keep
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %vi = load i32, i32* %pi, align 4
  %vj = load i32, i32* %pj, align 4
  store i32 %vj, i32* %pi, align 4
  store i32 %vi, i32* %pj, align 4
  %i2 = add nsw i64 %i.keep, 1
  %j2 = add nsw i64 %j.cur, -1
  br label %partition.loop

partition.break:                                 ; preds = %right.done
  %leftSize = sub nsw i64 %j.cur, %lo
  %rightSize = sub nsw i64 %hi, %i.keep
  %leftLT = icmp slt i64 %leftSize, %rightSize
  br i1 %leftLT, label %recurse.left, label %recurse.right

recurse.left:                                    ; preds = %partition.break
  %cmp.low.lt.j = icmp slt i64 %lo, %j.cur
  br i1 %cmp.low.lt.j, label %call.left, label %after.left.call

call.left:                                       ; preds = %recurse.left
  call void @quick_sort(i32* %arr, i64 %lo, i64 %j.cur)
  br label %after.left.call

after.left.call:                                 ; preds = %call.left, %recurse.left
  br label %outer.cont

recurse.right:                                   ; preds = %partition.break
  %cmp.i.lt.hi = icmp slt i64 %i.keep, %hi
  br i1 %cmp.i.lt.hi, label %call.right, label %after.right.call

call.right:                                      ; preds = %recurse.right
  call void @quick_sort(i32* %arr, i64 %i.keep, i64 %hi)
  br label %after.right.call

after.right.call:                                ; preds = %call.right, %recurse.right
  br label %outer.cont

outer.cont:                                      ; preds = %after.right.call, %after.left.call
  %lo.next = phi i64 [ %i.keep, %after.left.call ], [ %lo, %after.right.call ]
  %hi.next = phi i64 [ %hi, %after.left.call ], [ %j.cur, %after.right.call ]
  br label %outer.cond

ret:                                             ; preds = %outer.cond
  ret void
}