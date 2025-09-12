; ModuleID = 'main.ll'
target triple = "x86_64-unknown-linux-gnu"

declare void @bfs(i32* %adj, i64 %n, i64 %src, i32* %dist, i64* %order, i64* %order_len)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.sep.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.sep.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

define i32 @main() {
entry:
  ; locals
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %order_len = alloca i64, align 8
  %i = alloca i64, align 8
  %v = alloca i64, align 8
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16

  ; n = 7, src = 0, order_len = 0
  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %order_len, align 8

  ; memset adj to 0 (49 * 4 = 196 bytes)
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set adjacency entries to 1
  ; indices: 7, 14, 10, 22, 11, 29, 19, 37, 33, 39, 41, 47
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p7  = getelementptr inbounds i32, i32* %adj.base, i64 7
  store i32 1, i32* %p7,  align 4
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

  ; call bfs(adj, n, src, dist, order, &order_len)
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %src.val = load i64, i64* %src, align 8
  call void @bfs(i32* %adj.base, i64 %n.val, i64 %src.val, i32* %dist.base, i64* %order.base, i64* %order_len)

  ; printf("BFS order from %zu: ", src)
  %fmt.bfs.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %_ = call i32 (i8*, ...) @printf(i8* %fmt.bfs.ptr, i64 %src.val)

  ; for (i = 0; i < order_len; ++i) printf("%zu%s", order[i], (i+1 < order_len) ? " " : "");
  store i64 0, i64* %i, align 8
  br label %loop_order.cond

loop_order.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %order_len, align 8
  %cond.lt = icmp ult i64 %i.cur, %len.cur
  br i1 %cond.lt, label %loop_order.body, label %loop_order.end

loop_order.body:
  ; sep = (i + 1 < len) ? " " : ""
  %i.next = add i64 %i.cur, 1
  %cond.sep = icmp ult i64 %i.next, %len.cur
  %sep.space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.sep.space, i64 0, i64 0
  %sep.empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.sep.empty, i64 0, i64 0
  %sep.sel = select i1 %cond.sep, i8* %sep.space.ptr, i8* %sep.empty.ptr

  ; val = order[i]
  %ord.elem.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i.cur
  %ord.val = load i64, i64* %ord.elem.ptr, align 8

  ; printf("%zu%s", ord.val, sep)
  %fmt.pair.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.pair, i64 0, i64 0
  %__ = call i32 (i8*, ...) @printf(i8* %fmt.pair.ptr, i64 %ord.val, i8* %sep.sel)

  ; ++i
  %i.inc = add i64 %i.cur, 1
  store i64 %i.inc, i64* %i, align 8
  br label %loop_order.cond

loop_order.end:
  ; putchar('\n')
  call i32 @putchar(i32 10)

  ; for (v = 0; v < n; ++v) printf("dist(%zu -> %zu) = %d\n", src, v, dist[v]);
  store i64 0, i64* %v, align 8
  br label %loop_dist.cond

loop_dist.cond:
  %v.cur = load i64, i64* %v, align 8
  %n.cur = load i64, i64* %n, align 8
  %cond.v = icmp ult i64 %v.cur, %n.cur
  br i1 %cond.v, label %loop_dist.body, label %loop_dist.end

loop_dist.body:
  ; load dist[v]
  %dist.elem.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %v.cur
  %dist.val = load i32, i32* %dist.elem.ptr, align 4

  ; printf("dist(%zu -> %zu) = %d\n", src, v, dist)
  %fmt.dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %___ = call i32 (i8*, ...) @printf(i8* %fmt.dist.ptr, i64 %src.val, i64 %v.cur, i32 %dist.val)

  ; ++v
  %v.inc = add i64 %v.cur, 1
  store i64 %v.inc, i64* %v, align 8
  br label %loop_dist.cond

loop_dist.end:
  ret i32 0
}