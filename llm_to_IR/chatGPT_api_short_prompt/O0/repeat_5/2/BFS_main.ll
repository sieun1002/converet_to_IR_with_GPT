; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13DD
; Intent: Build a 7-node graph adjacency matrix, run BFS from 0, print BFS order and distances (confidence=0.95). Evidence: adjacency matrix indices set symmetrically; call to bfs with dist/order buffers and subsequent formatted prints.
; Preconditions: bfs expects an n x n adjacency matrix (row-major, i32), n=7, start=0.
; Postconditions: Prints BFS order and dist(start->v) for all v, returns 0.

; Only the necessary external declarations:
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  ; locals
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %i = alloca i64, align 8
  %v = alloca i64, align 8

  ; memset adj to 0 (49 * 4 = 196 bytes)
  %adj_bytes = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_bytes, i8 0, i64 196, i1 false)

  ; build undirected edges for n=7
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  ; 0-1 and 1-0
  %p01 = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %p01, align 4
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p10, align 4
  ; 0-2 and 2-0
  %p02 = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %p02, align 4
  %p20 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p20, align 4
  ; 1-3 and 3-1
  %p13 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p13, align 4
  %p31 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p31, align 4
  ; 1-4 and 4-1
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p14, align 4
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p41, align 4
  ; 2-5 and 5-2
  %p25 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p25, align 4
  %p52 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p52, align 4
  ; 4-5 and 5-4
  %p45 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p45, align 4
  %p54 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p54, align 4
  ; 5-6 and 6-5
  %p56 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p56, align 4
  %p65 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p65, align 4

  ; init order_len = 0
  store i64 0, i64* %order_len, align 8

  ; call bfs(adj, 7, 0, dist, order, &order_len)
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj.base, i64 7, i64 0, i32* %dist.base, i64* %order.base, i64* %order_len)

  ; printf("BFS order from %zu: ", 0)
  %fmt_bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt_bfs, i64 0)

  ; for (i = 0; i < order_len; ++i) print "%zu%s"
  store i64 0, i64* %i, align 8
  br label %loop_order.cond

loop_order.cond:                                  ; preds = %loop_order.body, %entry
  %i.val = load i64, i64* %i, align 8
  %len = load i64, i64* %order_len, align 8
  %cmp = icmp ult i64 %i.val, %len
  br i1 %cmp, label %loop_order.body, label %loop_order.end

loop_order.body:                                  ; preds = %loop_order.cond
  %next = add i64 %i.val, 1
  %more = icmp ult i64 %next, %len
  %sp = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep = select i1 %more, i8* %sp, i8* %empty
  %ord.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i.val
  %ord.val = load i64, i64* %ord.ptr, align 8
  %fmt_zu_s = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt_zu_s, i64 %ord.val, i8* %sep)
  %inc = add i64 %i.val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop_order.cond

loop_order.end:                                   ; preds = %loop_order.cond
  %nl = call i32 @putchar(i32 10)

  ; for (v = 0; v < 7; ++v) printf("dist(%zu -> %zu) = %d\n", 0, v, dist[v])
  store i64 0, i64* %v, align 8
  br label %loop_dist.cond

loop_dist.cond:                                   ; preds = %loop_dist.body, %loop_order.end
  %v.val = load i64, i64* %v, align 8
  %cmpv = icmp ult i64 %v.val, 7
  br i1 %cmpv, label %loop_dist.body, label %loop_dist.end

loop_dist.body:                                   ; preds = %loop_dist.cond
  %d.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %v.val
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt_dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt_dist, i64 0, i64 %v.val, i32 %d.val)
  %v.next = add i64 %v.val, 1
  store i64 %v.next, i64* %v, align 8
  br label %loop_dist.cond

loop_dist.end:                                    ; preds = %loop_dist.cond
  ret i32 0
}

; LLVM intrinsic
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)