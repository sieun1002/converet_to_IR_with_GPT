; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13DD
; Intent: Build a fixed 7-node undirected graph, run bfs(start=0), then print BFS order and distances (confidence=0.92). Evidence: adjacency NxN int matrix initialization; printf patterns "BFS order from %zu: " and "dist(%zu -> %zu) = %d\n".
; Preconditions: bfs expects a row-major NxN int (i32) adjacency matrix (0/1), n=7, start=0; dist has space for n i32; order has space for n i64; order_len is an i64 out-parameter.

@.str_bfs_hdr = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_elem = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\n\00", align 1

declare void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %order_len)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  ; n = 7, start = 0
  store i64 0, i64* %order_len, align 8

  ; zero adjacency 49 ints
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  store i64 0, i64* %i, align 8
  br label %zero_loop

zero_loop:                                          ; preds = %zero_body, %entry
  %idx = load i64, i64* %i, align 8
  %cmp0 = icmp ult i64 %idx, 49
  br i1 %cmp0, label %zero_body, label %zero_done

zero_body:                                          ; preds = %zero_loop
  %elt.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %idx
  store i32 0, i32* %elt.ptr, align 4
  %idx.next = add i64 %idx, 1
  store i64 %idx.next, i64* %i, align 8
  br label %zero_loop

zero_done:                                          ; preds = %zero_loop
  ; set undirected edges: (0-1), (0-2), (1-3), (1-4), (2-5), (4-5), (5-6)
  ; indices in row-major 7x7: 1,2,7,14,10,22,11,29,19,37,33,39,41,47
  %p1  = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %p1, align 4
  %p2  = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %p2, align 4
  %p7  = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p7, align 4
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p14, align 4
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p10, align 4
  %p22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p22, align 4
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p11, align 4
  %p29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p29, align 4
  %p19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p19, align 4
  %p37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p37, align 4
  %p33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p33, align 4
  %p39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p47, align 4

  ; call bfs(adj, 7, 0, dist, order, &order_len)
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj.base, i64 7, i64 0, i32* %dist.base, i64* %order.base, i64* %order_len)

  ; printf("BFS order from %zu: ", 0)
  %fmt_hdr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs_hdr, i64 0, i64 0
  %call_hdr = call i32 (i8*, ...) @printf(i8* %fmt_hdr, i64 0)

  ; for (i=0; i < order_len; ++i) printf("%zu%s", order[i], i+1<len ? " " : "");
  store i64 0, i64* %i, align 8
  br label %order_loop

order_loop:                                         ; preds = %order_body, %zero_done
  %i.cur = load i64, i64* %i, align 8
  %len = load i64, i64* %order_len, align 8
  %cmp1 = icmp ult i64 %i.cur, %len
  br i1 %cmp1, label %order_body, label %order_done

order_body:                                         ; preds = %order_loop
  %i.next = add i64 %i.cur, 1
  %more = icmp ult i64 %i.next, %len
  %sep.space = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %sep.empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep.ptr = select i1 %more, i8* %sep.space, i8* %sep.empty
  %ord.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i.cur
  %ord.val = load i64, i64* %ord.ptr, align 8
  %fmt_elem.gep = getelementptr inbounds [6 x i8], [6 x i8]* @.str_elem, i64 0, i64 0
  %call_elem = call i32 (i8*, ...) @printf(i8* %fmt_elem.gep, i64 %ord.val, i8* %sep.ptr)
  store i64 %i.next, i64* %i, align 8
  br label %order_loop

order_done:                                         ; preds = %order_loop
  %nl = call i32 @putchar(i32 10)

  ; for (j=0; j<7; ++j) printf("dist(%zu -> %zu) = %d\n", 0, j, dist[j]);
  store i64 0, i64* %j, align 8
  br label %dist_loop

dist_loop:                                          ; preds = %dist_body, %order_done
  %j.cur = load i64, i64* %j, align 8
  %cmp2 = icmp ult i64 %j.cur, 7
  br i1 %cmp2, label %dist_body, label %done

dist_body:                                          ; preds = %dist_loop
  %d.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %j.cur
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt_dist.gep = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %call_dist = call i32 (i8*, ...) @printf(i8* %fmt_dist.gep, i64 0, i64 %j.cur, i32 %d.val)
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %dist_loop

done:                                               ; preds = %dist_loop
  ret i32 0
}