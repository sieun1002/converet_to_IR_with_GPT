; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs  ; Address: 0x11C9
; Intent: Breadth-first search over an adjacency matrix; outputs visit order and shortest distances (confidence=0.98). Evidence: distance array initialized to -1; malloc’ed FIFO queue scanned with head<tail and adjacency row node*n+v.
; Preconditions: adj points to n*n i32 entries (row-major), dist points to n i32s, out points to n i64s, out_count is non-null; 0 <= start < n (else out_count is set to 0 and return).
; Postconditions: dist[v] = shortest hop count from start or -1 if unreachable; out[0..*out_count-1] is the visitation order; *out_count <= n.

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  %cond_n0 = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %invalid = or i1 %cond_n0, %start_ge_n
  br i1 %invalid, label %early_exit, label %init_loop_pre

early_exit:
  store i64 0, i64* %out_count
  ret void

init_loop_pre:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init_loop_pre ], [ %i.next, %init_loop_body ]
  %cont = icmp ult i64 %i, %n
  br i1 %cont, label %init_loop_body, label %after_init

init_loop_body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr
  %i.next = add i64 %i, 1
  br label %init_loop

after_init:
  %size = shl i64 %n, 3
  %mem = call noalias i8* @malloc(i64 %size)
  %q = bitcast i8* %mem to i64*
  %isnull = icmp eq i64* %q, null
  br i1 %isnull, label %malloc_fail, label %bfs_setup

malloc_fail:
  store i64 0, i64* %out_count
  ret void

bfs_setup:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr
  %q_tail0_ptr = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %start, i64* %q_tail0_ptr
  store i64 0, i64* %out_count
  br label %outer_loop

outer_loop:
  %head = phi i64 [ 0, %bfs_setup ], [ %head.next, %outer_loop_latch ]
  %tail = phi i64 [ 1, %bfs_setup ], [ %tail.updated, %outer_loop_latch ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %outer_body, label %done

outer_body:
  %q_head_ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %node = load i64, i64* %q_head_ptr
  %head.next = add i64 %head, 1
  %cnt_old = load i64, i64* %out_count
  %cnt_new = add i64 %cnt_old, 1
  store i64 %cnt_new, i64* %out_count
  %out_elem_ptr = getelementptr inbounds i64, i64* %out, i64 %cnt_old
  store i64 %node, i64* %out_elem_ptr
  br label %inner_loop

inner_loop:
  %v = phi i64 [ 0, %outer_body ], [ %v.next, %inner_latch ]
  %tail.cur = phi i64 [ %tail, %outer_body ], [ %tail.next, %inner_latch ]
  %cmp_v = icmp ult i64 %v, %n
  br i1 %cmp_v, label %inner_body, label %outer_loop_latch

inner_body:
  %mul = mul i64 %node, %n
  %idx = add i64 %mul, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr
  %is_edge = icmp ne i32 %adj_val, 0
  br i1 %is_edge, label %check_unseen, label %inner_latch

check_unseen:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr
  %is_unseen = icmp eq i32 %dist_v, -1
  br i1 %is_unseen, label %relax_enqueue, label %inner_latch

relax_enqueue:
  %dist_node_ptr = getelementptr inbounds i32, i32* %dist, i64 %node
  %dist_node = load i32, i32* %dist_node_ptr
  %dist_node_plus1 = add i32 %dist_node, 1
  store i32 %dist_node_plus1, i32* %dist_v_ptr
  %q_tail_ptr = getelementptr inbounds i64, i64* %q, i64 %tail.cur
  store i64 %v, i64* %q_tail_ptr
  %tail.next0 = add i64 %tail.cur, 1
  br label %inner_latch

inner_latch:
  %tail.next = phi i64 [ %tail.cur, %inner_body ], [ %tail.cur, %check_unseen ], [ %tail.next0, %relax_enqueue ]
  %v.next = add i64 %v, 1
  br label %inner_loop

outer_loop_latch:
  %tail.updated = phi i64 [ %tail.cur, %inner_loop ]
  br label %outer_loop

done:
  %q_i8 = bitcast i64* %q to i8*
  call void @free(i8* %q_i8)
  ret void
}