; ModuleID = 'dfs_module'
source_filename = "dfs_module"
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %matrix, i64 %n, i64 %start, i64* %out, i64* %countptr) {
entry:
  %is_n_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %invalid = or i1 %is_n_zero, %start_ge_n
  br i1 %invalid, label %early, label %alloc

early:
  store i64 0, i64* %countptr, align 8
  ret void

alloc:
  %size_vis = shl i64 %n, 2
  %call_malloc_vis = call noalias i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %call_malloc_vis to i32*
  %size_next = shl i64 %n, 3
  %call_malloc_next = call noalias i8* @malloc(i64 %size_next)
  %nextarr = bitcast i8* %call_malloc_next to i64*
  %call_malloc_stack = call noalias i8* @malloc(i64 %size_next)
  %stack = bitcast i8* %call_malloc_stack to i64*
  %isnull_vis = icmp eq i8* %call_malloc_vis, null
  %isnull_next = icmp eq i8* %call_malloc_next, null
  %isnull_stack = icmp eq i8* %call_malloc_stack, null
  %tmp.any1 = or i1 %isnull_vis, %isnull_next
  %anynull = or i1 %tmp.any1, %isnull_stack
  br i1 %anynull, label %alloc_fail, label %init

alloc_fail:
  call void @free(i8* %call_malloc_vis)
  call void @free(i8* %call_malloc_next)
  call void @free(i8* %call_malloc_stack)
  store i64 0, i64* %countptr, align 8
  ret void

init:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %init_body_end ]
  %cmp_i = icmp ult i64 %i, %n
  br i1 %cmp_i, label %init_body, label %init_done

init_body:
  %vis_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %nextarr, i64 %i
  store i64 0, i64* %next_ptr, align 8
  br label %init_body_end

init_body_end:
  %i.next = add i64 %i, 1
  br label %init_loop

init_done:
  store i64 0, i64* %countptr, align 8
  %size0 = add i64 0, 1
  %stack0ptr = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack0ptr, align 8
  %vis_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  %curcnt = load i64, i64* %countptr, align 8
  %out_ptr0 = getelementptr inbounds i64, i64* %out, i64 %curcnt
  store i64 %start, i64* %out_ptr0, align 8
  %curcnt1 = add i64 %curcnt, 1
  store i64 %curcnt1, i64* %countptr, align 8
  br label %outer_loop

outer_loop:
  %size = phi i64 [ %size0, %init_done ], [ %size_after, %after_inner ], [ %size_dec, %after_inner_pop ]
  %size_not_zero = icmp ne i64 %size, 0
  br i1 %size_not_zero, label %outer_body, label %cleanup

outer_body:
  %idx_top_minus1 = add i64 %size, -1
  %stack_top_ptr = getelementptr inbounds i64, i64* %stack, i64 %idx_top_minus1
  %top = load i64, i64* %stack_top_ptr, align 8
  %next_top_ptr = getelementptr inbounds i64, i64* %nextarr, i64 %top
  %i_inner = load i64, i64* %next_top_ptr, align 8
  br label %inner_loop

inner_loop:
  %ii = phi i64 [ %i_inner, %outer_body ], [ %i_inc, %inner_continue ]
  %cond_i = icmp ult i64 %ii, %n
  br i1 %cond_i, label %check_edge, label %inner_exhausted

check_edge:
  %mul = mul i64 %top, %n
  %offset = add i64 %mul, %ii
  %mat_ptr = getelementptr inbounds i32, i32* %matrix, i64 %offset
  %edge_val = load i32, i32* %mat_ptr, align 4
  %is_zero = icmp eq i32 %edge_val, 0
  br i1 %is_zero, label %inner_continue, label %check_visited

inner_continue:
  %i_inc = add i64 %ii, 1
  br label %inner_loop

check_visited:
  %vis_i_ptr = getelementptr inbounds i32, i32* %visited, i64 %ii
  %vis_i_val = load i32, i32* %vis_i_ptr, align 4
  %is_visited = icmp ne i32 %vis_i_val, 0
  br i1 %is_visited, label %inner_continue, label %do_push

do_push:
  %i_plus1 = add i64 %ii, 1
  store i64 %i_plus1, i64* %next_top_ptr, align 8
  store i32 1, i32* %vis_i_ptr, align 4
  %cnt_a = load i64, i64* %countptr, align 8
  %out_ptr_i = getelementptr inbounds i64, i64* %out, i64 %cnt_a
  store i64 %ii, i64* %out_ptr_i, align 8
  %cnt_a1 = add i64 %cnt_a, 1
  store i64 %cnt_a1, i64* %countptr, align 8
  %size_new = add i64 %size, 1
  %stack_new_ptr = getelementptr inbounds i64, i64* %stack, i64 %size
  store i64 %ii, i64* %stack_new_ptr, align 8
  br label %after_inner

inner_exhausted:
  %size_dec = add i64 %size, -1
  br label %after_inner_pop

after_inner_pop:
  br label %outer_loop

after_inner:
  %size_after = phi i64 [ %size_new, %do_push ]
  br label %outer_loop

cleanup:
  call void @free(i8* %call_malloc_vis)
  call void @free(i8* %call_malloc_next)
  call void @free(i8* %call_malloc_stack)
  ret void
}