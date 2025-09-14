; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs ; Address: 0x11C9
; Intent: Breadth-first search over an n x n int adjacency matrix; fills distances and visitation order, returns via out params (confidence=0.96). Evidence: Initializes dist to -1; uses queue with head/tail; sets dist[v]=dist[u]+1 upon discovery and records dequeue order into output array with count.
; Preconditions: n > 0 and start < n; adj is n*n ints; dist has n ints; out has capacity >= n.
; Postconditions: dist[v] == -1 for unreachable; otherwise hop-count from start. out[0..*out_count-1] holds nodes in BFS dequeue order; *out_count == number of visited nodes.

; Only the necessary external declarations:
declare i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  %bad1 = icmp eq i64 %n, 0
  %start_lt_n = icmp ult i64 %start, %n
  %not_start_lt_n = xor i1 %start_lt_n, true
  %bad = or i1 %bad1, %not_start_lt_n
  br i1 %bad, label %early_ret, label %init_dist

early_ret:                                        ; preds = %entry, %malloc_fail
  store i64 0, i64* %out_count, align 8
  ret void

init_dist:                                        ; preds = %entry
  br label %dist_loop

dist_loop:                                        ; preds = %dist_loop, %init_dist
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %dist_loop ]
  %done = icmp uge i64 %i, %n
  br i1 %done, label %after_init, label %dist_body

dist_body:                                        ; preds = %dist_loop
  %dist.ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.ptr, align 4
  %i.next = add i64 %i, 1
  br label %dist_loop

after_init:                                       ; preds = %dist_loop
  %size = shl i64 %n, 3
  %q.raw = call i8* @malloc(i64 %size)
  %q = bitcast i8* %q.raw to i64*
  %q.null = icmp eq i64* %q, null
  br i1 %q.null, label %malloc_fail, label %bfs_setup

malloc_fail:                                      ; preds = %after_init
  br label %early_ret

bfs_setup:                                        ; preds = %after_init
  %dist.start.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.ptr, align 4
  ; enqueue start
  store i64 %start, i64* %q, align 8
  store i64 0, i64* %out_count, align 8
  br label %bfs_loop

bfs_loop:                                         ; preds = %v_exit, %bfs_setup
  %head = phi i64 [ 0, %bfs_setup ], [ %head.next, %v_exit ]
  %tail = phi i64 [ 1, %bfs_setup ], [ %tail.out, %v_exit ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %bfs_pop, label %bfs_done

bfs_pop:                                          ; preds = %bfs_loop
  %u.ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %u.ptr, align 8
  %head.next = add i64 %head, 1
  ; record dequeue order
  %out_idx = load i64, i64* %out_count, align 8
  %out_idx.next = add i64 %out_idx, 1
  store i64 %out_idx.next, i64* %out_count, align 8
  %out.slot = getelementptr inbounds i64, i64* %out, i64 %out_idx
  store i64 %u, i64* %out.slot, align 8
  br label %v_loop

v_loop:                                           ; preds = %v_body, %bfs_pop
  %v = phi i64 [ 0, %bfs_pop ], [ %v.next, %v_body ]
  %tail.cur = phi i64 [ %tail, %bfs_pop ], [ %tail.next.sel, %v_body ]
  %v.done = icmp uge i64 %v, %n
  br i1 %v.done, label %v_exit, label %v_body

v_body:                                           ; preds = %v_loop
  ; if adj[u*n+v] != 0 and dist[v] == -1
  %u_mul_n = mul i64 %u, %n
  %idx = add i64 %u_mul_n, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge = load i32, i32* %adj.ptr, align 4
  %has_edge = icmp ne i32 %edge, 0
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %unseen = icmp eq i32 %dist.v, -1
  %discover = and i1 %has_edge, %unseen
  br i1 %discover, label %discover_then, label %discover_else

discover_then:                                    ; preds = %v_body
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.v.new = add nsw i32 %dist.u, 1
  store i32 %dist.v.new, i32* %dist.v.ptr, align 4
  %q.tail.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.cur
  store i64 %v, i64* %q.tail.ptr, align 8
  %tail.inc = add i64 %tail.cur, 1
  br label %discover_merge

discover_else:                                    ; preds = %v_body
  br label %discover_merge

discover_merge:                                   ; preds = %discover_else, %discover_then
  %tail.next.sel = phi i64 [ %tail.inc, %discover_then ], [ %tail.cur, %discover_else ]
  %v.next = add i64 %v, 1
  br label %v_loop

v_exit:                                           ; preds = %v_loop
  %tail.out = phi i64 [ %tail.cur, %v_loop ]
  br label %bfs_loop

bfs_done:                                         ; preds = %bfs_loop
  %q.free = bitcast i64* %q to i8*
  call void @free(i8* %q.free)
  ret void
}