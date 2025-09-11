; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: Print BFS order and distances on a fixed 7-node graph (confidence=0.86). Evidence: adjacency matrix traversal with queue; __printf_chk formatting for BFS order and dist outputs.
; Preconditions: None
; Postconditions: Prints BFS order from 0 and dist(0 -> i) for i=0..6.

@.str_header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00"
@.str_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.str_space = private unnamed_addr constant [2 x i8] c" \00"
@.str_empty = private unnamed_addr constant [1 x i8] c"\00"
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)
declare i32 @__printf_chk(i32, i8*, ...)
declare i8* @malloc(i64)
declare void @free(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [7 x [7 x i32]], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i32, align 4
  %head = alloca i32, align 4
  %tail = alloca i32, align 4
  %qmem = alloca i8*, align 8

  ; zero adjacency matrix
  %adj_i8 = bitcast [7 x [7 x i32]]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)

  ; initialize distances to -1
  store i32 0, i32* %order_len, align 4
  store i32 0, i32* %head, align 4
  store i32 0, i32* %tail, align 4
  br label %dist_init

dist_init:
  %di_i = phi i32 [ 0, %entry ], [ %di_next, %dist_init_body ]
  %di_cmp = icmp slt i32 %di_i, 7
  br i1 %di_cmp, label %dist_init_body, label %dist_done

dist_init_body:
  %di_i64 = sext i32 %di_i to i64
  %di_gep = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %di_i64
  store i32 -1, i32* %di_gep, align 4
  %di_next = add nsw i32 %di_i, 1
  br label %dist_init

dist_done:
  ; build an undirected example graph:
  ; 0-1, 0-2, 1-3, 1-4, 2-5, 3-6
  ; set adj[a][b] = adj[b][a] = 1

  ; helper indices
  ; edge 0-1
  %a0 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0
  %a0_1 = getelementptr inbounds [7 x i32], [7 x i32]* %a0, i64 0, i64 1
  store i32 1, i32* %a0_1, align 4
  %a1 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1
  %a1_0 = getelementptr inbounds [7 x i32], [7 x i32]* %a1, i64 0, i64 0
  store i32 1, i32* %a1_0, align 4

  ; edge 0-2
  %a0_2 = getelementptr inbounds [7 x i32], [7 x i32]* %a0, i64 0, i64 2
  store i32 1, i32* %a0_2, align 4
  %a2 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2
  %a2_0 = getelementptr inbounds [7 x i32], [7 x i32]* %a2, i64 0, i64 0
  store i32 1, i32* %a2_0, align 4

  ; edge 1-3
  %a1_3 = getelementptr inbounds [7 x i32], [7 x i32]* %a1, i64 0, i64 3
  store i32 1, i32* %a1_3, align 4
  %a3 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3
  %a3_1 = getelementptr inbounds [7 x i32], [7 x i32]* %a3, i64 0, i64 1
  store i32 1, i32* %a3_1, align 4

  ; edge 1-4
  %a1_4 = getelementptr inbounds [7 x i32], [7 x i32]* %a1, i64 0, i64 4
  store i32 1, i32* %a1_4, align 4
  %a4 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4
  %a4_1 = getelementptr inbounds [7 x i32], [7 x i32]* %a4, i64 0, i64 1
  store i32 1, i32* %a4_1, align 4

  ; edge 2-5
  %a2_5 = getelementptr inbounds [7 x i32], [7 x i32]* %a2, i64 0, i64 5
  store i32 1, i32* %a2_5, align 4
  %a5 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5
  %a5_2 = getelementptr inbounds [7 x i32], [7 x i32]* %a5, i64 0, i64 2
  store i32 1, i32* %a5_2, align 4

  ; edge 3-6
  %a3_6 = getelementptr inbounds [7 x i32], [7 x i32]* %a3, i64 0, i64 6
  store i32 1, i32* %a3_6, align 4
  %a6 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6
  %a6_3 = getelementptr inbounds [7 x i32], [7 x i32]* %a6, i64 0, i64 3
  store i32 1, i32* %a6_3, align 4

  ; allocate queue for up to 7 vertices (7*8 bytes)
  %mq = call i8* @malloc(i64 56)
  store i8* %mq, i8** %qmem, align 8
  %mq_isnull = icmp eq i8* %mq, null
  br i1 %mq_isnull, label %malloc_fail, label %malloc_ok

malloc_ok:
  ; queue[0] = 0
  %q64 = bitcast i8* %mq to i64*
  %q0 = getelementptr inbounds i64, i64* %q64, i64 0
  store i64 0, i64* %q0, align 8
  ; dist[0] = 0
  %d0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %d0, align 4
  store i32 0, i32* %head, align 4
  store i32 1, i32* %tail, align 4
  store i32 0, i32* %order_len, align 4
  br label %bfs_loop

bfs_loop:
  %h = load i32, i32* %head, align 4
  %t = load i32, i32* %tail, align 4
  %bfs_cond = icmp slt i32 %h, %t
  br i1 %bfs_cond, label %bfs_body, label %bfs_done

