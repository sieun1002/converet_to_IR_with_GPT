; ModuleID = 'quick_sort'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @quick_sort(i32* %arr, i32 %lo, i32 %hi) {
entry:
  br label %outer.loop

outer.loop:
  %lo.cur = phi i32 [ %lo, %entry ], [ %lo.next, %outer.cont ]
  %hi.cur = phi i32 [ %hi, %entry ], [ %hi.next, %outer.cont ]
  %cmp.outer = icmp slt i32 %lo.cur, %hi.cur
  br i1 %cmp.outer, label %partition.init, label %exit

partition.init:
  %diff = sub nsw i32 %hi.cur, %lo.cur
  %shr31 = lshr i32 %diff, 31
  %adj = add i32 %diff, %shr31
  %half = ashr i32 %adj, 1
  %mid = add i32 %lo.cur, %half
  %mid.ext = sext i32 %mid to i64
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid.ext
  %pivot = load i32, i32* %mid.ptr, align 4
  br label %loop.i

loop.i:
  %i.var = phi i32 [ %lo.cur, %partition.init ], [ %i.next, %inc.i ], [ %i.cont, %scan.reenter ]
  %j.const = phi i32 [ %hi.cur, %partition.init ], [ %j.const, %inc.i ], [ %j.cont, %scan.reenter ]
  %i.idx = sext i32 %i.var to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp sgt i32 %pivot, %i.val
  br i1 %cmp.i, label %inc.i, label %after.i

inc.i:
  %i.next = add nsw i32 %i.var, 1
  br label %loop.i

after.i:
  br label %loop.j

loop.j:
  %j.var = phi i32 [ %j.const, %after.i ], [ %j.next, %dec.j ]
  %i.pass = phi i32 [ %i.var, %after.i ], [ %i.pass, %dec.j ]
  %j.idx = sext i32 %j.var to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp slt i32 %pivot, %j.val
  br i1 %cmp.j, label %dec.j, label %after.j

dec.j:
  %j.next = add nsw i32 %j.var, -1
  br label %loop.j

after.j:
  %i_gt_j = icmp sgt i32 %i.pass, %j.var
  br i1 %i_gt_j, label %part.check, label %do.swap

do.swap:
  %i.idx.b = sext i32 %i.pass to i64
  %i.ptr.b = getelementptr inbounds i32, i32* %arr, i64 %i.idx.b
  %tmp = load i32, i32* %i.ptr.b, align 4
  %j.idx.b = sext i32 %j.var to i64
  %j.ptr.b = getelementptr inbounds i32, i32* %arr, i64 %j.idx.b
  %valj = load i32, i32* %j.ptr.b, align 4
  store i32 %valj, i32* %i.ptr.b, align 4
  store i32 %tmp, i32* %j.ptr.b, align 4
  %i.after = add nsw i32 %i.pass, 1
  %j.after = add nsw i32 %j.var, -1
  br label %part.check

part.check:
  %i.cont = phi i32 [ %i.after, %do.swap ], [ %i.pass, %after.j ]
  %j.cont = phi i32 [ %j.after, %do.swap ], [ %j.var, %after.j ]
  %i_le_j = icmp sle i32 %i.cont, %j.cont
  br i1 %i_le_j, label %scan.reenter, label %choose

scan.reenter:
  br label %loop.i

choose:
  %leftLen = sub nsw i32 %j.cont, %lo.cur
  %rightLen = sub nsw i32 %hi.cur, %i.cont
  %left_ge_right = icmp sge i32 %leftLen, %rightLen
  br i1 %left_ge_right, label %case.rightFirst, label %case.leftFirst

case.leftFirst:
  %lo_lt_j = icmp slt i32 %lo.cur, %j.cont
  br i1 %lo_lt_j, label %call.left, label %skip.left

call.left:
  call void @quick_sort(i32* %arr, i32 %lo.cur, i32 %j.cont)
  br label %after.left

skip.left:
  br label %after.left

after.left:
  br label %outer.cont

case.rightFirst:
  %i_lt_hi = icmp slt i32 %i.cont, %hi.cur
  br i1 %i_lt_hi, label %call.right, label %skip.right

call.right:
  call void @quick_sort(i32* %arr, i32 %i.cont, i32 %hi.cur)
  br label %after.right

skip.right:
  br label %after.right

after.right:
  br label %outer.cont

outer.cont:
  %lo.next = phi i32 [ %i.cont, %after.left ], [ %lo.cur, %after.right ]
  %hi.next = phi i32 [ %hi.cur, %after.left ], [ %j.cont, %after.right ]
  br label %outer.loop

exit:
  ret void
}