; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13DD
; Intent: Construct a 7x7 adjacency matrix for an undirected graph, run BFS from 0, and print BFS order and distances (confidence=0.93). Evidence: 7*7 zeroing and symmetric edge sets; call to bfs and printf with "%zu" and distance format.
; Preconditions: bfs(i32* adj, i64 n, i64 s, i32* dist_out, i64* order_out, i64* order_len_out) fills outputs for n=7.
; Postconditions: Prints BFS order and distances from source 0.

@.str_header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00"
@.space = private unnamed_addr constant [2 x i8] c" \00"
@.empty = private unnamed_addr constant [1 x i8] c"\00"
@.fmt_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.fmt_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"

declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8

  ; n = 7, s = 0
  store i64 0, i64* %order_len, align 8

  ; zero adjacency matrix (49 ints)
  br label %zero.loop

zero.loop:                                          ; preds = %zero.body, %entry
  %zi = phi i64 [ 0, %entry ], [ %zi.next, %zero.body ]
  %zi.cmp = icmp ult i64 %zi, 49
  br i1 %zi.cmp, label %zero.body, label %zero.done

zero.body:                                          ; preds = %zero.loop
  %zptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %zi
  store i32 0, i32* %zptr, align 4
  %zi.next = add i64 %zi, 1
  br label %zero.loop

zero.done:                                          ; preds = %zero.loop
  ; add undirected edges: (0,1), (0,2), (1,3), (1,4), (2,5), (4,5), (5,6)
  ; (0,1) and (1,0)
  %idx01 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %idx01, align 4
  %idx10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %idx10, align 4
  ; (0,2) and (2,0)
  %idx02 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %idx02, align 4
  %idx20 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %idx20, align 4
  ; (1,3) and (3,1)
  %idx13 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %idx13, align 4
  %idx31 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %idx31, align 4
  ; (1,4) and (4,1)
  %idx14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %idx14, align 4
  %idx41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %idx41, align 4
  ; (2,5) and (5,2)
  %idx25 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %idx25, align 4
  %idx52 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %idx52, align 4
  ; (4,5) and (5,4)
  %idx45 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %idx45, align 4
  %idx54 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %idx54, align 4
  ; (5,6) and (6,5)
  %idx56 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %idx56, align 4
  %idx65 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %idx65, align 4

  ; call bfs(adj, 7, 0, dist, order, &order_len)
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj.ptr, i64 7, i64 0, i32* %dist.ptr, i64* %order.ptr, i64* %order_len)

  ; printf("BFS order from %zu: ", 0)
  %hdr.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_header, i64 0, i64 0
  %call.hdr = call i32 (i8*, ...) @printf(i8* %hdr.ptr, i64 0)

  ; for (i = 0; i < order_len; ++i) printf("%zu%s", order[i], (i+1<len)?" ":"");
  br label %ord.loop

ord.loop:                                            ; preds = %ord.body, %zero.done
  %i = phi i64 [ 0, %zero.done ], [ %i.next, %ord.body ]
  %len = load i64, i64* %order_len, align 8
  %cmp = icmp ult i64 %i, %len
  br i1 %cmp, label %ord.body, label %ord.done

ord.body:                                            ; preds = %ord.loop
  %next = add i64 %i, 1
  %spc = icmp ult i64 %next, %len
  %spc.ptr.space = getelementptr inbounds [2 x i8], [2 x i8]* @.space, i64 0, i64 0
  %spc.ptr.empty = getelementptr inbounds [1 x i8], [1 x i8]* @.empty, i64 0, i64 0
  %sel = select i1 %spc, i8* %spc.ptr.space, i8* %spc.ptr.empty
  %ord.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i
  %ord.val = load i64, i64* %ord.elem.ptr, align 8
  %fmt.pair.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt_pair, i64 0, i64 0
  %call.pair = call i32 (i8*, ...) @printf(i8* %fmt.pair.ptr, i64 %ord.val, i8* %sel)
  %i.next = add i64 %i, 1
  br label %ord.loop

ord.done:                                            ; preds = %ord.loop
  %nl = call i32 @putchar(i32 10)

  ; for (j = 0; j < 7; ++j) printf("dist(%zu -> %zu) = %d\n", 0, j, dist[j]);
  br label %dist.loop

dist.loop:                                           ; preds = %dist.body, %ord.done
  %j = phi i64 [ 0, %ord.done ], [ %j.next, %dist.body ]
  %j.cmp = icmp ult i64 %j, 7
  br i1 %j.cmp, label %dist.body, label %ret

dist.body:                                           ; preds = %dist.loop
  %dptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
  %dval = load i32, i32* %dptr, align 4
  %fmt.dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.fmt_dist, i64 0, i64 0
  %call.dist = call i32 (i8*, ...) @printf(i8* %fmt.dist.ptr, i64 0, i64 %j, i32 %dval)
  %j.next = add i64 %j, 1
  br label %dist.loop

ret:                                                 ; preds = %dist.loop
  ret i32 0
}