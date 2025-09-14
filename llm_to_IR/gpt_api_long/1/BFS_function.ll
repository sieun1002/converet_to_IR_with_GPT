; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs  ; Address: 0x11C9
; Intent: Breadth-first search on an adjacency matrix; computes distances and visit order (confidence=0.92). Evidence: dist[] init to -1 and updates to dist[u]+1; queue via malloc/free with head/tail.
; Preconditions: adj is an n-by-n matrix of i32 in row-major; dist has at least n elements; order has capacity >= n; out_count is non-null; if n==0 or start>=n, out_count is set to 0 and the function returns.
; Postconditions: out_count is the number of visited nodes from start; order[0..out_count-1] is the visitation order; dist[v] is BFS level from start or -1 if unreachable.

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %order, i64* %out_count) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad = or i1 %n_is_zero, %start_ge_n
  br i1 %bad, label %early_ret, label %init_for.cond

early_ret:
  store i64 0, i64* %out_count, align 8
  ret void

init_for.cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %init_for.body ]
  %i_cmp = icmp ult i64 %i, %n
  br i1 %i_cmp, label %init_for.body, label %after_init

init_for.body:
  %dist_i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i, align 4
  %i.next = add i64 %i, 1
  br label %init_for.cond

after_init:
  %size = shl i64 %n, 3
  %mp = call i8* @malloc(i64 %size)
  %q = bitcast i8* %mp to i64*
  %q_isnull = icmp eq i64* %q, null
  br i1 %q_isnull, label %early_ret, label %setup

setup:
  %dist_start = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start, align 4
  %q0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %start, i64* %q0, align 8
  store i64 0, i64* %out_count, align 8
  br label %bfs_while.cond

bfs_while.cond:
  %head = phi i64 [ 0, %setup ], [ %head.next, %inner_after ]
  %tail = phi i64 [ 1, %setup ], [ %tail.after, %inner_after ]
  %not_empty = icmp ult i64 %head, %tail
  br i1 %not_empty, label %bfs_body, label %bfs_done

bfs_body:
  %u_ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %u_ptr, align 8
  %head.next = add i64 %head, 1
  %cnt_old = load i64, i64* %out_count, align 8
  %cnt_new = add i64 %cnt_old, 1
  store i64 %cnt_new, i64* %out_count, align 8
  %ord_slot = getelementptr inbounds i64, i64* %order, i64 %cnt_old
  store i64 %u, i64* %ord_slot, align 8
  br label %inner_for.cond

inner_for.cond:
  %v = phi i64 [ 0, %bfs_body ], [ %v.next, %inner_for.inc ]
  %tail.cur = phi i64 [ %tail, %bfs_body ], [ %tail.next, %inner_for.inc ]
  %v_cmp = icmp ult i64 %v, %n
  br i1 %v_cmp, label %inner_for.body, label %inner_after

inner_for.body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %a = load i32, i32* %adj_ptr, align 4
  %a_is_zero = icmp eq i32 %a, 0
  br i1 %a_is_zero, label %inner_for.inc, label %check_dist

check_dist:
  %dv_ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dv = load i32, i32* %dv_ptr, align 4
  %is_unseen = icmp eq i32 %dv, -1
  br i1 %is_unseen, label %relax, label %inner_for.inc

relax:
  %du_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %du = load i32, i32* %du_ptr, align 4
  %du1 = add i32 %du, 1
  store i32 %du1, i32* %dv_ptr, align 4
  %q_tail_ptr = getelementptr inbounds i64, i64* %q, i64 %tail.cur
  store i64 %v, i64* %q_tail_ptr, align 8
  %tail.inc = add i64 %tail.cur, 1
  br label %inner_for.inc

inner_for.inc:
  %tail.next = phi i64 [ %tail.cur, %inner_for.body ], [ %tail.cur, %check_dist ], [ %tail.inc, %relax ]
  %v.next = add i64 %v, 1
  br label %inner_for.cond

inner_after:
  %tail.after = phi i64 [ %tail.cur, %inner_for.cond ]
  br label %bfs_while.cond

bfs_done:
  %q_i8 = bitcast i64* %q to i8*
  call void @free(i8* %q_i8)
  ret void
}