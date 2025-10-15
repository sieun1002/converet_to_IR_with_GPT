; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %countptr) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %early, label %dist_init.entry

early:
  store i64 0, i64* %countptr, align 8
  ret void

dist_init.entry:
  br label %dist_init.cond

dist_init.cond:
  %i = phi i64 [ 0, %dist_init.entry ], [ %i.next, %dist_init.body ]
  %cmp_i = icmp ult i64 %i, %n
  br i1 %cmp_i, label %dist_init.body, label %dist_init.after

dist_init.body:
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.i.ptr, align 4
  %i.next = add i64 %i, 1
  br label %dist_init.cond

dist_init.after:
  %size = shl i64 %n, 3
  %q.i8 = call i8* @malloc(i64 %size)
  %q = bitcast i8* %q.i8 to i64*
  %isnull = icmp eq i64* %q, null
  br i1 %isnull, label %malloc_fail, label %bfs.init

malloc_fail:
  store i64 0, i64* %countptr, align 8
  ret void

bfs.init:
  %dist.start.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.ptr, align 4
  %q.slot0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %start, i64* %q.slot0, align 8
  store i64 0, i64* %countptr, align 8
  br label %outer.cond

outer.cond:
  %head = phi i64 [ 0, %bfs.init ], [ %head.next, %outer.latch ]
  %tail = phi i64 [ 1, %bfs.init ], [ %tail.next, %outer.latch ]
  %not_empty = icmp ult i64 %head, %tail
  br i1 %not_empty, label %outer.body, label %outer.after

outer.body:
  %q.head.ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %curr = load i64, i64* %q.head.ptr, align 8
  %head.next = add i64 %head, 1
  %old.count = load i64, i64* %countptr, align 8
  %order.slot = getelementptr inbounds i64, i64* %order, i64 %old.count
  store i64 %curr, i64* %order.slot, align 8
  %new.count = add i64 %old.count, 1
  store i64 %new.count, i64* %countptr, align 8
  br label %neighbor.cond

neighbor.cond:
  %nei = phi i64 [ 0, %outer.body ], [ %nei.next, %neighbor.latch ]
  %tail.c = phi i64 [ %tail, %outer.body ], [ %tail.c.next, %neighbor.latch ]
  %nei.lt.n = icmp ult i64 %nei, %n
  br i1 %nei.lt.n, label %neighbor.body, label %neighbor.after

neighbor.body:
  %mul = mul i64 %curr, %n
  %sum = add i64 %mul, %nei
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %sum
  %adj.val = load i32, i32* %adj.ptr, align 4
  %is.edge = icmp ne i32 %adj.val, 0
  br i1 %is.edge, label %check.unvisited, label %neighbor.latch.noedge

neighbor.latch.noedge:
  br label %neighbor.latch

check.unvisited:
  %dist.nei.ptr = getelementptr inbounds i32, i32* %dist, i64 %nei
  %dist.nei.val = load i32, i32* %dist.nei.ptr, align 4
  %is.unvisited = icmp eq i32 %dist.nei.val, -1
  br i1 %is.unvisited, label %visit, label %neighbor.latch.novisit

neighbor.latch.novisit:
  br label %neighbor.latch

visit:
  %dist.curr.ptr = getelementptr inbounds i32, i32* %dist, i64 %curr
  %dist.curr.val = load i32, i32* %dist.curr.ptr, align 4
  %newdist = add i32 %dist.curr.val, 1
  store i32 %newdist, i32* %dist.nei.ptr, align 4
  %q.tail.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.c
  store i64 %nei, i64* %q.tail.ptr, align 8
  %tail.updated = add i64 %tail.c, 1
  br label %neighbor.latch

neighbor.latch:
  %tail.c.next = phi i64 [ %tail.c, %neighbor.latch.noedge ], [ %tail.c, %neighbor.latch.novisit ], [ %tail.updated, %visit ]
  %nei.next = add i64 %nei, 1
  br label %neighbor.cond

neighbor.after:
  br label %outer.latch

outer.latch:
  %tail.next = phi i64 [ %tail.c, %neighbor.after ]
  br label %outer.cond

outer.after:
  call void @free(i8* %q.i8)
  ret void
}