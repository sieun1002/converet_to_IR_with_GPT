; ModuleID = 'merge_sort.ll'

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %alloc

alloc:
  %bytes = shl i64 %n, 2
  %raw = call i8* @malloc(i64 %bytes)
  %tmp = bitcast i8* %raw to i32*
  %isnull = icmp eq i32* %tmp, null
  br i1 %isnull, label %ret, label %outer.cond

outer.cond:
  %run = phi i64 [ 1, %alloc ], [ %run.next, %outer.swap ]
  %src.cur = phi i32* [ %dest, %alloc ], [ %src.next, %outer.swap ]
  %buf.cur = phi i32* [ %tmp, %alloc ], [ %buf.next, %outer.swap ]
  %run.lt.n = icmp ult i64 %run, %n
  br i1 %run.lt.n, label %outer.body, label %after.outer

outer.body:
  br label %merge.loop.cond

merge.loop.cond:
  %i = phi i64 [ 0, %outer.body ], [ %i.next, %merge.loop.end ]
  %i.lt.n = icmp ult i64 %i, %n
  br i1 %i.lt.n, label %merge.setup, label %outer.swap

merge.setup:
  %m0 = add i64 %i, %run
  %m.cmp = icmp ult i64 %m0, %n
  %m = select i1 %m.cmp, i64 %m0, i64 %n
  %twoRun = shl i64 %run, 1
  %r0 = add i64 %i, %twoRun
  %r.cmp = icmp ult i64 %r0, %n
  %r = select i1 %r.cmp, i64 %r0, i64 %n
  br label %inner.cond

inner.cond:
  %li = phi i64 [ %i, %merge.setup ], [ %li.upd, %inner.inc ]
  %ri = phi i64 [ %m, %merge.setup ], [ %ri.upd, %inner.inc ]
  %oi = phi i64 [ %i, %merge.setup ], [ %oi.upd, %inner.inc ]
  %cont = icmp ult i64 %oi, %r
  br i1 %cont, label %choose, label %merge.loop.end

choose:
  %leftAvail = icmp ult i64 %li, %m
  %rightAvail = icmp ult i64 %ri, %r
  %notLeftAvail = xor i1 %leftAvail, true
  br i1 %notLeftAvail, label %chooseRight.load, label %checkRight

checkRight:
  %notRightAvail = xor i1 %rightAvail, true
  br i1 %notRightAvail, label %chooseLeft.load, label %cmpvals

cmpvals:
  %leftptr = getelementptr inbounds i32, i32* %src.cur, i64 %li
  %leftval = load i32, i32* %leftptr, align 4
  %rightptr = getelementptr inbounds i32, i32* %src.cur, i64 %ri
  %rightval = load i32, i32* %rightptr, align 4
  %left.gt.right = icmp sgt i32 %leftval, %rightval
  br i1 %left.gt.right, label %chooseRight.direct, label %chooseLeft.direct

chooseLeft.load:
  %leftptrL = getelementptr inbounds i32, i32* %src.cur, i64 %li
  %leftvalL = load i32, i32* %leftptrL, align 4
  br label %chooseLeft.merge

chooseLeft.direct:
  br label %chooseLeft.merge

chooseLeft.merge:
  %leftval.phi = phi i32 [ %leftvalL, %chooseLeft.load ], [ %leftval, %chooseLeft.direct ]
  %outptrL = getelementptr inbounds i32, i32* %buf.cur, i64 %oi
  store i32 %leftval.phi, i32* %outptrL, align 4
  %li.next = add i64 %li, 1
  %oi.next = add i64 %oi, 1
  br label %inner.inc

chooseRight.load:
  %rightptrR = getelementptr inbounds i32, i32* %src.cur, i64 %ri
  %rightvalR = load i32, i32* %rightptrR, align 4
  br label %chooseRight.merge

chooseRight.direct:
  br label %chooseRight.merge

chooseRight.merge:
  %rightval.phi = phi i32 [ %rightvalR, %chooseRight.load ], [ %rightval, %chooseRight.direct ]
  %outptrR = getelementptr inbounds i32, i32* %buf.cur, i64 %oi
  store i32 %rightval.phi, i32* %outptrR, align 4
  %ri.next = add i64 %ri, 1
  %oi.next2 = add i64 %oi, 1
  br label %inner.inc

inner.inc:
  %li.upd = phi i64 [ %li.next, %chooseLeft.merge ], [ %li, %chooseRight.merge ]
  %ri.upd = phi i64 [ %ri, %chooseLeft.merge ], [ %ri.next, %chooseRight.merge ]
  %oi.upd = phi i64 [ %oi.next, %chooseLeft.merge ], [ %oi.next2, %chooseRight.merge ]
  br label %inner.cond

merge.loop.end:
  %i.next = add i64 %i, %twoRun
  br label %merge.loop.cond

outer.swap:
  %src.next = %buf.cur
  %buf.next = %src.cur
  %run.next = shl i64 %run, 1
  br label %outer.cond

after.outer:
  %src.ne.dest = icmp ne i32* %src.cur, %dest
  br i1 %src.ne.dest, label %do.memcpy, label %after.memcpy

do.memcpy:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.cur to i8*
  %call.memcpy = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %bytes)
  br label %after.memcpy

after.memcpy:
  call void @free(i8* %raw)
  br label %ret

ret:
  ret void
}