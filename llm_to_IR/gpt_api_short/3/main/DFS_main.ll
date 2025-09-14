; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs ; Address: 0x11C9
; Intent: Iterative DFS on adjacency matrix; outputs visit order and length (confidence=0.92). Evidence: adjacency[u*n+v] checks; stack/visited arrays and push/pop logic
; Preconditions: n > 0 and 0 <= start < n; out and out_len must be valid pointers; adj must be a valid n*n matrix
; Postconditions: out[0..*out_len-1] contains DFS order starting at 'start'; *out_len == 0 on invalid input/allocation failure

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_len) local_unnamed_addr {
entry:
  ; Early exit if n == 0 or start >= n
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

check_start:
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %alloc, label %early_zero

early_zero:
  store i64 0, i64* %out_len, align 8
  ret void

alloc:
  ; allocate visited (i32[n])
  %vis_bytes = mul i64 %n, 4
  %vis_raw = call noalias i8* @malloc(i64 %vis_bytes)
  %visited = bitcast i8* %vis_raw to i32*
  ; allocate nextIdx (i64[n])
  %next_bytes = mul i64 %n, 8
  %next_raw = call noalias i8* @malloc(i64 %next_bytes)
  %nextIdx = bitcast i8* %next_raw to i64*
  ; allocate stack (i64[n])
  %stack_raw = call noalias i8* @malloc(i64 %next_bytes)
  %stack = bitcast i8* %stack_raw to i64*
  ; check allocation failure
  %vis_null = icmp eq i32* %visited, null
  %next_null = icmp eq i64* %nextIdx, null
  %stack_null = icmp eq i64* %stack, null
  %any_null1 = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null1, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_loop

alloc_fail:
  ; free all (free(NULL) is safe)
  %vis_free_cast = bitcast i32* %visited to i8*
  call void @free(i8* %vis_free_cast)
  %next_free_cast = bitcast i64* %nextIdx to i8*
  call void @free(i8* %next_free_cast)
  %stack_free_cast = bitcast i64* %stack to i8*
  call void @free(i8* %stack_free_cast)
  store i64 0, i64* %out_len, align 8
  ret void

init_loop:
  ; for (i = 0; i < n; ++i) { visited[i]=0; nextIdx[i]=0; }
  br label %init_hdr

init_hdr:
  %i = phi i64 [ 0, %init_loop ], [ %i.next, %init_body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init_body, label %after_init

init_body:
  %vis_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %nextIdx, i64 %i
  store i64 0, i64* %next_ptr, align 8
  %i.next = add i64 %i, 1
  br label %init_hdr

after_init:
  ; stackSize = 0; *out_len = 0; push start; visited[start]=1; out[++]=start
  store i64 0, i64* %out_len, align 8
  ; push start at stack[0], then stackSize=1
  %stack_0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_0, align 8
  %stackSize.init = add i64 0, 1
  ; visited[start] = 1
  %vis_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  ; out[*out_len] = start; (*out_len)++
  %cnt0 = load i64, i64* %out_len, align 8
  %cnt0.inc = add i64 %cnt0, 1
  store i64 %cnt0.inc, i64* %out_len, align 8
  %out_pos0 = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %start, i64* %out_pos0, align 8
  br label %loop_top

loop_top:
  %stackSize = phi i64 [ %stackSize.init, %after_init ], [ %stackSize.next, %post_push ], [ %stackSize.pop, %after_inner ]
  ; while (stackSize != 0)
  %nonempty = icmp ne i64 %stackSize, 0
  br i1 %nonempty, label %outer, label %done

outer:
  ; u = stack[stackSize-1]
  %idx_top = add i64 %stackSize, -1
  %u_ptr = getelementptr inbounds i64, i64* %stack, i64 %idx_top
  %u = load i64, i64* %u_ptr, align 8
  ; v = nextIdx[u]
  %next_u_ptr = getelementptr inbounds i64, i64* %nextIdx, i64 %u
  %v0 = load i64, i64* %next_u_ptr, align 8
  br label %inner

inner:
  %v = phi i64 [ %v0, %outer ], [ %v.inc, %inc_v ]
  ; if (v < n) continue scanning, else break
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %scan, label %after_inner

scan:
  ; if (adj[u*n + v] != 0 && visited[v] == 0) -> push neighbor
  %un = mul i64 %u, %n
  %idx = add i64 %un, %v
  %adj_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj_val = load i32, i32* %adj_ptr, align 4
  %edge_nonzero = icmp ne i32 %adj_val, 0
  br i1 %edge_nonzero, label %check_vis, label %inc_v

check_vis:
  %vis_v_ptr = getelementptr inbounds i32, i32* %visited, i64 %v
  %vis_v = load i32, i32* %vis_v_ptr, align 4
  %not_visited = icmp eq i32 %vis_v, 0
  br i1 %not_visited, label %push_neighbor, label %inc_v

push_neighbor:
  ; nextIdx[u] = v + 1
  %v.plus1 = add i64 %v, 1
  store i64 %v.plus1, i64* %next_u_ptr, align 8
  ; visited[v] = 1
  store i32 1, i32* %vis_v_ptr, align 4
  ; out[*out_len] = v; (*out_len)++
  %cnt = load i64, i64* %out_len, align 8
  %out_pos = getelementptr inbounds i64, i64* %out, i64 %cnt
  store i64 %v, i64* %out_pos, align 8
  %cnt.inc = add i64 %cnt, 1
  store i64 %cnt.inc, i64* %out_len, align 8
  ; push v onto stack at stack[stackSize], then stackSize++
  %stack_slot = getelementptr inbounds i64, i64* %stack, i64 %stackSize
  store i64 %v, i64* %stack_slot, align 8
  %stackSize.next = add i64 %stackSize, 1
  br label %post_push

inc_v:
  ; v++
  %v.inc = add i64 %v, 1
  br label %inner

after_inner:
  ; if (v == n) pop; else continue
  %v_eq_n = icmp eq i64 %v, %n
  %stackSize.pop = select i1 %v_eq_n, i64 (add i64 %stackSize, -1), i64 %stackSize
  br label %loop_top

post_push:
  br label %loop_top

done:
  ; free resources
  %vis_free_cast2 = bitcast i32* %visited to i8*
  call void @free(i8* %vis_free_cast2)
  %next_free_cast2 = bitcast i64* %nextIdx to i8*
  call void @free(i8* %next_free_cast2)
  %stack_free_cast2 = bitcast i64* %stack to i8*
  call void @free(i8* %stack_free_cast2)
  ret void
}