; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs  ; Address: 0x11C9
; Intent: Iterative DFS (preorder) on an n×n int adjacency matrix; writes visit order to out and count to out_count (confidence=0.95). Evidence: adjacency index i*n+j with 4-byte elements; explicit visited[], per-node next-index[], and stack[] arrays with DFS push/pop.
; Preconditions: adj points to n*n 32-bit ints in row-major; out has capacity ≥ n; out_count is non-null; 0 ≤ start < n to perform traversal (else out_count is set to 0).
; Postconditions: *out_count = number of reachable vertices from start; out[0..*out_count-1] are the visited vertices in preorder.

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  ; early exit if n == 0 or start >= n
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %early = or i1 %n_is_zero, %start_ge_n
  br i1 %early, label %early_ret, label %allocs

early_ret:
  store i64 0, i64* %out_count, align 8
  ret void

allocs:
  %size4 = shl i64 %n, 2
  %visited_i8 = call noalias i8* @malloc(i64 %size4)
  %visited = bitcast i8* %visited_i8 to i32*
  %size8 = shl i64 %n, 3
  %next_i8 = call noalias i8* @malloc(i64 %size8)
  %next = bitcast i8* %next_i8 to i64*
  %stack_i8 = call noalias i8* @malloc(i64 %size8)
  %stack = bitcast i8* %stack_i8 to i64*
  %vis_null = icmp eq i8* %visited_i8, null
  %next_null = icmp eq i8* %next_i8, null
  %stack_null = icmp eq i8* %stack_i8, null
  %any_null1 = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null1, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_loop

alloc_fail:
  call void @free(i8* %visited_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  store i64 0, i64* %out_count, align 8
  ret void

init_loop:
  br label %init_hdr

init_hdr:
  %i = phi i64 [ 0, %init_loop ], [ %i.next, %init_body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init_body, label %after_init

init_body:
  %vis_gep = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_gep, align 4
  %next_gep = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_gep, align 8
  %i.next = add i64 %i, 1
  br label %init_hdr

after_init:
  ; initialize stack and output with start
  store i64 0, i64* %out_count, align 8
  %stack_slot0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_slot0, align 8
  %stack_size.init = add i64 0, 1
  ; mark visited[start] = 1
  %vis_start_gep = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start_gep, align 4
  ; increment out_count then store start at previous index
  %oc0 = load i64, i64* %out_count, align 8
  %oc1 = add i64 %oc0, 1
  store i64 %oc1, i64* %out_count, align 8
  %out_gep0 = getelementptr inbounds i64, i64* %out, i64 %oc0
  store i64 %start, i64* %out_gep0, align 8
  br label %main_check

main_check:
  %stack_size = phi i64 [ %stack_size.init, %after_init ], [ %stack_size.next_from_push, %after_push ], [ %stack_size.dec, %after_neighbors ]
  %has_items = icmp ne i64 %stack_size, 0
  br i1 %has_items, label %process_top, label %cleanup

process_top:
  ; curr = stack[stack_size-1]
  %top_index = add i64 %stack_size, -1
  %stack_top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_index
  %curr = load i64, i64* %stack_top_ptr, align 8
  ; i = next[curr]
  %next_ptr_curr = getelementptr inbounds i64, i64* %next, i64 %curr
  %i0 = load i64, i64* %next_ptr_curr, align 8
  br label %neighbor_check

neighbor_check:
  %i.cur = phi i64 [ %i0, %process_top ], [ %i.inc, %inc_i ]
  %i_lt_n = icmp ult i64 %i.cur, %n
  br i1 %i_lt_n, label %neighbor_test, label %after_neighbors

neighbor_test:
  ; if adj[curr*n + i] != 0 and visited[i] == 0
  %mul = mul i64 %curr, %n
  %idx = add i64 %mul, %i.cur
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge = load i32, i32* %adj_ptr, align 4
  %edge_nz = icmp ne i32 %edge, 0
  br i1 %edge_nz, label %check_visited, label %inc_i

check_visited:
  %vis_i_ptr = getelementptr inbounds i32, i32* %visited, i64 %i.cur
  %vis_i = load i32, i32* %vis_i_ptr, align 4
  %not_visited = icmp eq i32 %vis_i, 0
  br i1 %not_visited, label %explore, label %inc_i

explore:
  ; next[curr] = i+1
  %i.plus1 = add i64 %i.cur, 1
  store i64 %i.plus1, i64* %next_ptr_curr, align 8
  ; visited[i] = 1
  store i32 1, i32* %vis_i_ptr, align 4
  ; out_count++ ; out[old] = i
  %oc_old = load i64, i64* %out_count, align 8
  %oc_new = add i64 %oc_old, 1
  store i64 %oc_new, i64* %out_count, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %oc_old
  store i64 %i.cur, i64* %out_slot, align 8
  ; push i onto stack
  %stack_push_ptr = getelementptr inbounds i64, i64* %stack, i64 %stack_size
  store i64 %i.cur, i64* %stack_push_ptr, align 8
  %stack_size.next_from_push = add i64 %stack_size, 1
  br label %after_push

inc_i:
  %i.inc = add i64 %i.cur, 1
  br label %neighbor_check

after_neighbors:
  ; i.cur >= n -> pop
  %stack_size.dec = add i64 %stack_size, -1
  br label %main_check

after_push:
  br label %main_check

cleanup:
  call void @free(i8* %visited_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  ret void
}