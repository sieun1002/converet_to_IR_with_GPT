; ModuleID = 'bfs.ll'
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %count) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

check_start:
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %init_dist_loop, label %early_zero

early_zero:
  store i64 0, i64* %count, align 8
  ret void

init_dist_loop:
  br label %loop_init

loop_init:
  %i = phi i64 [ 0, %init_dist_loop ], [ %i.next, %loop_body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %loop_body, label %after_init

loop_body:
  %gep = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %gep, align 4
  %i.next = add i64 %i, 1
  br label %loop_init

after_init:
  %size = shl i64 %n, 3
  %mem = call i8* @malloc(i64 %size)
  %q = bitcast i8* %mem to i64*
  %isnull = icmp eq i64* %q, null
  br i1 %isnull, label %early_zero, label %init_bfs

init_bfs:
  %start_idx_gep = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %start_idx_gep, align 4
  %head0 = add i64 0, 0
  %tail0 = add i64 0, 0
  %pos0 = add i64 %tail0, 0
  %tail1 = add i64 %tail0, 1
  %qposptr = getelementptr inbounds i64, i64* %q, i64 %pos0
  store i64 %start, i64* %qposptr, align 8
  store i64 0, i64* %count, align 8
  br label %bfs_loop

bfs_loop:
  %head = phi i64 [ %head0, %init_bfs ], [ %head.next, %after_neighbors ]
  %tail = phi i64 [ %tail1, %init_bfs ], [ %tail2, %after_neighbors ]
  %cond2 = icmp ult i64 %head, %tail
  br i1 %cond2, label %dequeue, label %done

dequeue:
  %qhepptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %qhepptr, align 8
  %head.next = add i64 %head, 1
  %oldcnt = load i64, i64* %count, align 8
  %newcnt = add i64 %oldcnt, 1
  store i64 %newcnt, i64* %count, align 8
  %outptr = getelementptr inbounds i64, i64* %out, i64 %oldcnt
  store i64 %u, i64* %outptr, align 8
  br label %for_cond

for_cond:
  %v.phi = phi i64 [ 0, %dequeue ], [ %v.next, %for_v_inc ]
  %tail.phi = phi i64 [ %tail, %dequeue ], [ %tail.phi.next, %for_v_inc ]
  %lt = icmp ult i64 %v.phi, %n
  br i1 %lt, label %body_edge, label %after_neighbors

body_edge:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v.phi
  %adjptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edgeval = load i32, i32* %adjptr, align 4
  %edge_nonzero = icmp ne i32 %edgeval, 0
  br i1 %edge_nonzero, label %check_unvisited, label %skip

check_unvisited:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v.phi
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_v, -1
  br i1 %is_unvisited, label %visit, label %skip

visit:
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add nsw i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  %pos1 = add i64 %tail.phi, 0
  %tail.enq = add i64 %tail.phi, 1
  %qposptr2 = getelementptr inbounds i64, i64* %q, i64 %pos1
  store i64 %v.phi, i64* %qposptr2, align 8
  br label %for_v_inc

skip:
  br label %for_v_inc

for_v_inc:
  %tail.phi.next = phi i64 [ %tail.phi, %skip ], [ %tail.enq, %visit ]
  %v.next = add i64 %v.phi, 1
  br label %for_cond

after_neighbors:
  %tail2 = phi i64 [ %tail.phi, %for_cond ]
  br label %bfs_loop

done:
  %qcast = bitcast i64* %q to i8*
  call void @free(i8* %qcast)
  ret void
}