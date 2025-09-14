; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs ; Address: 0x11C9
; Intent: Breadth-first search over adjacency matrix, compute distances and visitation order (confidence=0.95). Evidence: queue via malloc/free, dist init to -1 and BFS updates, adjacency check matrix[u*n+v] != 0.
; Preconditions: matrix is n*n int32_t adjacency matrix; dist has length >= n; out has capacity >= n; out_count is valid pointer.
; Postconditions: dist[src]=0; dist[v] is BFS distance or -1 if unreachable; out[0..*out_count-1] are nodes in visitation order; *out_count == number of visited nodes (0 if n==0 or src>=n).

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* nocapture readonly %matrix, i64 %n, i64 %src, i32* nocapture %dist, i64* nocapture %out, i64* nocapture %out_count) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %src_oob = icmp uge i64 %src, %n
  %early = or i1 %n_is_zero, %src_oob
  br i1 %early, label %early_ret, label %dist_init.loop

early_ret:                                          ; preds = %entry
  store i64 0, i64* %out_count, align 8
  ret void

dist_init.loop:                                     ; preds = %entry
  br label %dist_init.header

dist_init.header:                                   ; preds = %dist_init.body, %dist_init.loop
  %i = phi i64 [ 0, %dist_init.loop ], [ %i.next, %dist_init.body ]
  %cmp.i = icmp ult i64 %i, %n
  br i1 %cmp.i, label %dist_init.body, label %post_init

dist_init.body:                                     ; preds = %dist_init.header
  %dist.ptr.i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.ptr.i, align 4
  %i.next = add i64 %i, 1
  br label %dist_init.header

post_init:                                          ; preds = %dist_init.header
  %size.bytes = shl i64 %n, 3
  %q.raw = call noalias i8* @malloc(i64 %size.bytes)
  %q = bitcast i8* %q.raw to i64*
  %qnull = icmp eq i64* %q, null
  br i1 %qnull, label %malloc_fail, label %init_bfs

malloc_fail:                                        ; preds = %post_init
  store i64 0, i64* %out_count, align 8
  ret void

init_bfs:                                           ; preds = %post_init
  ; dist[src] = 0
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src
  store i32 0, i32* %dist.src.ptr, align 4
  ; enqueue src
  %q.tail0.ptr = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %src, i64* %q.tail0.ptr, align 8
  ; out_count = 0
  store i64 0, i64* %out_count, align 8
  br label %outer.cond

outer.cond:                                         ; preds = %inner.end, %init_bfs
  %head = phi i64 [ 0, %init_bfs ], [ %head.next, %inner.end ]
  %tail = phi i64 [ 1, %init_bfs ], [ %tail.after, %inner.end ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %outer.body, label %done

outer.body:                                         ; preds = %outer.cond
  ; dequeue
  %q.head.ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %q.head.ptr, align 8
  %head.next = add i64 %head, 1
  ; out[*out_count] = u; ++*out_count
  %oc.old = load i64, i64* %out_count, align 8
  %out.elem.ptr = getelementptr inbounds i64, i64* %out, i64 %oc.old
  store i64 %u, i64* %out.elem.ptr, align 8
  %oc.new = add i64 %oc.old, 1
  store i64 %oc.new, i64* %out_count, align 8
  br label %inner.header

inner.header:                                       ; preds = %inner.inc, %outer.body
  %v = phi i64 [ 0, %outer.body ], [ %v.next, %inner.inc ]
  %tail.phi = phi i64 [ %tail, %outer.body ], [ %tail.next, %inner.inc ]
  %v.lt.n = icmp ult i64 %v, %n
  br i1 %v.lt.n, label %inner.body, label %inner.end

inner.body:                                         ; preds = %inner.header
  ; if matrix[u*n + v] != 0
  %u.mul.n = mul i64 %u, %n
  %idx = add i64 %u.mul.n, %v
  %mat.ptr = getelementptr inbounds i32, i32* %matrix, i64 %idx
  %mat.val = load i32, i32* %mat.ptr, align 4
  %has.edge = icmp ne i32 %mat.val, 0
  br i1 %has.edge, label %check.unseen, label %inner.inc

check.unseen:                                       ; preds = %inner.body
  ; if dist[v] == -1
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %is.unseen = icmp eq i32 %dist.v, -1
  br i1 %is.unseen, label %visit, label %inner.inc

visit:                                              ; preds = %check.unseen
  ; dist[v] = dist[u] + 1
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.plus1 = add i32 %dist.u, 1
  store i32 %dist.u.plus1, i32* %dist.v.ptr, align 4
  ; enqueue v
  %q.tail.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.phi
  store i64 %v, i64* %q.tail.ptr, align 8
  %tail.enq = add i64 %tail.phi, 1
  br label %inner.inc

inner.inc:                                          ; preds = %visit, %check.unseen, %inner.body
  %tail.next = phi i64 [ %tail.enq, %visit ], [ %tail.phi, %check.unseen ], [ %tail.phi, %inner.body ]
  %v.next = add i64 %v, 1
  br label %inner.header

inner.end:                                          ; preds = %inner.header
  %tail.after = phi i64 [ %tail.phi, %inner.header ]
  br label %outer.cond

done:                                               ; preds = %outer.cond
  %q.raw.free = bitcast i64* %q to i8*
  call void @free(i8* %q.raw.free)
  ret void
}