; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13DD
; Intent: Build a 7x7 undirected graph adjacency matrix, run BFS from node 0, print BFS order and distances (confidence=0.95). Evidence: 7x7 int matrix initialization; call to bfs with dist/order outputs and formatted prints.

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

; Only the needed extern declarations:
declare void @bfs(i32* noundef, i64 noundef, i64 noundef, i32* noundef, i64* noundef, i64* noundef)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8

  ; zero initialize 7x7 adjacency matrix (49 * 4 = 196 bytes)
  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)

  ; Undirected edges: (0,1), (0,2), (1,3), (1,4), (2,5), (4,5), (5,6)
  ; A[0][1] = 1
  %gep1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %gep1, align 4
  ; A[1][0] = 1
  %gep7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %gep7, align 4

  ; A[0][2] = 1
  %gep2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %gep2, align 4
  ; A[2][0] = 1
  %gep14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %gep14, align 4

  ; A[1][3] = 1
  %gep10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %gep10, align 4
  ; A[3][1] = 1
  %gep22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %gep22, align 4

  ; A[1][4] = 1
  %gep11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %gep11, align 4
  ; A[4][1] = 1
  %gep29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %gep29, align 4

  ; A[2][5] = 1
  %gep19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %gep19, align 4
  ; A[5][2] = 1
  %gep37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %gep37, align 4

  ; A[4][5] = 1
  %gep33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %gep33, align 4
  ; A[5][4] = 1
  %gep39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %gep39, align 4

  ; A[5][6] = 1
  %gep41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %gep41, align 4
  ; A[6][5] = 1
  %gep47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %gep47, align 4

  ; start node = 0
  store i64 0, i64* %order_len, align 8

  ; call bfs(adj, 7, 0, dist, order, &order_len)
  %adj0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order0 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj0, i64 7, i64 0, i32* %dist0, i64* %order0, i64* %order_len)

  ; printf("BFS order from %zu: ", 0)
  %fmt_bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt_bfs, i64 0)

  ; for (i = 0; i < order_len; ++i) printf("%zu%s", order[i], i+1 < order_len ? " " : "");
  br label %loop_order.cond

loop_order.cond:                                  ; preds = %loop_order.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop_order.body ]
  %len = load i64, i64* %order_len, align 8
  %cmp = icmp ult i64 %i, %len
  br i1 %cmp, label %loop_order.body, label %loop_order.end

loop_order.body:                                  ; preds = %loop_order.cond
  %i.plus1 = add i64 %i, 1
  %lt_next = icmp ult i64 %i.plus1, %len
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %delim = select i1 %lt_next, i8* %space_ptr, i8* %empty_ptr
  %ord_i_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i
  %ord_i = load i64, i64* %ord_i_ptr, align 8
  %fmt_zu_s = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt_zu_s, i64 %ord_i, i8* %delim)
  %i.next = add i64 %i, 1
  br label %loop_order.cond

loop_order.end:                                   ; preds = %loop_order.cond
  %call2 = call i32 @putchar(i32 10)

  ; for (j = 0; j < 7; ++j) printf("dist(%zu -> %zu) = %d\n", 0, j, dist[j]);
  br label %loop_dist.cond

loop_dist.cond:                                   ; preds = %loop_dist.body, %loop_order.end
  %j = phi i64 [ 0, %loop_order.end ], [ %j.next, %loop_dist.body ]
  %cmpj = icmp ult i64 %j, 7
  br i1 %cmpj, label %loop_dist.body, label %exit

loop_dist.body:                                   ; preds = %loop_dist.cond
  %dist_j_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
  %dist_j = load i32, i32* %dist_j_ptr, align 4
  %fmt_dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @printf(i8* %fmt_dist, i64 0, i64 %j, i32 %dist_j)
  %j.next = add i64 %j, 1
  br label %loop_dist.cond

exit:                                             ; preds = %loop_dist.cond
  ret i32 0
}