bfs_body:
  ; v = queue[head]
  %h_i64 = sext i32 %h to i64
  %qv_ptr = getelementptr inbounds i64, i64* %q64, i64 %h_i64
  %v64 = load i64, i64* %qv_ptr, align 8
  %v = trunc i64 %v64 to i32
  ; head++
  %h_next = add nsw i32 %h, 1
  store i32 %h_next, i32* %head, align 4
  ; order[order_len] = v
  %ol = load i32, i32* %order_len, align 4
  %ol_i64 = sext i32 %ol to i64
  %o_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %ol_i64
  %v64z = zext i32 %v to i64
  store i64 %v64z, i64* %o_ptr, align 8
  %ol_next = add nsw i32 %ol, 1
  store i32 %ol_next, i32* %order_len, align 4
  ; iterate neighbors u = 0..6
  br label %nbr_loop

nbr_loop:
  %u = phi i32 [ 0, %bfs_body ], [ %u_next, %nbr_next ]
  %u_cmp = icmp slt i32 %u, 7
  br i1 %u_cmp, label %nbr_check, label %bfs_loop

nbr_check:
  ; if adj[v][u] != 0 and dist[u] == -1 then enqueue u and set dist[u] = dist[v] + 1
  %v_i64 = sext i32 %v to i64
  %u_i64 = sext i32 %u to i64
  %row_ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %v_i64
  %adj_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %row_ptr, i64 0, i64 %u_i64
  %adj_val = load i32, i32* %adj_ptr, align 4
  %adj_nz = icmp ne i32 %adj_val, 0

  %du_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %u_i64
  %du = load i32, i32* %du_ptr, align 4
  %du_unseen = icmp eq i32 %du, -1

  %cond = and i1 %adj_nz, %du_unseen
  br i1 %cond, label %enqueue, label %nbr_next

enqueue:
  ; queue[tail] = u
  %t2 = load i32, i32* %tail, align 4
  %t2_i64 = sext i32 %t2 to i64
  %qt_ptr = getelementptr inbounds i64, i64* %q64, i64 %t2_i64
  %u64z = zext i32 %u to i64
  store i64 %u64z, i64* %qt_ptr, align 8
  %t2_next = add nsw i32 %t2, 1
  store i32 %t2_next, i32* %tail, align 4

  ; dist[u] = dist[v] + 1
  %dv_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v_i64
  %dv = load i32, i32* %dv_ptr, align 4
  %dv1 = add nsw i32 %dv, 1
  store i32 %dv1, i32* %du_ptr, align 4
  br label %nbr_next

nbr_next:
  %u_next = add nsw i32 %u, 1
  br label %nbr_loop

bfs_done:
  ; free queue
  %mq2 = load i8*, i8** %qmem, align 8
  call void @free(i8* %mq2)
  br label %print_header

malloc_fail:
  ; print header even if BFS couldn't run (order will be empty; dists remain -1)
  br label %print_header

print_header:
  ; print "BFS order from %zu: " with src=0
  %hdr_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_header, i64 0, i64 0
  %call_hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %hdr_ptr, i64 0)

  ; print order elements separated by spaces, no trailing space
  %ol2 = load i32, i32* %order_len, align 4
  %ol2_is_zero = icmp eq i32 %ol2, 0
  br i1 %ol2_is_zero, label %after_order, label %order_loop

order_loop:
  %oi = phi i32 [ 0, %print_header ], [ %oi_next, %order_loop_next ]
  %oi_i64 = sext i32 %oi to i64
  %oval_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %oi_i64
  %oval = load i64, i64* %oval_ptr, align 8

  ; choose suffix: space if not last, else empty
  %ol3 = load i32, i32* %order_len, align 4
  %last_idx = add nsw i32 %ol3, -1
  %is_last = icmp eq i32 %oi, %last_idx
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %suffix = select i1 %is_last, i8* %empty_ptr, i8* %space_ptr

  %pair_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %call_pair = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %pair_ptr, i64 %oval, i8* %suffix)

  %oi_next = add nsw i32 %oi, 1
  %cont = icmp slt i32 %oi_next, %ol3
  br i1 %cont, label %order_loop_next, label %after_order

order_loop_next:
  br label %order_loop

after_order:
  ; print newline
  %nl_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %call_nl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl_ptr)

  ; print distances: for i=0..6: dist(0 -> i) = d
  br label %dist_print

dist_print:
  %pi = phi i32 [ 0, %after_order ], [ %pi_next, %dist_print_next ]
  %pi_cmp = icmp slt i32 %pi, 7
  br i1 %pi_cmp, label %dist_one, label %ret

dist_one:
  %pi_i64 = sext i32 %pi to i64
  %pd_ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %pi_i64
  %pd = load i32, i32* %pd_ptr, align 4
  %fmt_ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %call_dist = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_ptr, i64 0, i64 %pi_i64, i32 %pd)
  br label %dist_print_next

dist_print_next:
  %pi_next = add nsw i32 %pi, 1
  br label %dist_print

ret:
  ret i32 0
}