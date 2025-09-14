; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs ; Address: 0x11C9
; Intent: Breadth-first search over adjacency matrix: fill dist[], record visit order into out[] and out_len (confidence=0.92). Evidence: dist initialized to -1 and updated as dist[u]+1; queue via malloc/free; out_len incremented and out[] populated per dequeue.
; Preconditions: adj points to n*n 32-bit ints (row-major), dist has at least n 32-bit ints, out has at least n 64-bit entries, out_len is non-null; 0 <= start < n for normal traversal.
; Postconditions: If n==0 or start>=n or allocation fails: *out_len=0. Otherwise: dist[start]=0; for reachable v, dist[v]=BFS distance, else -1; out[0..*out_len-1] is the BFS visitation order.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* nocapture readonly %adj, i64 %n, i64 %start, i32* nocapture %dist, i64* nocapture %out, i64* nocapture %out_len) local_unnamed_addr {
entry:
  %n_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %early = or i1 %n_zero, %start_ge_n
  br i1 %early, label %ret0, label %init_dist

ret0:                                             ; n==0 || start>=n
  store i64 0, i64* %out_len, align 8
  ret void

init_dist:                                        ; initialize dist[i] = -1 for i in [0,n)
  br label %dist_loop

dist_loop:
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %dist_loop_body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %dist_loop_body, label %post_init

dist_loop_body:
  %dist.ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.ptr, align 4
  %i.next = add i64 %i, 1
  br label %dist_loop

post_init:
  %size = shl i64 %n, 3
  %qmem.i8 = call noalias i8* @malloc(i64 %size)
  %qnull = icmp eq i8* %qmem.i8, null
  br i1 %qnull, label %malloc_fail, label %bfs_init

malloc_fail:
  store i64 0, i64* %out_len, align 8
  ret void

bfs_init:
  %queue = bitcast i8* %qmem.i8 to i64*
  ; dist[start] = 0
  %dist.start.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.ptr, align 4
  ; enqueue start at tail=0
  %q0.ptr = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0.ptr, align 8
  ; set out_len = 0
  store i64 0, i64* %out_len, align 8
  br label %while_check

while_check:
  %head = phi i64 [ 0, %bfs_init ], [ %head.next, %end_inner ]
  %tail = phi i64 [ 1, %bfs_init ], [ %tail.upd, %end_inner ]
  %not_empty = icmp ult i64 %head, %tail
  br i1 %not_empty, label %pop, label %done

pop:
  %q.head.ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %q.head.ptr, align 8
  %head.next = add i64 %head, 1
  ; append u to out[*out_len], then increment *out_len
  %old_len = load i64, i64* %out_len, align 8
  %out.slot = getelementptr inbounds i64, i64* %out, i64 %old_len
  store i64 %u, i64* %out.slot, align 8
  %new_len = add i64 %old_len, 1
  store i64 %new_len, i64* %out_len, align 8
  br label %inner_loop

inner_loop:
  %v = phi i64 [ 0, %pop ], [ %v.next, %inner_loop_latch ]
  %tail.cur = phi i64 [ %tail, %pop ], [ %tail.next, %inner_loop_latch ]
  %v_cond = icmp ult i64 %v, %n
  br i1 %v_cond, label %check_edge, label %end_inner

check_edge:
  ; idx = u*n + v
  %un = mul i64 %u, %n
  %idx = add i64 %un, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %a = load i32, i32* %adj.ptr, align 4
  %has_edge = icmp ne i32 %a, 0
  br i1 %has_edge, label %check_visited, label %inner_loop_latch

check_visited:
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv = load i32, i32* %dist.v.ptr, align 4
  %is_unvisited = icmp eq i32 %dv, -1
  br i1 %is_unvisited, label %relax_enqueue, label %inner_loop_latch

relax_enqueue:
  ; dist[v] = dist[u] + 1
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %dist.u.ptr, align 4
  %du1 = add i32 %du, 1
  store i32 %du1, i32* %dist.v.ptr, align 4
  ; enqueue v at tail.cur
  %q.tail.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.cur
  store i64 %v, i64* %q.tail.ptr, align 8
  %tail.next.enq = add i64 %tail.cur, 1
  br label %inner_loop_latch

inner_loop_latch:
  %tail.next = phi i64 [ %tail.cur, %check_edge ], [ %tail.cur, %check_visited ], [ %tail.next.enq, %relax_enqueue ]
  %v.next = add i64 %v, 1
  br label %inner_loop

end_inner:
  %tail.upd = phi i64 [ %tail.cur, %inner_loop ]
  br label %while_check

done:
  %qmem.i8.final = bitcast i64* %queue to i8*
  call void @free(i8* %qmem.i8.final)
  ret void
}