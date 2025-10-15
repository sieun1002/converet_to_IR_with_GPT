; ModuleID = 'dijkstra_module'
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dijkstra(i32* %graph, i64 %n, i64 %start, i32* %dist, i32* %prev) {
entry:
  %cmp0 = icmp eq i64 %n, 0
  br i1 %cmp0, label %ret, label %check_start

check_start:
  %cmp1 = icmp uge i64 %start, %n
  br i1 %cmp1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %raw = call noalias i8* @malloc(i64 %size)
  %block = bitcast i8* %raw to i32*
  %allocnull = icmp eq i32* %block, null
  br i1 %allocnull, label %ret, label %init.loop

init.loop:
  %i = phi i64 [ 0, %alloc ], [ %i.next, %init.loop ]
  %dist.ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 1061109567, i32* %dist.ptr, align 4
  %prev.ptr = getelementptr inbounds i32, i32* %prev, i64 %i
  store i32 -1, i32* %prev.ptr, align 4
  %block.ptr = getelementptr inbounds i32, i32* %block, i64 %i
  store i32 0, i32* %block.ptr, align 4
  %i.next = add i64 %i, 1
  %init.cond = icmp ult i64 %i.next, %n
  br i1 %init.cond, label %init.loop, label %post_init

post_init:
  %dist.start.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.ptr, align 4
  br label %outer.loop

outer.loop:
  %t = phi i64 [ 0, %post_init ], [ %t.next, %outer.latch ]
  br label %select.loop

select.loop:
  %k = phi i64 [ 0, %outer.loop ], [ %k.next, %select.latch ]
  %min = phi i32 [ 1061109567, %outer.loop ], [ %min.next, %select.latch ]
  %u = phi i64 [ %n, %outer.loop ], [ %u.next, %select.latch ]
  %blk.k.ptr = getelementptr inbounds i32, i32* %block, i64 %k
  %blk.k = load i32, i32* %blk.k.ptr, align 4
  %blk.k.zero = icmp eq i32 %blk.k, 0
  br i1 %blk.k.zero, label %maybe_update, label %no_update

maybe_update:
  %dist.k.ptr = getelementptr inbounds i32, i32* %dist, i64 %k
  %dist.k = load i32, i32* %dist.k.ptr, align 4
  %lt.min = icmp slt i32 %dist.k, %min
  br i1 %lt.min, label %do_update, label %no_update

do_update:
  br label %select.latch

no_update:
  br label %select.latch

select.latch:
  %min.next = phi i32 [ %min, %no_update ], [ %dist.k, %do_update ]
  %u.next = phi i64 [ %u, %no_update ], [ %k, %do_update ]
  %k.next = add i64 %k, 1
  %sel.more = icmp ult i64 %k.next, %n
  br i1 %sel.more, label %select.loop, label %after_select

after_select:
  %u.final = phi i64 [ %u.next, %select.latch ]
  %min.final = phi i32 [ %min.next, %select.latch ]
  %u.is.sentinel = icmp eq i64 %u.final, %n
  br i1 %u.is.sentinel, label %free_block, label %mark_visit

mark_visit:
  %blk.u.ptr = getelementptr inbounds i32, i32* %block, i64 %u.final
  store i32 1, i32* %blk.u.ptr, align 4
  br label %inner.loop

inner.loop:
  %j = phi i64 [ 0, %mark_visit ], [ %j.next, %inner.latch ]
  %u.mul.n = mul i64 %u.final, %n
  %idx = add i64 %u.mul.n, %j
  %edge.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %edge.ptr, align 4
  %w.neg = icmp slt i32 %w, 0
  br i1 %w.neg, label %inner.latch, label %check_block_j

check_block_j:
  %blk.j.ptr = getelementptr inbounds i32, i32* %block, i64 %j
  %blk.j = load i32, i32* %blk.j.ptr, align 4
  %blk.j.zero = icmp eq i32 %blk.j, 0
  br i1 %blk.j.zero, label %check_dist_u, label %inner.latch

check_dist_u:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u.final
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.is.inf = icmp eq i32 %dist.u, 1061109567
  br i1 %dist.u.is.inf, label %inner.latch, label %compute_sum

compute_sum:
  %sum = add i32 %dist.u, %w
  %dist.j.ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dist.j = load i32, i32* %dist.j.ptr, align 4
  %better = icmp slt i32 %sum, %dist.j
  br i1 %better, label %do_relax, label %inner.latch

do_relax:
  store i32 %sum, i32* %dist.j.ptr, align 4
  %u.trunc = trunc i64 %u.final to i32
  %prev.j.ptr = getelementptr inbounds i32, i32* %prev, i64 %j
  store i32 %u.trunc, i32* %prev.j.ptr, align 4
  br label %inner.latch

inner.latch:
  %j.next = add i64 %j, 1
  %j.more = icmp ult i64 %j.next, %n
  br i1 %j.more, label %inner.loop, label %outer.latch

outer.latch:
  %t.next = add i64 %t, 1
  %t.more = icmp ult i64 %t.next, %n
  br i1 %t.more, label %outer.loop, label %free_block

free_block:
  %raw.free = bitcast i32* %block to i8*
  call void @free(i8* %raw.free)
  br label %ret

ret:
  ret void
}