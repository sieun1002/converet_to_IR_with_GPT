; ModuleID = 'quick_sort.ll'
target triple = "x86_64-unknown-linux-gnu"

define void @quick_sort(i32* %arr, i64 %l, i64 %r) {
entry:
  %cmp0 = icmp sge i64 %l, %r
  br i1 %cmp0, label %ret, label %outer.loop

outer.loop:
  %L = phi i64 [ %l, %entry ], [ %L.next.r, %loop.latch.right ], [ %L.next.l, %loop.latch.left ]
  %R = phi i64 [ %r, %entry ], [ %R.next.r, %loop.latch.right ], [ %R.next.l, %loop.latch.left ]
  %diff = sub i64 %R, %L
  %half = ashr i64 %diff, 1
  %mid = add i64 %L, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %part.outer

part.outer:
  %i0 = phi i64 [ %L, %outer.loop ], [ %i.next, %do.swap ]
  %j0 = phi i64 [ %R, %outer.loop ], [ %j.next, %do.swap ]
  br label %adv.i

adv.i:
  %i1 = phi i64 [ %i0, %part.outer ], [ %i.inc, %adv.i.cont ]
  %ai.ptr = getelementptr inbounds i32, i32* %arr, i64 %i1
  %ai = load i32, i32* %ai.ptr, align 4
  %cmp.ai = icmp slt i32 %ai, %pivot
  br i1 %cmp.ai, label %adv.i.cont, label %adv.j.entry

adv.i.cont:
  %i.inc = add i64 %i1, 1
  br label %adv.i

adv.j.entry:
  %i2 = phi i64 [ %i1, %adv.i ]
  %ai2 = phi i32 [ %ai, %adv.i ]
  br label %adv.j

adv.j:
  %j1 = phi i64 [ %j0, %adv.j.entry ], [ %j.dec, %adv.j.cont ]
  %aj.ptr = getelementptr inbounds i32, i32* %arr, i64 %j1
  %aj = load i32, i32* %aj.ptr, align 4
  %cmp.aj = icmp sgt i32 %aj, %pivot
  br i1 %cmp.aj, label %adv.j.cont, label %check.swap

adv.j.cont:
  %j.dec = add i64 %j1, -1
  br label %adv.j

check.swap:
  %cmp.ilej = icmp sle i64 %i2, %j1
  br i1 %cmp.ilej, label %do.swap, label %part.done

do.swap:
  store i32 %aj, i32* %ai.ptr, align 4
  store i32 %ai2, i32* %aj.ptr, align 4
  %i.next = add i64 %i2, 1
  %j.next = add i64 %j1, -1
  br label %part.outer

part.done:
  br label %choose

choose:
  %i.final = phi i64 [ %i2, %part.done ]
  %j.final = phi i64 [ %j1, %part.done ]
  %left.sz = sub i64 %j.final, %L
  %right.sz = sub i64 %R, %i.final
  %cmp.left.ge.right = icmp sge i64 %left.sz, %right.sz
  br i1 %cmp.left.ge.right, label %right.first, label %left.first

right.first:
  %need.right = icmp slt i64 %i.final, %R
  br i1 %need.right, label %call.right, label %skip.right

call.right:
  call void @quick_sort(i32* %arr, i64 %i.final, i64 %R)
  br label %update.right

skip.right:
  br label %update.right

update.right:
  %L.right.next = phi i64 [ %L, %call.right ], [ %L, %skip.right ]
  %R.right.next = phi i64 [ %j.final, %call.right ], [ %j.final, %skip.right ]
  br label %loop.latch.right

loop.latch.right:
  %L.next.r = phi i64 [ %L.right.next, %update.right ]
  %R.next.r = phi i64 [ %R.right.next, %update.right ]
  %cont.r = icmp slt i64 %L.next.r, %R.next.r
  br i1 %cont.r, label %outer.loop, label %ret

left.first:
  %need.left = icmp slt i64 %L, %j.final
  br i1 %need.left, label %call.left, label %skip.left

call.left:
  call void @quick_sort(i32* %arr, i64 %L, i64 %j.final)
  br label %update.left

skip.left:
  br label %update.left

update.left:
  %L.left.next = phi i64 [ %i.final, %call.left ], [ %i.final, %skip.left ]
  %R.left.next = phi i64 [ %R, %call.left ], [ %R, %skip.left ]
  br label %loop.latch.left

loop.latch.left:
  %L.next.l = phi i64 [ %L.left.next, %update.left ]
  %R.next.l = phi i64 [ %R.left.next, %update.left ]
  %cont.l = icmp slt i64 %L.next.l, %R.next.l
  br i1 %cont.l, label %outer.loop, label %ret

ret:
  ret void
}