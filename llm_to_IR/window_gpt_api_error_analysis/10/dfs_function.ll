; ModuleID = 'dfs_module'
source_filename = "dfs_module"
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %count) {
entry:
  %cmp_n_zero = icmp eq i64 %n, 0
  br i1 %cmp_n_zero, label %ret_zero, label %check_start

ret_zero:
  store i64 0, i64* %count, align 8
  ret void

check_start:
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %alloc, label %ret_zero

alloc:
  %bytes_block = mul i64 %n, 4
  %blk_i8 = call i8* @malloc(i64 %bytes_block)
  %blk = bitcast i8* %blk_i8 to i32*
  %bytes_64 = mul i64 %n, 8
  %next_i8 = call i8* @malloc(i64 %bytes_64)
  %next = bitcast i8* %next_i8 to i64*
  %stack_i8 = call i8* @malloc(i64 %bytes_64)
  %stack = bitcast i8* %stack_i8 to i64*
  %blk_null = icmp eq i8* %blk_i8, null
  %next_null = icmp eq i8* %next_i8, null
  %stack_null = icmp eq i8* %stack_i8, null
  %any_null_a = or i1 %blk_null, %next_null
  %any_null = or i1 %any_null_a, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_header

alloc_fail:
  call void @free(i8* %blk_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  store i64 0, i64* %count, align 8
  ret void

init_header:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init_header ], [ %i_next, %init_body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_body, label %post_init

init_body:
  %blk_gep = getelementptr inbounds i32, i32* %blk, i64 %i
  store i32 0, i32* %blk_gep, align 4
  %next_gep = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_gep, align 8
  %i_next = add i64 %i, 1
  br label %init_loop

post_init:
  store i64 0, i64* %count, align 8
  %stack_gep0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_gep0, align 8
  %top0 = add i64 0, 1
  %blk_start_gep = getelementptr inbounds i32, i32* %blk, i64 %start
  store i32 1, i32* %blk_start_gep, align 4
  %cnt0 = load i64, i64* %count, align 8
  %out_slot0 = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %start, i64* %out_slot0, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %count, align 8
  br label %outer_loop

outer_loop:
  %top = phi i64 [ %top0, %post_init ], [ %top_push, %found ], [ %top_pop, %after_inner ]
  %top_is_zero = icmp eq i64 %top, 0
  br i1 %top_is_zero, label %cleanup, label %process

process:
  %topm1 = add i64 %top, -1
  %cur_ptr = getelementptr inbounds i64, i64* %stack, i64 %topm1
  %cur = load i64, i64* %cur_ptr, align 8
  %next_idx_ptr = getelementptr inbounds i64, i64* %next, i64 %cur
  %idx0 = load i64, i64* %next_idx_ptr, align 8
  br label %inner_loop

inner_loop:
  %idx = phi i64 [ %idx0, %process ], [ %idx_inc, %inc_idx ]
  %idx_lt_n = icmp ult i64 %idx, %n
  br i1 %idx_lt_n, label %check_edge, label %after_inner

check_edge:
  %mul = mul i64 %cur, %n
  %sum = add i64 %mul, %idx
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %sum
  %edge = load i32, i32* %adj_ptr, align 4
  %edge_zero = icmp eq i32 %edge, 0
  br i1 %edge_zero, label %inc_idx, label %check_visited

inc_idx:
  %idx_inc = add i64 %idx, 1
  br label %inner_loop

check_visited:
  %vis_ptr = getelementptr inbounds i32, i32* %blk, i64 %idx
  %vis_val = load i32, i32* %vis_ptr, align 4
  %vis_zero = icmp eq i32 %vis_val, 0
  br i1 %vis_zero, label %found, label %inc_idx

found:
  %idx_p1 = add i64 %idx, 1
  store i64 %idx_p1, i64* %next_idx_ptr, align 8
  store i32 1, i32* %vis_ptr, align 4
  %oldcnt = load i64, i64* %count, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %oldcnt
  store i64 %idx, i64* %out_slot, align 8
  %newcnt = add i64 %oldcnt, 1
  store i64 %newcnt, i64* %count, align 8
  %stack_slot = getelementptr inbounds i64, i64* %stack, i64 %top
  store i64 %idx, i64* %stack_slot, align 8
  %top_push = add i64 %top, 1
  br label %outer_loop

after_inner:
  %top_pop = add i64 %top, -1
  br label %outer_loop

cleanup:
  call void @free(i8* %blk_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  ret void
}