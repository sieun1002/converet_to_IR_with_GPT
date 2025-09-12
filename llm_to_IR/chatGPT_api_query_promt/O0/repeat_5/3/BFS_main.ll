; ModuleID = 'recovered'
source_filename = "recovered.ll"

declare void @bfs(i32* nocapture, i64, i64, i32* nocapture, i64* nocapture, i64* nocapture)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

@.fmt_hdr = private constant [21 x i8] c"BFS order from %zu: \00"
@.fmt_pair = private constant [7 x i8] c"%zu%s\00"
@.space = private constant [2 x i8] c" \00"
@.empty = private constant [1 x i8] c"\00"
@.fmt_dist = private constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"

define i32 @main() {
entry:
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %out_len = alloca i64, align 8
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %out_len, align 8

  ; memset adj to 0 (49 * 4 = 196 bytes)
  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)

  ; set edges in adjacency matrix (row-major, n=7)
  %adj_base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p1 = getelementptr inbounds i32, i32* %adj_base, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %adj_base, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds i32, i32* %adj_base, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds i32, i32* %adj_base, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %adj_base, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds i32, i32* %adj_base, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds i32, i32* %adj_base, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds i32, i32* %adj_base, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds i32, i32* %adj_base, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds i32, i32* %adj_base, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds i32, i32* %adj_base, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds i32, i32* %adj_base, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adj_base, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adj_base, i64 47
  store i32 1, i32* %p47, align 4

  ; call bfs(adj, n, src, dist, order, out_len)
  %dist_base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order_base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %nval = load i64, i64* %n, align 8
  %srcval = load i64, i64* %src, align 8
  call void @bfs(i32* %adj_base, i64 %nval, i64 %srcval, i32* %dist_base, i64* %order_base, i64* %out_len)

  ; printf("BFS order from %zu: ", src)
  %fmt_hdr_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.fmt_hdr, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_hdr_ptr, i64 %srcval)

  ; for (i = 0; i < out_len; ++i) printf("%zu%s", order[i], (i+1<out_len)?" ":"")
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %loop_orders.cond

loop_orders.cond:
  %i.cur = load i64, i64* %i, align 8
  %olen = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.cur, %olen
  br i1 %cmp, label %loop_orders.body, label %loop_orders.end

loop_orders.body:
  %i.next = add i64 %i.cur, 1
  %use_empty = icmp uge i64 %i.next, %olen
  %delim.empty = getelementptr inbounds [1 x i8], [1 x i8]* @.empty, i64 0, i64 0
  %delim.space = getelementptr inbounds [2 x i8], [2 x i8]* @.space, i64 0, i64 0
  %delim.sel = select i1 %use_empty, i8* %delim.empty, i8* %delim.space
  %order_i_ptr = getelementptr inbounds i64, i64* %order_base, i64 %i.cur
  %order_i = load i64, i64* %order_i_ptr, align 8
  %fmt_pair_ptr = getelementptr inbounds [7 x i8], [7 x i8]* @.fmt_pair, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_pair_ptr, i64 %order_i, i8* %delim.sel)
  %i.inc = add i64 %i.cur, 1
  store i64 %i.inc, i64* %i, align 8
  br label %loop_orders.cond

loop_orders.end:
  call i32 @putchar(i32 10)

  ; for (v = 0; v < n; ++v) printf("dist(%zu -> %zu) = %d\n", src, v, dist[v])
  %v = alloca i64, align 8
  store i64 0, i64* %v, align 8
  br label %loop_dists.cond

loop_dists.cond:
  %v.cur = load i64, i64* %v, align 8
  %ncur = load i64, i64* %n, align 8
  %cmpv = icmp ult i64 %v.cur, %ncur
  br i1 %cmpv, label %loop_dists.body, label %loop_dists.end

loop_dists.body:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist_base, i64 %v.cur
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %fmt_dist_ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.fmt_dist, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_dist_ptr, i64 %srcval, i64 %v.cur, i32 %dist_v)
  %v.inc = add i64 %v.cur, 1
  store i64 %v.inc, i64* %v, align 8
  br label %loop_dists.cond

loop_dists.end:
  ret i32 0
}