; LLVM 14 IR for function: bfs
; Signature (System V AMD64):
; void bfs(int32_t* matrix, uint64_t n, uint64_t start, int32_t* dist, uint64_t* out, uint64_t* outCount)

declare i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %matrix, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %outCount) {
entry:
  ; early exit if n == 0 or start >= n
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %early_bad = or i1 %n_is_zero, %start_ge_n
  br i1 %early_bad, label %early, label %init_dist

early:
  store i64 0, i64* %outCount, align 8
  ret void

; dist[i] = -1 for i in [0, n)
init_dist:
  br label %dist.loop

dist.loop:
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %dist.body ]
  %i.lt.n = icmp ult i64 %i, %n
  br i1 %i.lt.n, label %dist.body, label %post_dist

dist.body:
  %dist.ptr.i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.ptr.i, align 4
  %i.next = add i64 %i, 1
  br label %dist.loop

post_dist:
  ; queue = malloc(n * 8)
  %size.bytes = shl i64 %n, 3
  %q.raw = call i8* @malloc(i64 %size.bytes)
  %q = bitcast i8* %q.raw to i64*
  %q.null = icmp eq i64* %q, null
  br i1 %q.null, label %alloc_fail, label %init_bfs

alloc_fail:
  store i64 0, i64* %outCount, align 8
  ret void

init_bfs:
  ; dist[start] = 0
  %dist.start.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.ptr, align 4
  ; enqueue start at tail=0, then tail=1
  store i64 %start, i64* %q, align 8
  store i64 0, i64* %outCount, align 8
  br label %outer.cond

outer.cond:
  %head = phi i64 [ 0, %init_bfs ], [ %head.next, %after.inner ]
  %tail = phi i64 [ 1, %init_bfs ], [ %tail.after, %after.inner ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %dequeue, label %done

dequeue:
  ; u = q[head]; head++
  %q.head.ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %q.head.ptr, align 8
  %head.next = add i64 %head, 1
  ; append u to out
  %cnt.cur = load i64, i64* %outCount, align 8
  %out.slot = getelementptr inbounds i64, i64* %out, i64 %cnt.cur
  store i64 %u, i64* %out.slot, align 8
  %cnt.next = add i64 %cnt.cur, 1
  store i64 %cnt.next, i64* %outCount, align 8
  ; iterate neighbors v = 0..n-1
  br label %inner.cond

inner.cond:
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %inner.inc ]
  %tail.cur = phi i64 [ %tail, %dequeue ], [ %tail.upd, %inner.inc ]
  %v.lt.n = icmp ult i64 %v, %n
  br i1 %v.lt.n, label %inner.body, label %after.inner

inner.body:
  ; if matrix[u*n + v] != 0
  %u.mul.n = mul i64 %u, %n
  %idx = add i64 %u.mul.n, %v
  %m.ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx
  %m.val = load i32, i32* %m.ptr, align 4
  %m.nonzero = icmp ne i32 %m.val, 0
  br i1 %m.nonzero, label %check.unvisited, label %inner.inc

check.unvisited:
  ; and dist[v] == -1
  %d.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %d.v = load i32, i32* %d.v.ptr, align 4
  %is.unvisited = icmp eq i32 %d.v, -1
  br i1 %is.unvisited, label %visit, label %inner.inc

visit:
  ; dist[v] = dist[u] + 1
  %d.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %d.u = load i32, i32* %d.u.ptr, align 4
  %d.new = add i32 %d.u, 1
  store i32 %d.new, i32* %d.v.ptr, align 4
  ; enqueue v: q[tail.cur] = v; tail.cur++
  %q.tail.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.cur
  store i64 %v, i64* %q.tail.ptr, align 8
  %tail.visited = add i64 %tail.cur, 1
  br label %inner.inc

inner.inc:
  ; merge tail update and advance v
  %tail.upd = phi i64 [ %tail.cur, %inner.body ], [ %tail.cur, %check.unvisited ], [ %tail.visited, %visit ]
  %v.next = add i64 %v, 1
  br label %inner.cond

after.inner:
  ; tail after scanning neighbors
  %tail.after = phi i64 [ %tail.cur, %inner.cond ]
  br label %outer.cond

done:
  %q.raw2 = bitcast i64* %q to i8*
  call void @free(i8* %q.raw2)
  ret void
}