; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @quick_sort(i32* %arr, i32 %left, i32 %right) local_unnamed_addr {
entry:
  br label %loop.check

loop.check:                                          ; corresponds to loc_1400015B7
  %left.cur = phi i32 [ %left, %entry ], [ %i.end.l, %after.left.set ], [ %left.pass.r, %after.right.set ]
  %right.cur = phi i32 [ %right, %entry ], [ %right.pass.l, %after.left.set ], [ %j.end.r, %after.right.set ]
  %cmp.lr = icmp slt i32 %left.cur, %right.cur
  br i1 %cmp.lr, label %part.entry, label %exit

part.entry:                                          ; corresponds to loc_140001468 setup
  %i.init = add i32 %left.cur, 0
  %j.init = add i32 %right.cur, 0
  %delta = sub i32 %right.cur, %left.cur
  %shr31 = lshr i32 %delta, 31
  %addshr = add i32 %delta, %shr31
  %midoff = ashr i32 %addshr, 1
  %mididx = add i32 %left.cur, %midoff
  %mididx64 = sext i32 %mididx to i64
  %ptr.mid = getelementptr inbounds i32, i32* %arr, i64 %mididx64
  %pivot = load i32, i32* %ptr.mid, align 4
  br label %inc_i

inc_i:                                               ; corresponds to loc_1400014A6
  %i.cur = phi i32 [ %i.init, %part.entry ], [ %i.next, %inc_i.inc ], [ %i.after, %part.after ]
  %j.cur = phi i32 [ %j.init, %part.entry ], [ %j.pass.inc, %inc_i.inc ], [ %j.after, %part.after ]
  %i64 = sext i32 %i.cur to i64
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i64
  %val.i = load i32, i32* %ptr.i, align 4
  %cmp.i = icmp sgt i32 %pivot, %val.i
  br i1 %cmp.i, label %inc_i.inc, label %dec_j

inc_i.inc:                                           ; corresponds to loc_1400014A2
  %i.next = add i32 %i.cur, 1
  %j.pass.inc = add i32 %j.cur, 0
  br label %inc_i

dec_j:                                               ; corresponds to loc_1400014C7
  %j.cur2 = phi i32 [ %j.cur, %inc_i ], [ %j.next, %dec_j.dec ]
  %i.hold = phi i32 [ %i.cur, %inc_i ], [ %i.hold.pass, %dec_j.dec ]
  %j64 = sext i32 %j.cur2 to i64
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j64
  %val.j = load i32, i32* %ptr.j, align 4
  %cmp.j = icmp slt i32 %pivot, %val.j
  br i1 %cmp.j, label %dec_j.dec, label %compare_ij

dec_j.dec:                                           ; corresponds to loc_1400014C3
  %j.next = add i32 %j.cur2, -1
  %i.hold.pass = add i32 %i.hold, 0
  br label %dec_j

compare_ij:                                          ; compare i and j
  %cond.gt = icmp sgt i32 %i.hold, %j.cur2
  br i1 %cond.gt, label %part.after, label %swap

swap:                                                ; corresponds to swap block around 0x1400014EA-0x14000154D
  %i64.s = sext i32 %i.hold to i64
  %ptr.i.s = getelementptr inbounds i32, i32* %arr, i64 %i64.s
  %tmp = load i32, i32* %ptr.i.s, align 4
  %j64.s = sext i32 %j.cur2 to i64
  %ptr.j.s = getelementptr inbounds i32, i32* %arr, i64 %j64.s
  %val.j.s = load i32, i32* %ptr.j.s, align 4
  store i32 %val.j.s, i32* %ptr.i.s, align 4
  store i32 %tmp, i32* %ptr.j.s, align 4
  %i.inc.after = add i32 %i.hold, 1
  %j.dec.after = add i32 %j.cur2, -1
  br label %part.after

part.after:                                          ; corresponds to loc_140001551
  %i.after = phi i32 [ %i.hold, %compare_ij ], [ %i.inc.after, %swap ]
  %j.after = phi i32 [ %j.cur2, %compare_ij ], [ %j.dec.after, %swap ]
  %cond.le = icmp sle i32 %i.after, %j.after
  br i1 %cond.le, label %inc_i, label %branch.select

branch.select:                                       ; corresponds to 0x14000155D decision
  %leftlen = sub i32 %j.after, %left.cur
  %rightlen = sub i32 %right.cur, %i.after
  %cmp.len = icmp sge i32 %leftlen, %rightlen
  br i1 %cmp.len, label %right.first, label %left.first

left.first:                                          ; corresponds to 0x14000156F..0x14000158C
  %cond.leftcall = icmp slt i32 %left.cur, %j.after
  br i1 %cond.leftcall, label %left.call, label %left.set

left.call:
  call void @quick_sort(i32* %arr, i32 %left.cur, i32 %j.after)
  br label %left.set

left.set:
  %i.end.l = phi i32 [ %i.after, %left.call ], [ %i.after, %left.first ]
  %right.pass.l = add i32 %right.cur, 0
  br label %after.left.set

after.left.set:
  br label %loop.check

right.first:                                         ; corresponds to 0x140001594..0x1400015B1
  %cond.rightcall = icmp slt i32 %i.after, %right.cur
  br i1 %cond.rightcall, label %right.call, label %right.set

right.call:
  call void @quick_sort(i32* %arr, i32 %i.after, i32 %right.cur)
  br label %right.set

right.set:
  %j.end.r = phi i32 [ %j.after, %right.call ], [ %j.after, %right.first ]
  %left.pass.r = add i32 %left.cur, 0
  br label %after.right.set

after.right.set:
  br label %loop.check

exit:
  ret void
}