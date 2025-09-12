; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13DD
; Intent: Build a 7x7 adjacency matrix, run bfs(start=0), then print BFS order and distances (confidence=0.92). Evidence: call to bfs with adj matrix and buffers; prints "BFS order" and "dist(...)=..."
; Preconditions: None
; Postconditions: Prints BFS traversal order and distances from node 0.

; Only the necessary external declarations:
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

@.str0 = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str1 = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str2 = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str3 = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str4 = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %dist = alloca [8 x i32], align 16
  %order = alloca [8 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %order_len = alloca i64, align 8
  %i = alloca i64, align 8
  %k = alloca i64, align 8

  ; n = 7, start = 0, order_len = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %order_len, align 8

  ; zero adj[49]
  store i64 0, i64* %i, align 8
  br label %zero_loop

zero_loop:                                         ; preds = %zero_loop, %entry
  %i.val = load i64, i64* %i, align 8
  %cmp.z = icmp ult i64 %i.val, 49
  br i1 %cmp.z, label %zero_body, label %zero_done

zero_body:                                         ; preds = %zero_loop
  %adj.elem.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %i.val
  store i32 0, i32* %adj.elem.ptr, align 4
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %zero_loop

zero_done:                                         ; preds = %zero_loop
  ; set edges = 1 (undirected)
  ; (0,1) and (1,0)
  %p01 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p01, align 4
  %p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %p10, align 4
  ; (0,2) and (2,0)
  %p02 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p02, align 4
  %p20 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %p20, align 4
  ; (1,3) and (3,1)
  %p13 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %p13, align 4
  %p31 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %p31, align 4
  ; (1,4) and (4,1)
  %p14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %p14, align 4
  %p41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %p41, align 4
  ; (2,5) and (5,2)
  %p25 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %p25, align 4
  %p52 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %p52, align 4
  ; (4,5) and (5,4)
  %p45 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %p45, align 4
  %p54 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %p54, align 4
  ; (5,6) and (6,5)
  %p56 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %p56, align 4
  %p65 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p65, align 4

  ; call bfs(adj, n, start, dist, order, &order_len)
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [8 x i32], [8 x i32]* %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  call void @bfs(i32* %adj.ptr, i64 %n.val, i64 %start.val, i32* %dist.ptr, i64* %order.ptr, i64* %order_len)

  ; printf("BFS order from %zu: ", start)
  %fmt0 = getelementptr inbounds [21 x i8], [21 x i8]* @.str0, i64 0, i64 0
  %pr0 = call i32 (i8*, ...) @printf(i8* %fmt0, i64 %start.val)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %order_check

order_check:                                       ; preds = %order_body, %zero_done
  %i.ov = load i64, i64* %i, align 8
  %len = load i64, i64* %order_len, align 8
  %cond = icmp ult i64 %i.ov, %len
  br i1 %cond, label %order_body, label %order_done

order_body:                                        ; preds = %order_check
  %next = add i64 %i.ov, 1
  %has_more = icmp ult i64 %next, %len
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str2, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str3, i64 0, i64 0
  %sep = select i1 %has_more, i8* %space.ptr, i8* %empty.ptr
  %ord.elem.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %order, i64 0, i64 %i.ov
  %ord.val = load i64, i64* %ord.elem.ptr, align 8
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str1, i64 0, i64 0
  %pr1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %ord.val, i8* %sep)
  %i.inc = add i64 %i.ov, 1
  store i64 %i.inc, i64* %i, align 8
  br label %order_check

order_done:                                        ; preds = %order_check
  ; putchar('\n')
  %pc = call i32 @putchar(i32 10)

  ; k = 0
  store i64 0, i64* %k, align 8
  br label %dist_check

dist_check:                                        ; preds = %dist_body, %order_done
  %k.val = load i64, i64* %k, align 8
  %lt = icmp ult i64 %k.val, %n.val
  br i1 %lt, label %dist_body, label %done

dist_body:                                         ; preds = %dist_check
  %dptr = getelementptr inbounds [8 x i32], [8 x i32]* %dist, i64 0, i64 %k.val
  %dval = load i32, i32* %dptr, align 4
  %fmt2 = getelementptr inbounds [23 x i8], [23 x i8]* @.str4, i64 0, i64 0
  %pr2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %start.val, i64 %k.val, i32 %dval)
  %k.inc = add i64 %k.val, 1
  store i64 %k.inc, i64* %k, align 8
  br label %dist_check

done:                                              ; preds = %dist_check
  ret i32 0
}