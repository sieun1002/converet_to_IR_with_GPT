; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs  ; Address: 0x11C9
; Intent: Breadth-first search on an n x n adjacency matrix; fills distance array and outputs visit order/count (confidence=0.95). Evidence: adjacency[u*n+v] access, queue-based traversal
; Preconditions: adj is an n*n row-major array of i32; dist has length >= n; order has length >= n; count_io is non-null
; Postconditions: dist[start]=0; dist[v]>=0 iff reachable; order[0..*count_io-1] stores nodes in BFS visitation order

; Only the needed extern declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %count_io) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

early_zero:                                        ; preds = %entry
  store i64 0, i64* %count_io, align 8
  ret void

check_start:                                       ; preds = %entry
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %init_dist, label %early_zero2

early_zero2:                                       ; preds = %check_start
  store i64 0, i64* %count_io, align 8
  ret void

init_dist:                                         ; preds = %check_start
  br label %dist_loop

dist_loop:                                         ; preds = %dist_loop_body, %init_dist
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %dist_loop_body ]
  %i_cmp = icmp ult i64 %i, %n
  br i1 %i_cmp, label %dist_loop_body, label %after_init

dist_loop_body:                                    ; preds = %dist_loop
  %dist_gep = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_gep, align 4
  %i.next = add i64 %i, 1
  br label %dist_loop

after_init:                                        ; preds = %dist_loop
  %sz = shl i64 %n, 3
  %q_raw = call i8* @malloc(i64 %sz)
  %q = bitcast i8* %q_raw to i64*
  %q_is_null = icmp eq i64* %q, null
  br i1 %q_is_null, label %early_zero3, label %init_queue

early_zero3:                                       ; preds = %after_init
  store i64 0, i64* %count_io, align 8
  ret void

init_queue:                                        ; preds = %after_init
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %q0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %start, i64* %q0, align 8
  store i64 0, i64* %count_io, align 8
  br label %outer_header

outer_header:                                      ; preds = %outer_latch, %init_queue
  %head = phi i64 [ 0, %init_queue ], [ %head.next, %outer_latch ]
  %tail = phi i64 [ 1, %init_queue ], [ %tail.after_inner, %outer_latch ]
  %cond_outer = icmp ult i64 %head, %tail
  br i1 %cond_outer, label %outer_body, label %done

outer_body:                                        ; preds = %outer_header
  %q_head_ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %q_head_ptr, align 8
  %head.next = add i64 %head, 1
  %cnt0 = load i64, i64* %count_io, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %count_io, align 8
  %order_slot = getelementptr inbounds i64, i64* %order, i64 %cnt0
  store i64 %u, i64* %order_slot, align 8
  br label %inner_header

inner_header:                                      ; preds = %inner_latch, %outer_body
  %v = phi i64 [ 0, %outer_body ], [ %v.next, %inner_latch ]
  %tail.cur = phi i64 [ %tail, %outer_body ], [ %tail.next.phi, %inner_latch ]
  %cond_inner = icmp ult i64 %v, %n
  br i1 %cond_inner, label %inner_body, label %inner_end

inner_body:                                        ; preds = %inner_header
  %un = mul i64 %u, %n
  %idx_mat = add i64 %un, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx_mat
  %a = load i32, i32* %adj_ptr, align 4
  %a_is_zero = icmp eq i32 %a, 0
  br i1 %a_is_zero, label %inner_latch, label %check_unseen

check_unseen:                                      ; preds = %inner_body
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv = load i32, i32* %dist_v_ptr, align 4
  %is_unseen = icmp eq i32 %dv, -1
  br i1 %is_unseen, label %discover, label %inner_latch

discover:                                          ; preds = %check_unseen
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %dist_u_ptr, align 4
  %du1 = add i32 %du, 1
  store i32 %du1, i32* %dist_v_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %q, i64 %tail.cur
  store i64 %v, i64* %q_tail_ptr, align 8
  %tail.inc = add i64 %tail.cur, 1
  br label %inner_latch

inner_latch:                                       ; preds = %check_unseen, %discover, %inner_body
  %tail.next.phi = phi i64 [ %tail.cur, %inner_body ], [ %tail.inc, %discover ], [ %tail.cur, %check_unseen ]
  %v.next = add i64 %v, 1
  br label %inner_header

inner_end:                                         ; preds = %inner_header
  %tail.after_inner = phi i64 [ %tail.cur, %inner_header ]
  br label %outer_latch

outer_latch:                                       ; preds = %inner_end
  br label %outer_header

done:                                              ; preds = %outer_header
  %q_raw_free = bitcast i64* %q to i8*
  call void @free(i8* %q_raw_free)
  ret void
}