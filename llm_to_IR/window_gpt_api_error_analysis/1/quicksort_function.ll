; ModuleID = 'quick_sort_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @quick_sort(i32* nocapture %arr, i32 %l, i32 %r) local_unnamed_addr {
entry:
  br label %while.cond

while.cond:                                          ; preds = %while.cont, %entry
  %l.cur = phi i32 [ %l, %entry ], [ %l.updated, %while.cont ]
  %r.cur = phi i32 [ %r, %entry ], [ %r.updated, %while.cont ]
  %cmp0 = icmp slt i32 %l.cur, %r.cur
  br i1 %cmp0, label %partition.init, label %ret

partition.init:                                      ; preds = %while.cond
  %diff = sub i32 %r.cur, %l.cur
  %sign = lshr i32 %diff, 31
  %sum = add i32 %diff, %sign
  %half = ashr i32 %sum, 1
  %mid = add i32 %l.cur, %half
  %mid64 = sext i32 %mid to i64
  %gep.pivot = getelementptr inbounds i32, i32* %arr, i64 %mid64
  %pivot = load i32, i32* %gep.pivot, align 4
  br label %inc_i.loop

inc_i.loop:                                          ; preds = %loop.check.true, %inc_i.loop.inc, %partition.init
  %i.cur = phi i32 [ %l.cur, %partition.init ], [ %i.inc, %inc_i.loop.inc ], [ %i.cont, %loop.check.true ]
  %j.cur = phi i32 [ %r.cur, %partition.init ], [ %j.cur, %inc_i.loop.inc ], [ %j.cont, %loop.check.true ]
  %i64 = sext i32 %i.cur to i64
  %p_i = getelementptr inbounds i32, i32* %arr, i64 %i64
  %val_i = load i32, i32* %p_i, align 4
  %cmp_i = icmp sgt i32 %pivot, %val_i
  br i1 %cmp_i, label %inc_i.loop.inc, label %dec_j.loop

inc_i.loop.inc:                                      ; preds = %inc_i.loop
  %i.inc = add i32 %i.cur, 1
  br label %inc_i.loop

dec_j.loop:                                          ; preds = %inc_i.loop, %dec_j.loop.dec
  %i.fixed = phi i32 [ %i.cur, %inc_i.loop ], [ %i.cur, %dec_j.loop.dec ]
  %j.scan = phi i32 [ %j.cur, %inc_i.loop ], [ %j.dec, %dec_j.loop.dec ]
  %j64 = sext i32 %j.scan to i64
  %p_j = getelementptr inbounds i32, i32* %arr, i64 %j64
  %val_j = load i32, i32* %p_j, align 4
  %cmp_j = icmp slt i32 %pivot, %val_j
  br i1 %cmp_j, label %dec_j.loop.dec, label %check_and_maybe_swap

dec_j.loop.dec:                                      ; preds = %dec_j.loop
  %j.dec = add i32 %j.scan, -1
  br label %dec_j.loop

check_and_maybe_swap:                                ; preds = %dec_j.loop
  %cmp_ij = icmp sle i32 %i.fixed, %j.scan
  br i1 %cmp_ij, label %do_swap, label %loop.check

do_swap:                                             ; preds = %check_and_maybe_swap
  %i64b = sext i32 %i.fixed to i64
  %p_i2 = getelementptr inbounds i32, i32* %arr, i64 %i64b
  %tmp = load i32, i32* %p_i2, align 4
  %j64b = sext i32 %j.scan to i64
  %p_j2 = getelementptr inbounds i32, i32* %arr, i64 %j64b
  %valj2 = load i32, i32* %p_j2, align 4
  store i32 %valj2, i32* %p_i2, align 4
  store i32 %tmp, i32* %p_j2, align 4
  %i.after = add i32 %i.fixed, 1
  %j.after = add i32 %j.scan, -1
  br label %loop.check

loop.check:                                          ; preds = %do_swap, %check_and_maybe_swap
  %i.cont = phi i32 [ %i.after, %do_swap ], [ %i.fixed, %check_and_maybe_swap ]
  %j.cont = phi i32 [ %j.after, %do_swap ], [ %j.scan, %check_and_maybe_swap ]
  %cond_continue = icmp sle i32 %i.cont, %j.cont
  br i1 %cond_continue, label %loop.check.true, label %after_partition

loop.check.true:                                     ; preds = %loop.check
  br label %inc_i.loop

after_partition:                                     ; preds = %loop.check
  %i.final = phi i32 [ %i.cont, %loop.check ]
  %j.final = phi i32 [ %j.cont, %loop.check ]
  %left_size = sub i32 %j.final, %l.cur
  %right_size = sub i32 %r.cur, %i.final
  %cmp_choose = icmp slt i32 %left_size, %right_size
  br i1 %cmp_choose, label %recurse_left, label %recurse_right

recurse_left:                                        ; preds = %after_partition
  %cond_left_nonempty = icmp slt i32 %l.cur, %j.final
  br i1 %cond_left_nonempty, label %call_left, label %skip_left

call_left:                                           ; preds = %recurse_left
  call void @quick_sort(i32* %arr, i32 %l.cur, i32 %j.final)
  br label %skip_left

skip_left:                                           ; preds = %call_left, %recurse_left
  br label %while.cont

recurse_right:                                       ; preds = %after_partition
  %cond_right_nonempty = icmp slt i32 %i.final, %r.cur
  br i1 %cond_right_nonempty, label %call_right, label %skip_right

call_right:                                          ; preds = %recurse_right
  call void @quick_sort(i32* %arr, i32 %i.final, i32 %r.cur)
  br label %skip_right

skip_right:                                          ; preds = %call_right, %recurse_right
  br label %while.cont

while.cont:                                          ; preds = %skip_right, %skip_left
  %l.updated = phi i32 [ %i.final, %skip_left ], [ %l.cur, %skip_right ]
  %r.updated = phi i32 [ %r.cur, %skip_left ], [ %j.final, %skip_right ]
  br label %while.cond

ret:                                                 ; preds = %while.cond
  ret void
}