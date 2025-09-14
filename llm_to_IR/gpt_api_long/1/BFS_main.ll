; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13DD
; Intent: Build a 7-node undirected graph, run BFS from node 0, print BFS order and distances (confidence=0.95). Evidence: initializes 7x7 i32 adjacency matrix with symmetric edges; calls bfs(dist, order, order_len) and prints with %zu/%d.
; Preconditions: bfs expects row-major i32 adjacency of size n*n, n=7, start=0; dist buffer length >= n; order buffer length >= n; order_len is an output counter.
; Postconditions: Prints BFS visitation order and dist(0->i) for all i in [0,n).

@__stack_chk_guard = external global i64

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %out_len)
declare i32 @_printf(i8* %fmt, ...)
declare i32 @_putchar(i32 %c)
declare void @___stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard0 = load i64, i64* @__stack_chk_guard
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8

  ; zero adjacency matrix (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set undirected edges:
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

  ; init order_len = 0
  store i64 0, i64* %order_len, align 8

  ; bfs(adj, n=7, start=0, dist, order, &order_len)
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj.base, i64 7, i64 0, i32* %dist.base, i64* %order.base, i64* %order_len)

  ; printf("BFS order from %zu: ", 0)
  %fmt.bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %call.printf.bfs = call i32 @_printf(i8* %fmt.bfs, i64 0)

  ; loop over order[0..order_len)
  br label %loop1.header

loop1.header: ; i in %i1
  %i1 = phi i64 [ 0, %entry ], [ %i1.next, %loop1.latch ]
  %len1 = load i64, i64* %order_len, align 8
  %cond1 = icmp ult i64 %i1, %len1
  br i1 %cond1, label %loop1.body, label %after.loop1

loop1.body:
  %i1.plus1 = add i64 %i1, 1
  %len1b = load i64, i64* %order_len, align 8
  %more = icmp ult i64 %i1.plus1, %len1b
  %sep.space = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %sep.empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.sel = select i1 %more, i8* %sep.space, i8* %sep.empty
  %ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i1
  %ord.val = load i64, i64* %ord.ptr, align 8
  %fmt.item = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %call.printf.item = call i32 @_printf(i8* %fmt.item, i64 %ord.val, i8* %sep.sel)
  br label %loop1.latch

loop1.latch:
  %i1.next = add i64 %i1, 1
  br label %loop1.header

after.loop1:
  %putnl = call i32 @_putchar(i32 10)

  ; print distances
  br label %loop2.header

loop2.header:
  %i2 = phi i64 [ 0, %after.loop1 ], [ %i2.next, %loop2.latch ]
  %cond2 = icmp ult i64 %i2, 7
  br i1 %cond2, label %loop2.body, label %epilogue

loop2.body:
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i2
  %dist.val = load i32, i32* %dist.ptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %call.printf.dist = call i32 @_printf(i8* %fmt.dist, i64 0, i64 %i2, i32 %dist.val)
  br label %loop2.latch

loop2.latch:
  %i2.next = add i64 %i2, 1
  br label %loop2.header

epilogue:
  %guard1 = load i64, i64* @__stack_chk_guard
  %guard.ok = icmp eq i64 %guard0, %guard1
  br i1 %guard.ok, label %ret, label %stackfail

stackfail:
  call void @___stack_chk_fail()
  unreachable

ret:
  ret i32 0
}

; Only the needed intrinsics:
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)