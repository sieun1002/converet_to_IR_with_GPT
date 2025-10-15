; ModuleID = 'main_module'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00"
@asc_140004015 = private unnamed_addr constant [2 x i8] c" \00"
@unk_140004017 = private unnamed_addr constant [1 x i8] zeroinitializer
@aZuS = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@aDistZuZuD = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"

declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)
declare dso_local void @bfs(i32* noundef, i64 noundef, i64 noundef, i32* noundef, i64* noundef, i64* noundef)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %adj = alloca [49 x i32], align 4
  %order = alloca [7 x i64], align 8
  %dist = alloca [7 x i32], align 4

  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8

  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)

  %n.val = load i64, i64* %n, align 8
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i32 0, i32 0
  %one = add i32 0, 1

  %gep1 = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 %one, i32* %gep1, align 4

  %gep2 = getelementptr inbounds i32, i32* %adj.base, i64 %n.val
  store i32 %one, i32* %gep2, align 4

  %gep3 = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 %one, i32* %gep3, align 4

  %n2 = shl i64 %n.val, 1
  %gep4 = getelementptr inbounds i32, i32* %adj.base, i64 %n2
  store i32 %one, i32* %gep4, align 4

  %n_plus3 = add i64 %n.val, 3
  %gep5 = getelementptr inbounds i32, i32* %adj.base, i64 %n_plus3
  store i32 %one, i32* %gep5, align 4

  %n3 = add i64 %n2, %n.val
  %n3p1 = add i64 %n3, 1
  %gep6 = getelementptr inbounds i32, i32* %adj.base, i64 %n3p1
  store i32 %one, i32* %gep6, align 4

  %n_plus4 = add i64 %n.val, 4
  %gep7 = getelementptr inbounds i32, i32* %adj.base, i64 %n_plus4
  store i32 %one, i32* %gep7, align 4

  %n4 = shl i64 %n.val, 2
  %n4p1 = add i64 %n4, 1
  %gep8 = getelementptr inbounds i32, i32* %adj.base, i64 %n4p1
  store i32 %one, i32* %gep8, align 4

  %n2p5 = add i64 %n2, 5
  %gep9 = getelementptr inbounds i32, i32* %adj.base, i64 %n2p5
  store i32 %one, i32* %gep9, align 4

  %n5 = add i64 %n4, %n.val
  %n5p2 = add i64 %n5, 2
  %gep10 = getelementptr inbounds i32, i32* %adj.base, i64 %n5p2
  store i32 %one, i32* %gep10, align 4

  %n4p5 = add i64 %n4, 5
  %gep11 = getelementptr inbounds i32, i32* %adj.base, i64 %n4p5
  store i32 %one, i32* %gep11, align 4

  %n5p4 = add i64 %n5, 4
  %gep12 = getelementptr inbounds i32, i32* %adj.base, i64 %n5p4
  store i32 %one, i32* %gep12, align 4

  %n5p6 = add i64 %n5, 6
  %gep13 = getelementptr inbounds i32, i32* %adj.base, i64 %n5p6
  store i32 %one, i32* %gep13, align 4

  %n6 = add i64 %n5, %n.val
  %n6p5 = add i64 %n6, 5
  %gep14 = getelementptr inbounds i32, i32* %adj.base, i64 %n6p5
  store i32 %one, i32* %gep14, align 4

  store i64 0, i64* %len, align 8

  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i32 0, i32 0
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i32 0, i32 0

  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i32 0, i32 0
  %start.val = load i64, i64* %start, align 8
  call void @bfs(i32* %adj.ptr, i64 %n.val, i64 %start.val, i32* %dist.base, i64* %len, i64* %order.base)

  %fmt_hdr = getelementptr inbounds [21 x i8], [21 x i8]* @_Format, i32 0, i32 0
  %start.val2 = load i64, i64* %start, align 8
  %call_hdr = call i32 (i8*, ...) @printf(i8* %fmt_hdr, i64 %start.val2)

  store i64 0, i64* %i, align 8
  br label %bfs_loop.cond

bfs_loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %len, align 8
  %cmp.loop = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp.loop, label %bfs_loop.body, label %bfs_loop.end

bfs_loop.body:
  %i.plus1 = add i64 %i.cur, 1
  %len.cur2 = load i64, i64* %len, align 8
  %has_space = icmp ult i64 %i.plus1, %len.cur2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @asc_140004015, i32 0, i32 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140004017, i32 0, i32 0
  %sep.ptr = select i1 %has_space, i8* %space.ptr, i8* %empty.ptr

  %ord.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i32 0, i64 %i.cur
  %ord.val = load i64, i64* %ord.elem.ptr, align 8
  %fmt_item = getelementptr inbounds [6 x i8], [6 x i8]* @aZuS, i32 0, i32 0
  %call_item = call i32 (i8*, ...) @printf(i8* %fmt_item, i64 %ord.val, i8* %sep.ptr)

  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %bfs_loop.cond

bfs_loop.end:
  %nl = call i32 @putchar(i32 10)

  store i64 0, i64* %j, align 8
  br label %dist_loop.cond

dist_loop.cond:
  %j.cur = load i64, i64* %j, align 8
  %n.cur = load i64, i64* %n, align 8
  %cmp.j = icmp ult i64 %j.cur, %n.cur
  br i1 %cmp.j, label %dist_loop.body, label %dist_loop.end

dist_loop.body:
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i32 0, i64 %j.cur
  %dist.val = load i32, i32* %dist.ptr, align 4
  %fmt_dist = getelementptr inbounds [23 x i8], [23 x i8]* @aDistZuZuD, i32 0, i32 0
  %start.val3 = load i64, i64* %start, align 8
  %call_dist = call i32 (i8*, ...) @printf(i8* %fmt_dist, i64 %start.val3, i64 %j.cur, i32 %dist.val)
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %dist_loop.cond

dist_loop.end:
  ret i32 0
}