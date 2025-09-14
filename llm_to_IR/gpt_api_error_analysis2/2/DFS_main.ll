; target: Linux x86-64 SysV
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %order, i64* %countptr) {
entry:
  %n_zero = icmp eq i64 %n, 0
  br i1 %n_zero, label %early_zero, label %check_start

early_zero:
  store i64 0, i64* %countptr, align 8
  ret void

check_start:
  %start_in_range = icmp ult i64 %start, %n
  br i1 %start_in_range, label %alloc, label %early_zero2

early_zero2:
  store i64 0, i64* %countptr, align 8
  ret void

alloc:
  %size_vis = shl i64 %n, 2
  %p_vis_i8 = call noalias i8* @malloc(i64 %size_vis)
  %p_vis = bitcast i8* %p_vis_i8 to i32*
  %size_next = shl i64 %n, 3
  %p_next_i8 = call noalias i8* @malloc(i64 %size_next)
  %p_next = bitcast i8* %p_next_i8 to i64*
  %p_stack_i8 = call noalias i8* @malloc(i64 %size_next)
  %p_stack = bitcast i8* %p_stack_i8 to i64*
  %vis_null = icmp eq i32* %p_vis, null
  %next_null = icmp eq i64* %p_next, null
  %stack_null = icmp eq i64* %p_stack, null
  %tmp_any = or i1 %vis_null, %next_null
  %any_null = or i1 %tmp_any, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_cond

alloc_fail:
  br i1 %vis_null, label %skip_free_vis, label %do_free_vis
do_free_vis:
  %p_vis_i8_for_free = bitcast i32* %p_vis to i8*
  call void @free(i8* %p_vis_i8_for_free)
  br label %skip_free_vis
skip_free_vis:
  br i1 %next_null, label %skip_free_next, label %do_free_next
do_free_next:
  %p_next_i8_for_free = bitcast i64* %p_next to i8*
  call void @free(i8* %p_next_i8_for_free)
  br label %skip_free_next
skip_free_next:
  br i1 %stack_null, label %skip_free_stack, label %do_free_stack
do_free_stack:
  %p_stack_i8_for_free = bitcast i64* %p_stack to i8*
  call void @free(i8* %p_stack_i8_for_free)
  br label %skip_free_stack
skip_free_stack:
  store i64 0, i64* %countptr, align 8
  ret void

init_cond:
  %i = phi i64 [ 0, %alloc ], [ %i_next, %init_body ]
  %i_lt = icmp ult i64 %i, %n
  br i1 %i_lt, label %init_body, label %after_init

init_body:
  %vis_gep = getelementptr inbounds i32, i32* %p_vis, i64 %i
  store i32 0, i32* %vis_gep, align 4
  %next_gep = getelementptr inbounds i64, i64* %p_next, i64 %i
  store i64 0, i64* %next_gep, align 8
  %i_next = add i64 %i, 1
  br label %init_cond

after_init:
  store i64 0, i64* %countptr, align 8
  %sp1 = add i64 0, 1
  %sp1_m1 = add i64 %sp1, -1
  %stack_slot0 = getelementptr inbounds i64, i64* %p_stack, i64 %sp1_m1
  store i64 %start, i64* %stack_slot0, align 8
  %vis_start_gep = getelementptr inbounds i32, i32* %p_vis, i64 %start
  store i32 1, i32* %vis_start_gep, align 4
  %cnt0 = load i64, i64* %countptr, align 8
  %order_slot0 = getelementptr inbounds i64, i64* %order, i64 %cnt0
  store i64 %start, i64* %order_slot0, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %countptr, align 8
  br label %outer_loop

outer_loop:
  %sp = phi i64 [ %sp1, %after_init ], [ %sp_next, %outer_iter_end ]
  %sp_nonzero = icmp ne i64 %sp, 0
  br i1 %sp_nonzero, label %process_top, label %done

process_top:
  %sp_m1 = add i64 %sp, -1
  %stack_slot = getelementptr inbounds i64, i64* %p_stack, i64 %sp_m1
  %top = load i64, i64* %stack_slot, align 8
  %next_slot_top = getelementptr inbounds i64, i64* %p_next, i64 %top
  %idx0 = load i64, i64* %next_slot_top, align 8
  br label %inner_cond

inner_cond:
  %idx = phi i64 [ %idx0, %process_top ], [ %idx_inc, %inner_advance ]
  %idx_lt = icmp ult i64 %idx, %n
  br i1 %idx_lt, label %inner_body, label %no_more_neighbors

inner_body:
  %mul = mul i64 %top, %n
  %lin = add i64 %mul, %idx
  %adj_gep = getelementptr inbounds i32, i32* %adj, i64 %lin
  %adj_val = load i32, i32* %adj_gep, align 4
  %adj_nz = icmp ne i32 %adj_val, 0
  br i1 %adj_nz, label %check_visited, label %inner_advance

check_visited:
  %vis_idx_gep = getelementptr inbounds i32, i32* %p_vis, i64 %idx
  %vis_val = load i32, i32* %vis_idx_gep, align 4
  %not_visited = icmp eq i32 %vis_val, 0
  br i1 %not_visited, label %do_push, label %inner_advance

do_push:
  %idx_plus = add i64 %idx, 1
  store i64 %idx_plus, i64* %next_slot_top, align 8
  store i32 1, i32* %vis_idx_gep, align 4
  %cnt_before = load i64, i64* %countptr, align 8
  %order_slot = getelementptr inbounds i64, i64* %order, i64 %cnt_before
  store i64 %idx, i64* %order_slot, align 8
  %cnt_inc = add i64 %cnt_before, 1
  store i64 %cnt_inc, i64* %countptr, align 8
  %sp_new = add i64 %sp, 1
  %sp_new_m1 = add i64 %sp_new, -1
  %stack_slot_new = getelementptr inbounds i64, i64* %p_stack, i64 %sp_new_m1
  store i64 %idx, i64* %stack_slot_new, align 8
  br label %outer_iter_end

inner_advance:
  %idx_inc = add i64 %idx, 1
  br label %inner_cond

no_more_neighbors:
  %sp_dec = add i64 %sp, -1
  br label %outer_iter_end

outer_iter_end:
  %sp_next = phi i64 [ %sp_new, %do_push ], [ %sp_dec, %no_more_neighbors ]
  br label %outer_loop

done:
  %p_vis_i8_free = bitcast i32* %p_vis to i8*
  call void @free(i8* %p_vis_i8_free)
  %p_next_i8_free = bitcast i64* %p_next to i8*
  call void @free(i8* %p_next_i8_free)
  %p_stack_i8_free = bitcast i64* %p_stack to i8*
  call void @free(i8* %p_stack_i8_free)
  ret void
}