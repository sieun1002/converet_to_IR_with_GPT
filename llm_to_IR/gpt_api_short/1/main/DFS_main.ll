; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs ; Address: 0x11C9
; Intent: Iterative DFS traversal (preorder) on an adjacency matrix; writes visit order and count (confidence=0.93). Evidence: alloc of visited/next/stack; adjacency matrix indexing [u*N+v]; push/pop stack; visited checks; output array with count.
; Preconditions: adj points to N*N i32 matrix; out has capacity >= N; out_len is valid; 0 <= start < N for non-empty traversal.
; Postconditions: out_len set to number of visited nodes; out[0..out_len-1] contains preorder DFS from start.

; Only the necessary external declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr

define dso_local void @dfs(i32* nocapture readonly %adj, i64 %n, i64 %start, i64* nocapture %out, i64* nocapture %out_len) local_unnamed_addr {
entry:
  ; Early exit if n == 0 or start >= n
  %n_is_zero = icmp eq i64 %n, 0
  %start_ge_n = icmp uge i64 %start, %n
  %early = or i1 %n_is_zero, %start_ge_n
  br i1 %early, label %early_zero, label %alloc

early_zero:                                         ; preds = %entry
  store i64 0, i64* %out_len, align 8
  ret void

alloc:                                               ; preds = %entry
  ; visited: n * 4 bytes
  %sz_vis = shl i64 %n, 2
  %vis_i8 = call noalias i8* @malloc(i64 %sz_vis)
  ; next index per node: n * 8 bytes
  %sz_next = shl i64 %n, 3
  %next_i8 = call noalias i8* @malloc(i64 %sz_next)
  ; stack: n * 8 bytes
  %stack_i8 = call noalias i8* @malloc(i64 %sz_next)
  %vis = bitcast i8* %vis_i8 to i32*
  %next = bitcast i8* %next_i8 to i64*
  %stack = bitcast i8* %stack_i8 to i64*
  ; check allocation failure
  %vis_null = icmp eq i8* %vis_i8, null
  %next_null = icmp eq i8* %next_i8, null
  %stack_null = icmp eq i8* %stack_i8, null
  %any_null.tmp = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null.tmp, %stack_null
  br i1 %any_null, label %alloc_fail, label %init.loop

alloc_fail:                                          ; preds = %alloc
  ; free what we may have gotten; free(NULL) is OK
  call void @free(i8* %vis_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  store i64 0, i64* %out_len, align 8
  ret void

init.loop:                                           ; preds = %alloc, %init.body
  ; i from 0 to n-1: visited[i]=0; next[i]=0
  %i.init = phi i64 [ 0, %alloc ], [ %i.next, %init.body ]
  %init.cond = icmp ult i64 %i.init, %n
  br i1 %init.cond, label %init.body, label %init.done

init.body:                                           ; preds = %init.loop
  %vis.gep = getelementptr inbounds i32, i32* %vis, i64 %i.init
  store i32 0, i32* %vis.gep, align 4
  %next.gep = getelementptr inbounds i64, i64* %next, i64 %i.init
  store i64 0, i64* %next.gep, align 8
  %i.next = add i64 %i.init, 1
  br label %init.loop

init.done:                                           ; preds = %init.loop
  ; stack_size = 0; *out_len = 0
  store i64 0, i64* %out_len, align 8
  ; push start
  ; stack[0] = start
  %stack.slot0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack.slot0, align 8
  ; visited[start] = 1
  %vstart.ptr = getelementptr inbounds i32, i32* %vis, i64 %start
  store i32 1, i32* %vstart.ptr, align 4
  ; out[0] = start ; out_len = 1
  %oldc0 = load i64, i64* %out_len, align 8
  %outp0 = getelementptr inbounds i64, i64* %out, i64 %oldc0
  store i64 %start, i64* %outp0, align 8
  %newc0 = add i64 %oldc0, 1
  store i64 %newc0, i64* %out_len, align 8
  br label %loop.head

loop.head:                                           ; preds = %found, %pop, %init.done
  %ss = phi i64 [ 1, %init.done ], [ %ss.next, %found ], [ %ss.dec, %pop ]
  %has_items = icmp ne i64 %ss, 0
  br i1 %has_items, label %loop.body, label %cleanup

loop.body:                                           ; preds = %loop.head
  ; curr = stack[ss-1]
  %ssm1 = add i64 %ss, -1
  %curr.ptr = getelementptr inbounds i64, i64* %stack, i64 %ssm1
  %curr = load i64, i64* %curr.ptr, align 8
  ; i = next[curr]
  %nptr.curr = getelementptr inbounds i64, i64* %next, i64 %curr
  %i.start = load i64, i64* %nptr.curr, align 8
  br label %inner.head

inner.head:                                          ; preds = %loop.body, %inner.inc
  %i.var = phi i64 [ %i.start, %loop.body ], [ %i.inc, %inner.inc ]
  %i.lt.n = icmp ult i64 %i.var, %n
  br i1 %i.lt.n, label %check.edge, label %pop

check.edge:                                          ; preds = %inner.head
  ; edge = adj[curr*n + i] != 0
  %mul = mul i64 %curr, %n
  %index = add i64 %mul, %i.var
  %adj.gep = getelementptr inbounds i32, i32* %adj, i64 %index
  %edge.val = load i32, i32* %adj.gep, align 4
  %is_edge = icmp ne i32 %edge.val, 0
  ; not visited?
  %vis.i.ptr = getelementptr inbounds i32, i32* %vis, i64 %i.var
  %vis.i = load i32, i32* %vis.i.ptr, align 4
  %not_vis = icmp eq i32 %vis.i, 0
  %ok = and i1 %is_edge, %not_vis
  br i1 %ok, label %found, label %inner.inc

found:                                               ; preds = %check.edge
  ; next[curr] = i + 1
  %i.plus1 = add i64 %i.var, 1
  store i64 %i.plus1, i64* %nptr.curr, align 8
  ; visited[i] = 1
  store i32 1, i32* %vis.i.ptr, align 4
  ; append to out
  %oldc = load i64, i64* %out_len, align 8
  %newc = add i64 %oldc, 1
  store i64 %newc, i64* %out_len, align 8
  %outp = getelementptr inbounds i64, i64* %out, i64 %oldc
  store i64 %i.var, i64* %outp, align 8
  ; push i onto stack
  %stack.push.ptr = getelementptr inbounds i64, i64* %stack, i64 %ss
  store i64 %i.var, i64* %stack.push.ptr, align 8
  %ss.next = add i64 %ss, 1
  br label %loop.head

inner.inc:                                           ; preds = %check.edge
  %i.inc = add i64 %i.var, 1
  br label %inner.head

pop:                                                 ; preds = %inner.head
  %ss.dec = add i64 %ss, -1
  br label %loop.head

cleanup:                                             ; preds = %loop.head
  call void @free(i8* %vis_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  ret void
}