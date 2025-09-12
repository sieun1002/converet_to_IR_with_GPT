; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13DD
; Intent: Build a 7-node graph adjacency matrix, run bfs from 0, then print BFS order and distances (confidence=0.92). Evidence: adjacency [n*n] stores with n=7; call bfs(adj, n, start, dist, order, len) and subsequent formatted prints.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

@.str_bfs_hdr = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_space   = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty   = private unnamed_addr constant [1 x i8] c"\00", align 1
@.fmt_zu_s    = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.fmt_dist    = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; constants
  %n = i64 7
  %start = i64 0

  ; locals
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  ; zero init adjacency
  store [49 x i32] zeroinitializer, [49 x i32]* %adj, align 16
  store i64 0, i64* %len, align 8

  ; adj[0,1] = 1
  %adj_p_01 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj_p_01, align 4
  ; adj[0,2] = 1
  %adj_p_02 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj_p_02, align 4
  ; adj[1,0] = 1
  %adj_p_10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj_p_10, align 4
  ; adj[1,3] = 1
  %adj_p_13 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj_p_13, align 4
  ; adj[1,4] = 1
  %adj_p_14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj_p_14, align 4
  ; adj[2,0] = 1
  %adj_p_20 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj_p_20, align 4
  ; adj[2,5] = 1
  %adj_p_25 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj_p_25, align 4
  ; adj[3,1] = 1
  %adj_p_31 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj_p_31, align 4
  ; adj[4,1] = 1
  %adj_p_41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj_p_41, align 4
  ; adj[4,5] = 1
  %adj_p_45 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj_p_45, align 4
  ; adj[5,2] = 1
  %adj_p_52 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj_p_52, align 4
  ; adj[5,4] = 1
  %adj_p_54 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj_p_54, align 4
  ; adj[5,6] = 1
  %adj_p_56 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj_p_56, align 4
  ; adj[6,5] = 1
  %adj_p_65 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj_p_65, align 4

  ; call bfs(adj, n, start, dist, order, &len)
  %adj_base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist_base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order_base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj_base, i64 %n, i64 %start, i32* %dist_base, i64* %order_base, i64* %len)

  ; printf("BFS order from %zu: ", start)
  %hdr_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs_hdr, i64 0, i64 0
  %call_hdr = call i32 (i8*, ...) @printf(i8* %hdr_ptr, i64 %start)

  ; for (i = 0; i < len; ++i) printf("%zu%s", order[i], (i+1<len)?" ":"")
  store i64 0, i64* %i, align 8
  br label %loop_order.cond

loop_order.cond:
  %i.val = load i64, i64* %i, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp_i = icmp ult i64 %i.val, %len.val
  br i1 %cmp_i, label %loop_order.body, label %loop_order.end

loop_order.body:
  %ip1 = add i64 %i.val, 1
  %has_next = icmp ult i64 %ip1, %len.val
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %delim = select i1 %has_next, i8* %space_ptr, i8* %empty_ptr

  %ord_elem_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.val
  %ord_elem = load i64, i64* %ord_elem_ptr, align 8
  %fmt_zu_s_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt_zu_s, i64 0, i64 0
  %call_zu = call i32 (i8*, ...) @printf(i8* %fmt_zu_s_ptr, i64 %ord_elem, i8* %delim)

  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop_order.cond

loop_order.end:
  ; putchar('\n')
  %nlcall = call i32 @putchar(i32 10)

  ; for (j = 0; j < n; ++j) printf("dist(%zu -> %zu) = %d\n", start, j, dist[j])
  store i64 0, i64* %j, align 8
  br label %loop_dist.cond

loop_dist.cond:
  %j.val = load i64, i64* %j, align 8
  %cmp_j = icmp ult i64 %j.val, %n
  br i1 %cmp_j, label %loop_dist.body, label %loop_dist.end

loop_dist.body:
  %dj.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j.val
  %dj = load i32, i32* %dj.ptr, align 4
  %fmt_dist_ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.fmt_dist, i64 0, i64 0
  %call_dist = call i32 (i8*, ...) @printf(i8* %fmt_dist_ptr, i64 %start, i64 %j.val, i32 %dj)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop_dist.cond

loop_dist.end:
  ret i32 0
}