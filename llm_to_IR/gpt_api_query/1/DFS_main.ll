; ModuleID = 'dfs'
source_filename = "dfs"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out_seq, i64* %out_len_ptr) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %ret_zero, label %check_start

ret_zero:
  store i64 0, i64* %out_len_ptr
  ret void

check_start:
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %alloc, label %ret_zero

alloc:
  %size_vis = shl i64 %n, 2
  %raw_vis = call i8* @malloc(i64 %size_vis)
  %size64 = shl i64 %n, 3
  %raw_next = call i8* @malloc(i64 %size64)
  %raw_stack = call i8* @malloc(i64 %size64)
  %visited = bitcast i8* %raw_vis to i32*
  %next = bitcast i8* %raw_next to i64*
  %stack = bitcast i8* %raw_stack to i64*
  %vis_is_null = icmp eq i8* %raw_vis, null
  %next_is_null = icmp eq i8* %raw_next, null
  %stack_is_null = icmp eq i8* %raw_stack, null
  %any_null_t = or i1 %vis_is_null, %next_is_null
  %any_null = or i1 %any_null_t, %stack_is_null
  br i1 %any_null, label %alloc_fail, label %init

alloc_fail:
  call void @free(i8* %raw_vis)
  call void @free(i8* %raw_next)
  call void @free(i8* %raw_stack)
  store i64 0, i64* %out_len_ptr
  ret void

init:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %init_loop_body_post ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_loop_body, label %after_init

init_loop_body:
  %vis_ptr_i = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_ptr_i
  %next_ptr_i = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr_i
  br label %init_loop_body_post

init_loop_body_post:
  %i.next = add i64 %i, 1
  br label %init_loop

after_init:
  store i64 0, i64* %out_len_ptr
  ; push start onto stack at index 0
  %stack_ptr0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_ptr0
  ; mark visited[start] = 1
  %vis_ptr_start = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_ptr_start
  ; append start to out_seq
  %len_old0 = load i64, i64* %out_len_ptr
  %len_new0 = add i64 %len_old0, 1
  store i64 %len_new0, i64* %out_len_ptr
  %out_pos_ptr0 = getelementptr inbounds i64, i64* %out_seq, i64 %len_old0
  store i64 %start, i64* %out_pos_ptr0
  br label %outer_check

outer_check:
  %ss = phi i64 [ 1, %after_init ], [ %ss_push, %after_push ], [ %ss_pop, %after_pop ]
  %ss_nonzero = icmp ne i64 %ss, 0
  br i1 %ss_nonzero, label %outer_body, label %cleanup

outer_body:
  %idx_top = add i64 %ss, -1
  %stack_ptr_top = getelementptr inbounds i64, i64* %stack, i64 %idx_top
  %current = load i64, i64* %stack_ptr_top
  %next_ptr_cur = getelementptr inbounds i64, i64* %next, i64 %current
  %j0 = load i64, i64* %next_ptr_cur
  br label %inner_header

inner_header:
  %j = phi i64 [ %j0, %outer_body ], [ %j_inc, %j_increase ]
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %inner_body, label %after_pop

inner_body:
  %row_mul = mul i64 %current, %n
  %lin = add i64 %row_mul, %j
  %adj_elem_ptr = getelementptr inbounds i32, i32* %adj, i64 %lin
  %adj_val = load i32, i32* %adj_elem_ptr
  %adj_zero = icmp eq i32 %adj_val, 0
  br i1 %adj_zero, label %j_increase, label %check_visited

j_increase:
  %j_inc = add i64 %j, 1
  br label %inner_header

check_visited:
  %vis_ptr_j = getelementptr inbounds i32, i32* %visited, i64 %j
  %vis_val = load i32, i32* %vis_ptr_j
  %is_visited = icmp ne i32 %vis_val, 0
  br i1 %is_visited, label %j_increase, label %found_neighbor

found_neighbor:
  %j_plus1 = add i64 %j, 1
  store i64 %j_plus1, i64* %next_ptr_cur
  store i32 1, i32* %vis_ptr_j
  %len_old = load i64, i64* %out_len_ptr
  %len_new = add i64 %len_old, 1
  store i64 %len_new, i64* %out_len_ptr
  %out_pos_ptr = getelementptr inbounds i64, i64* %out_seq, i64 %len_old
  store i64 %j, i64* %out_pos_ptr
  %stack_ptr_push = getelementptr inbounds i64, i64* %stack, i64 %ss
  store i64 %j, i64* %stack_ptr_push
  %ss_push = add i64 %ss, 1
  br label %after_push

after_push:
  br label %outer_check

after_pop:
  %ss_pop = add i64 %ss, -1
  br label %outer_check

cleanup:
  call void @free(i8* %raw_vis)
  call void @free(i8* %raw_next)
  call void @free(i8* %raw_stack)
  ret void
}