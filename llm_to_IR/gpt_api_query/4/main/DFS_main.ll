; ModuleID = 'dfs_module'
source_filename = "dfs.c"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %count) {
entry:
  ; Early exit if n == 0 or start >= n
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad_args = or i1 %n_is_zero, %start_ge_n
  br i1 %bad_args, label %early_ret, label %allocs

early_ret:
  store i64 0, i64* %count, align 8
  ret void

allocs:
  ; Allocate visited (i32[n]), nextIndex (i64[n]), stack (i64[n])
  %sz_visit = mul i64 %n, 4
  %visit_mem = call i8* @malloc(i64 %sz_visit)
  %visited = bitcast i8* %visit_mem to i32*

  %sz_next = mul i64 %n, 8
  %next_mem = call i8* @malloc(i64 %sz_next)
  %nextIndex = bitcast i8* %next_mem to i64*

  %stack_mem = call i8* @malloc(i64 %sz_next)
  %stack = bitcast i8* %stack_mem to i64*

  ; Check allocation failure
  %visit_null = icmp eq i8* %visit_mem, null
  %next_null = icmp eq i8* %next_mem, null
  %stack_null = icmp eq i8* %stack_mem, null
  %any_null.tmp = or i1 %visit_null, %next_null
  %any_null = or i1 %any_null.tmp, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_arrays

alloc_fail:
  ; Free whatever was allocated (free on null is safe)
  call void @free(i8* %visit_mem)
  call void @free(i8* %next_mem)
  call void @free(i8* %stack_mem)
  store i64 0, i64* %count, align 8
  ret void

; Initialize visited[i]=0 and nextIndex[i]=0 for i in [0..n)
init_arrays:
  %i0 = phi i64 [ 0, %allocs ]
  %cmp_init = icmp ult i64 %i0, %n
  br i1 %cmp_init, label %init_loop, label %post_init

init_loop:
  %visit_ptr = getelementptr inbounds i32, i32* %visited, i64 %i0
  store i32 0, i32* %visit_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %nextIndex, i64 %i0
  store i64 0, i64* %next_ptr, align 8
  %i1 = add i64 %i0, 1
  br label %init_arrays

post_init:
  ; top = 0; *count = 0
  %top = alloca i64, align 8
  store i64 0, i64* %top, align 8
  store i64 0, i64* %count, align 8

  ; Push start: top++, stack[top-1] = start
  %top0 = load i64, i64* %top, align 8
  %top1 = add i64 %top0, 1
  store i64 %top1, i64* %top, align 8
  %top1m1 = add i64 %top1, -1
  %stack_slot0 = getelementptr inbounds i64, i64* %stack, i64 %top1m1
  store i64 %start, i64* %stack_slot0, align 8

  ; visited[start] = 1
  %visit_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %visit_start_ptr, align 4

  ; out[*count] = start; (*count)++
  %cnt0 = load i64, i64* %count, align 8
  %out_slot0 = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %start, i64* %out_slot0, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %count, align 8

  br label %outer_check

; while (top != 0)
outer_check:
  %top_now = load i64, i64* %top, align 8
  %has_items = icmp ne i64 %top_now, 0
  br i1 %has_items, label %outer_body, label %cleanup

outer_body:
  ; u = stack[top-1]
  %top_now_m1 = add i64 %top_now, -1
  %stack_slot = getelementptr inbounds i64, i64* %stack, i64 %top_now_m1
  %u = load i64, i64* %stack_slot, align 8

  ; i = nextIndex[u]
  %next_u_ptr = getelementptr inbounds i64, i64* %nextIndex, i64 %u
  %i_cur = load i64, i64* %next_u_ptr, align 8
  br label %inner_check

; while (i < n)
inner_check:
  %i_now = phi i64 [ %i_cur, %outer_body ], [ %i_inc, %inner_continue ]
  %i_lt_n = icmp ult i64 %i_now, %n
  br i1 %i_lt_n, label %try_edge, label %pop_and_continue

try_edge:
  ; Check adj[u*n + i_now] != 0
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %i_now
  %adj_elem_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_elem_ptr, align 4
  %has_edge = icmp ne i32 %adj_val, 0

  ; And visited[i_now] == 0
  %visit_i_ptr = getelementptr inbounds i32, i32* %visited, i64 %i_now
  %visit_i = load i32, i32* %visit_i_ptr, align 4
  %not_visited = icmp eq i32 %visit_i, 0

  %can_traverse.tmp = and i1 %has_edge, %not_visited
  br i1 %can_traverse.tmp, label %traverse, label %inner_continue

traverse:
  ; nextIndex[u] = i_now + 1
  %i_next = add i64 %i_now, 1
  store i64 %i_next, i64* %next_u_ptr, align 8

  ; visited[i_now] = 1
  store i32 1, i32* %visit_i_ptr, align 4

  ; out[*count] = i_now; (*count)++
  %cnt2 = load i64, i64* %count, align 8
  %out_slot1 = getelementptr inbounds i64, i64* %out, i64 %cnt2
  store i64 %i_now, i64* %out_slot1, align 8
  %cnt3 = add i64 %cnt2, 1
  store i64 %cnt3, i64* %count, align 8

  ; Push i_now onto stack
  %top_push0 = load i64, i64* %top, align 8
  %top_push1 = add i64 %top_push0, 1
  store i64 %top_push1, i64* %top, align 8
  %top_push1_m1 = add i64 %top_push1, -1
  %stack_slot_new = getelementptr inbounds i64, i64* %stack, i64 %top_push1_m1
  store i64 %i_now, i64* %stack_slot_new, align 8

  ; Continue outer loop
  br label %outer_check

inner_continue:
  ; i_now++
  %i_inc = add i64 %i_now, 1
  br label %inner_check

pop_and_continue:
  ; i_now >= n => pop: top--
  %top_pop0 = load i64, i64* %top, align 8
  %top_pop1 = add i64 %top_pop0, -1
  store i64 %top_pop1, i64* %top, align 8
  br label %outer_check

cleanup:
  ; Free allocated arrays
  call void @free(i8* %visit_mem)
  call void @free(i8* %next_mem)
  call void @free(i8* %stack_mem)
  ret void
}