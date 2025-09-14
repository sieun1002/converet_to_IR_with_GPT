; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs ; Address: 0x11C9
; Intent: Breadth-first search over an adjacency matrix; fills dist[] with levels and records visit order (confidence=0.95). Evidence: dist initialized to -1 and set via dist[u]+1; queue via malloc/free and head/tail; append to order and count via order_len.
; Preconditions: adj is an N×N row-major int32 matrix; 0 <= src < N; dist has length >= N; order has capacity >= N; order_len is a valid i64*.
; Postconditions: dist[src]=0; dist[v] is BFS level or -1 if unreachable; order[0..order_len-1] holds nodes in dequeue order; order_len is number of visited nodes.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* nocapture readonly %adj, i64 %n, i64 %src, i32* nocapture %dist, i64* nocapture %order, i64* nocapture %order_len) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %src_oob = icmp uge i64 %src, %n
  %bad = or i1 %n_is_zero, %src_oob
  br i1 %bad, label %early, label %init_start

early:                                            ; preds = %after_init, %entry
  store i64 0, i64* %order_len, align 8
  ret void

init_start:                                       ; preds = %entry
  br label %init_loop

init_loop:                                        ; preds = %init_body, %init_start
  %i = phi i64 [ 0, %init_start ], [ %i.next, %init_body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init_body, label %after_init

init_body:                                        ; preds = %init_loop
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop

after_init:                                       ; preds = %init_loop
  %size_bytes = shl i64 %n, 3
  %mem = call noalias i8* @malloc(i64 %size_bytes)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %early, label %cont

cont:                                             ; preds = %after_init
  %q = bitcast i8* %mem to i64*
  %dist_src_ptr = getelementptr inbounds i32, i32* %dist, i64 %src
  store i32 0, i32* %dist_src_ptr, align 4
  %q0ptr = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %src, i64* %q0ptr, align 8
  store i64 0, i64* %order_len, align 8
  br label %outer_cond

outer_cond:                                       ; preds = %after_inner, %cont
  %head = phi i64 [ 0, %cont ], [ %head.next, %after_inner ]
  %tail = phi i64 [ 1, %cont ], [ %tail.out, %after_inner ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %dequeue, label %cleanup

dequeue:                                          ; preds = %outer_cond
  %uptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %uptr, align 8
  %head.next = add i64 %head, 1
  %oldcnt = load i64, i64* %order_len, align 8
  %newcnt = add i64 %oldcnt, 1
  store i64 %newcnt, i64* %order_len, align 8
  %order_slot = getelementptr inbounds i64, i64* %order, i64 %oldcnt
  store i64 %u, i64* %order_slot, align 8
  br label %inner_cond

inner_cond:                                       ; preds = %inner_body_end, %dequeue
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %inner_body_end ]
  %tail.in = phi i64 [ %tail, %dequeue ], [ %tail.propagate, %inner_body_end ]
  %more = icmp ult i64 %v, %n
  br i1 %more, label %inner_body, label %after_inner

inner_body:                                       ; preds = %inner_cond
  %un = mul i64 %u, %n
  %idx = add i64 %un, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %a = load i32, i32* %adj_ptr, align 4
  %adj_nz = icmp ne i32 %a, 0
  br i1 %adj_nz, label %check_unvisited, label %inner_body_end

check_unvisited:                                  ; preds = %inner_body
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %unvisited = icmp eq i32 %dist_v, -1
  br i1 %unvisited, label %visit, label %inner_body_end

visit:                                            ; preds = %check_unvisited
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_inc = add i32 %dist_u, 1
  store i32 %dist_u_inc, i32* %dist_v_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %q, i64 %tail.in
  store i64 %v, i64* %q_tail_ptr, align 8
  %tail.new = add i64 %tail.in, 1
  br label %inner_body_end

inner_body_end:                                   ; preds = %visit, %check_unvisited, %inner_body
  %tail.propagate = phi i64 [ %tail.in, %inner_body ], [ %tail.in, %check_unvisited ], [ %tail.new, %visit ]
  %v.next = add i64 %v, 1
  br label %inner_cond

after_inner:                                      ; preds = %inner_cond
  %tail.out = phi i64 [ %tail.in, %inner_cond ]
  br label %outer_cond

cleanup:                                          ; preds = %outer_cond
  call void @free(i8* %mem)
  ret void
}