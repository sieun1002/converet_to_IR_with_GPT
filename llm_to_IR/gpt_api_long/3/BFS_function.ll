; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs  ; Address: 0x11C9
; Intent: Breadth-first search from a source over an NxN int32 adjacency matrix; compute distances and visitation order (confidence=0.95). Evidence: dist init to -1 and BFS queue; adj[u*N+v] != 0 then dist[v]=dist[u]+1 and enqueue
; Preconditions: adj points to at least n*n i32s; dist points to at least n i32s; out_order points to at least n i64s; out_count is non-null; 0 <= src < n for traversal (else out_count set to 0 and return)
; Postconditions: If traversal occurs: dist[src]=0; for reachable v: dist[v] is shortest path length; out_order[0..*out_count-1] records dequeued nodes in BFS order

; Only the needed extern declarations:
declare i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %adj, i64 %n, i64 %src, i32* %dist, i64* %out_order, i64* %out_count) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %src_ge_n = icmp uge i64 %src, %n
  %early = or i1 %n_is_zero, %src_ge_n
  br i1 %early, label %early_zero, label %init

early_zero:
  store i64 0, i64* %out_count, align 8
  ret void

init:
  br label %init_cond

init_cond:                                            ; loop: for (i=0; i<n; ++i) dist[i]=-1
  %i = phi i64 [ 0, %init ], [ %i.next, %init_body ]
  %init_cmp = icmp ult i64 %i, %n
  br i1 %init_cmp, label %init_body, label %post_init

init_body:
  %dist.i.ptr = getelementptr i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.i.ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_cond

post_init:
  %size_bytes = shl i64 %n, 3
  %qraw = call i8* @malloc(i64 %size_bytes)
  %qnull = icmp eq i8* %qraw, null
  br i1 %qnull, label %early_zero, label %setup

setup:
  %queue = bitcast i8* %qraw to i64*
  %dist.src.ptr = getelementptr i32, i32* %dist, i64 %src
  store i32 0, i32* %dist.src.ptr, align 4
  ; enqueue src at tail=0
  %qpos0 = getelementptr i64, i64* %queue, i64 0
  store i64 %src, i64* %qpos0, align 8
  store i64 0, i64* %out_count, align 8
  br label %outer_cond

outer_cond:
  %head.phi = phi i64 [ 0, %setup ], [ %head.next, %after_inner ]
  %tail.phi = phi i64 [ 1, %setup ], [ %tail.after, %after_inner ]
  %cmp_ht = icmp ult i64 %head.phi, %tail.phi
  br i1 %cmp_ht, label %outer_body, label %done

outer_body:
  %qpop.ptr = getelementptr i64, i64* %queue, i64 %head.phi
  %u = load i64, i64* %qpop.ptr, align 8
  %head.next = add i64 %head.phi, 1
  %cnt.old = load i64, i64* %out_count, align 8
  %cnt.new = add i64 %cnt.old, 1
  store i64 %cnt.new, i64* %out_count, align 8
  %outpos = getelementptr i64, i64* %out_order, i64 %cnt.old
  store i64 %u, i64* %outpos, align 8
  br label %inner_cond

inner_cond:
  %v = phi i64 [ 0, %outer_body ], [ %v.next, %inner_inc ]
  %tail.inner = phi i64 [ %tail.phi, %outer_body ], [ %tail.new, %inner_inc ]
  %v_cmp = icmp ult i64 %v, %n
  br i1 %v_cmp, label %inner_check, label %after_inner

inner_check:
  %un = mul i64 %u, %n
  %idx = add i64 %un, %v
  %adj.ptr = getelementptr i32, i32* %adj, i64 %idx
  %edge = load i32, i32* %adj.ptr, align 4
  %edge_is_zero = icmp eq i32 %edge, 0
  br i1 %edge_is_zero, label %inner_inc, label %check_dist

check_dist:
  %dist.v.ptr = getelementptr i32, i32* %dist, i64 %v
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %is_unseen = icmp eq i32 %dist.v, -1
  br i1 %is_unseen, label %visit, label %inner_inc

visit:
  %dist.u.ptr = getelementptr i32, i32* %dist, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.plus1 = add i32 %dist.u, 1
  store i32 %dist.u.plus1, i32* %dist.v.ptr, align 4
  %qtail.ptr = getelementptr i64, i64* %queue, i64 %tail.inner
  store i64 %v, i64* %qtail.ptr, align 8
  %tail.updated = add i64 %tail.inner, 1
  br label %inner_inc

inner_inc:
  %tail.new = phi i64 [ %tail.inner, %inner_check ], [ %tail.inner, %check_dist ], [ %tail.updated, %visit ]
  %v.next = add i64 %v, 1
  br label %inner_cond

after_inner:
  %tail.after = phi i64 [ %tail.inner, %inner_cond ]
  br label %outer_cond

done:
  call void @free(i8* %qraw)
  ret void
}