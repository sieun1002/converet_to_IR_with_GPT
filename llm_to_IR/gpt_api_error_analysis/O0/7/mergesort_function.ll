; target: x86_64 System V (Linux/glibc)
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64 noundef)
declare void @free(i8* noundef)
declare i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)

define void @merge_sort(i32* noundef %dest, i64 noundef %n) {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %alloc

alloc:
  %bytes = shl i64 %n, 2
  %rawbuf = call i8* @malloc(i64 %bytes)
  %isnull = icmp eq i8* %rawbuf, null
  br i1 %isnull, label %ret, label %init

init:
  %buf = bitcast i8* %rawbuf to i32*
  br label %outer.header

outer.header:
  %width = phi i64 [ 1, %init ], [ %width.next, %after.inner ]
  %src.cur = phi i32* [ %dest, %init ], [ %out.cur, %after.inner ]
  %out.cur = phi i32* [ %buf, %init ], [ %src.cur, %after.inner ]
  %cond.width = icmp ult i64 %width, %n
  br i1 %cond.width, label %inner.init, label %after.outer

inner.init:
  br label %inner.header

inner.header:
  %i = phi i64 [ 0, %inner.init ], [ %i.next, %merge.done ]
  %cond.i = icmp ult i64 %i, %n
  br i1 %cond.i, label %merge.prepare, label %after.inner

merge.prepare:
  %i.plus.w = add i64 %i, %width
  %mid.lt.n = icmp ult i64 %i.plus.w, %n
  %mid = select i1 %mid.lt.n, i64 %i.plus.w, i64 %n
  %tw = add i64 %width, %width
  %i.plus.tw = add i64 %i, %tw
  %r.lt.n = icmp ult i64 %i.plus.tw, %n
  %r = select i1 %r.lt.n, i64 %i.plus.tw, i64 %n
  br label %merge.cond

merge.cond:
  %li = phi i64 [ %i, %merge.prepare ], [ %li.next, %take.left ], [ %li, %take.right ]
  %ri = phi i64 [ %mid, %merge.prepare ], [ %ri, %take.left ], [ %ri.next, %take.right ]
  %oi = phi i64 [ %i, %merge.prepare ], [ %oi.nextL, %take.left ], [ %oi.nextR, %take.right ]
  %oi.lt.r = icmp ult i64 %oi, %r
  br i1 %oi.lt.r, label %choose, label %merge.done

choose:
  %li.lt.mid = icmp ult i64 %li, %mid
  br i1 %li.lt.mid, label %check.ri, label %take.right

check.ri:
  %ri.lt.r = icmp ult i64 %ri, %r
  br i1 %ri.lt.r, label %compare, label %take.left

compare:
  %lptr.c = getelementptr inbounds i32, i32* %src.cur, i64 %li
  %lval.c = load i32, i32* %lptr.c, align 4
  %rptr.c = getelementptr inbounds i32, i32* %src.cur, i64 %ri
  %rval.c = load i32, i32* %rptr.c, align 4
  %l.gt.r = icmp sgt i32 %lval.c, %rval.c
  br i1 %l.gt.r, label %take.right, label %take.left

take.left:
  %src.l.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %li
  %val.l = load i32, i32* %src.l.ptr, align 4
  %out.l.ptr = getelementptr inbounds i32, i32* %out.cur, i64 %oi
  store i32 %val.l, i32* %out.l.ptr, align 4
  %li.next = add i64 %li, 1
  %oi.nextL = add i64 %oi, 1
  br label %merge.cond

take.right:
  %src.r.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %ri
  %val.r = load i32, i32* %src.r.ptr, align 4
  %out.r.ptr = getelementptr inbounds i32, i32* %out.cur, i64 %oi
  store i32 %val.r, i32* %out.r.ptr, align 4
  %ri.next = add i64 %ri, 1
  %oi.nextR = add i64 %oi, 1
  br label %merge.cond

merge.done:
  %tw2 = add i64 %width, %width
  %i.next = add i64 %i, %tw2
  br label %inner.header

after.inner:
  %width.next = shl i64 %width, 1
  br label %outer.header

after.outer:
  %src.eq.dest = icmp eq i32* %src.cur, %dest
  br i1 %src.eq.dest, label %do.free, label %do.memcpy

do.memcpy:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.cur to i8*
  %bytes.copy = shl i64 %n, 2
  %memcpy.ret = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %bytes.copy)
  br label %do.free

do.free:
  call void @free(i8* %rawbuf)
  br label %ret

ret:
  ret void
}