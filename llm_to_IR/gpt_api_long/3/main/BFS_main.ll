; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13DD
; Intent: Build a fixed 7-node graph, run BFS from node 0, and print BFS order and distances (confidence=0.90). Evidence: call to bfs with adjacency matrix and printing of “BFS order” and “dist(..)”.
; Preconditions: None
; Postconditions: None

@.str.bfs = private unnamed_addr constant [22 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

; Only the needed extern declarations:
declare void @bfs(i32* nocapture, i64, i64, i32* nocapture, i64* nocapture, i64* nocapture) local_unnamed_addr
declare i32 @printf(i8*, ...) local_unnamed_addr
declare i32 @putchar(i32) local_unnamed_addr
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) nounwind

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %out_len = alloca i64, align 8
  store i64 0, i64* %out_len, align 8

  ; memset adj[49] = 0
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; Set specific adjacency entries to 1 (flattened 7x7 matrix)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p1 = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds i32, i32* %adj.base, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p47, align 4

  ; Call bfs(adj, 7, 0, dist, order, &out_len)
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj.base, i64 7, i64 0, i32* %dist.base, i64* %order.base, i64* %out_len)

  ; printf("BFS order from %zu: ", 0)
  %fmt1 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.bfs, i64 0, i64 0
  %header = call i32 (i8*, ...) @printf(i8* %fmt1, i64 0)

  ; Print BFS order
  br label %loop.order

loop.order:                                       ; preds = %loop.order, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.order ]
  %len = load i64, i64* %out_len, align 8
  %cond = icmp ult i64 %i, %len
  br i1 %cond, label %order.body, label %order.done

order.body:                                       ; preds = %loop.order
  %i.plus1 = add nuw nsw i64 %i, 1
  %len2 = load i64, i64* %out_len, align 8
  %has_space = icmp ult i64 %i.plus1, %len2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %suffix = select i1 %has_space, i8* %space.ptr, i8* %empty.ptr
  %oval.ptr = getelementptr inbounds [7 x i64], [7 x i64]* @.str.empty, i64 0, i64 0 ; dummy to keep structure consistent (will be unused)
  %order.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i
  %order.val = load i64, i64* %order.elem.ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zu_s, i64 0, i64 0
  %print2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %order.val, i8* %suffix)
  %i.next = add nuw nsw i64 %i, 1
  br label %loop.order

order.done:                                       ; preds = %loop.order
  %nl = call i32 @putchar(i32 10)

  ; Print distances
  br label %loop.dist

loop.dist:                                        ; preds = %loop.dist, %order.done
  %v = phi i64 [ 0, %order.done ], [ %v.next, %loop.dist ]
  %more = icmp ult i64 %v, 7
  br i1 %more, label %dist.body, label %ret

dist.body:                                        ; preds = %loop.dist
  %dptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v
  %dval = load i32, i32* %dptr, align 4
  %fmt3 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %print3 = call i32 (i8*, ...) @printf(i8* %fmt3, i64 0, i64 %v, i32 %dval)
  %v.next = add nuw nsw i64 %v, 1
  br label %loop.dist

ret:                                              ; preds = %loop.dist
  ret i32 0
}