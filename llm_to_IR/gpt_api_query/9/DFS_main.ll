; target triple and datalayout for x86_64 Linux (LLVM 14 compatible)
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %order, i64* %countPtr) {
entry:
  ; locals
  %stackTop = alloca i64, align 8
  %u = alloca i64, align 8
  %i = alloca i64, align 8

  ; if (n == 0) { *countPtr = 0; return; }
  %n_zero = icmp eq i64 %n, 0
  br i1 %n_zero, label %invalid, label %check_start

check_start:
  ; if (start >= n) { *countPtr = 0; return; }
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %alloc, label %invalid

invalid:
  store i64 0, i64* %countPtr, align 8
  ret void

alloc:
  ; visited: i32[n]
  %n_x4 = shl i64 %n, 2
  %visited_i8 = call noalias i8* @malloc(i64 %n_x4)
  %visited = bitcast i8* %visited_i8 to i32*

  ; next: i64[n]
  %n_x8 = shl i64 %n, 3
  %next_i8 = call noalias i8* @malloc(i64 %n_x8)
  %next = bitcast i8* %next_i8 to i64*

  ; stack: i64[n]
  %stack_i8 = call noalias i8* @malloc(i64 %n_x8)
  %stack = bitcast i8* %stack_i8 to i64*

  ; if any alloc failed
  %vis_null = icmp eq i8* %visited_i8, null
  %next_null = icmp eq i8* %next_i8, null
  %stack_null = icmp eq i8* %stack_i8, null
  %tmp_any1 = or i1 %vis_null, %next_null
  %any_null = or i1 %tmp_any1, %stack_null
  br i1 %any_null, label %alloc_fail, label %init

alloc_fail:
  call void @free(i8* %visited_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  store i64 0, i64* %countPtr, align 8
  ret void

init:
  ; initialize visited[] = 0, next[] = 0
  br label %init_loop

init_loop:
  %idx = phi i64 [ 0, %init ], [ %idx.next, %init_loop ]
  %idx.lt.n = icmp ult i64 %idx, %n
  br i1 %idx.lt.n, label %init_body, label %post_init

init_body:
  %vis.p = getelementptr inbounds i32, i32* %visited, i64 %idx
  store i32 0, i32* %vis.p, align 4
  %next.p = getelementptr inbounds i64, i64* %next, i64 %idx
  store i64 0, i64* %next.p, align 8
  %idx.next = add i64 %idx, 1
  br label %init_loop

post_init:
  ; stackTop = 0
  store i64 0, i64* %stackTop, align 8
  ; *countPtr = 0
  store i64 0, i64* %countPtr, align 8

  ; push start: stack[0] = start; stackTop = 1
  %stack.0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack.0, align 8
  store i64 1, i64* %stackTop, align 8

  ; visited[start] = 1
  %vis.start.p = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis.start.p, align 4

  ; order[count] = start; count++
  %cnt0 = load i64, i64* %countPtr, align 8
  %order.slot0 = getelementptr inbounds i64, i64* %order, i64 %cnt0
  store i64 %start, i64* %order.slot0, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %countPtr, align 8

  br label %outer

outer:
  ; while (stackTop != 0)
  %st = load i64, i64* %stackTop, align 8
  %st.ne.0 = icmp ne i64 %st, 0
  br i1 %st.ne.0, label %outer_body, label %exit

outer_body:
  ; u = stack[stackTop - 1]
  %top.idx = add i64 %st, -1
  %stack.top.p = getelementptr inbounds i64, i64* %stack, i64 %top.idx
  %u.val = load i64, i64* %stack.top.p, align 8
  store i64 %u.val, i64* %u, align 8

  ; i = next[u]
  %next.u.p = getelementptr inbounds i64, i64* %next, i64 %u.val
  %i.init = load i64, i64* %next.u.p, align 8
  store i64 %i.init, i64* %i, align 8

  br label %inner

inner:
  ; while (i < n)
  %i.cur = load i64, i64* %i, align 8
  %i.lt.n = icmp ult i64 %i.cur, %n
  br i1 %i.lt.n, label %scan, label %after_inner

scan:
  ; if (adj[u*n + i] != 0) and (visited[i] == 0)
  %u.scan = load i64, i64* %u, align 8
  %mul = mul i64 %u.scan, %n
  %sum = add i64 %mul, %i.cur
  %adj.p = getelementptr inbounds i32, i32* %adj, i64 %sum
  %edge = load i32, i32* %adj.p, align 4
  %edge.is.zero = icmp eq i32 %edge, 0
  br i1 %edge.is.zero, label %inc_i, label %check_visited

check_visited:
  %vis.i.p = getelementptr inbounds i32, i32* %visited, i64 %i.cur
  %vis.i.val = load i32, i32* %vis.i.p, align 4
  %vis.zero = icmp eq i32 %vis.i.val, 0
  br i1 %vis.zero, label %visit_neighbor, label %inc_i

visit_neighbor:
  ; next[u] = i + 1
  %i.plus1 = add i64 %i.cur, 1
  store i64 %i.plus1, i64* %next.u.p, align 8

  ; visited[i] = 1
  store i32 1, i32* %vis.i.p, align 4

  ; order[count] = i; count++
  %cnt.old = load i64, i64* %countPtr, align 8
  %order.slot = getelementptr inbounds i64, i64* %order, i64 %cnt.old
  store i64 %i.cur, i64* %order.slot, align 8
  %cnt.new = add i64 %cnt.old, 1
  store i64 %cnt.new, i64* %countPtr, align 8

  ; push i onto stack: stack[stackTop] = i; stackTop++
  %st.push = load i64, i64* %stackTop, align 8
  %stack.push.p = getelementptr inbounds i64, i64* %stack, i64 %st.push
  store i64 %i.cur, i64* %stack.push.p, align 8
  %st.next = add i64 %st.push, 1
  store i64 %st.next, i64* %stackTop, align 8

  ; go to next outer iteration
  br label %outer

inc_i:
  ; i++
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %inner

after_inner:
  ; if (i == n) stackTop--
  %i.end = load i64, i64* %i, align 8
  %i.eq.n = icmp eq i64 %i.end, %n
  br i1 %i.eq.n, label %pop, label %outer

pop:
  %st.pop = load i64, i64* %stackTop, align 8
  %st.dec = add i64 %st.pop, -1
  store i64 %st.dec, i64* %stackTop, align 8
  br label %outer

exit:
  call void @free(i8* %visited_i8)
  call void @free(i8* %next_i8)
  call void @free(i8* %stack_i8)
  ret void
}