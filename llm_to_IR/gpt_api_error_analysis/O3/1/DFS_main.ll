; ModuleID = 'dfs_preorder_main'
source_filename = "dfs_preorder_main.ll"
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str_header = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@qword_2028 = constant i64 4294967297, align 8

declare i32 @__printf_chk(i32, i8*, ...) local_unnamed_addr
declare noalias i8* @calloc(i64, i64) local_unnamed_addr
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr
declare void @__stack_chk_fail() local_unnamed_addr
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) local_unnamed_addr

define i32 @main() local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %order = alloca [7 x i64], align 16
  %depth = alloca i64, align 8
  %count = alloca i64, align 8
  %k = alloca i64, align 8
  %node = alloca i64, align 8
  %idx = alloca i64, align 8
  %visited_raw = call noalias i8* @calloc(i64 28, i64 1)
  %next_raw = call noalias i8* @calloc(i64 56, i64 1)
  %path_raw = call noalias i8* @malloc(i64 56)
  %visited_isnull = icmp eq i8* %visited_raw, null
  %next_isnull = icmp eq i8* %next_raw, null
  %anynull_tmp = or i1 %visited_isnull, %next_isnull
  %path_isnull = icmp eq i8* %path_raw, null
  %anynull = or i1 %anynull_tmp, %path_isnull
  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)
  %adj0_1_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj0_1_ptr, align 4
  %adj0_2_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj0_2_ptr, align 4
  %adj1_0_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj1_0_ptr, align 4
  %adj1_3_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj1_3_ptr, align 4
  %adj1_4_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj1_4_ptr, align 4
  %adj2_0_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj2_0_ptr, align 4
  %adj2_5_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj2_5_ptr, align 4
  %adj3_1_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj3_1_ptr, align 4
  %adj4_1_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj4_1_ptr, align 4
  %adj4_5_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj4_5_ptr, align 4
  %adj5_2_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj5_2_ptr, align 4
  %adj5_4_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj5_4_ptr, align 4
  %adj5_6_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj5_6_ptr, align 4
  %adj6_5_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj6_5_ptr, align 4
  br i1 %anynull, label %alloc_fail, label %alloc_ok

alloc_ok:
  %visited_i32 = bitcast i8* %visited_raw to i32*
  %next_i64 = bitcast i8* %next_raw to i64*
  %path_i64 = bitcast i8* %path_raw to i64*
  %path0_ptr = getelementptr inbounds i64, i64* %path_i64, i64 0
  store i64 0, i64* %path0_ptr, align 8
  %visited0_ptr = getelementptr inbounds i32, i32* %visited_i32, i64 0
  store i32 1, i32* %visited0_ptr, align 4
  store i64 1, i64* %depth, align 8
  store i64 0, i64* %count, align 8
  br label %dfs_loop.cond

dfs_loop.cond:
  %depth_cur = load i64, i64* %depth, align 8
  %depth_nonzero = icmp ne i64 %depth_cur, 0
  br i1 %depth_nonzero, label %dfs_loop.body, label %dfs_end

dfs_loop.body:
  %d_minus1 = add i64 %depth_cur, -1
  %stack_top_ptr = getelementptr inbounds i64, i64* %path_i64, i64 %d_minus1
  %node_val = load i64, i64* %stack_top_ptr, align 8
  store i64 %node_val, i64* %node, align 8
  %next_ptr_for_node = getelementptr inbounds i64, i64* %next_i64, i64 %node_val
  %idx_val = load i64, i64* %next_ptr_for_node, align 8
  store i64 %idx_val, i64* %idx, align 8
  %idx_lt7 = icmp ult i64 %idx_val, 7
  br i1 %idx_lt7, label %scan_init, label %backtrack

scan_init:
  store i64 %idx_val, i64* %k, align 8
  br label %scan_loop.cond

scan_loop.cond:
  %k_cur = load i64, i64* %k, align 8
  %k_lt7 = icmp ult i64 %k_cur, 7
  br i1 %k_lt7, label %scan_loop.body, label %no_neighbor_found

