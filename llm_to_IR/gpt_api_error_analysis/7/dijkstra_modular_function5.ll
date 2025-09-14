target triple = "x86_64-pc-linux-gnu"

declare i32 @min_index(i32*, i32*, i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define void @dijkstra(i32* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* %s.i8, i8 0, i64 400, i1 false)
  br label %init_loop

init_loop:                                         ; i from 0 to n-1
  %i = phi i32 [ 0, %entry ], [ %i.next, %init_cont ]
  %cmp.i = icmp slt i32 %i, %n
  br i1 %cmp.i, label %init_body, label %after_init

init_body:
  %i64 = sext i32 %i to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %dist.i.ptr, align 4
  br label %init_cont

init_cont:
  %i.next = add nsw i32 %i, 1
  br label %init_loop

after_init:
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer_loop

outer_loop:                                        ; count from 0 to n-2
  %count = phi i32 [ 0, %after_init ], [ %count.next, %outer_latch ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.count = icmp slt i32 %count, %n.minus1
  br i1 %cmp.count, label %outer_body, label %ret

outer_body:
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %ret, label %got_u

got_u:
  %u64 = sext i32 %u to i64
  %s.u.ptr = getelementptr inbounds i32, i32* %s.base, i64 %u64
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner_loop

inner_loop:                                        ; v from 0 to n-1
  %v = phi i32 [ 0, %got_u ], [ %v.next, %inner_latch ]
  %cmp.v = icmp slt i32 %v, %n
  br i1 %cmp.v, label %inner_check_edge, label %outer_latch

inner_check_edge:
  %u64.row = sext i32 %u to i64
  %u.mul100 = mul nsw i64 %u64.row, 100
  %row.ptr = getelementptr inbounds i32, i32* %graph, i64 %u.mul100
  %v64 = sext i32 %v to i64
  %g.uv.ptr = getelementptr inbounds i32, i32* %row.ptr, i64 %v64
  %w = load i32, i32* %g.uv.ptr, align 4
  %w.iszero = icmp eq i32 %w, 0
  br i1 %w.iszero, label %inner_latch, label %inner_check_s

inner_check_s:
  %s.v.ptr = getelementptr inbounds i32, i32* %s.base, i64 %v64
  %s.v = load i32, i32* %s.v.ptr, align 4
  %s.v.visited = icmp ne i32 %s.v, 0
  br i1 %s.v.visited, label %inner_latch, label %inner_check_du

inner_check_du:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %du.isinf = icmp eq i32 %dist.u, 2147483647
  br i1 %du.isinf, label %inner_latch, label %inner_relax_cmp

inner_relax_cmp:
  %alt = add nsw i32 %dist.u, %w
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %alt.lt.dv = icmp slt i32 %alt, %dist.v
  br i1 %alt.lt.dv, label %inner_store, label %inner_latch

inner_store:
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %inner_latch

inner_latch:
  %v.next = add nsw i32 %v, 1
  br label %inner_loop

outer_latch:
  %count.next = add nsw i32 %count, 1
  br label %outer_loop

ret:
  ret void
}