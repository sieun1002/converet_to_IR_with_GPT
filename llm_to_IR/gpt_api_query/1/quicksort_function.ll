; ModuleID = 'quick_sort'
source_filename = "quick_sort"

define dso_local void @quick_sort(i32* nocapture %base, i64 %left, i64 %right) local_unnamed_addr #0 {
entry:
  br label %top.check

top.check:                                            ; preds = %after.recurse, %entry
  %L.cur = phi i64 [ %left, %entry ], [ %L.next.loop, %after.recurse ]
  %R.cur = phi i64 [ %right, %entry ], [ %R.next.loop, %after.recurse ]
  %cmp.lr = icmp slt i64 %L.cur, %R.cur
  br i1 %cmp.lr, label %partition.init, label %ret

partition.init:                                       ; preds = %top.check
  %diff = sub i64 %R.cur, %L.cur
  %shr = lshr i64 %diff, 63
  %add = add i64 %diff, %shr
  %half = ashr i64 %add, 1
  %mid = add i64 %L.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %partition.loop

partition.loop:                                       ; preds = %do.swap, %partition.init
  %iF = phi i64 [ %L.cur, %partition.init ], [ %i.next, %do.swap ]
  %jF = phi i64 [ %R.cur, %partition.init ], [ %j.next, %do.swap ]
  br label %fscan

fscan:                                                ; preds = %fscan.inc, %partition.loop
  %i.cur = phi i64 [ %iF, %partition.loop ], [ %i.cur.inc, %fscan.inc ]
  %ai.ptr = getelementptr inbounds i32, i32* %base, i64 %i.cur
  %ai = load i32, i32* %ai.ptr, align 4
  %condF = icmp sgt i32 %pivot, %ai
  br i1 %condF, label %fscan.inc, label %fscan.exit

fscan.inc:                                            ; preds = %fscan
  %i.cur.inc = add i64 %i.cur, 1
  br label %fscan

fscan.exit:                                           ; preds = %fscan
  br label %bscan

bscan:                                                ; preds = %bscan.dec, %fscan.exit
  %i.stop = phi i64 [ %i.cur, %fscan.exit ], [ %i.stop, %bscan.dec ]
  %j.cur = phi i64 [ %jF, %fscan.exit ], [ %j.cur.dec, %bscan.dec ]
  %aj.ptr = getelementptr inbounds i32, i32* %base, i64 %j.cur
  %aj = load i32, i32* %aj.ptr, align 4
  %condB = icmp slt i32 %pivot, %aj
  br i1 %condB, label %bscan.dec, label %after.scans

bscan.dec:                                            ; preds = %bscan
  %j.cur.dec = add i64 %j.cur, -1
  br label %bscan

after.scans:                                          ; preds = %bscan
  %cmpIJ = icmp sgt i64 %i.stop, %j.cur
  br i1 %cmpIJ, label %partition.done, label %do.swap

do.swap:                                              ; preds = %after.scans
  %a.i.ptr = getelementptr inbounds i32, i32* %base, i64 %i.stop
  %a.j.ptr = getelementptr inbounds i32, i32* %base, i64 %j.cur
  %val.i = load i32, i32* %a.i.ptr, align 4
  %val.j = load i32, i32* %a.j.ptr, align 4
  store i32 %val.j, i32* %a.i.ptr, align 4
  store i32 %val.i, i32* %a.j.ptr, align 4
  %i.next = add i64 %i.stop, 1
  %j.next = add i64 %j.cur, -1
  br label %partition.loop

partition.done:                                       ; preds = %after.scans
  %left.size = sub i64 %j.cur, %L.cur
  %right.size = sub i64 %R.cur, %i.stop
  %choose.right = icmp sge i64 %left.size, %right.size
  br i1 %choose.right, label %recurse.right, label %recurse.left

recurse.left:                                         ; preds = %partition.done
  %needLeft = icmp slt i64 %L.cur, %j.cur
  br i1 %needLeft, label %call.left, label %skip.left

call.left:                                            ; preds = %recurse.left
  call void @quick_sort(i32* %base, i64 %L.cur, i64 %j.cur)
  br label %skip.left

skip.left:                                            ; preds = %call.left, %recurse.left
  %L.afterLeft = %i.stop
  %R.afterLeft = %R.cur
  br label %after.recurse

recurse.right:                                        ; preds = %partition.done
  %needRight = icmp slt i64 %i.stop, %R.cur
  br i1 %needRight, label %call.right, label %skip.right

call.right:                                           ; preds = %recurse.right
  call void @quick_sort(i32* %base, i64 %i.stop, i64 %R.cur)
  br label %skip.right

skip.right:                                           ; preds = %call.right, %recurse.right
  %L.afterRight = %L.cur
  %R.afterRight = %j.cur
  br label %after.recurse

after.recurse:                                        ; preds = %skip.right, %skip.left
  %L.next.loop = phi i64 [ %L.afterLeft, %skip.left ], [ %L.afterRight, %skip.right ]
  %R.next.loop = phi i64 [ %R.afterLeft, %skip.left ], [ %R.afterRight, %skip.right ]
  br label %top.check

ret:                                                  ; preds = %top.check
  ret void
}

attributes #0 = { nounwind uwtable }