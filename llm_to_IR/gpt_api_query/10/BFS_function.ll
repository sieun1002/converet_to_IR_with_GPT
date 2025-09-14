; ModuleID = 'bfs.ll'
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %count_ptr) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_lt_n = icmp ult i64 %start, %n
  %start_ge_n = xor i1 %start_lt_n, true
  %early_ret = or i1 %n_is_zero, %start_ge_n
  br i1 %early_ret, label %ret_zero, label %init.cond

ret_zero:
  store i64 0, i64* %count_ptr
  ret void

init.cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %init.body ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init.body, label %after_init

init.body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr
  %i.next = add i64 %i, 1
  br label %init.cond

after_init:
  %size = mul i64 %n, 8
  %mem = call noalias i8* @malloc(i64 %size)
  %queue = bitcast i8* %mem to i64*
  %isnull = icmp eq i64* %queue, null
  br i1 %isnull, label %malloc_fail, label %after_malloc

malloc_fail:
  store i64 0, i64* %count_ptr
  ret void

after_malloc:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr
  %slot0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %slot0
  store i64 0, i64* %count_ptr
  br label %outer.cond

outer.cond:
  %head = phi i64 [ 0, %after_malloc ], [ %head.next, %outer.latch ]
  %tail = phi i64 [ 1, %after_malloc ], [ %tail.next, %outer.latch ]
  %has_elem = icmp ult i64 %head, %tail
  br i1 %has_elem, label %outer.body, label %outer.end

outer.body:
  %u_ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %u_ptr
  %head.next = add i64 %head, 1
  %oldc = load i64, i64* %count_ptr
  %newc = add i64 %oldc, 1
  store i64 %newc, i64* %count_ptr
  %order_slot = getelementptr inbounds i64, i64* %order, i64 %oldc
  store i64 %u, i64* %order_slot
  br label %inner.cond

inner.cond:
  %tail.cur = phi i64 [ %tail, %outer.body ], [ %tail.next.inner, %inner.inc ]
  %v = phi i64 [ 0, %outer.body ], [ %v.next, %inner.inc ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner.body, label %outer.latch

inner.body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr
  %adj_is_zero = icmp eq i32 %adj_val, 0
  br i1 %adj_is_zero, label %inner.inc, label %maybe.visit

maybe.visit:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr
  %is_neg1 = icmp eq i32 %dist_v, -1
  br i1 %is_neg1, label %visit, label %inner.inc

visit:
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr
  %dist_u_plus1 = add i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr
  %q_slot = getelementptr inbounds i64, i64* %queue, i64 %tail.cur
  store i64 %v, i64* %q_slot
  %tail.enq = add i64 %tail.cur, 1
  br label %inner.inc

inner.inc:
  %tail.next.inner = phi i64 [ %tail.cur, %inner.body ], [ %tail.cur, %maybe.visit ], [ %tail.enq, %visit ]
  %v.next = add i64 %v, 1
  br label %inner.cond

outer.latch:
  %tail.next = phi i64 [ %tail.cur, %inner.cond ]
  br label %outer.cond

outer.end:
  %queue_i8 = bitcast i64* %queue to i8*
  call void @free(i8* %queue_i8)
  ret void
}