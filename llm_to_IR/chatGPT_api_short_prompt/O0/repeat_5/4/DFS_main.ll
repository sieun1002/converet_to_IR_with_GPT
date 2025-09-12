; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs ; Address: 0x11C9
; Intent: Iterative DFS over an N×N int32 adjacency matrix, producing visit order and count (confidence=0.92). Evidence: row-major adj indexing (u*N+i), visited int array, explicit stack and next-neighbor indices.
; Preconditions: adj has at least n*n int32 entries; out has capacity ≥ n; countp is valid; 0 ≤ start < n.
; Postconditions: *countp is number of visited nodes from start; out[0..*countp-1] contains visit order.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* nocapture readonly %adj, i64 %n, i64 %start, i64* nocapture %out, i64* nocapture %countp) local_unnamed_addr {
entry:
  %isNZero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %bad0 = or i1 %isNZero, %start_ge_n
  br i1 %bad0, label %early, label %allocs

early:
  store i64 0, i64* %countp, align 8
  ret void

allocs:
  %size_vis = mul i64 %n, 4
  %vis_raw = call i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %vis_raw to i32*
  %size64 = shl i64 %n, 3
  %next_raw = call i8* @malloc(i64 %size64)
  %next = bitcast i8* %next_raw to i64*
  %stack_raw = call i8* @malloc(i64 %size64)
  %stack = bitcast i8* %stack_raw to i64*
  %vis_null = icmp eq i8* %vis_raw, null
  %next_null = icmp eq i8* %next_raw, null
  %stack_null = icmp eq i8* %stack_raw, null
  %tmp.or = or i1 %vis_null, %next_null
  %any_null = or i1 %tmp.or, %stack_null
  br i1 %any_null, label %alloc_fail, label %init

alloc_fail:
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  store i64 0, i64* %countp, align 8
  ret void

init:
  br label %init_loop

init_loop:                                           ; i in [0, n)
  %i = phi i64 [ 0, %init ], [ %i.next, %init_loop_body ]
  %i.cmp = icmp ult i64 %i, %n
  br i1 %i.cmp, label %init_loop_body, label %post_init

init_loop_body:
  %visited.i.ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %visited.i.ptr, align 4
  %next.i.ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next.i.ptr, align 8
  %i.next = add nuw nsw i64 %i, 1
  br label %init_loop

post_init:
  store i64 0, i64* %countp, align 8
  ; push start
  %stack.slot0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack.slot0, align 8
  ; mark visited[start] = 1
  %vis.start.ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis.start.ptr, align 4
  ; out[*count] = start; *count += 1
  %c0 = load i64, i64* %countp, align 8
  %out.c0.ptr = getelementptr inbounds i64, i64* %out, i64 %c0
  store i64 %start, i64* %out.c0.ptr, align 8
  %c0.plus = add i64 %c0, 1
  store i64 %c0.plus, i64* %countp, align 8
  br label %outer_header

outer_header:
  %s = phi i64 [ 1, %post_init ], [ %s2, %after_push ], [ %s3, %after_pop ]
  %nonzero = icmp ne i64 %s, 0
  br i1 %nonzero, label %outer_top, label %done

outer_top:
  %top.idx = add i64 %s, -1
  %top.ptr = getelementptr inbounds i64, i64* %stack, i64 %top.idx
  %u = load i64, i64* %top.ptr, align 8
  %next.u.ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %i.cur = load i64, i64* %next.u.ptr, align 8
  br label %inner_cond

inner_cond:
  %i.var = phi i64 [ %i.cur, %outer_top ], [ %i.inc, %inc_i ]
  %i.lt.n = icmp ult i64 %i.var, %n
  br i1 %i.lt.n, label %inner_body, label %inner_end

inner_body:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %i.var
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj.nz = icmp ne i32 %adj.val, 0
  br i1 %adj.nz, label %check_visited, label %inc_i

check_visited:
  %vis.i.ptr2 = getelementptr inbounds i32, i32* %visited, i64 %i.var
  %vis.i.val = load i32, i32* %vis.i.ptr2, align 4
  %not.visited = icmp eq i32 %vis.i.val, 0
  br i1 %not.visited, label %neighbor_found, label %inc_i

neighbor_found:
  ; next[u] = i+1
  %i.plus1 = add i64 %i.var, 1
  store i64 %i.plus1, i64* %next.u.ptr, align 8
  ; visited[i] = 1
  store i32 1, i32* %vis.i.ptr2, align 4
  ; out[*count] = i; *count += 1
  %c1 = load i64, i64* %countp, align 8
  %out.c1.ptr = getelementptr inbounds i64, i64* %out, i64 %c1
  store i64 %i.var, i64* %out.c1.ptr, align 8
  %c1.plus = add i64 %c1, 1
  store i64 %c1.plus, i64* %countp, align 8
  ; push i onto stack
  %push.ptr = getelementptr inbounds i64, i64* %stack, i64 %s
  store i64 %i.var, i64* %push.ptr, align 8
  %s2 = add i64 %s, 1
  br label %after_push

inc_i:
  %i.inc = add i64 %i.var, 1
  br label %inner_cond

inner_end:
  ; finished scanning neighbors of u -> pop
  %s3 = add i64 %s, -1
  br label %after_pop

after_push:
  br label %outer_header

after_pop:
  br label %outer_header

done:
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  ret void
}