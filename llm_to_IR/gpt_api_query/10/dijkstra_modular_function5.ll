; ModuleID = 'dijkstra.ll'

declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

define void @dijkstra(i32* nocapture %graph, i32 %n, i32 %src, i32* nocapture %dist) local_unnamed_addr {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  call i8* @memset(i8* %s.i8, i32 0, i64 400)

  br label %init_loop

init_loop:                                          ; i = 0..n-1
  %i = phi i32 [ 0, %entry ], [ %i.next, %init_body ]
  %init_cmp = icmp slt i32 %i, %n
  br i1 %init_cmp, label %init_body, label %after_init

init_body:
  %i64 = sext i32 %i to i64
  %dist.i = getelementptr inbounds i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %dist.i, align 4
  %i.next = add nsw i32 %i, 1
  br label %init_loop

after_init:
  %src64 = sext i32 %src to i64
  %dist.src = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist.src, align 4
  br label %outer

outer:                                               ; count = 0..n-2
  %count = phi i32 [ 0, %after_init ], [ %count.next, %after_outer_body ]
  %nminus1 = add nsw i32 %n, -1
  %outer_cmp = icmp slt i32 %count, %nminus1
  br i1 %outer_cmp, label %outer_body, label %end

outer_body:
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  %u_is_neg1 = icmp eq i32 %u, -1
  br i1 %u_is_neg1, label %end, label %set_u

set_u:
  %u64 = sext i32 %u to i64
  %s.u = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %u64
  store i32 1, i32* %s.u, align 4
  br label %inner

inner:                                               ; v = 0..n-1
  %v = phi i32 [ 0, %set_u ], [ %v.next, %inner_cont ]
  %inner_cmp = icmp slt i32 %v, %n
  br i1 %inner_cmp, label %inner_body, label %after_outer_body

inner_body:
  %u64.row = sext i32 %u to i64
  %rowOff = mul nsw i64 %u64.row, 100
  %v64 = sext i32 %v to i64
  %idx = add nsw i64 %rowOff, %v64
  %g.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %g.ptr, align 4
  %w_is_zero = icmp eq i32 %w, 0
  br i1 %w_is_zero, label %inner_cont, label %check_s

check_s:
  %s.v = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %v64
  %s.v.val = load i32, i32* %s.v, align 4
  %s.v_set = icmp ne i32 %s.v.val, 0
  br i1 %s.v_set, label %inner_cont, label %check_inf

check_inf:
  %dist.u = getelementptr inbounds i32, i32* %dist, i64 %u64.row
  %du = load i32, i32* %dist.u, align 4
  %du_is_inf = icmp eq i32 %du, 2147483647
  br i1 %du_is_inf, label %inner_cont, label %compute

compute:
  %sum = add nsw i32 %du, %w
  %dist.v = getelementptr inbounds i32, i32* %dist, i64 %v64
  %dv = load i32, i32* %dist.v, align 4
  %upd = icmp slt i32 %sum, %dv
  br i1 %upd, label %do_update, label %inner_cont

do_update:
  store i32 %sum, i32* %dist.v, align 4
  br label %inner_cont

inner_cont:
  %v.next = add nsw i32 %v, 1
  br label %inner

after_outer_body:
  %count.next = add nsw i32 %count, 1
  br label %outer

end:
  ret void
}