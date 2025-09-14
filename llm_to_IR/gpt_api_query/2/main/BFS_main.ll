; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.perczu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.dist = private unnamed_addr constant [24 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32* nocapture, i64, i64, i32* nocapture, i64* nocapture, i64* nocapture)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1)

define i32 @main() {
entry:
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %order_len = alloca i64, align 8
  %i = alloca i64, align 8
  %v = alloca i64, align 8
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16

  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %order_len, align 8

  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)

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

  %dist_base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order_base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %n_val = load i64, i64* %n, align 8
  %src_val = load i64, i64* %src, align 8
  call void @bfs(i32* %adj_base, i64 %n_val, i64 %src_val, i32* %dist_base, i64* %order_base, i64* %order_len)

  %fmt_bfs_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %src_val2 = load i64, i64* %src, align 8
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt_bfs_ptr, i64 %src_val2)

  store i64 0, i64* %i, align 8
  br label %order.loop.cond

order.loop.cond:
  %i_val = load i64, i64* %i, align 8
  %len_val = load i64, i64* %order_len, align 8
  %cmp = icmp ult i64 %i_val, %len_val
  br i1 %cmp, label %order.loop.body, label %order.loop.end

order.loop.body:
  %i_plus1 = add i64 %i_val, 1
  %cmp2 = icmp ult i64 %i_plus1, %len_val
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep_ptr = select i1 %cmp2, i8* %space_ptr, i8* %empty_ptr
  %order_elem_ptr = getelementptr inbounds i64, i64* %order_base, i64 %i_val
  %order_elem = load i64, i64* %order_elem_ptr, align 8
  %fmt_pairs_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.perczu_s, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt_pairs_ptr, i64 %order_elem, i8* %sep_ptr)
  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %i, align 8
  br label %order.loop.cond

order.loop.end:
  %call2 = call i32 @putchar(i32 10)

  store i64 0, i64* %v, align 8
  br label %dist.loop.cond

dist.loop.cond:
  %v_val = load i64, i64* %v, align 8
  %n_val2 = load i64, i64* %n, align 8
  %cmpv = icmp ult i64 %v_val, %n_val2
  br i1 %cmpv, label %dist.loop.body, label %dist.loop.end

dist.loop.body:
  %dist_elem_ptr = getelementptr inbounds i32, i32* %dist_base, i64 %v_val
  %dist_elem = load i32, i32* %dist_elem_ptr, align 4
  %fmt_dist_ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.dist, i64 0, i64 0
  %src_val3 = load i64, i64* %src, align 8
  %call3 = call i32 (i8*, ...) @printf(i8* %fmt_dist_ptr, i64 %src_val3, i64 %v_val, i32 %dist_elem)
  %v_next = add i64 %v_val, 1
  store i64 %v_next, i64* %v, align 8
  br label %dist.loop.cond

dist.loop.end:
  ret i32 0
}