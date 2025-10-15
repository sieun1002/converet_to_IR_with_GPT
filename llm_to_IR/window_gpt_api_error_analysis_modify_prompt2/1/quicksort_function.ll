; ModuleID = 'quick_sort_module'
target triple = "x86_64-pc-windows-msvc"

define void @quick_sort(i32* %arr, i32 %left, i32 %right) {
entry:
  br label %outer.cond

outer.cond:                                      ; preds = %cont.right, %cont.left, %entry
  %L = phi i32 [ %left, %entry ], [ %L.next, %cont.left ], [ %L2.next, %cont.right ]
  %R = phi i32 [ %right, %entry ], [ %R.next, %cont.left ], [ %R2.next, %cont.right ]
  %cmp.lr = icmp slt i32 %L, %R
  br i1 %cmp.lr, label %partition.init, label %ret

partition.init:                                   ; preds = %outer.cond
  %diff = sub i32 %R, %L
  %sign = lshr i32 %diff, 31
  %sum = add i32 %diff, %sign
  %shift = ashr i32 %sum, 1
  %mid = add i32 %L, %shift
  %mid64 = sext i32 %mid to i64
  %ptrmid = getelementptr inbounds i32, i32* %arr, i64 %mid64
  %pivot = load i32, i32* %ptrmid, align 4
  br label %loop.left

loop.left:                                        ; preds = %after.swap.back, %left.inc, %partition.init
  %i = phi i32 [ %L, %partition.init ], [ %i.inc, %left.inc ], [ %i.after, %after.swap.back ]
  %j = phi i32 [ %R, %partition.init ], [ %j.pass, %left.inc ], [ %j.after, %after.swap.back ]
  %i64 = sext i32 %i to i64
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i64
  %ai = load i32, i32* %ptr.i, align 4
  %cmp.li = icmp slt i32 %ai, %pivot
  br i1 %cmp.li, label %left.inc, label %loop.right

left.inc:                                         ; preds = %loop.left
  %i.inc = add nsw i32 %i, 1
  %j.pass = add i32 %j, 0
  br label %loop.left

loop.right:                                       ; preds = %right.dec, %loop.left
  %iR = phi i32 [ %i, %loop.left ], [ %i.pass, %right.dec ]
  %jR = phi i32 [ %j, %loop.left ], [ %j.dec, %right.dec ]
  %j64 = sext i32 %jR to i64
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j64
  %aj = load i32, i32* %ptr.j, align 4
  %cmp.r = icmp slt i32 %pivot, %aj
  br i1 %cmp.r, label %right.dec, label %check.swap

right.dec:                                        ; preds = %loop.right
  %j.dec = add nsw i32 %jR, -1
  %i.pass = add i32 %iR, 0
  br label %loop.right

check.swap:                                       ; preds = %loop.right
  %cmp.ij = icmp sle i32 %iR, %jR
  br i1 %cmp.ij, label %do.swap, label %partition.done

do.swap:                                          ; preds = %check.swap
  %i64.2 = sext i32 %iR to i64
  %ptr.i2 = getelementptr inbounds i32, i32* %arr, i64 %i64.2
  %val.i = load i32, i32* %ptr.i2, align 4
  %j64.2 = sext i32 %jR to i64
  %ptr.j2 = getelementptr inbounds i32, i32* %arr, i64 %j64.2
  %val.j = load i32, i32* %ptr.j2, align 4
  store i32 %val.j, i32* %ptr.i2, align 4
  store i32 %val.i, i32* %ptr.j2, align 4
  %i.after = add nsw i32 %iR, 1
  %j.after = add nsw i32 %jR, -1
  br label %after.swap.back

after.swap.back:                                  ; preds = %do.swap
  %cmp.ij2 = icmp sle i32 %i.after, %j.after
  br i1 %cmp.ij2, label %loop.left, label %partition.done

partition.done:                                   ; preds = %after.swap.back, %check.swap
  %i.done = phi i32 [ %iR, %check.swap ], [ %i.after, %after.swap.back ]
  %j.done = phi i32 [ %jR, %check.swap ], [ %j.after, %after.swap.back ]
  %leftSize = sub nsw i32 %j.done, %L
  %rightSize = sub nsw i32 %R, %i.done
  %cmp.sizes = icmp slt i32 %leftSize, %rightSize
  br i1 %cmp.sizes, label %case.left, label %case.right

case.left:                                        ; preds = %partition.done
  %condL = icmp slt i32 %L, %j.done
  br i1 %condL, label %recurse.left, label %skip.left

recurse.left:                                     ; preds = %case.left
  call void @quick_sort(i32* %arr, i32 %L, i32 %j.done)
  br label %skip.left

skip.left:                                        ; preds = %recurse.left, %case.left
  %L.next = add i32 %i.done, 0
  %R.next = add i32 %R, 0
  br label %cont.left

cont.left:                                        ; preds = %skip.left
  br label %outer.cond

case.right:                                       ; preds = %partition.done
  %condR = icmp slt i32 %i.done, %R
  br i1 %condR, label %recurse.right, label %skip.right

recurse.right:                                    ; preds = %case.right
  call void @quick_sort(i32* %arr, i32 %i.done, i32 %R)
  br label %skip.right

skip.right:                                       ; preds = %recurse.right, %case.right
  %L2.next = add i32 %L, 0
  %R2.next = add i32 %j.done, 0
  br label %cont.right

cont.right:                                       ; preds = %skip.right
  br label %outer.cond

ret:                                              ; preds = %outer.cond
  ret void
}