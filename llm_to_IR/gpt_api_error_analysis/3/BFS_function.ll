; ModuleID = 'bfs_module'
source_filename = "bfs_module"
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64) nounwind
declare void @free(i8* nocapture) nounwind

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %count) local_unnamed_addr nounwind {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_ret0, label %check_start

early_ret0:
  store i64 0, i64* %count, align 8
  ret void

check_start:
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %init_loop.preheader, label %early_ret0_2

early_ret0_2:
  store i64 0, i64* %count, align 8
  ret void

init_loop.preheader:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init_loop.preheader ], [ %i.next, %init_body ]
  %i_cond = icmp ult i64 %i, %n
  br i1 %i_cond, label %init_body, label %after_init

init_body:
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop

after_init:
  %size.bytes = shl i64 %n, 3
  %q.raw = call i8* @malloc(i64 %size.bytes)
  %q = bitcast i8* %q.raw to i64*
  %q.isnull = icmp eq i64* %q, null
  br i1 %q.isnull, label %malloc_fail, label %post_alloc

malloc_fail:
  store i64 0, i64* %count, align 8
  ret void

post_alloc:
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %q_tail0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %start, i64* %q_tail0, align 8
  store i64 0, i64* %count, align 8
  br label %bfs_loop

bfs_loop:
  %head = phi i64 [ 0, %post_alloc ], [ %head.next, %after_neighbors ]
  %tail = phi i64 [ 1, %post_alloc ], [ %tail.out, %after_neighbors ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %dequeue, label %done

dequeue:
  %u.ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %u.ptr, align 8
  %head.next0 = add i64 %head, 1
  %cnt.old = load i64, i64* %count, align 8
  %out.slot = getelementptr inbounds i64, i64* %out, i64 %cnt.old
  store i64 %u, i64* %out.slot, align 8
  %cnt.new = add i64 %cnt.old, 1
  store i64 %cnt.new, i64* %count, align 8
  br label %neighbors

neighbors:
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %neighbors_latch ]
  %tail.cur = phi i64 [ %tail, %dequeue ], [ %tail.next, %neighbors_latch ]
  %more_v = icmp ult i64 %v, %n
  br i1 %more_v, label %neighbors_body, label %after_neighbors

neighbors_body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj.zero = icmp eq i32 %adj.val, 0
  br i1 %adj.zero, label %skip_neighbor, label %check_unvis

check_unvis:
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %is_unvis = icmp eq i32 %dist.v, -1
  br i1 %is_unvis, label %visit_neighbor, label %skip_neighbor

visit_neighbor:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.plus1 = add nsw i32 %dist.u, 1
  store i32 %dist.u.plus1, i32* %dist.v.ptr, align 4
  %q.tail.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.cur
  store i64 %v, i64* %q.tail.ptr, align 8
  %tail.inc = add i64 %tail.cur, 1
  br label %neighbors_latch

skip_neighbor:
  br label %neighbors_latch

neighbors_latch:
  %tail.next = phi i64 [ %tail.inc, %visit_neighbor ], [ %tail.cur, %skip_neighbor ]
  %v.next = add i64 %v, 1
  br label %neighbors

after_neighbors:
  %head.next = phi i64 [ %head.next0, %neighbors ]
  %tail.out = phi i64 [ %tail.cur, %neighbors ]
  br label %bfs_loop

done:
  %q.bc = bitcast i64* %q to i8*
  call void @free(i8* %q.bc)
  ret void
}