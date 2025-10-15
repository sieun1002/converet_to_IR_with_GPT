; ModuleID = 'quick_sort_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @quick_sort(i32* nocapture %arr, i32 %lo, i32 %hi) local_unnamed_addr nounwind {
entry:
  br label %while.cond

while.cond:
  %lo.phi = phi i32 [ %lo, %entry ], [ %lo.next, %while.update ]
  %hi.phi = phi i32 [ %hi, %entry ], [ %hi.next, %while.update ]
  %cmp0 = icmp slt i32 %lo.phi, %hi.phi
  br i1 %cmp0, label %partition.entry, label %while.end

partition.entry:
  %i.init = add nsw i32 %lo.phi, 0
  %j.init = add nsw i32 %hi.phi, 0
  %diff = sub nsw i32 %hi.phi, %lo.phi
  %half = ashr i32 %diff, 1
  %mid = add nsw i32 %lo.phi, %half
  %mid.ext = sext i32 %mid to i64
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid.ext
  %pivot = load i32, i32* %mid.ptr, align 4
  br label %inc_i.loop

inc_i.loop:
  %i.cur = phi i32 [ %i.init, %partition.entry ], [ %i.next, %inc_i.step ], [ %i.next.swap, %after.swap ]
  %j.for.i = phi i32 [ %j.init, %partition.entry ], [ %j.for.i, %inc_i.step ], [ %j.next.swap, %after.swap ]
  %i.ext = sext i32 %i.cur to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %i.val, %pivot
  br i1 %cmp.i, label %inc_i.step, label %dec_j.loop.entry

inc_i.step:
  %i.next = add nsw i32 %i.cur, 1
  br label %inc_i.loop

dec_j.loop.entry:
  br label %dec_j.loop

dec_j.loop:
  %i.for.j = phi i32 [ %i.cur, %dec_j.loop.entry ], [ %i.for.j, %dec_j.step ]
  %j.cur = phi i32 [ %j.for.i, %dec_j.loop.entry ], [ %j.prev, %dec_j.step ]
  %j.ext = sext i32 %j.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp sgt i32 %j.val, %pivot
  br i1 %cmp.j, label %dec_j.step, label %after.move.ij

dec_j.step:
  %j.prev = add nsw i32 %j.cur, -1
  br label %dec_j.loop

after.move.ij:
  %cmp.ij = icmp sle i32 %i.for.j, %j.cur
  br i1 %cmp.ij, label %after.swap, label %partition.done

after.swap:
  %i.swap.ext = sext i32 %i.for.j to i64
  %j.swap.ext = sext i32 %j.cur to i64
  %i.swap.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.swap.ext
  %j.swap.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.swap.ext
  %val.i = load i32, i32* %i.swap.ptr, align 4
  %val.j = load i32, i32* %j.swap.ptr, align 4
  store i32 %val.j, i32* %i.swap.ptr, align 4
  store i32 %val.i, i32* %j.swap.ptr, align 4
  %i.next.swap = add nsw i32 %i.for.j, 1
  %j.next.swap = add nsw i32 %j.cur, -1
  br label %inc_i.loop

partition.done:
  %i.final = phi i32 [ %i.for.j, %after.move.ij ]
  %j.final = phi i32 [ %j.cur, %after.move.ij ]
  %left.len = sub nsw i32 %j.final, %lo.phi
  %right.len = sub nsw i32 %hi.phi, %i.final
  %cmp.len = icmp slt i32 %left.len, %right.len
  br i1 %cmp.len, label %left.smaller, label %right.smaller

left.smaller:
  %cond.left = icmp slt i32 %lo.phi, %j.final
  br i1 %cond.left, label %call.left, label %skip.left

call.left:
  call void @quick_sort(i32* %arr, i32 %lo.phi, i32 %j.final)
  br label %skip.left

skip.left:
  %lo.nextA = add nsw i32 %i.final, 0
  %hi.nextA = add nsw i32 %hi.phi, 0
  br label %while.update

right.smaller:
  %cond.right = icmp slt i32 %i.final, %hi.phi
  br i1 %cond.right, label %call.right, label %skip.right

call.right:
  call void @quick_sort(i32* %arr, i32 %i.final, i32 %hi.phi)
  br label %skip.right

skip.right:
  %lo.nextB = add nsw i32 %lo.phi, 0
  %hi.nextB = add nsw i32 %j.final, 0
  br label %while.update

while.update:
  %lo.next = phi i32 [ %lo.nextA, %skip.left ], [ %lo.nextB, %skip.right ]
  %hi.next = phi i32 [ %hi.nextA, %skip.left ], [ %hi.nextB, %skip.right ]
  br label %while.cond

while.end:
  ret void
}