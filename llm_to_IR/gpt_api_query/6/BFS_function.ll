; LLVM IR (LLVM 14) for function: bfs

declare i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %out_count) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early, label %checkstart

checkstart:
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %init, label %early

early:
  store i64 0, i64* %out_count, align 8
  ret void

init:
  br label %init.loop

init.loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %init.body ]
  %i.cmp = icmp ult i64 %i, %n
  br i1 %i.cmp, label %init.body, label %after_init

init.body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init.loop

after_init:
  %q_size = shl i64 %n, 3
  %q_raw = call i8* @malloc(i64 %q_size)
  %q = bitcast i8* %q_raw to i64*
  %q_null = icmp eq i64* %q, null
  br i1 %q_null, label %early, label %setup

setup:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %q0ptr = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %start, i64* %q0ptr, align 8
  store i64 0, i64* %out_count, align 8
  br label %loop.cond

loop.cond:
  %head = phi i64 [ 0, %setup ], [ %head.inc, %after_inner ]
  %tail = phi i64 [ 1, %setup ], [ %tail.curr, %after_inner ]
  %cmp_ht = icmp ult i64 %head, %tail
  br i1 %cmp_ht, label %loop.body, label %loop.end

loop.body:
  %q_head_ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %q_head_ptr, align 8
  %head.inc = add i64 %head, 1
  %cnt.old = load i64, i64* %out_count, align 8
  %cnt.new = add i64 %cnt.old, 1
  store i64 %cnt.new, i64* %out_count, align 8
  %out_pos_ptr = getelementptr inbounds i64, i64* %out, i64 %cnt.old
  store i64 %u, i64* %out_pos_ptr, align 8
  br label %inner.cond

inner.cond:
  %v = phi i64 [ 0, %loop.body ], [ %v.next, %inner.next ]
  %tail.curr = phi i64 [ %tail, %loop.body ], [ %tail.updated, %inner.next ]
  %cmp_v = icmp ult i64 %v, %n
  br i1 %cmp_v, label %inner.body, label %after_inner

inner.body:
  %un = mul i64 %u, %n
  %idx = add i64 %un, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %adj_nz = icmp ne i32 %adj_val, 0
  br i1 %adj_nz, label %check_unvisited, label %inner.next

check_unvisited:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_v, -1
  br i1 %is_unvisited, label %visit, label %inner.next

visit:
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_inc = add i32 %dist_u, 1
  store i32 %dist_u_inc, i32* %dist_v_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %q, i64 %tail.curr
  store i64 %v, i64* %q_tail_ptr, align 8
  %tail.next.in.visit = add i64 %tail.curr, 1
  br label %inner.next

inner.next:
  %tail.updated = phi i64 [ %tail.curr, %inner.body ], [ %tail.curr, %check_unvisited ], [ %tail.next.in.visit, %visit ]
  %v.next = add i64 %v, 1
  br label %inner.cond

after_inner:
  br label %loop.cond

loop.end:
  %q_free = bitcast i64* %q to i8*
  call void @free(i8* %q_free)
  ret void
}