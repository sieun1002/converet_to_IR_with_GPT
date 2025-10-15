; ModuleID = 'quick_sort'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @quick_sort(i32* nocapture %arr, i64 %lo, i64 %hi) {
entry:
  br label %while.cond

while.cond:
  %lo.cur = phi i64 [ %lo, %entry ], [ %lo.next, %continue ]
  %hi.cur = phi i64 [ %hi, %entry ], [ %hi.next, %continue ]
  %cmp0 = icmp slt i64 %lo.cur, %hi.cur
  br i1 %cmp0, label %partition.init, label %end

partition.init:
  %delta = sub i64 %hi.cur, %lo.cur
  %shr.sign = lshr i64 %delta, 63
  %adj = add i64 %delta, %shr.sign
  %half = ashr i64 %adj, 1
  %mid = add i64 %lo.cur, %half
  %i.init = add i64 %lo.cur, 0
  %j.init = add i64 %hi.cur, 0
  %gep.mid = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %gep.mid, align 4
  br label %part.loop.header

part.loop.header:
  %i.ph = phi i64 [ %i.init, %partition.init ], [ %i.after.swap, %swap.cont.back ]
  %j.ph = phi i64 [ %j.init, %partition.init ], [ %j.after.swap, %swap.cont.back ]
  br label %inc.i.loop

inc.i.loop:
  %i.cur = phi i64 [ %i.ph, %part.loop.header ], [ %i.inc, %inc.i.body ]
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %val.i = load i32, i32* %gep.i, align 4
  %lt = icmp slt i32 %val.i, %pivot
  br i1 %lt, label %inc.i.body, label %inc.i.done

inc.i.body:
  %i.inc = add i64 %i.cur, 1
  br label %inc.i.loop

inc.i.done:
  br label %dec.j.loop

dec.j.loop:
  %i.fin = phi i64 [ %i.cur, %inc.i.done ], [ %i.fin, %dec.j.body ]
  %j.cur = phi i64 [ %j.ph, %inc.i.done ], [ %j.dec, %dec.j.body ]
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %val.j = load i32, i32* %gep.j, align 4
  %gt = icmp sgt i32 %val.j, %pivot
  br i1 %gt, label %dec.j.body, label %dec.j.done

dec.j.body:
  %j.dec = sub i64 %j.cur, 1
  br label %dec.j.loop

dec.j.done:
  %cmp.le = icmp sle i64 %i.fin, %j.cur
  br i1 %cmp.le, label %do.swap, label %part.exit.no.swap

do.swap:
  %gep.i2 = getelementptr inbounds i32, i32* %arr, i64 %i.fin
  %a = load i32, i32* %gep.i2, align 4
  %gep.j2 = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %b = load i32, i32* %gep.j2, align 4
  store i32 %b, i32* %gep.i2, align 4
  store i32 %a, i32* %gep.j2, align 4
  %i.after.swap = add i64 %i.fin, 1
  %j.after.swap = sub i64 %j.cur, 1
  %cmp.after = icmp sle i64 %i.after.swap, %j.after.swap
  br i1 %cmp.after, label %swap.cont.back, label %part.exit.with.swap

swap.cont.back:
  br label %part.loop.header

part.exit.with.swap:
  br label %part.exit

part.exit.no.swap:
  br label %part.exit

part.exit:
  %i.exit = phi i64 [ %i.after.swap, %part.exit.with.swap ], [ %i.fin, %part.exit.no.swap ]
  %j.exit = phi i64 [ %j.after.swap, %part.exit.with.swap ], [ %j.cur, %part.exit.no.swap ]
  %left.len = sub i64 %j.exit, %lo.cur
  %right.len = sub i64 %hi.cur, %i.exit
  %left.ge.right = icmp sge i64 %left.len, %right.len
  br i1 %left.ge.right, label %right.first, label %left.first

left.first:
  %need.left = icmp slt i64 %lo.cur, %j.exit
  br i1 %need.left, label %call.left, label %left.skip

call.left:
  call void @quick_sort(i32* %arr, i64 %lo.cur, i64 %j.exit)
  br label %left.skip

left.skip:
  %lo.next.left = add i64 %i.exit, 0
  %hi.next.left = add i64 %hi.cur, 0
  br label %continue

right.first:
  %need.right = icmp slt i64 %i.exit, %hi.cur
  br i1 %need.right, label %call.right, label %right.skip

call.right:
  call void @quick_sort(i32* %arr, i64 %i.exit, i64 %hi.cur)
  br label %right.skip

right.skip:
  %lo.next.right = add i64 %lo.cur, 0
  %hi.next.right = add i64 %j.exit, 0
  br label %continue

continue:
  %lo.next = phi i64 [ %lo.next.left, %left.skip ], [ %lo.next.right, %right.skip ]
  %hi.next = phi i64 [ %hi.next.left, %left.skip ], [ %hi.next.right, %right.skip ]
  br label %while.cond

end:
  ret void
}