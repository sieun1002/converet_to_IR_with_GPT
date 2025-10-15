; ModuleID = 'heap_sort_module'
source_filename = "heap_sort.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define void @heap_sort(i32* noundef %arr, i64 noundef %n) local_unnamed_addr {
entry:
  %cmp1 = icmp ule i64 %n, 1
  br i1 %cmp1, label %ret, label %build.init

build.init:
  %i.init = lshr i64 %n, 1
  br label %build.dec

build.dec:
  %i.cur = phi i64 [ %i.init, %build.init ], [ %i.next, %build.body_end ]
  %cond = icmp ne i64 %i.cur, 0
  br i1 %cond, label %build.body, label %phase2.init

build.body:
  %j0 = add i64 %i.cur, -1
  br label %bd.header

bd.header:
  %j = phi i64 [ %j0, %build.body ], [ %j.next, %bd.swap_done ]
  %twice = add i64 %j, %j
  %left = add i64 %twice, 1
  %hasLeft = icmp ult i64 %left, %n
  br i1 %hasLeft, label %bd.hasLeft, label %build.body_end

bd.hasLeft:
  %right = add i64 %left, 1
  %hasRight = icmp ult i64 %right, %n
  br i1 %hasRight, label %bd.loadRightLeft, label %bd.chooseLeft

bd.loadRightLeft:
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  %gt = icmp sgt i32 %right.val, %left.val
  br i1 %gt, label %bd.chooseRight, label %bd.chooseLeft

bd.chooseRight:
  br label %bd.childChosen

bd.chooseLeft:
  br label %bd.childChosen

bd.childChosen:
  %largestChild = phi i64 [ %right, %bd.chooseRight ], [ %left, %bd.chooseLeft ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j.val = load i32, i32* %j.ptr, align 4
  %lc.ptr = getelementptr inbounds i32, i32* %arr, i64 %largestChild
  %lc.val = load i32, i32* %lc.ptr, align 4
  %lt = icmp slt i32 %j.val, %lc.val
  br i1 %lt, label %bd.doSwap, label %build.body_end

bd.doSwap:
  store i32 %lc.val, i32* %j.ptr, align 4
  store i32 %j.val, i32* %lc.ptr, align 4
  %j.next = add i64 %largestChild, 0
  br label %bd.swap_done

bd.swap_done:
  br label %bd.header

build.body_end:
  %i.next = add i64 %i.cur, -1
  br label %build.dec

phase2.init:
  %heap0 = add i64 %n, -1
  br label %ex.loop.cond

ex.loop.cond:
  %heap = phi i64 [ %heap0, %phase2.init ], [ %heap.next, %ex.iter_end ]
  %notZero = icmp ne i64 %heap, 0
  br i1 %notZero, label %ex.iter, label %ret

ex.iter:
  %root.ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root.val = load i32, i32* %root.ptr, align 4
  %end.ptr = getelementptr inbounds i32, i32* %arr, i64 %heap
  %end.val = load i32, i32* %end.ptr, align 4
  store i32 %end.val, i32* %root.ptr, align 4
  store i32 %root.val, i32* %end.ptr, align 4
  br label %ex.bd.header

ex.bd.header:
  %j2 = phi i64 [ 0, %ex.iter ], [ %j2.next, %ex.bd.swap_done ]
  %twice2 = add i64 %j2, %j2
  %left2 = add i64 %twice2, 1
  %hasLeft2 = icmp ult i64 %left2, %heap
  br i1 %hasLeft2, label %ex.bd.hasLeft, label %ex.iter_end

ex.bd.hasLeft:
  %right2 = add i64 %left2, 1
  %hasRight2 = icmp ult i64 %right2, %heap
  br i1 %hasRight2, label %ex.bd.loadRightLeft, label %ex.bd.chooseLeft

ex.bd.loadRightLeft:
  %right2.ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2.val = load i32, i32* %right2.ptr, align 4
  %left2.ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2.val = load i32, i32* %left2.ptr, align 4
  %gt2 = icmp sgt i32 %right2.val, %left2.val
  br i1 %gt2, label %ex.bd.chooseRight, label %ex.bd.chooseLeft

ex.bd.chooseRight:
  br label %ex.bd.childChosen

ex.bd.chooseLeft:
  br label %ex.bd.childChosen

ex.bd.childChosen:
  %largestChild2 = phi i64 [ %right2, %ex.bd.chooseRight ], [ %left2, %ex.bd.chooseLeft ]
  %j2.ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j2.val = load i32, i32* %j2.ptr, align 4
  %lc2.ptr = getelementptr inbounds i32, i32* %arr, i64 %largestChild2
  %lc2.val = load i32, i32* %lc2.ptr, align 4
  %lt2 = icmp slt i32 %j2.val, %lc2.val
  br i1 %lt2, label %ex.bd.doSwap, label %ex.iter_end

ex.bd.doSwap:
  store i32 %lc2.val, i32* %j2.ptr, align 4
  store i32 %j2.val, i32* %lc2.ptr, align 4
  %j2.next = add i64 %largestChild2, 0
  br label %ex.bd.swap_done

ex.bd.swap_done:
  br label %ex.bd.header

ex.iter_end:
  %heap.next = add i64 %heap, -1
  br label %ex.loop.cond

ret:
  ret void
}