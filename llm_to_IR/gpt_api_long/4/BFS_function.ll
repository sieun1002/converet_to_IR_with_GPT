; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs  ; Address: 0x11C9
; Intent: Breadth-first search over an adjacency matrix, computing distances and BFS order (confidence=0.95). Evidence: queue via malloc/free with head/tail, dist initialized to -1 and updated as dist[u]+1, adjacency indexed by u*n+v.
; Preconditions: adj is an n*n array of i32; dist is an array of at least n i32; order_out can hold up to n i64s; order_len is a valid i64*; if n == 0 or start >= n, *order_len is set to 0 and the function returns.

; Only the needed extern declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order_out, i64* %order_len) local_unnamed_addr {
entry:
  %cmp_n0 = icmp eq i64 %n, 0
  %cmp_start_bad = icmp uge i64 %start, %n
  %bad = or i1 %cmp_n0, %cmp_start_bad
  br i1 %bad, label %early, label %init.loop

early:                                            ; preds = %entry
  store i64 0, i64* %order_len, align 8
  br label %ret

init.loop:                                        ; preds = %entry, %init.loop.inc
  %i = phi i64 [ 0, %entry ], [ %i.next, %init.loop.inc ]
  %init.cond = icmp ult i64 %i, %n
  br i1 %init.cond, label %init.body, label %alloc

init.body:                                        ; preds = %init.loop
  %dist.i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.i, align 4
  br label %init.loop.inc

init.loop.inc:                                    ; preds = %init.body
  %i.next = add i64 %i, 1
  br label %init.loop

alloc:                                            ; preds = %init.loop
  %bytes = shl i64 %n, 3
  %q_i8 = call i8* @malloc(i64 %bytes)
  %isnull = icmp eq i8* %q_i8, null
  br i1 %isnull, label %malloc_null, label %after_alloc

malloc_null:                                      ; preds = %alloc
  store i64 0, i64* %order_len, align 8
  br label %ret

after_alloc:                                      ; preds = %alloc
  %queue = bitcast i8* %q_i8 to i64*
  %dst_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dst_start_ptr, align 4
  %q0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0, align 8
  store i64 0, i64* %order_len, align 8
  br label %outer.cond

outer.cond:                                       ; preds = %after_alloc, %outer.latch
  %head = phi i64 [ 0, %after_alloc ], [ %head.next, %outer.latch ]
  %tail = phi i64 [ 1, %after_alloc ], [ %tail.after.inner, %outer.latch ]
  %nonempty = icmp ult i64 %head, %tail
  br i1 %nonempty, label %outer.body, label %done

outer.body:                                       ; preds = %outer.cond
  %q_head_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %q_head_ptr, align 8
  %head.next = add i64 %head, 1
  %len.old = load i64, i64* %order_len, align 8
  %len.new = add i64 %len.old, 1
  store i64 %len.new, i64* %order_len, align 8
  %out_ptr = getelementptr inbounds i64, i64* %order_out, i64 %len.old
  store i64 %u, i64* %out_ptr, align 8
  br label %inner.cond

inner.cond:                                       ; preds = %outer.body, %inner.latch
  %v = phi i64 [ 0, %outer.body ], [ %v.next, %inner.latch ]
  %tail.curr = phi i64 [ %tail, %outer.body ], [ %tail.next, %inner.latch ]
  %v.lt = icmp ult i64 %v, %n
  br i1 %v.lt, label %inner.body, label %outer.latch

inner.body:                                       ; preds = %inner.cond
  %prod = mul i64 %u, %n
  %idx = add i64 %prod, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge.val = load i32, i32* %adj.ptr, align 4
  %edge.zero = icmp eq i32 %edge.val, 0
  br i1 %edge.zero, label %skip.edge, label %check.vis

check.vis:                                        ; preds = %inner.body
  %dv.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv = load i32, i32* %dv.ptr, align 4
  %unvisited = icmp eq i32 %dv, -1
  br i1 %unvisited, label %visit, label %skip.edge

visit:                                            ; preds = %check.vis
  %du.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %du.ptr, align 4
  %du.plus1 = add i32 %du, 1
  store i32 %du.plus1, i32* %dv.ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.curr
  store i64 %v, i64* %q_tail_ptr, align 8
  %tail.inc = add i64 %tail.curr, 1
  br label %inner.latch

skip.edge:                                        ; preds = %check.vis, %inner.body
  br label %inner.latch

inner.latch:                                      ; preds = %skip.edge, %visit
  %tail.next = phi i64 [ %tail.inc, %visit ], [ %tail.curr, %skip.edge ]
  %v.next = add i64 %v, 1
  br label %inner.cond

outer.latch:                                      ; preds = %inner.cond
  %tail.after.inner = phi i64 [ %tail.curr, %inner.cond ]
  br label %outer.cond

done:                                             ; preds = %outer.cond
  call void @free(i8* %q_i8)
  br label %ret

ret:                                              ; preds = %done, %malloc_null, %early
  ret void
}