; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs ; Address: 0x11C9
; Intent: BFS on adjacency matrix: fill dist with shortest-hop counts and record visit order (confidence=0.96). Evidence: dist[] init to -1; queue via malloc/free; check matrix[u*n+v]!=0 and dist[v]==-1, then dist[v]=dist[u]+1 and enqueue.
; Preconditions: matrix has at least n*n 32-bit ints; dist has at least n 32-bit ints; out_nodes has capacity >= n 64-bit ints; out_count is a valid i64*.
; Postconditions: If n==0, start>=n, or malloc fails: *out_count = 0 and return. Otherwise: dist[start]=0; for reachable v, dist[v]=min hops from start; out_nodes[0..*out_count-1] holds visit order.

; Only the necessary external declarations:
declare noalias i8* @_malloc(i64)
declare void @_free(i8*)

define dso_local void @bfs(i32* nocapture readonly %matrix, i64 %n, i64 %start, i32* nocapture %dist, i64* nocapture %out_nodes, i64* nocapture %out_count) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early, label %check_start

check_start:                                          ; preds = %entry
  %start_in_range = icmp ult i64 %start, %n
  br i1 %start_in_range, label %init_dist, label %early

early:                                                ; preds = %check_start, %entry
  store i64 0, i64* %out_count, align 8
  ret void

init_dist:                                            ; preds = %check_start
  br label %dist.loop

dist.loop:                                            ; preds = %dist.loop, %init_dist
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %dist.loop ]
  %i.cmp = icmp ult i64 %i, %n
  br i1 %i.cmp, label %dist.body, label %dist.done

dist.body:                                            ; preds = %dist.loop
  %dist.ptr.i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.ptr.i, align 4
  %i.next = add i64 %i, 1
  br label %dist.loop

dist.done:                                            ; preds = %dist.loop
  %qbytes = shl i64 %n, 3
  %qmem = call noalias i8* @_malloc(i64 %qbytes)
  %qnull = icmp eq i8* %qmem, null
  br i1 %qnull, label %malloc_fail, label %after_malloc

malloc_fail:                                          ; preds = %dist.done
  store i64 0, i64* %out_count, align 8
  ret void

after_malloc:                                         ; preds = %dist.done
  %q = bitcast i8* %qmem to i64*
  ; head = 0, tail = 0
  ; dist[start] = 0
  %dist.start.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.ptr, align 4
  ; enqueue start at q[0], tail = 1
  %q0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %start, i64* %q0, align 8
  store i64 0, i64* %out_count, align 8
  br label %while.cond

while.cond:                                           ; preds = %for.end, %after_malloc
  %head = phi i64 [ 0, %after_malloc ], [ %head.next, %for.end ]
  %tail = phi i64 [ 1, %after_malloc ], [ %tail.out, %for.end ]
  %not_empty = icmp ult i64 %head, %tail
  br i1 %not_empty, label %while.body, label %while.end

while.body:                                           ; preds = %while.cond
  ; u = q[head]; head++
  %q.head.ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %q.head.ptr, align 8
  %head.next = add i64 %head, 1
  ; out_nodes[*out_count] = u; ++*out_count
  %oldcnt = load i64, i64* %out_count, align 8
  %newcnt = add i64 %oldcnt, 1
  store i64 %newcnt, i64* %out_count, align 8
  %out.ptr = getelementptr inbounds i64, i64* %out_nodes, i64 %oldcnt
  store i64 %u, i64* %out.ptr, align 8
  ; precompute dist[u] + 1
  %du.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %du.ptr, align 4
  %du1 = add i32 %du, 1
  br label %for.cond

for.cond:                                             ; preds = %for.inc, %while.body
  %v = phi i64 [ 0, %while.body ], [ %v.next, %for.inc ]
  %tail.inner = phi i64 [ %tail, %while.body ], [ %tail.next.inner, %for.inc ]
  %v.cmp = icmp ult i64 %v, %n
  br i1 %v.cmp, label %for.body, label %for.end

for.body:                                             ; preds = %for.cond
  ; if (matrix[u*n+v] == 0) continue
  %rowmul = mul i64 %u, %n
  %midx = add i64 %rowmul, %v
  %mat.ptr = getelementptr inbounds i32, i32* %matrix, i64 %midx
  %a = load i32, i32* %mat.ptr, align 4
  %isZero = icmp eq i32 %a, 0
  br i1 %isZero, label %for.inc, label %check_dist

check_dist:                                           ; preds = %for.body
  ; if (dist[v] != -1) continue
  %dv.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv = load i32, i32* %dv.ptr, align 4
  %unvisited = icmp eq i32 %dv, -1
  br i1 %unvisited, label %enqueue, label %for.inc

enqueue:                                              ; preds = %check_dist
  ; dist[v] = dist[u] + 1; q[tail++] = v
  store i32 %du1, i32* %dv.ptr, align 4
  %q.tail.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.inner
  store i64 %v, i64* %q.tail.ptr, align 8
  %tail.enq = add i64 %tail.inner, 1
  br label %for.inc

for.inc:                                              ; preds = %enqueue, %check_dist, %for.body
  %tail.next.inner = phi i64 [ %tail.inner, %for.body ], [ %tail.inner, %check_dist ], [ %tail.enq, %enqueue ]
  %v.next = add i64 %v, 1
  br label %for.cond

for.end:                                              ; preds = %for.cond
  %tail.out = phi i64 [ %tail.inner, %for.cond ]
  br label %while.cond

while.end:                                            ; preds = %while.cond
  %qmem.i8 = bitcast i64* %q to i8*
  call void @_free(i8* %qmem.i8)
  ret void
}