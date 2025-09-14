; target: System V AMD64 (Linux)
target triple = "x86_64-pc-linux-gnu"

declare i8* @memset(i8* noundef, i32 noundef, i64 noundef)
declare i32 @min_index(i32* noundef, i32* noundef, i32 noundef)

define void @dijkstra(i32* noundef %graph, i32 noundef %n, i32 noundef %src, i32* noundef %dist) {
entry:
  %visited = alloca [100 x i32], align 16

  %visited_i8ptr = bitcast [100 x i32]* %visited to i8*
  %memset_call = call i8* @memset(i8* noundef %visited_i8ptr, i32 noundef 0, i64 noundef 400)

  br label %init_loop

init_loop:                                            ; i = 0..n-1 initialize dist[i] = INT_MAX
  %i = phi i32 [ 0, %entry ], [ %i.next, %init_body ]
  %init_cmp = icmp slt i32 %i, %n
  br i1 %init_cmp, label %init_body, label %post_init

init_body:
  %i.ext = sext i32 %i to i64
  %dist.gep = getelementptr inbounds i32, i32* %dist, i64 %i.ext
  store i32 2147483647, i32* %dist.gep, align 4
  %i.next = add nsw i32 %i, 1
  br label %init_loop

post_init:
  %src.ext = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src.ext
  store i32 0, i32* %dist.src.ptr, align 4

  br label %outer_loop

outer_loop:                                           ; iter = 0..(n-2)
  %iter = phi i32 [ 0, %post_init ], [ %iter.next, %outer_latch ]
  %n.minus1 = add nsw i32 %n, -1
  %outer_cmp = icmp slt i32 %iter, %n.minus1
  br i1 %outer_cmp, label %outer_body, label %exit

outer_body:
  %visited.base = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 0
  %u = call i32 @min_index(i32* noundef %dist, i32* noundef %visited.base, i32 noundef %n)
  %u.neg1 = icmp eq i32 %u, -1
  br i1 %u.neg1, label %exit, label %mark_visited

mark_visited:
  %u.ext = sext i32 %u to i64
  %visited.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u.ext
  store i32 1, i32* %visited.u.ptr, align 4

  br label %inner_loop

inner_loop:                                           ; v = 0..(n-1)
  %v = phi i32 [ 0, %mark_visited ], [ %v.next, %inner_latch ]
  %inner_cmp = icmp slt i32 %v, %n
  br i1 %inner_cmp, label %inner_body, label %outer_latch

inner_body:
  %u.ext2 = sext i32 %u to i64
  %row.off = mul nsw i64 %u.ext2, 100
  %v.ext = sext i32 %v to i64
  %idx.flat = add nsw i64 %row.off, %v.ext
  %g.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx.flat
  %w = load i32, i32* %g.ptr, align 4
  %w.iszero = icmp eq i32 %w, 0
  br i1 %w.iszero, label %inner_latch, label %check_visited

check_visited:
  %visited.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v.ext
  %visited.v = load i32, i32* %visited.v.ptr, align 4
  %v.already = icmp ne i32 %visited.v, 0
  br i1 %v.already, label %inner_latch, label %check_du

check_du:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u.ext2
  %du = load i32, i32* %dist.u.ptr, align 4
  %du.isinf = icmp eq i32 %du, 2147483647
  br i1 %du.isinf, label %inner_latch, label %relax_try

relax_try:
  %sum = add nsw i32 %du, %w
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v.ext
  %dv = load i32, i32* %dist.v.ptr, align 4
  %improve = icmp slt i32 %sum, %dv
  br i1 %improve, label %do_relax, label %inner_latch

do_relax:
  store i32 %sum, i32* %dist.v.ptr, align 4
  br label %inner_latch

inner_latch:
  %v.next = add nsw i32 %v, 1
  br label %inner_loop

outer_latch:
  %iter.next = add nsw i32 %iter, 1
  br label %outer_loop

exit:
  ret void
}