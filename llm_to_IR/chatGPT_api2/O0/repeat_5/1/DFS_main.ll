; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs  ; Address: 0x11C9
; Intent: Iterative DFS on an n x n i32 adjacency matrix, recording visit order (confidence=0.95). Evidence: current*n + next indexing into i32 matrix; visited array and explicit stack with per-node next-edge index.
; Preconditions: graph points to an n*n matrix of i32 (0 = no edge, nonzero = edge); out has capacity >= n; 0 <= start < n; out_len is a valid i64*.

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* %graph, i64 %n, i64 %start, i64* %out, i64* %out_len) local_unnamed_addr {
entry:
  %cmp_n0 = icmp eq i64 %n, 0
  %cmp_start = icmp uge i64 %start, %n
  %bad = or i1 %cmp_n0, %cmp_start
  br i1 %bad, label %early_zero, label %alloc

early_zero:
  store i64 0, i64* %out_len, align 8
  ret void

alloc:
  %size4 = mul i64 %n, 4
  %p1 = call noalias i8* @malloc(i64 %size4)
  %visited = bitcast i8* %p1 to i32*
  %size8 = shl i64 %n, 3
  %p2 = call noalias i8* @malloc(i64 %size8)
  %nextIdx = bitcast i8* %p2 to i64*
  %p3 = call noalias i8* @malloc(i64 %size8)
  %stack = bitcast i8* %p3 to i64*
  %c1 = icmp ne i8* %p1, null
  %c2 = icmp ne i8* %p2, null
  %c3 = icmp ne i8* %p3, null
  %ok12 = and i1 %c1, %c2
  %ok = and i1 %ok12, %c3
  br i1 %ok, label %init, label %alloc_fail

alloc_fail:
  call void @free(i8* %p1)
  call void @free(i8* %p2)
  call void @free(i8* %p3)
  store i64 0, i64* %out_len, align 8
  ret void

init:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %init_loop_body_end ]
  %i.cmp = icmp ult i64 %i, %n
  br i1 %i.cmp, label %init_loop_body, label %post_init

init_loop_body:
  %vptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vptr, align 4
  %nptr = getelementptr inbounds i64, i64* %nextIdx, i64 %i
  store i64 0, i64* %nptr, align 8
  br label %init_loop_body_end

init_loop_body_end:
  %i.next = add i64 %i, 1
  br label %init_loop

post_init:
  store i64 0, i64* %out_len, align 8
  %stack_idx0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_idx0, align 8
  %vstart.ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vstart.ptr, align 4
  %len0 = load i64, i64* %out_len, align 8
  %optr = getelementptr inbounds i64, i64* %out, i64 %len0
  store i64 %start, i64* %optr, align 8
  %len1 = add i64 %len0, 1
  store i64 %len1, i64* %out_len, align 8
  br label %outer_loop

outer_loop:
  %ss = phi i64 [ 1, %post_init ], [ %ss.next, %outer_continue ]
  %nonzero = icmp ne i64 %ss, 0
  br i1 %nonzero, label %body, label %done

body:
  %ssm1 = add i64 %ss, -1
  %currptr = getelementptr inbounds i64, i64* %stack, i64 %ssm1
  %current = load i64, i64* %currptr, align 8
  %nidxptr = getelementptr inbounds i64, i64* %nextIdx, i64 %current
  %j0 = load i64, i64* %nidxptr, align 8
  br label %inner_loop

inner_loop:
  %j = phi i64 [ %j0, %body ], [ %j.next, %inner_loop_cont ]
  %jlt = icmp ult i64 %j, %n
  br i1 %jlt, label %check_edge, label %inner_done

check_edge:
  %cmul = mul i64 %current, %n
  %idx = add i64 %cmul, %j
  %gptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %gval = load i32, i32* %gptr, align 4
  %hasEdge = icmp ne i32 %gval, 0
  br i1 %hasEdge, label %check_visited, label %inner_loop_cont

check_visited:
  %vjptr = getelementptr inbounds i32, i32* %visited, i64 %j
  %vval = load i32, i32* %vjptr, align 4
  %isUnvisited = icmp eq i32 %vval, 0
  br i1 %isUnvisited, label %take_edge, label %inner_loop_cont

inner_loop_cont:
  %j.next = add i64 %j, 1
  br label %inner_loop

take_edge:
  %jplus1 = add i64 %j, 1
  store i64 %jplus1, i64* %nidxptr, align 8
  store i32 1, i32* %vjptr, align 4
  %olen = load i64, i64* %out_len, align 8
  %op = getelementptr inbounds i64, i64* %out, i64 %olen
  store i64 %j, i64* %op, align 8
  %olen1 = add i64 %olen, 1
  store i64 %olen1, i64* %out_len, align 8
  %stack_push_ptr = getelementptr inbounds i64, i64* %stack, i64 %ss
  store i64 %j, i64* %stack_push_ptr, align 8
  %ss_push = add i64 %ss, 1
  br label %outer_continue

inner_done:
  %ss_pop = add i64 %ss, -1
  br label %outer_continue

outer_continue:
  %ss.next = phi i64 [ %ss_push, %take_edge ], [ %ss_pop, %inner_done ]
  br label %outer_loop

done:
  call void @free(i8* %p1)
  call void @free(i8* %p2)
  call void @free(i8* %p3)
  ret void
}