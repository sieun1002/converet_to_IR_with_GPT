; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @quick_sort(i32* %arr, i32 %left, i32 %right) {
entry:
  br label %while.cond

while.cond:                                           ; preds = %cont.right, %cont.left, %entry
  %l.phi = phi i32 [ %left, %entry ], [ %i.final, %cont.left ], [ %l.phi, %cont.right ]
  %r.phi = phi i32 [ %right, %entry ], [ %r.phi, %cont.left ], [ %j.final, %cont.right ]
  %cmp.lr = icmp slt i32 %l.phi, %r.phi
  br i1 %cmp.lr, label %partition.entry, label %return

partition.entry:                                      ; preds = %while.cond
  %diff = sub i32 %r.phi, %l.phi
  %sign = lshr i32 %diff, 31
  %tmp = add i32 %diff, %sign
  %half = ashr i32 %tmp, 1
  %mid = add i32 %l.phi, %half
  %mid64 = sext i32 %mid to i64
  %pivot.addr = getelementptr inbounds i32, i32* %arr, i64 %mid64
  %pivot = load i32, i32* %pivot.addr, align 4
  br label %left.scan

left.scan:                                            ; preds = %loop.continue, %left.inc, %partition.entry
  %i.phi = phi i32 [ %l.phi, %partition.entry ], [ %i.inc, %left.inc ], [ %i2, %loop.continue ]
  %j.phi = phi i32 [ %r.phi, %partition.entry ], [ %j.phi, %left.inc ], [ %j2, %loop.continue ]
  %i64 = sext i32 %i.phi to i64
  %addr.i = getelementptr inbounds i32, i32* %arr, i64 %i64
  %val.i = load i32, i32* %addr.i, align 4
  %cmp.left = icmp slt i32 %val.i, %pivot
  br i1 %cmp.left, label %left.inc, label %right.scan

left.inc:                                             ; preds = %left.scan
  %i.inc = add i32 %i.phi, 1
  br label %left.scan

right.scan:                                           ; preds = %right.dec, %left.scan
  %i.rs = phi i32 [ %i.phi, %left.scan ], [ %i.rs, %right.dec ]
  %j.rs = phi i32 [ %j.phi, %left.scan ], [ %j.dec, %right.dec ]
  %j64 = sext i32 %j.rs to i64
  %addr.j = getelementptr inbounds i32, i32* %arr, i64 %j64
  %val.j = load i32, i32* %addr.j, align 4
  %cmp.right = icmp sgt i32 %val.j, %pivot
  br i1 %cmp.right, label %right.dec, label %cmp.ij

right.dec:                                            ; preds = %right.scan
  %j.dec = add i32 %j.rs, -1
  br label %right.scan

cmp.ij:                                               ; preds = %right.scan
  %cmp.ijcond = icmp sle i32 %i.rs, %j.rs
  br i1 %cmp.ijcond, label %do.swap, label %after.partition

do.swap:                                              ; preds = %cmp.ij
  %i64b = sext i32 %i.rs to i64
  %addr.i.b = getelementptr inbounds i32, i32* %arr, i64 %i64b
  %tmp.val = load i32, i32* %addr.i.b, align 4
  %j64b = sext i32 %j.rs to i64
  %addr.j.b = getelementptr inbounds i32, i32* %arr, i64 %j64b
  %val.j2 = load i32, i32* %addr.j.b, align 4
  store i32 %val.j2, i32* %addr.i.b, align 4
  store i32 %tmp.val, i32* %addr.j.b, align 4
  %i2 = add i32 %i.rs, 1
  %j2 = add i32 %j.rs, -1
  %cmp.loop = icmp sle i32 %i2, %j2
  br i1 %cmp.loop, label %loop.continue, label %after.partition2

loop.continue:                                        ; preds = %do.swap
  br label %left.scan

after.partition:                                      ; preds = %cmp.ij
  br label %after.partition.join

after.partition2:                                     ; preds = %do.swap
  br label %after.partition.join

after.partition.join:                                 ; preds = %after.partition2, %after.partition
  %i.final = phi i32 [ %i.rs, %after.partition ], [ %i2, %after.partition2 ]
  %j.final = phi i32 [ %j.rs, %after.partition ], [ %j2, %after.partition2 ]
  %left.size = sub i32 %j.final, %l.phi
  %right.size = sub i32 %r.phi, %i.final
  %cmp.sizes = icmp sge i32 %left.size, %right.size
  br i1 %cmp.sizes, label %rightFirst, label %leftFirst

leftFirst:                                            ; preds = %after.partition.join
  %condL = icmp slt i32 %l.phi, %j.final
  br i1 %condL, label %call.left, label %leftFirst.cont

call.left:                                            ; preds = %leftFirst
  call void @quick_sort(i32* %arr, i32 %l.phi, i32 %j.final)
  br label %leftFirst.cont

leftFirst.cont:                                       ; preds = %call.left, %leftFirst
  br label %cont.left

cont.left:                                            ; preds = %leftFirst.cont
  br label %while.cond

rightFirst:                                           ; preds = %after.partition.join
  %condR = icmp slt i32 %i.final, %r.phi
  br i1 %condR, label %call.right, label %rightFirst.cont

call.right:                                           ; preds = %rightFirst
  call void @quick_sort(i32* %arr, i32 %i.final, i32 %r.phi)
  br label %rightFirst.cont

rightFirst.cont:                                      ; preds = %call.right, %rightFirst
  br label %cont.right

cont.right:                                           ; preds = %rightFirst.cont
  br label %while.cond

return:                                               ; preds = %while.cond
  ret void
}