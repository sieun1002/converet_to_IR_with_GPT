; LLVM IR (.ll) for function: dfs
; Reconstructed from the provided x86-64 SysV disassembly (LLVM 14 compatible)

; Signature inferred:
; void dfs(int32_t* adj, uint64_t n, uint64_t start, uint64_t* order, uint64_t* out_count)

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %order, i64* %out_count) {
entry:
  ; if (n == 0 || start >= n) { *out_count = 0; return; }
  %n_is_zero = icmp eq i64 %n, 0
  %start_oob = icmp uge i64 %start, %n
  %bad_args = or i1 %n_is_zero, %start_oob
  br i1 %bad_args, label %early_ret, label %alloc

early_ret:
  store i64 0, i64* %out_count, align 8
  ret void

alloc:
  ; visited: i32[n]
  %size_vis = shl nuw nsw i64 %n, 2
  %vis_raw = call i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %vis_raw to i32*

  ; next_idx: i64[n]
  %size_64 = shl nuw nsw i64 %n, 3
  %next_raw = call i8* @malloc(i64 %size_64)
  %next_idx = bitcast i8* %next_raw to i64*

  ; stack: i64[n]
  %stack_raw = call i8* @malloc(i64 %size_64)
  %stack = bitcast i8* %stack_raw to i64*

  ; if any alloc failed
  %vis_null = icmp eq i8* %vis_raw, null
  %next_null = icmp eq i8* %next_raw, null
  %stack_null = icmp eq i8* %stack_raw, null
  %any_null.tmp = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null.tmp, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_zero

alloc_fail:
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  store i64 0, i64* %out_count, align 8
  ret void

; Initialize visited[i]=0 and next_idx[i]=0 for i in [0,n)
init_zero:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init_zero ], [ %i.next, %init_loop_cont ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %init_body, label %init_done

init_body:
  %vptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vptr, align 4
  %nptr = getelementptr inbounds i64, i64* %next_idx, i64 %i
  store i64 0, i64* %nptr, align 8
  br label %init_loop_cont

init_loop_cont:
  %i.next = add nuw nsw i64 %i, 1
  br label %init_loop

init_done:
  ; setup: sp=1 after pushing start
  store i64 0, i64* %out_count, align 8

  ; push start onto stack
  %stack0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack0, align 8

  ; visited[start] = 1
  %vstart = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vstart, align 4

  ; order[(*out_count)++] = start
  %cnt0 = load i64, i64* %out_count, align 8
  %optr0 = getelementptr inbounds i64, i64* %order, i64 %cnt0
  store i64 %start, i64* %optr0, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count, align 8

  br label %outer

; DFS outer loop: while (sp != 0)
outer:
  %sp = phi i64 [ 1, %init_done ], [ %sp.next, %outer_cont ]
  %sp_nz = icmp ne i64 %sp, 0
  br i1 %sp_nz, label %outer_body, label %finish

outer_body:
  ; u = stack[sp-1]
  %spm1 = add i64 %sp, -1
  %upptr = getelementptr inbounds i64, i64* %stack, i64 %spm1
  %u = load i64, i64* %upptr, align 8

  ; j = next_idx[u]
  %nuptr = getelementptr inbounds i64, i64* %next_idx, i64 %u
  %j0 = load i64, i64* %nuptr, align 8

  br label %inner

; Scan neighbors j from current next_idx[u] to n-1
inner:
  %j = phi i64 [ %j0, %outer_body ], [ %j.next, %inner_cont ]
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %check_edge, label %after_inner

; if (adj[u*n + j] != 0 && visited[j] == 0) -> visit
check_edge:
  %un = mul i64 %u, %n
  %idx = add i64 %un, %j
  %cellptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %cell = load i32, i32* %cellptr, align 4
  %edge_nz = icmp ne i32 %cell, 0
  br i1 %edge_nz, label %check_unvisited, label %inner_cont

check_unvisited:
  %vjptr = getelementptr inbounds i32, i32* %visited, i64 %j
  %vj = load i32, i32* %vjptr, align 4
  %unvisited = icmp eq i32 %vj, 0
  br i1 %unvisited, label %found_neighbor, label %inner_cont

inner_cont:
  %j.next = add i64 %j, 1
  br label %inner

; Found an unvisited neighbor j
found_neighbor:
  ; next_idx[u] = j + 1
  %jplus = add i64 %j, 1
  store i64 %jplus, i64* %nuptr, align 8

  ; visited[j] = 1
  store i32 1, i32* %vjptr, align 4

  ; order[(*out_count)++] = j
  %cntA = load i64, i64* %out_count, align 8
  %optrA = getelementptr inbounds i64, i64* %order, i64 %cntA
  store i64 %j, i64* %optrA, align 8
  %cntA1 = add i64 %cntA, 1
  store i64 %cntA1, i64* %out_count, align 8

  ; push j
  %pushptr = getelementptr inbounds i64, i64* %stack, i64 %sp
  store i64 %j, i64* %pushptr, align 8
  %sp.inc = add i64 %sp, 1
  br label %outer_cont

; No more neighbors for u: pop
after_inner:
  %sp.dec = add i64 %sp, -1
  br label %outer_cont

outer_cont:
  %sp.next = phi i64 [ %sp.inc, %found_neighbor ], [ %sp.dec, %after_inner ]
  br label %outer

finish:
  call void @free(i8* %vis_raw)
  call void @free(i8* %next_raw)
  call void @free(i8* %stack_raw)
  ret void
}