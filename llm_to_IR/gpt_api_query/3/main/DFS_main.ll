; ModuleID = 'dfs_module'
source_filename = "dfs_module.ll"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count_ptr) {
entry:
  ; early exit if n == 0 or start >= n
  %n_is_zero = icmp eq i64 %n, 0
  %start_lt_n = icmp ult i64 %start, %n
  %n_ok = xor i1 %n_is_zero, true
  %valid = and i1 %n_ok, %start_lt_n
  br i1 %valid, label %allocs, label %early_zero

early_zero:                                        ; preds = %entry
  store i64 0, i64* %out_count_ptr, align 8
  ret void

allocs:                                            ; preds = %entry
  ; allocate visited (i32[n]), next (i64[n]), stack (i64[n])
  %bytes_visited = mul i64 %n, 4
  %visited_raw = call i8* @malloc(i64 %bytes_visited)
  %visited = bitcast i8* %visited_raw to i32*

  %bytes_next = mul i64 %n, 8
  %next_raw = call i8* @malloc(i64 %bytes_next)
  %next = bitcast i8* %next_raw to i64*

  %bytes_stack = mul i64 %n, 8
  %stack_raw = call i8* @malloc(i64 %bytes_stack)
  %stack = bitcast i8* %stack_raw to i64*

  ; check allocation failures
  %vis_null = icmp eq i8* %visited_raw, null
  %next_null = icmp eq i8* %next_raw, null
  %stack_null = icmp eq i8* %stack_raw, null
  %any_null_tmp = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null_tmp, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_arrays

alloc_fail:                                        ; preds = %allocs
  ; free any that were allocated
  br i1 %vis_null, label %skip_free_vis, label %do_free_vis
do_free_vis:
  call void @free(i8* %visited_raw)
  br label %after_free_vis
skip_free_vis:
  br label %after_free_vis
after_free_vis:
  br i1 %next_null, label %skip_free_next, label %do_free_next
do_free_next:
  call void @free(i8* %next_raw)
  br label %after_free_next
skip_free_next:
  br label %after_free_next
after_free_next:
  br i1 %stack_null, label %skip_free_stack, label %do_free_stack
do_free_stack:
  call void @free(i8* %stack_raw)
  br label %after_free_stack
skip_free_stack:
  br label %after_free_stack
after_free_stack:
  store i64 0, i64* %out_count_ptr, align 8
  ret void

init_arrays:                                       ; preds = %allocs
  ; i = 0
  %i_init = alloca i64, align 8
  store i64 0, i64* %i_init, align 8
  br label %zero_loop

zero_loop:                                         ; preds = %zero_loop, %init_arrays
  %i_val = load i64, i64* %i_init, align 8
  %i_lt_n = icmp ult i64 %i_val, %n
  br i1 %i_lt_n, label %zero_body, label %post_init

zero_body:                                         ; preds = %zero_loop
  ; visited[i] = 0
  %vis_ptr = getelementptr inbounds i32, i32* %visited, i64 %i_val
  store i32 0, i32* %vis_ptr, align 4
  ; next[i] = 0
  %next_ptr_i = getelementptr inbounds i64, i64* %next, i64 %i_val
  store i64 0, i64* %next_ptr_i, align 8
  ; i++
  %i_inc = add i64 %i_val, 1
  store i64 %i_inc, i64* %i_init, align 8
  br label %zero_loop

post_init:                                         ; preds = %zero_loop
  ; stack_size = 0
  %stack_size = alloca i64, align 8
  store i64 0, i64* %stack_size, align 8
  ; *out_count_ptr = 0
  store i64 0, i64* %out_count_ptr, align 8

  ; push start onto stack
  %sz0 = load i64, i64* %stack_size, align 8
  %stack_slot0 = getelementptr inbounds i64, i64* %stack, i64 %sz0
  store i64 %start, i64* %stack_slot0, align 8
  %sz1 = add i64 %sz0, 1
  store i64 %sz1, i64* %stack_size, align 8

  ; visited[start] = 1
  %vis_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4

  ; out_count++ and out[old] = start
  %old_count0 = load i64, i64* %out_count_ptr, align 8
  %new_count0 = add i64 %old_count0, 1
  store i64 %new_count0, i64* %out_count_ptr, align 8
  %out_slot0 = getelementptr inbounds i64, i64* %out, i64 %old_count0
  store i64 %start, i64* %out_slot0, align 8

  br label %while_stack_check

while_stack_check:                                 ; preds = %inner_done, %found_unvisited, %post_init
  %sz = load i64, i64* %stack_size, align 8
  %not_empty = icmp ne i64 %sz, 0
  br i1 %not_empty, label %while_stack_body, label %final_cleanup

while_stack_body:                                  ; preds = %while_stack_check
  ; u = stack[sz-1]
  %top_idx = sub i64 %sz, 1
  %u_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_idx
  %u = load i64, i64* %u_ptr, align 8

  ; i = next[u]
  %next_u_ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %i_start = load i64, i64* %next_u_ptr, align 8
  br label %inner_loop

inner_loop:                                        ; preds = %inner_continue, %while_stack_body
  %i = phi i64 [ %i_start, %while_stack_body ], [ %i_next, %inner_continue ]
  %i_lt_n2 = icmp ult i64 %i, %n
  br i1 %i_lt_n2, label %inner_body, label %inner_done

inner_body:                                        ; preds = %inner_loop
  ; if adj[u*n + i] != 0
  %un = mul i64 %u, %n
  %adj_index = add i64 %un, %i
  %adj_elem_ptr = getelementptr inbounds i32, i32* %adj, i64 %adj_index
  %adj_val = load i32, i32* %adj_elem_ptr, align 4
  %edge = icmp ne i32 %adj_val, 0
  br i1 %edge, label %check_visited, label %inner_continue

check_visited:                                     ; preds = %inner_body
  ; if visited[i] == 0
  %vis_i_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  %vis_i_val = load i32, i32* %vis_i_ptr, align 4
  %unvisited = icmp eq i32 %vis_i_val, 0
  br i1 %unvisited, label %found_unvisited, label %inner_continue

found_unvisited:                                   ; preds = %check_visited
  ; next[u] = i + 1
  %i_plus1 = add i64 %i, 1
  store i64 %i_plus1, i64* %next_u_ptr, align 8

  ; visited[i] = 1
  store i32 1, i32* %vis_i_ptr, align 4

  ; out_count++ and out[old] = i
  %old_count = load i64, i64* %out_count_ptr, align 8
  %new_count = add i64 %old_count, 1
  store i64 %new_count, i64* %out_count_ptr, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %old_count
  store i64 %i, i64* %out_slot, align 8

  ; push i onto stack
  %sz_cur = load i64, i64* %stack_size, align 8
  %stack_slot = getelementptr inbounds i64, i64* %stack, i64 %sz_cur
  store i64 %i, i64* %stack_slot, align 8
  %sz_inc2 = add i64 %sz_cur, 1
  store i64 %sz_inc2, i64* %stack_size, align 8

  br label %while_stack_check

inner_continue:                                    ; preds = %check_visited, %inner_body
  ; i++
  %i_next = add i64 %i, 1
  br label %inner_loop

inner_done:                                        ; preds = %inner_loop
  ; finished neighbors: pop stack
  %sz_now = load i64, i64* %stack_size, align 8
  %sz_dec = sub i64 %sz_now, 1
  store i64 %sz_dec, i64* %stack_size, align 8
  br label %while_stack_check

final_cleanup:                                     ; preds = %while_stack_check
  call void @free(i8* %visited_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  ret void
}