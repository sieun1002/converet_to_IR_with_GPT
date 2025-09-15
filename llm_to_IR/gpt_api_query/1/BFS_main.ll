; ModuleID = 'recovered'
source_filename = "recovered.ll"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.elem = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

@__stack_chk_guard = external global i64

declare void @__stack_chk_fail() noreturn
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @bfs(i32* noundef, i64 noundef, i64 noundef, i32* noundef, i64* noundef, i64* noundef)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %guard.slot = alloca i64, align 8
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %order_len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16

  ; stack protector prologue
  %g0 = load i64, i64* @__stack_chk_guard
  store i64 %g0, i64* %guard.slot, align 8

  ; n = 7, src = 0, order_len = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %order_len, align 8

  ; memset adj (49 * 4 = 196 bytes) to 0
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; adj[1] = 1
  %adj.base.i32 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.base.i32, align 4
  ; adj[2] = 1
  %adj.base.i32.2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.base.i32.2, align 4

  ; Set undirected edges using flattened index row*n + col
  %n.val = load i64, i64* %n, align 8
  %n1 = mul i64 %n.val, 1
  %n2 = mul i64 %n.val, 2
  %n3 = mul i64 %n.val, 3
  %n4 = mul i64 %n.val, 4
  %n5 = mul i64 %n.val, 5
  %n6 = mul i64 %n.val, 6

  ; (1,0): n
  %idx_1_0.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n1
  store i32 1, i32* %idx_1_0.ptr, align 4

  ; (2,0): 2n
  %idx_2_0.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %n2
  store i32 1, i32* %idx_2_0.ptr, align 4

  ; (1,3): n+3
  %idx_1_3 = add i64 %n1, 3
  %idx_1_3.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx_1_3
  store i32 1, i32* %idx_1_3.ptr, align 4

  ; (3,1): 3n+1
  %idx_3_1 = add i64 %n3, 1
  %idx_3_1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx_3_1
  store i32 1, i32* %idx_3_1.ptr, align 4

  ; (1,4): n+4
  %idx_1_4 = add i64 %n1, 4
  %idx_1_4.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx_1_4
  store i32 1, i32* %idx_1_4.ptr, align 4

  ; (4,1): 4n+1
  %idx_4_1 = add i64 %n4, 1
  %idx_4_1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx_4_1
  store i32 1, i32* %idx_4_1.ptr, align 4

  ; (2,5): 2n+5
  %idx_2_5 = add i64 %n2, 5
  %idx_2_5.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx_2_5
  store i32 1, i32* %idx_2_5.ptr, align 4

  ; (5,2): 5n+2
  %idx_5_2 = add i64 %n5, 2
  %idx_5_2.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx_5_2
  store i32 1, i32* %idx_5_2.ptr, align 4

  ; (4,5): 4n+5
  %idx_4_5 = add i64 %n4, 5
  %idx_4_5.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx_4_5
  store i32 1, i32* %idx_4_5.ptr, align 4

  ; (5,4): 5n+4
  %idx_5_4 = add i64 %n5, 4
  %idx_5_4.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx_5_4
  store i32 1, i32* %idx_5_4.ptr, align 4

  ; (5,6): 5n+6
  %idx_5_6 = add i64 %n5, 6
  %idx_5_6.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx_5_6
  store i32 1, i32* %idx_5_6.ptr, align 4

  ; (6,5): 6n+5
  %idx_6_5 = add i64 %n6, 5
  %idx_6_5.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %idx_6_5
  store i32 1, i32* %idx_6_5.ptr, align 4

  ; call bfs(adj, n, src, dist, order, &order_len)
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %src.val = load i64, i64* %src, align 8
  call void @bfs(i32* %adj.ptr, i64 %n.val, i64 %src.val, i32* %dist.ptr, i64* %order.ptr, i64* %order_len)

  ; printf("BFS order from %zu: ", src)
  %fmt.bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %call.printf.bfs = call i32 (i8*, ...) @printf(i8* %fmt.bfs, i64 %src.val)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop.order.cond

loop.order.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %order_len, align 8
  %cond.more = icmp ult i64 %i.cur, %len.cur
  br i1 %cond.more, label %loop.order.body, label %loop.order.end

loop.order.body:
  ; choose suffix: " " if (i+1) < len else ""
  %ip1 = add i64 %i.cur, 1
  %last = icmp uge i64 %ip1, %len.cur
  %suffix.ptr = select i1 %last, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.space, i64 0, i64 0)

  ; load order[i]
  %ord.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.cur
  %ord.elem = load i64, i64* %ord.elem.ptr, align 8

  ; printf("%zu%s", order[i], suffix)
  %fmt.elem = getelementptr inbounds [6 x i8], [6 x i8]* @.str.elem, i64 0, i64 0
  %call.printf.elem = call i32 (i8*, ...) @printf(i8* %fmt.elem, i64 %ord.elem, i8* %suffix.ptr)

  ; i++
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.order.cond

loop.order.end:
  ; putchar('\n')
  %call.putc = call i32 @putchar(i32 10)

  ; for (j = 0; j < n; ++j) printf("dist(%zu -> %zu) = %d\n", src, j, dist[j]);
  store i64 0, i64* %j, align 8
  br label %loop.dist.cond

loop.dist.cond:
  %j.cur = load i64, i64* %j, align 8
  %cond.j = icmp ult i64 %j.cur, %n.val
  br i1 %cond.j, label %loop.dist.body, label %epilogue

loop.dist.body:
  %dist.elem.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j.cur
  %dist.elem = load i32, i32* %dist.elem.ptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %call.printf.dist = call i32 (i8*, ...) @printf(i8* %fmt.dist, i64 %src.val, i64 %j.cur, i32 %dist.elem)
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop.dist.cond

epilogue:
  ; stack protector epilogue
  %g1 = load i64, i64* %guard.slot, align 8
  %g2 = load i64, i64* @__stack_chk_guard
  %guard.ok = icmp eq i64 %g1, %g2
  br i1 %guard.ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}