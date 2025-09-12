; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs  ; Address: 0x11C9
; Intent: Breadth-first search over an adjacency matrix; fills distances and visit order (confidence=0.95). Evidence: initializes dist to -1, queue-based traversal with dist[next]=dist[cur]+1 and enqueue.
; Preconditions: adj points to at least n*n i32s; dist points to at least n i32s; out points to at least n i64s; outCount is a valid i64*.

; Only the needed extern declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %outCount) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %ret_zero, label %check_start

check_start:
  %start_ge_n = icmp uge i64 %start, %n
  br i1 %start_ge_n, label %ret_zero, label %init_loop

init_loop:
  br label %init_loop.head

init_loop.head:
  %i = phi i64 [ 0, %init_loop ], [ %i.next, %init_loop.inc ]
  %cmp_i = icmp ult i64 %i, %n
  br i1 %cmp_i, label %init_loop.body, label %after_init

init_loop.body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  br label %init_loop.inc

init_loop.inc:
  %i.next = add i64 %i, 1
  br label %init_loop.head

after_init:
  %size = shl i64 %n, 3
  %q.raw = call noalias i8* @malloc(i64 %size)
  %queue = bitcast i8* %q.raw to i64*
  %q.isnull = icmp eq i64* %queue, null
  br i1 %q.isnull, label %ret_zero, label %init2

init2:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %q0ptr = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0ptr, align 8
  store i64 0, i64* %outCount, align 8
  br label %outer_cond

outer_cond:
  %head = phi i64 [ 0, %init2 ], [ %head.next, %outer_body_end ]
  %tail.ph = phi i64 [ 1, %init2 ], [ %tail.after, %outer_body_end ]
  %cond = icmp ult i64 %head, %tail.ph
  br i1 %cond, label %outer_body, label %cleanup

outer_body:
  %q_head_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %cur = load i64, i64* %q_head_ptr, align 8
  %head.next = add i64 %head, 1
  %outCount.val = load i64, i64* %outCount, align 8
  %outCount.next = add i64 %outCount.val, 1
  store i64 %outCount.next, i64* %outCount, align 8
  %out_ptr = getelementptr inbounds i64, i64* %out, i64 %outCount.val
  store i64 %cur, i64* %out_ptr, align 8
  br label %neigh_head

neigh_head:
  %j = phi i64 [ 0, %outer_body ], [ %j.next, %neigh_inc ]
  %tail.loop = phi i64 [ %tail.ph, %outer_body ], [ %tail.updated.iter, %neigh_inc ]
  %cmp_j = icmp ult i64 %j, %n
  br i1 %cmp_j, label %neigh_body, label %outer_body_end

neigh_body:
  %mul = mul i64 %cur, %n
  %idx = add i64 %mul, %j
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %adj_zero = icmp eq i32 %adj_val, 0
  br i1 %adj_zero, label %neigh_inc, label %edge_nonzero

edge_nonzero:
  %dist_j_ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dist_j_val = load i32, i32* %dist_j_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_j_val, -1
  br i1 %is_unvisited, label %visit_neighbor, label %neigh_inc

visit_neighbor:
  %dist_cur_ptr = getelementptr inbounds i32, i32* %dist, i64 %cur
  %dist_cur_val = load i32, i32* %dist_cur_ptr, align 4
  %newdist = add i32 %dist_cur_val, 1
  store i32 %newdist, i32* %dist_j_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.loop
  store i64 %j, i64* %q_tail_ptr, align 8
  %tail.next = add i64 %tail.loop, 1
  br label %neigh_inc

neigh_inc:
  %tail.updated.iter = phi i64 [ %tail.loop, %neigh_body ], [ %tail.loop, %edge_nonzero ], [ %tail.next, %visit_neighbor ]
  %j.next = add i64 %j, 1
  br label %neigh_head

outer_body_end:
  %tail.after = phi i64 [ %tail.loop, %neigh_head ]
  br label %outer_cond

cleanup:
  call void @free(i8* %q.raw)
  ret void

ret_zero:
  store i64 0, i64* %outCount, align 8
  ret void
}