scan_loop.body:
  %node_cur = load i64, i64* %node, align 8
  %row_base = mul i64 %node_cur, 7
  %adj_index = add i64 %row_base, %k_cur
  %adj_cell_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %adj_index
  %adj_val = load i32, i32* %adj_cell_ptr, align 4
  %adj_is_zero = icmp eq i32 %adj_val, 0
  br i1 %adj_is_zero, label %scan_advance_k, label %check_visited

check_visited:
  %visited_elem_ptr = getelementptr inbounds i32, i32* %visited_i32, i64 %k_cur
  %vis_val = load i32, i32* %visited_elem_ptr, align 4
  %vis_is_zero = icmp eq i32 %vis_val, 0
  br i1 %vis_is_zero, label %take_neighbor, label %scan_advance_k

scan_advance_k:
  %k_next = add i64 %k_cur, 1
  store i64 %k_next, i64* %k, align 8
  br label %scan_loop.cond

take_neighbor:
  %ord_count = load i64, i64* %count, align 8
  %ord_slot = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %ord_count
  store i64 %k_cur, i64* %ord_slot, align 8
  %ord_count_next = add i64 %ord_count, 1
  store i64 %ord_count_next, i64* %count, align 8
  %path_slot = getelementptr inbounds i64, i64* %path_i64, i64 %depth_cur
  store i64 %k_cur, i64* %path_slot, align 8
  %depth_next = add i64 %depth_cur, 1
  store i64 %depth_next, i64* %depth, align 8
  %k_plus1 = add i64 %k_cur, 1
  store i64 %k_plus1, i64* %next_ptr_for_node, align 8
  store i32 1, i32* %visited_elem_ptr, align 4
  br label %dfs_loop.cond

no_neighbor_found:
  br label %backtrack

backtrack:
  %depth_after_bt = add i64 %depth_cur, -1
  store i64 %depth_after_bt, i64* %depth, align 8
  br label %dfs_loop.cond

dfs_end:
  call void @free(i8* %visited_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %path_raw)
  %hdr_ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_header, i64 0, i64 0
  %print_hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdr_ptr, i64 0)
  %cnt_final = load i64, i64* %count, align 8
  %cnt_is_zero = icmp eq i64 %cnt_final, 0
  br i1 %cnt_is_zero, label %print_nl, label %print_nonempty

print_nonempty:
  %fmt_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 1
  %first_elem_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %first_val = load i64, i64* %first_elem_ptr, align 8
  %print_first = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_ptr, i64 %first_val, i8* %empty_ptr)
  %more_than_one = icmp ugt i64 %cnt_final, 1
  br i1 %more_than_one, label %print_loop.init, label %after_print_loop

print_loop.init:
  %space_ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_header, i64 0, i64 22
  %i_var = alloca i64, align 8
  store i64 0, i64* %i_var, align 8
  br label %print_loop.cond

print_loop.cond:
  %i_cur = load i64, i64* %i_var, align 8
  %last_index = add i64 %cnt_final, -1
  %i_lt_last = icmp ult i64 %i_cur, %last_index
  br i1 %i_lt_last, label %print_loop.body, label %print_last

print_loop.body:
  %elem_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i_cur
  %elem_val = load i64, i64* %elem_ptr, align 8
  %print_mid = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_ptr, i64 %elem_val, i8* %space_ptr)
  %i_next = add i64 %i_cur, 1
  store i64 %i_next, i64* %i_var, align 8
  br label %print_loop.cond

print_last:
  %last_idx = add i64 %cnt_final, -1
  %last_elem_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %last_idx
  %last_val = load i64, i64* %last_elem_ptr, align 8
  %print_tail = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_ptr, i64 %last_val, i8* %empty_ptr)
  br label %after_print_loop

after_print_loop:
  br label %print_nl

print_nl:
  %nl_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %print_newline = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl_ptr)
  ret i32 0

alloc_fail:
  call void @free(i8* %visited_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %path_raw)
  %hdr_ptr_fail = getelementptr inbounds [24 x i8], [24 x i8]* @.str_header, i64 0, i64 0
  %print_hdr_fail = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %hdr_ptr_fail, i64 0)
  br label %print_nl
}