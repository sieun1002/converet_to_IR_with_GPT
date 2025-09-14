; target: x86_64 SysV (GNU/Linux)
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8* nocapture)
declare i8* @memcpy(i8* noalias, i8* noalias, i64)

define void @merge_sort(i32* nocapture %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp.small = icmp ule i64 %n, 1
  br i1 %cmp.small, label %ret, label %alloc

alloc:
  %size.bytes = shl i64 %n, 2
  %raw = call noalias i8* @malloc(i64 %size.bytes)
  %isnull = icmp eq i8* %raw, null
  br i1 %isnull, label %ret, label %init

init:
  %tmpbuf0 = bitcast i8* %raw to i32*
  br label %outer.cond

outer.cond:
  %src.cur = phi i32* [ %dest, %init ], [ %src.next, %after.inner ]
  %tmp.cur = phi i32* [ %tmpbuf0, %init ], [ %tmp.next, %after.inner ]
  %run.cur = phi i64 [ 1, %init ], [ %run.dbl, %after.inner ]
  %run.lt.n = icmp ult i64 %run.cur, %n
  br i1 %run.lt.n, label %outer.body.entry, label %outer.done

outer.body.entry:
  br label %inner.cond

inner.cond:
  %idx.cur = phi i64 [ 0, %outer.body.entry ], [ %idx.next, %inner.done ]
  %idx.lt.n = icmp ult i64 %idx.cur, %n
  br i1 %idx.lt.n, label %merge.prep, label %after.inner

merge.prep:
  %l = add i64 %idx.cur, 0
  %idx.plus.run = add i64 %idx.cur, %run.cur
  %m.cmp = icmp ult i64 %idx.plus.run, %n
  %m = select i1 %m.cmp, i64 %idx.plus.run, i64 %n
  %two.run = shl i64 %run.cur, 1
  %idx.plus.tworun = add i64 %idx.cur, %two.run
  %r.cmp = icmp ult i64 %idx.plus.tworun, %n
  %r.end = select i1 %r.cmp, i64 %idx.plus.tworun, i64 %n
  br label %merge.loop

merge.loop:
  %i.cur = phi i64 [ %l, %merge.prep ], [ %i.next, %merge.iter.end ]
  %j.cur = phi i64 [ %m, %merge.prep ], [ %j.next, %merge.iter.end ]
  %k.cur = phi i64 [ %l, %merge.prep ], [ %k.next, %merge.iter.end ]
  %k.lt.rend = icmp ult i64 %k.cur, %r.end
  br i1 %k.lt.rend, label %choose, label %inner.done

choose:
  %i.lt.m = icmp ult i64 %i.cur, %m
  br i1 %i.lt.m, label %check.right, label %take.right

check.right:
  %j.lt.rend = icmp ult i64 %j.cur, %r.end
  br i1 %j.lt.rend, label %compare.vals, label %take.left

compare.vals:
  %ptr.i = getelementptr inbounds i32, i32* %src.cur, i64 %i.cur
  %val.i = load i32, i32* %ptr.i, align 4
  %ptr.j = getelementptr inbounds i32, i32* %src.cur, i64 %j.cur
  %val.j = load i32, i32* %ptr.j, align 4
  %le.ij = icmp sle i32 %val.i, %val.j
  br i1 %le.ij, label %take.left, label %take.right

take.left:
  %ptr.i.tl = getelementptr inbounds i32, i32* %src.cur, i64 %i.cur
  %val.i.tl = load i32, i32* %ptr.i.tl, align 4
  %ptr.k.tl = getelementptr inbounds i32, i32* %tmp.cur, i64 %k.cur
  store i32 %val.i.tl, i32* %ptr.k.tl, align 4
  %i.inc = add i64 %i.cur, 1
  %k.inc.l = add i64 %k.cur, 1
  br label %merge.iter.end

take.right:
  %ptr.j.tr = getelementptr inbounds i32, i32* %src.cur, i64 %j.cur
  %val.j.tr = load i32, i32* %ptr.j.tr, align 4
  %ptr.k.tr = getelementptr inbounds i32, i32* %tmp.cur, i64 %k.cur
  store i32 %val.j.tr, i32* %ptr.k.tr, align 4
  %j.inc = add i64 %j.cur, 1
  %k.inc.r = add i64 %k.cur, 1
  br label %merge.iter.end

merge.iter.end:
  %i.next = phi i64 [ %i.inc, %take.left ], [ %i.cur, %take.right ]
  %j.next = phi i64 [ %j.cur, %take.left ], [ %j.inc, %take.right ]
  %k.next = phi i64 [ %k.inc.l, %take.left ], [ %k.inc.r, %take.right ]
  br label %merge.loop

inner.done:
  %idx.step = shl i64 %run.cur, 1
  %idx.next = add i64 %idx.cur, %idx.step
  br label %inner.cond

after.inner:
  %src.next = phi i32* [ %src.cur, %inner.cond ] ; not used, placeholder to satisfy form
  %tmp.next = phi i32* [ %tmp.cur, %inner.cond ] ; will be overwritten below by swap
  %src.swapped = add i64 0, 0
  ; swap src and tmp
  %src.out = add i64 %src.swapped, 0
  ; The above two add zeros are no-ops to keep opcodes; actual swap via select-like PHIs on outer.cond
  %src.next.swap = add i64 0, 0
  ; Prepare values for outer PHIs
  br label %outer.swap

outer.swap:
  %src.next.ptr = phi i32* [ %tmp.cur, %after.inner ]
  %tmp.next.ptr = phi i32* [ %src.cur, %after.inner ]
  %run.dbl = shl i64 %run.cur, 1
  br label %outer.cond

outer.done:
  %src.final = phi i32* [ %src.cur, %outer.cond ]
  %eq.dest = icmp eq i32* %src.final, %dest
  br i1 %eq.dest, label %free.and.ret, label %do.copy

do.copy:
  %size.bytes.2 = shl i64 %n, 2
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.final to i8*
  %mc = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %size.bytes.2)
  br label %free.and.ret

free.and.ret:
  call void @free(i8* %raw)
  br label %ret

ret:
  ret void
}