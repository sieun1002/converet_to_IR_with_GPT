; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs  ; Address: 0x11C9
; Intent: Breadth-first search over an n x n adjacency matrix, computing distances and visit order (confidence=0.95). Evidence: queue via malloc/free, dist initialized to -1 and set to dist[u]+1 for neighbors.
; Preconditions: adj points to an i32[n*n] row-major matrix; dist points to i32[n]; out_nodes points to i64[n] capacity; 0 <= start < n.
; Postconditions: dist[start]=0, other reachable vertices have BFS distance, unreachable remain -1. out_nodes[0..out_count-1] holds nodes in dequeue (BFS) order; *out_count is number of visited nodes (0 on invalid input or alloc failure).

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out_nodes, i64* %out_count) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %early, label %init_loop.init

early:
  store i64 0, i64* %out_count, align 8
  ret void

init_loop.init:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init_loop.init ], [ %i.next, %init_body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init_body, label %post_init

init_body:
  %dist_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop

post_init:
  %size_bytes = mul i64 %n, 8
  %malloc_ptr = call i8* @malloc(i64 %size_bytes)
  %is_null = icmp eq i8* %malloc_ptr, null
  br i1 %is_null, label %malloc_fail, label %after_malloc

malloc_fail:
  store i64 0, i64* %out_count, align 8
  ret void

after_malloc:
  %queue = bitcast i8* %malloc_ptr to i64*
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %qslot0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %qslot0, align 8
  store i64 0, i64* %out_count, align 8
  br label %outer_cond

outer_cond:
  %head = phi i64 [ 0, %after_malloc ], [ %head.next, %outer_body_end ]
  %tail = phi i64 [ 1, %after_malloc ], [ %tail.out, %outer_body_end ]
  %cmp = icmp ult i64 %head, %tail
  br i1 %cmp, label %outer_body, label %done

outer_body:
  %qptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %qptr, align 8
  %head.next = add i64 %head, 1
  %curcnt = load i64, i64* %out_count, align 8
  %outslot = getelementptr inbounds i64, i64* %out_nodes, i64 %curcnt
  store i64 %u, i64* %outslot, align 8
  %newcnt = add i64 %curcnt, 1
  store i64 %newcnt, i64* %out_count, align 8
  br label %inner_loop

inner_loop:
  %v = phi i64 [ 0, %outer_body ], [ %v.next, %inner_loop_end ]
  %tail.phi = phi i64 [ %tail, %outer_body ], [ %tail.updated, %inner_loop_end ]
  %condv = icmp ult i64 %v, %n
  br i1 %condv, label %inner_body, label %inner_done

inner_body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adjptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge = load i32, i32* %adjptr, align 4
  %edge_zero = icmp eq i32 %edge, 0
  br i1 %edge_zero, label %inner_loop_end, label %check_unvisited

check_unvisited:
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_v, -1
  br i1 %is_unvisited, label %visit_v, label %inner_loop_end

visit_v:
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  %qpos_ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.phi
  store i64 %v, i64* %qpos_ptr, align 8
  %tail.next = add i64 %tail.phi, 1
  br label %inner_loop_end

inner_loop_end:
  %tail.updated = phi i64 [ %tail.phi, %inner_body ], [ %tail.phi, %check_unvisited ], [ %tail.next, %visit_v ]
  %v.next = add i64 %v, 1
  br label %inner_loop

inner_done:
  %tail.out = phi i64 [ %tail.phi, %inner_loop ]
  br label %outer_body_end

outer_body_end:
  br label %outer_cond

done:
  call void @free(i8* %malloc_ptr)
  ret void
}