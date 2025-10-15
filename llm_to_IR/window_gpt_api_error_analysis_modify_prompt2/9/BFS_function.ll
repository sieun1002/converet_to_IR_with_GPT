; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"

declare dllimport i8* @malloc(i64)
declare dllimport void @free(i8*)

define dso_local void @bfs(i32* noundef %adj, i64 noundef %n, i64 noundef %start, i32* noundef %dist, i64* noundef %out, i64* noundef %count_ptr) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  %cmp_start_ge_n = icmp uge i64 %start, %n
  %need_fail = or i1 %cmp_n_zero, %cmp_start_ge_n
  br i1 %need_fail, label %fail, label %init.loop.entry

fail:
  store i64 0, i64* %count_ptr, align 8
  ret void

init.loop.entry:
  br label %init.loop.header

init.loop.header:
  %i = phi i64 [ 0, %init.loop.entry ], [ %i.next, %init.loop.body ]
  %cmp_i = icmp ult i64 %i, %n
  br i1 %cmp_i, label %init.loop.body, label %alloc

init.loop.body:
  %dist.ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.ptr, align 4
  %i.next = add i64 %i, 1
  br label %init.loop.header

alloc:
  %size = shl i64 %n, 3
  %block.i8 = call i8* @malloc(i64 %size)
  %block = bitcast i8* %block.i8 to i64*
  %isnull = icmp eq i64* %block, null
  br i1 %isnull, label %malloc.fail, label %start.setup

malloc.fail:
  store i64 0, i64* %count_ptr, align 8
  ret void

start.setup:
  %dist.start.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.ptr, align 4
  %block.idx0 = getelementptr inbounds i64, i64* %block, i64 0
  store i64 %start, i64* %block.idx0, align 8
  store i64 0, i64* %count_ptr, align 8
  br label %bfs.header

bfs.header:
  %head = phi i64 [ 0, %start.setup ], [ %head.next, %bfs.after_inner ]
  %tail = phi i64 [ 1, %start.setup ], [ %tail.cur, %bfs.after_inner ]
  %cond = icmp ult i64 %head, %tail
  br i1 %cond, label %bfs.body, label %bfs.exit

bfs.body:
  %block.elem.ptr = getelementptr inbounds i64, i64* %block, i64 %head
  %x = load i64, i64* %block.elem.ptr, align 8
  %head.next = add i64 %head, 1
  %c = load i64, i64* %count_ptr, align 8
  %c1 = add i64 %c, 1
  store i64 %c1, i64* %count_ptr, align 8
  %out.ptr = getelementptr inbounds i64, i64* %out, i64 %c
  store i64 %x, i64* %out.ptr, align 8
  br label %inner.header

inner.header:
  %j = phi i64 [ 0, %bfs.body ], [ %j.next, %inner.latch ]
  %tail.cur = phi i64 [ %tail, %bfs.body ], [ %tail.new, %inner.latch ]
  %j.cmp = icmp ult i64 %j, %n
  br i1 %j.cmp, label %inner.body, label %bfs.after_inner

inner.body:
  %xn = mul i64 %x, %n
  %idx = add i64 %xn, %j
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %a = load i32, i32* %adj.ptr, align 4
  %a.nz = icmp ne i32 %a, 0
  br i1 %a.nz, label %check.dist, label %inner.cont

check.dist:
  %distj.ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dj = load i32, i32* %distj.ptr, align 4
  %is_unvisited = icmp eq i32 %dj, -1
  br i1 %is_unvisited, label %visit, label %inner.cont

visit:
  %distx.ptr = getelementptr inbounds i32, i32* %dist, i64 %x
  %dx = load i32, i32* %distx.ptr, align 4
  %dx1 = add i32 %dx, 1
  store i32 %dx1, i32* %distj.ptr, align 4
  %block.tail.ptr = getelementptr inbounds i64, i64* %block, i64 %tail.cur
  store i64 %j, i64* %block.tail.ptr, align 8
  %tail.inc = add i64 %tail.cur, 1
  br label %inner.cont

inner.cont:
  %tail.new = phi i64 [ %tail.inc, %visit ], [ %tail.cur, %inner.body ], [ %tail.cur, %check.dist ]
  br label %inner.latch

inner.latch:
  %j.next = add i64 %j, 1
  br label %inner.header

bfs.after_inner:
  br label %bfs.header

bfs.exit:
  %block.i8.free = bitcast i64* %block to i8*
  call void @free(i8* %block.i8.free)
  ret void
}