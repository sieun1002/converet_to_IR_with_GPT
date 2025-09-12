; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs  ; Address: 0x11C9
; Intent: Breadth-first search on adjacency matrix: compute distances and visitation order (confidence=0.95). Evidence: queue via malloc/free, dist init to -1 and updates dist[v]=dist[u]+1.
; Preconditions: adj is an n*n i32 matrix (row-major, nonzero = edge); dist has at least n elements; out has capacity >= n; out_count is non-null.
; Postconditions: dist holds BFS levels from start (or remains -1 if unreachable); out[0..*out_count-1] holds nodes in dequeue order; *out_count == number of dequeued nodes.

; Only the needed extern declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  %cmp_n0 = icmp eq i64 %n, 0
  br i1 %cmp_n0, label %early, label %check_start

check_start:
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %init, label %early

early:
  store i64 0, i64* %out_count, align 8
  ret void

init:
  br label %fill_loop

fill_loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %fill_body ]
  %fill_cond = icmp ult i64 %i, %n
  br i1 %fill_cond, label %fill_body, label %post_fill

fill_body:
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.i.ptr, align 4
  %i.next = add nuw i64 %i, 1
  br label %fill_loop

post_fill:
  %size = shl i64 %n, 3
  %raw = call noalias i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %raw, null
  br i1 %isnull, label %early2, label %after_malloc

early2:
  store i64 0, i64* %out_count, align 8
  ret void

after_malloc:
  %queue = bitcast i8* %raw to i64*
  %dist.start.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.ptr, align 4
  %q0 = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0, align 8
  store i64 0, i64* %out_count, align 8
  br label %outer_loop

outer_loop:
  %head = phi i64 [ 0, %after_malloc ], [ %head.next, %after_inner ]
  %tail = phi i64 [ 1, %after_malloc ], [ %tail.after, %after_inner ]
  %outer_cond = icmp ult i64 %head, %tail
  br i1 %outer_cond, label %pop, label %done

pop:
  %u.ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %u.ptr, align 8
  %head.next = add nuw i64 %head, 1
  %t = load i64, i64* %out_count, align 8
  %t.new = add i64 %t, 1
  store i64 %t.new, i64* %out_count, align 8
  %out.t.ptr = getelementptr inbounds i64, i64* %out, i64 %t
  store i64 %u, i64* %out.t.ptr, align 8
  br label %inner_loop

inner_loop:
  %v = phi i64 [ 0, %pop ], [ %v.next, %inner_inc_t ]
  %tail.cur = phi i64 [ %tail, %pop ], [ %tail.next, %inner_inc_t ]
  %v.cond = icmp ult i64 %v, %n
  br i1 %v.cond, label %inner_body, label %after_inner

inner_body:
  %u.times.n = mul i64 %u, %n
  %idx = add i64 %u.times.n, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj.zero = icmp eq i32 %adj.val, 0
  br i1 %adj.zero, label %inner_inc, label %check_visited

inner_inc:
  br label %inner_inc_t

check_visited:
  %d.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %d.v = load i32, i32* %d.v.ptr, align 4
  %unseen = icmp eq i32 %d.v, -1
  br i1 %unseen, label %visit, label %inner_inc

visit:
  %d.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %d.u = load i32, i32* %d.u.ptr, align 4
  %d.u.plus1 = add i32 %d.u, 1
  store i32 %d.u.plus1, i32* %d.v.ptr, align 4
  %q.tail.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.cur
  store i64 %v, i64* %q.tail.ptr, align 8
  %tail.updated = add i64 %tail.cur, 1
  br label %inner_inc_t

inner_inc_t:
  %tail.next = phi i64 [ %tail.cur, %inner_inc ], [ %tail.updated, %visit ]
  %v.next = add nuw i64 %v, 1
  br label %inner_loop

after_inner:
  %tail.after = phi i64 [ %tail.cur, %inner_loop ]
  br label %outer_loop

done:
  %raw2 = bitcast i64* %queue to i8*
  call void @free(i8* %raw2)
  ret void
}