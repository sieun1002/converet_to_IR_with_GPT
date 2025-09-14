; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs  ; Address: 0x11C9
; Intent: Breadth-first search on adjacency matrix, producing visit order and distances (confidence=0.95). Evidence: queue via malloc/free and head/tail indices; dist initialized to -1 and updated with BFS levels.
; Preconditions: graph is an n*n adjacency matrix (i32, row-major); dist has length ≥ n; out has length ≥ n; out_count is non-null.
; Postconditions: If n==0 or start>=n or allocation fails, *out_count = 0 and return. Otherwise, dist contains BFS distances from start; out[0..*out_count-1] stores dequeue order.

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %graph, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %early, label %init_dist

early:
  store i64 0, i64* %out_count, align 8
  ret void

init_dist:
  br label %dist_loop

dist_loop:
  %i = phi i64 [ 0, %init_dist ], [ %i_next, %dist_body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %dist_body, label %after_init

dist_body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i_next = add i64 %i, 1
  br label %dist_loop

after_init:
  %size = shl i64 %n, 3
  %q_bytes = call noalias i8* @malloc(i64 %size)
  %qnull = icmp eq i8* %q_bytes, null
  br i1 %qnull, label %malloc_fail, label %queue_init

malloc_fail:
  store i64 0, i64* %out_count, align 8
  ret void

queue_init:
  %queue = bitcast i8* %q_bytes to i64*
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %q0_ptr = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0_ptr, align 8
  store i64 0, i64* %out_count, align 8
  br label %bfs_loop

bfs_loop:
  %head = phi i64 [ 0, %queue_init ], [ %head2, %after_neighbors ]
  %tail = phi i64 [ 1, %queue_init ], [ %tail2, %after_neighbors ]
  %has = icmp ult i64 %head, %tail
  br i1 %has, label %dequeue, label %done

dequeue:
  %q_head_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %curr = load i64, i64* %q_head_ptr, align 8
  %head1 = add i64 %head, 1
  %cnt0 = load i64, i64* %out_count, align 8
  %out_pos_ptr = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %curr, i64* %out_pos_ptr, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count, align 8
  br label %nbr_loop

nbr_loop:
  %j = phi i64 [ 0, %dequeue ], [ %j_next, %nbr_loop_latch ]
  %t = phi i64 [ %tail, %dequeue ], [ %t_next, %nbr_loop_latch ]
  %h = phi i64 [ %head1, %dequeue ], [ %h, %nbr_loop_latch ]
  %j_cond = icmp ult i64 %j, %n
  br i1 %j_cond, label %check_edge, label %after_neighbors

check_edge:
  %prod = mul i64 %curr, %n
  %idx = add i64 %prod, %j
  %g_ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %edge = load i32, i32* %g_ptr, align 4
  %edge_zero = icmp eq i32 %edge, 0
  br i1 %edge_zero, label %nbr_inc, label %check_visit

check_visit:
  %dist_j_ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dj = load i32, i32* %dist_j_ptr, align 4
  %unvis = icmp eq i32 %dj, -1
  br i1 %unvis, label %visit, label %nbr_inc

visit:
  %dist_curr_ptr = getelementptr inbounds i32, i32* %dist, i64 %curr
  %dc = load i32, i32* %dist_curr_ptr, align 4
  %dc1 = add nsw i32 %dc, 1
  store i32 %dc1, i32* %dist_j_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %queue, i64 %t
  store i64 %j, i64* %q_tail_ptr, align 8
  %t2 = add i64 %t, 1
  br label %nbr_loop_latch

nbr_inc:
  br label %nbr_loop_latch

nbr_loop_latch:
  %t_next = phi i64 [ %t, %nbr_inc ], [ %t2, %visit ]
  %j_next = add i64 %j, 1
  br label %nbr_loop

after_neighbors:
  %tail2 = phi i64 [ %t, %nbr_loop ]
  %head2 = phi i64 [ %h, %nbr_loop ]
  br label %bfs_loop

done:
  call void @free(i8* %q_bytes)
  ret void
}