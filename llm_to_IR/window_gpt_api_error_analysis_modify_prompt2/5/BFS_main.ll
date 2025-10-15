; ModuleID = 'bfs_main_module'
source_filename = "bfs_main_module.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_zus = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32* nocapture, i64, i64, i8*, i64*, i64*)

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %order = alloca [7 x i64], align 16
  %dist = alloca [7 x i32], align 16
  %len = alloca i64, align 8
  %start = alloca i64, align 8
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8

  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)

  ; Set adjacency matrix entries to 1 (7x7 flattened, row-major)
  ; Indices: 1,2,7,10,11,14,19,22,29,33,37,39,41,47
  %adj_base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p1 = getelementptr inbounds i32, i32* %adj_base, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %adj_base, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds i32, i32* %adj_base, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds i32, i32* %adj_base, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %adj_base, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds i32, i32* %adj_base, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds i32, i32* %adj_base, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds i32, i32* %adj_base, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds i32, i32* %adj_base, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds i32, i32* %adj_base, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds i32, i32* %adj_base, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds i32, i32* %adj_base, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adj_base, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adj_base, i64 47
  store i32 1, i32* %p47, align 4

  store i64 0, i64* %len, align 8

  %adj_ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %n_val = load i64, i64* %n, align 8
  %start_val = load i64, i64* %start, align 8
  %dist_base_i8 = bitcast [7 x i32]* %dist to i8*
  %order_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj_ptr, i64 %n_val, i64 %start_val, i8* %dist_base_i8, i64* %len, i64* %order_ptr)

  ; printf("BFS order from %zu: ", start)
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i64 0, i64 0
  %start_for_print = load i64, i64* %start, align 8
  %call_printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %start_for_print)

  ; for (i = 0; i < len; ++i) { printf("%zu%s", order[i], (i+1<len) ? " " : ""); }
  store i64 0, i64* %i, align 8
  br label %loop_order_cond

loop_order_cond:
  %i_cur = load i64, i64* %i, align 8
  %len_cur = load i64, i64* %len, align 8
  %cmp_i_len = icmp ult i64 %i_cur, %len_cur
  br i1 %cmp_i_len, label %loop_order_body, label %loop_order_end

loop_order_body:
  %i_next = add i64 %i_cur, 1
  %cmp_next = icmp ult i64 %i_next, %len_cur
  br i1 %cmp_next, label %suffix_space, label %suffix_empty

suffix_space:
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  br label %suffix_merge

suffix_empty:
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  br label %suffix_merge

suffix_merge:
  %suffix_phi = phi i8* [ %space_ptr, %suffix_space ], [ %empty_ptr, %suffix_empty ]
  %order_elem_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i_cur
  %order_elem = load i64, i64* %order_elem_ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zus, i64 0, i64 0
  %call_printf2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %order_elem, i8* %suffix_phi)
  %i_inc = add i64 %i_cur, 1
  store i64 %i_inc, i64* %i, align 8
  br label %loop_order_cond

loop_order_end:
  %newline = call i32 @putchar(i32 10)

  ; for (j = 0; j < n; ++j) { printf("dist(%zu -> %zu) = %d\n", start, j, dist[j]); }
  store i64 0, i64* %j, align 8
  br label %loop_dist_cond

loop_dist_cond:
  %j_cur = load i64, i64* %j, align 8
  %n_cur = load i64, i64* %n, align 8
  %cmp_j_n = icmp ult i64 %j_cur, %n_cur
  br i1 %cmp_j_n, label %loop_dist_body, label %loop_dist_end

loop_dist_body:
  %dist_elem_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j_cur
  %dist_elem = load i32, i32* %dist_elem_ptr, align 4
  %fmt3 = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %start_for_dist = load i64, i64* %start, align 8
  %call_printf3 = call i32 (i8*, ...) @printf(i8* %fmt3, i64 %start_for_dist, i64 %j_cur, i32 %dist_elem)
  %j_inc = add i64 %j_cur, 1
  store i64 %j_inc, i64* %j, align 8
  br label %loop_dist_cond

loop_dist_end:
  ret i32 0
}