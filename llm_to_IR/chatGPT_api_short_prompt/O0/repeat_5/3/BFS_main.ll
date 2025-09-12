; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13DD
; Intent: Build a small graph, run BFS from node 0, and print traversal order and distances (confidence=0.83). Evidence: call to bfs with adjacency matrix and buffers; printf loops for order and dist.
; Preconditions: None
; Postconditions: Prints BFS order and per-node distances from source 0.

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare void @__stack_chk_fail()
@__stack_chk_guard = external global i64

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00"
@.str.elem = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.str.space = private unnamed_addr constant [2 x i8] c" \00"
@.str.empty = private unnamed_addr constant [1 x i8] c"\00"
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  %saved_canary = alloca i64, align 8
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %out_len = alloca i64, align 8

  ; stack protector setup
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %saved_canary, align 8

  ; memset adj to 0
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* nonnull %adj.i8, i8 0, i64 196, i1 false)

  ; initialize specific adjacency entries to 1 (column-major, n = 7)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  ; indices: 1,2,7,10,11,14,19,22,29,33,37,39,47
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
  %p47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %p47, align 4

  ; prepare buffers and call bfs(adj, n=7, src=0, dist, order, &out_len)
  store i64 0, i64* %out_len, align 8
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj.base, i64 7, i64 0, i32* %dist.base, i64* %order.base, i64* %out_len)

  ; printf("BFS order from %zu: ", 0)
  %fmt.bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %call.printf.bfs = call i32 (i8*, ...) @printf(i8* %fmt.bfs, i64 0)

  ; for (i = 0; i < out_len; ++i) { printf("%zu%s", order[i], (i+1<out_len)?" ":""); }
  br label %order.loop.cond

order.loop.cond:                              ; preds = %order.loop.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %order.loop.body ]
  %len.cur = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i, %len.cur
  br i1 %cmp, label %order.loop.body, label %order.loop.end

order.loop.body:                              ; preds = %order.loop.cond
  %ip1 = add i64 %i, 1
  %len.cur2 = load i64, i64* %out_len, align 8
  %has_next = icmp ult i64 %ip1, %len.cur2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %suffix = select i1 %has_next, i8* %space.ptr, i8* %empty.ptr
  %elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i
  %elem = load i64, i64* %elem.ptr, align 8
  %fmt.elem = getelementptr inbounds [6 x i8], [6 x i8]* @.str.elem, i64 0, i64 0
  %call.printf.elem = call i32 (i8*, ...) @printf(i8* %fmt.elem, i64 %elem, i8* %suffix)
  %i.next = add i64 %i, 1
  br label %order.loop.cond

order.loop.end:                               ; preds = %order.loop.cond
  %call.putchar = call i32 @putchar(i32 10)

  ; for (j = 0; j < n; ++j) printf("dist(%zu -> %zu) = %d\n", 0, j, dist[j]);
  br label %dist.loop.cond

dist.loop.cond:                               ; preds = %dist.loop.body, %order.loop.end
  %j = phi i64 [ 0, %order.loop.end ], [ %j.next, %dist.loop.body ]
  %j.cmp = icmp ult i64 %j, 7
  br i1 %j.cmp, label %dist.loop.body, label %ret.check

dist.loop.body:                               ; preds = %dist.loop.cond
  %dptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
  %dval = load i32, i32* %dptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %call.printf.dist = call i32 (i8*, ...) @printf(i8* %fmt.dist, i64 0, i64 %j, i32 %dval)
  %j.next = add i64 %j, 1
  br label %dist.loop.cond

ret.check:                                    ; preds = %dist.loop.cond
  ; stack protector check
  %guard.end = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %saved_canary, align 8
  %guard.ok = icmp eq i64 %saved, %guard.end
  br i1 %guard.ok, label %ret, label %fail

fail:                                          ; preds = %ret.check
  call void @__stack_chk_fail()
  br label %ret

ret:                                           ; preds = %fail, %ret.check
  ret i32 0
}

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)