; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs ; Address: 0x11C9
; Intent: breadth-first search over adjacency matrix, compute distances and visit order (confidence=0.94). Evidence: dist initialized to -1, source set to 0 and neighbors set to dist[u]+1; explicit FIFO queue with head/tail and adj[u*n+v] checks.
; Preconditions: adj points to an n*n i32 matrix; dist points to n i32s; out points to >= n i64s; out_count non-null; 0 <= start < n (else *out_count=0 and return).
; Postconditions: dist[v] = shortest path length from start or -1 if unreachable; out[0..*out_count-1] holds BFS dequeue order; *out_count is number of visited nodes.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)
declare i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* nocapture %adj, i64 %n, i64 %start, i32* nocapture %dist, i64* nocapture %out, i64* nocapture %out_count) local_unnamed_addr {
entry:
  %ok1 = icmp ne i64 %n, 0
  %ok2 = icmp ult i64 %start, %n
  %ok = and i1 %ok1, %ok2
  br i1 %ok, label %init_dist, label %early_ret

early_ret:
  store i64 0, i64* %out_count, align 8
  ret void

init_dist:
  br label %dist_loop

dist_loop:
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %dist_body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %dist_body, label %post_init

dist_body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %dist_loop

post_init:
  %size = shl i64 %n, 3
  %qraw = call i8* @malloc(i64 %size)
  %queue = bitcast i8* %qraw to i64*
  %qnull = icmp eq i64* %queue, null
  br i1 %qnull, label %early_ret, label %init_queue

init_queue:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %q0ptr = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0ptr, align 8
  store i64 0, i64* %out_count, align 8
  br label %bfs_outer

bfs_outer:
  %head = phi i64 [ 0, %init_queue ], [ %head.next, %after_inner ]
  %tail = phi i64 [ 1, %init_queue ], [ %tail.next_after_inner, %after_inner ]
  %cond_outer = icmp ult i64 %head, %tail
  br i1 %cond_outer, label %dequeue, label %done

dequeue:
  %q_head_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %q_head_ptr, align 8
  %head.next = add i64 %head, 1
  %t = load i64, i64* %out_count, align 8
  %t.inc = add i64 %t, 1
  store i64 %t.inc, i64* %out_count, align 8
  %out_t_ptr = getelementptr inbounds i64, i64* %out, i64 %t
  store i64 %u, i64* %out_t_ptr, align 8
  br label %inner_loop

inner_loop:
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %after_relax ]
  %tail.loop = phi i64 [ %tail, %dequeue ], [ %tail.updated, %after_relax ]
  %cond_inner = icmp ult i64 %v, %n
  br i1 %cond_inner, label %check_edge, label %after_inner

check_edge:
  %u_mul_n = mul i64 %u, %n
  %idx = add i64 %u_mul_n, %v
  %adj_elem_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_elem_ptr, align 4
  %has_edge = icmp ne i32 %adj_val, 0
  br i1 %has_edge, label %check_unseen, label %no_enqueue

check_unseen:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unseen = icmp eq i32 %dist_v, -1
  br i1 %is_unseen, label %do_enqueue, label %no_enqueue

do_enqueue:
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_inc = add i32 %dist_u, 1
  store i32 %dist_u_inc, i32* %dist_v_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.loop
  store i64 %v, i64* %q_tail_ptr, align 8
  %tail.enq = add i64 %tail.loop, 1
  br label %after_relax

no_enqueue:
  br label %after_relax

after_relax:
  %tail.updated = phi i64 [ %tail.loop, %no_enqueue ], [ %tail.enq, %do_enqueue ]
  %v.next = add i64 %v, 1
  br label %inner_loop

after_inner:
  %tail.next_after_inner = phi i64 [ %tail.loop, %inner_loop ]
  br label %bfs_outer

done:
  %qraw2 = bitcast i64* %queue to i8*
  call void @free(i8* %qraw2)
  ret void
}