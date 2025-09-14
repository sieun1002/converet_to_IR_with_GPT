; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs  ; Address: 0x11C9
; Intent: Iterative depth-first search from a start node, recording visit order (confidence=0.95). Evidence: row-major adjacency matrix indexing (cur*n+idx) and visited flags with explicit stack.
; Preconditions: adj is an n×n row-major i32 matrix; 0 <= start < n; order has capacity >= n; count is a valid i64*.
; Postconditions: *count = number of visited nodes from start; order[0..*count-1] contains nodes in DFS visitation order.

; Only the needed extern declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %order, i64* %count) local_unnamed_addr {
entry:
  %cmp_n0 = icmp eq i64 %n, 0
  br i1 %cmp_n0, label %zero_ret, label %check_start

check_start:
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %allocs, label %zero_ret

zero_ret:
  store i64 0, i64* %count, align 8
  ret void

allocs:
  %size_visit = shl i64 %n, 2
  %vraw = call i8* @malloc(i64 %size_visit)
  %visited = bitcast i8* %vraw to i32*
  %size_idx = shl i64 %n, 3
  %nraw = call i8* @malloc(i64 %size_idx)
  %next = bitcast i8* %nraw to i64*
  %sraw = call i8* @malloc(i64 %size_idx)
  %stack = bitcast i8* %sraw to i64*
  %vnull = icmp eq i8* %vraw, null
  %nnull = icmp eq i8* %nraw, null
  %snull = icmp eq i8* %sraw, null
  %tmp.or = or i1 %vnull, %nnull
  %anynull = or i1 %tmp.or, %snull
  br i1 %anynull, label %malloc_fail, label %init_loop

malloc_fail:
  call void @free(i8* %vraw)
  call void @free(i8* %nraw)
  call void @free(i8* %sraw)
  store i64 0, i64* %count, align 8
  ret void

init_loop:
  br label %init_phi

init_phi:
  %i = phi i64 [ 0, %init_loop ], [ %i.next, %init_body ]
  %i_cmp = icmp ult i64 %i, %n
  br i1 %i_cmp, label %init_body, label %after_init

init_body:
  %vptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vptr, align 4
  %nptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %nptr, align 8
  %i.next = add i64 %i, 1
  br label %init_phi

after_init:
  store i64 0, i64* %count, align 8
  ; visited[start] = 1
  %vsptr.start = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vsptr.start, align 4
  ; push start onto stack at index 0
  %sptr0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %sptr0, align 8
  ; record in order
  %oldcnt0 = load i64, i64* %count, align 8
  %newcnt0 = add i64 %oldcnt0, 1
  store i64 %newcnt0, i64* %count, align 8
  %optr0 = getelementptr inbounds i64, i64* %order, i64 %oldcnt0
  store i64 %start, i64* %optr0, align 8
  br label %loop_main

loop_main:
  %ssz = phi i64 [ 1, %after_init ], [ %ssz_pop, %after_neighbors ], [ %ssz_push, %explore ]
  %nonzero = icmp ne i64 %ssz, 0
  br i1 %nonzero, label %process_top, label %cleanup

process_top:
  %top_index = add i64 %ssz, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_index
  %cur = load i64, i64* %top_ptr, align 8
  %idx_ptr = getelementptr inbounds i64, i64* %next, i64 %cur
  %idx0 = load i64, i64* %idx_ptr, align 8
  br label %neighbors_loop

neighbors_loop:
  %idx = phi i64 [ %idx0, %process_top ], [ %idx_next1, %skip_neighbor ], [ %idx_next2, %visited_case ]
  %idx_cmp = icmp ult i64 %idx, %n
  br i1 %idx_cmp, label %check_edge, label %after_neighbors

check_edge:
  %mul = mul i64 %cur, %n
  %linear = add i64 %mul, %idx
  %adjptr = getelementptr inbounds i32, i32* %adj, i64 %linear
  %val = load i32, i32* %adjptr, align 4
  %zero = icmp eq i32 %val, 0
  br i1 %zero, label %skip_neighbor, label %check_visited

skip_neighbor:
  %idx_next1 = add i64 %idx, 1
  br label %neighbors_loop

check_visited:
  %vptr2 = getelementptr inbounds i32, i32* %visited, i64 %idx
  %vflag = load i32, i32* %vptr2, align 4
  %is_vis = icmp ne i32 %vflag, 0
  br i1 %is_vis, label %visited_case, label %explore

visited_case:
  %idx_next2 = add i64 %idx, 1
  br label %neighbors_loop

explore:
  %idx_plus1 = add i64 %idx, 1
  store i64 %idx_plus1, i64* %idx_ptr, align 8
  store i32 1, i32* %vptr2, align 4
  %oldcnt = load i64, i64* %count, align 8
  %newcnt = add i64 %oldcnt, 1
  store i64 %newcnt, i64* %count, align 8
  %optr = getelementptr inbounds i64, i64* %order, i64 %oldcnt
  store i64 %idx, i64* %optr, align 8
  %sptr_push = getelementptr inbounds i64, i64* %stack, i64 %ssz
  store i64 %idx, i64* %sptr_push, align 8
  %ssz_push = add i64 %ssz, 1
  br label %loop_main

after_neighbors:
  %ssz_pop = add i64 %ssz, -1
  br label %loop_main

cleanup:
  call void @free(i8* %vraw)
  call void @free(i8* %nraw)
  call void @free(i8* %sraw)
  ret void
}