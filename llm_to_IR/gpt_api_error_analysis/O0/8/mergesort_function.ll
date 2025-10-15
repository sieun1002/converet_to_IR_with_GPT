; ModuleID = 'merge_sort'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* noundef %dest, i64 noundef %n) {
entry:
  %cmp_le1 = icmp ule i64 %n, 1
  br i1 %cmp_le1, label %ret, label %alloc

alloc:
  %size_bytes = shl i64 %n, 2
  %buf.i8 = call noalias i8* @malloc(i64 %size_bytes)
  %buf_is_null = icmp eq i8* %buf.i8, null
  br i1 %buf_is_null, label %ret, label %init

init:
  %tmp0 = bitcast i8* %buf.i8 to i32*
  %run0 = add i64 0, 1
  br label %outer.cond

outer.cond:
  %run = phi i64 [ %run0, %init ], [ %run.next, %outer.swap ]
  %src.cur = phi i32* [ %dest, %init ], [ %tmp.cur, %outer.swap ]
  %tmp.cur = phi i32* [ %tmp0, %init ], [ %src.cur, %outer.swap ]
  %run_lt_n = icmp ult i64 %run, %n
  br i1 %run_lt_n, label %outer.body.init, label %after.outer

outer.body.init:
  %start0 = add i64 0, 0
  br label %inner.cond

inner.cond:
  %start = phi i64 [ %start0, %outer.body.init ], [ %start.next, %after.chunk ]
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %chunk.init, label %inner.end

chunk.init:
  %left = add i64 %start, 0
  %mid.tmp = add i64 %start, %run
  %mid.gt.n = icmp ugt i64 %mid.tmp, %n
  %mid = select i1 %mid.gt.n, i64 %n, i64 %mid.tmp
  %right.tmp1 = add i64 %start, %run
  %twice.run = add i64 %right.tmp1, %run
  %right.gt.n = icmp ugt i64 %twice.run, %n
  %right = select i1 %right.gt.n, i64 %n, i64 %twice.run
  %i0 = add i64 %left, 0
  %j0 = add i64 %mid, 0
  %k0 = add i64 %left, 0
  br label %chunk.loop.cond

chunk.loop.cond:
  %i = phi i64 [ %i0, %chunk.init ], [ %i.next, %chunk.loop.latch ]
  %j = phi i64 [ %j0, %chunk.init ], [ %j.next, %chunk.loop.latch ]
  %k = phi i64 [ %k0, %chunk.init ], [ %k.next, %chunk.loop.latch ]
  %k_lt_right = icmp ult i64 %k, %right
  br i1 %k_lt_right, label %choose, label %after.chunk

choose:
  %i_lt_mid = icmp ult i64 %i, %mid
  br i1 %i_lt_mid, label %have_i, label %take_right_i_oob

have_i:
  %j_lt_right = icmp ult i64 %j, %right
  br i1 %j_lt_right, label %both_valid, label %take_left_j_oob

both_valid:
  %src.i.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %i
  %val.i = load i32, i32* %src.i.ptr, align 4
  %src.j.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %j
  %val.j = load i32, i32* %src.j.ptr, align 4
  %i_gt_j = icmp sgt i32 %val.i, %val.j
  br i1 %i_gt_j, label %take_right_both, label %take_left_both

take_left_j_oob:
  %src.i.ptr.lo = getelementptr inbounds i32, i32* %src.cur, i64 %i
  %val.i.lo = load i32, i32* %src.i.ptr.lo, align 4
  %tmp.k.ptr.lo = getelementptr inbounds i32, i32* %tmp.cur, i64 %k
  store i32 %val.i.lo, i32* %tmp.k.ptr.lo, align 4
  %i.next.lo = add i64 %i, 1
  %j.next.lo = add i64 %j, 0
  %k.next.lo = add i64 %k, 1
  br label %chunk.loop.latch

take_left_both:
  %tmp.k.ptr.lb = getelementptr inbounds i32, i32* %tmp.cur, i64 %k
  store i32 %val.i, i32* %tmp.k.ptr.lb, align 4
  %i.next.lb = add i64 %i, 1
  %j.next.lb = add i64 %j, 0
  %k.next.lb = add i64 %k, 1
  br label %chunk.loop.latch

take_right_i_oob:
  %src.j.ptr.ro = getelementptr inbounds i32, i32* %src.cur, i64 %j
  %val.j.ro = load i32, i32* %src.j.ptr.ro, align 4
  %tmp.k.ptr.ro = getelementptr inbounds i32, i32* %tmp.cur, i64 %k
  store i32 %val.j.ro, i32* %tmp.k.ptr.ro, align 4
  %i.next.ro = add i64 %i, 0
  %j.next.ro = add i64 %j, 1
  %k.next.ro = add i64 %k, 1
  br label %chunk.loop.latch

take_right_both:
  %tmp.k.ptr.rb = getelementptr inbounds i32, i32* %tmp.cur, i64 %k
  store i32 %val.j, i32* %tmp.k.ptr.rb, align 4
  %i.next.rb = add i64 %i, 0
  %j.next.rb = add i64 %j, 1
  %k.next.rb = add i64 %k, 1
  br label %chunk.loop.latch

chunk.loop.latch:
  %i.next = phi i64 [ %i.next.lo, %take_left_j_oob ], [ %i.next.lb, %take_left_both ], [ %i.next.ro, %take_right_i_oob ], [ %i.next.rb, %take_right_both ]
  %j.next = phi i64 [ %j.next.lo, %take_left_j_oob ], [ %j.next.lb, %take_left_both ], [ %j.next.ro, %take_right_i_oob ], [ %j.next.rb, %take_right_both ]
  %k.next = phi i64 [ %k.next.lo, %take_left_j_oob ], [ %k.next.lb, %take_left_both ], [ %k.next.ro, %take_right_i_oob ], [ %k.next.rb, %take_right_both ]
  br label %chunk.loop.cond

after.chunk:
  %two.run = add i64 %run, %run
  %start.next = add i64 %start, %two.run
  br label %inner.cond

inner.end:
  br label %outer.swap

outer.swap:
  %run.next = add i64 %run, %run
  br label %outer.cond

after.outer:
  %src_eq_dest = icmp eq i32* %src.cur, %dest
  br i1 %src_eq_dest, label %free.buf, label %do.memcpy

do.memcpy:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.cur to i8*
  %call.memcpy = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %size_bytes)
  br label %free.buf

free.buf:
  call void @free(i8* %buf.i8)
  br label %ret

ret:
  ret void
}