; ModuleID = 'bfs_module'
target triple = "x86_64-pc-linux-gnu"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* readonly %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %outCount) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %ret_zero, label %init_dist

ret_zero:
  store i64 0, i64* %outCount, align 8
  ret void

init_dist:
  br label %dist_loop

dist_loop:
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %dist_loop_body_end ]
  %loop_cond = icmp ult i64 %i, %n
  br i1 %loop_cond, label %dist_loop_body, label %post_init_dist

dist_loop_body:
  %dist.ptr.i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.ptr.i, align 4
  br label %dist_loop_body_end

dist_loop_body_end:
  %i.next = add i64 %i, 1
  br label %dist_loop

post_init_dist:
  %size = shl i64 %n, 3
  %qmem = call i8* @malloc(i64 %size)
  %queue = bitcast i8* %qmem to i64*
  %qnull = icmp eq i8* %qmem, null
  br i1 %qnull, label %ret_zero2, label %setup

ret_zero2:
  store i64 0, i64* %outCount, align 8
  ret void

setup:
  %start.dist.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %start.dist.ptr, align 4
  %q0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0, align 8
  store i64 0, i64* %outCount, align 8
  br label %bfs_outer

bfs_outer:
  %front = phi i64 [ 0, %setup ], [ %front.next, %bfs_outer_continue ]
  %back = phi i64 [ 1, %setup ], [ %back.next, %bfs_outer_continue ]
  %has = icmp ult i64 %front, %back
  br i1 %has, label %dequeue, label %done

dequeue:
  %q.front.ptr = getelementptr inbounds i64, i64* %queue, i64 %front
  %v = load i64, i64* %q.front.ptr, align 8
  %front.inc = add i64 %front, 1
  %count.old = load i64, i64* %outCount, align 8
  %count.new = add i64 %count.old, 1
  store i64 %count.new, i64* %outCount, align 8
  %out.ptr = getelementptr inbounds i64, i64* %out, i64 %count.old
  store i64 %v, i64* %out.ptr, align 8
  br label %nbr_loop

nbr_loop:
  %j = phi i64 [ 0, %dequeue ], [ %j.next, %nbr_iter_end ]
  %back.cur = phi i64 [ %back, %dequeue ], [ %back.next.iter, %nbr_iter_end ]
  %j.cond = icmp ult i64 %j, %n
  br i1 %j.cond, label %nbr_check_edge, label %neighbors_done

nbr_check_edge:
  %row.mul = mul i64 %v, %n
  %idx.adj = add i64 %row.mul, %j
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx.adj
  %adj.val = load i32, i32* %adj.ptr, align 4
  %is_edge = icmp ne i32 %adj.val, 0
  br i1 %is_edge, label %maybe_visit, label %no_enq

maybe_visit:
  %dist.j.ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dist.j.val = load i32, i32* %dist.j.ptr, align 4
  %unvisited = icmp eq i32 %dist.j.val, -1
  br i1 %unvisited, label %visit, label %no_enq

visit:
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist.v.val = load i32, i32* %dist.v.ptr, align 4
  %dist.v.plus1 = add i32 %dist.v.val, 1
  store i32 %dist.v.plus1, i32* %dist.j.ptr, align 4
  %q.enq.ptr = getelementptr inbounds i64, i64* %queue, i64 %back.cur
  store i64 %j, i64* %q.enq.ptr, align 8
  %back.inc = add i64 %back.cur, 1
  br label %enq_or_not

no_enq:
  br label %enq_or_not

enq_or_not:
  %back.next.iter = phi i64 [ %back.cur, %no_enq ], [ %back.inc, %visit ]
  %j.next = add i64 %j, 1
  br label %nbr_iter_end

nbr_iter_end:
  br label %nbr_loop

neighbors_done:
  br label %after_neighbors

after_neighbors:
  %back.after = phi i64 [ %back.cur, %neighbors_done ]
  br label %bfs_outer_continue

bfs_outer_continue:
  %front.next = phi i64 [ %front.inc, %after_neighbors ]
  %back.next = phi i64 [ %back.after, %after_neighbors ]
  br label %bfs_outer

done:
  %qmem.free = bitcast i64* %queue to i8*
  call void @free(i8* %qmem.free)
  ret void
}