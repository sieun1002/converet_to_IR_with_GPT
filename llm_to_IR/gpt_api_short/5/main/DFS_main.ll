; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs ; Address: 0x11C9
; Intent: Iterative DFS over an adjacency matrix from a start node; emits visit order into out and count into out_count (confidence=0.84). Evidence: adj[u*n+v] access, visited array, explicit stack and next-edge indices, appending nodes to out/out_count.
; Preconditions: adj points to at least n*n i32s; out points to sufficient space; out_count is valid; 0 <= start < n.
; Postconditions: out[0..(*out_count-1)] contains DFS order starting at start. If n==0, start>=n, or allocation fails: *out_count == 0.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %ret_zero, label %alloc

ret_zero:                                          ; preds = %entry
  store i64 0, i64* %out_count, align 8
  ret void

alloc:                                             ; preds = %entry
  %vis_sz_bytes = shl i64 %n, 2
  %vis_i8 = call i8* @malloc(i64 %vis_sz_bytes)
  %vis = bitcast i8* %vis_i8 to i32*
  %nx_sz_bytes = shl i64 %n, 3
  %nx_i8 = call i8* @malloc(i64 %nx_sz_bytes)
  %nx = bitcast i8* %nx_i8 to i64*
  %stk_i8 = call i8* @malloc(i64 %nx_sz_bytes)
  %stk = bitcast i8* %stk_i8 to i64*
  %anynull1 = icmp eq i8* %vis_i8, null
  %anynull2 = icmp eq i8* %nx_i8, null
  %anynull3 = icmp eq i8* %stk_i8, null
  %tmp_or = or i1 %anynull1, %anynull2
  %anynull = or i1 %tmp_or, %anynull3
  br i1 %anynull, label %alloc_fail, label %init

alloc_fail:                                        ; preds = %alloc
  call void @free(i8* %vis_i8)
  call void @free(i8* %nx_i8)
  call void @free(i8* %stk_i8)
  store i64 0, i64* %out_count, align 8
  ret void

init:                                              ; preds = %alloc
  br label %init_loop

init_loop:                                         ; preds = %init_loop_body_exit, %init
  %i = phi i64 [ 0, %init ], [ %i.next, %init_loop_body_exit ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init_loop_body, label %after_init

init_loop_body:                                    ; preds = %init_loop
  %vis_ptr_i = getelementptr inbounds i32, i32* %vis, i64 %i
  store i32 0, i32* %vis_ptr_i, align 4
  %nx_ptr_i = getelementptr inbounds i64, i64* %nx, i64 %i
  store i64 0, i64* %nx_ptr_i, align 8
  br label %init_loop_body_exit

init_loop_body_exit:                               ; preds = %init_loop_body
  %i.next = add i64 %i, 1
  br label %init_loop

after_init:                                        ; preds = %init_loop
  store i64 0, i64* %out_count, align 8
  %stk0 = getelementptr inbounds i64, i64* %stk, i64 0
  store i64 %start, i64* %stk0, align 8
  %vis_start_ptr = getelementptr inbounds i32, i32* %vis, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  store i64 %start, i64* %out, align 8
  store i64 1, i64* %out_count, align 8
  br label %main_loop

main_loop:                                         ; preds = %after_for_exhaust, %found_neighbor, %after_init
  %stack_size = phi i64 [ 1, %after_init ], [ %stack_size_next_from_push, %found_neighbor ], [ %stack_size_after_pop, %after_for_exhaust ]
  %empty = icmp eq i64 %stack_size, 0
  br i1 %empty, label %cleanup, label %process_top

process_top:                                       ; preds = %main_loop
  %idx_top = add i64 %stack_size, -1
  %stk_ptr_top = getelementptr inbounds i64, i64* %stk, i64 %idx_top
  %u = load i64, i64* %stk_ptr_top, align 8
  %nx_ptr_u = getelementptr inbounds i64, i64* %nx, i64 %u
  %v0 = load i64, i64* %nx_ptr_u, align 8
  br label %for_loop

for_loop:                                          ; preds = %for_inc, %process_top
  %v = phi i64 [ %v0, %process_top ], [ %v.next, %for_inc ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %check_edge, label %after_for_exhaust

check_edge:                                        ; preds = %for_loop
  %u_mul_n = mul i64 %u, %n
  %idx = add i64 %u_mul_n, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge_val = load i32, i32* %adj_ptr, align 4
  %edge_zero = icmp eq i32 %edge_val, 0
  br i1 %edge_zero, label %for_inc, label %check_visited

check_visited:                                     ; preds = %check_edge
  %vis_ptr_v = getelementptr inbounds i32, i32* %vis, i64 %v
  %vis_val_v = load i32, i32* %vis_ptr_v, align 4
  %vis_is_zero = icmp eq i32 %vis_val_v, 0
  br i1 %vis_is_zero, label %found_neighbor, label %for_inc

found_neighbor:                                    ; preds = %check_visited
  %v_plus1 = add i64 %v, 1
  store i64 %v_plus1, i64* %nx_ptr_u, align 8
  store i32 1, i32* %vis_ptr_v, align 4
  %oldc = load i64, i64* %out_count, align 8
  %oldc_ptr = getelementptr inbounds i64, i64* %out, i64 %oldc
  store i64 %v, i64* %oldc_ptr, align 8
  %newc = add i64 %oldc, 1
  store i64 %newc, i64* %out_count, align 8
  %stk_ptr_push = getelementptr inbounds i64, i64* %stk, i64 %stack_size
  store i64 %v, i64* %stk_ptr_push, align 8
  %stack_size_next_from_push = add i64 %stack_size, 1
  br label %main_loop

for_inc:                                           ; preds = %check_edge, %check_visited
  %v.next = add i64 %v, 1
  br label %for_loop

after_for_exhaust:                                 ; preds = %for_loop
  %stack_size_after_pop = add i64 %stack_size, -1
  br label %main_loop

cleanup:                                           ; preds = %main_loop
  call void @free(i8* %vis_i8)
  call void @free(i8* %nx_i8)
  call void @free(i8* %stk_i8)
  ret void
}