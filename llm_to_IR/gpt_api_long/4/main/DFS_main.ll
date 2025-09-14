; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs  ; Address: 0x11C9
; Intent: Iterative depth-first traversal from a start node over an n×n adjacency matrix, writing preorder to out and count to out_len (confidence=0.95). Evidence: matrix index u*n+v with 32-bit edges; visited marking and push/pop stack.
; Preconditions: adj points to at least n*n i32 elements (row-major). out points to at least n i64 slots. out_len is a valid i64*. start < n for any traversal to occur.
; Postconditions: 0 <= *out_len <= n. out[0..*out_len-1] contains distinct visited nodes in DFS preorder starting at start.

; Only the needed extern declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_len) local_unnamed_addr {
entry:
  %not_zero = icmp ne i64 %n, 0
  %start_lt = icmp ult i64 %start, %n
  %ok = and i1 %not_zero, %start_lt
  br i1 %ok, label %alloc, label %early_zero

early_zero:                                       ; preds = %entry
  store i64 0, i64* %out_len, align 8
  ret void

alloc:                                            ; preds = %entry
  %size_vis = shl i64 %n, 2
  %pvisited.i8 = call noalias i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %pvisited.i8 to i32*
  %size64 = shl i64 %n, 3
  %pnext.i8 = call noalias i8* @malloc(i64 %size64)
  %next = bitcast i8* %pnext.i8 to i64*
  %pstack.i8 = call noalias i8* @malloc(i64 %size64)
  %stack = bitcast i8* %pstack.i8 to i64*
  %vis_null = icmp eq i32* %visited, null
  %next_null = icmp eq i64* %next, null
  %stack_null = icmp eq i64* %stack, null
  %any_null1 = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null1, %stack_null
  br i1 %any_null, label %alloc_fail, label %init

alloc_fail:                                       ; preds = %alloc
  call void @free(i8* %pvisited.i8)
  call void @free(i8* %pnext.i8)
  call void @free(i8* %pstack.i8)
  store i64 0, i64* %out_len, align 8
  ret void

init:                                             ; preds = %alloc
  br label %init.loop

init.loop:                                        ; preds = %init.loop, %init
  %i = phi i64 [ 0, %init ], [ %i.next, %init.loop ]
  %cmp.i = icmp ult i64 %i, %n
  br i1 %cmp.i, label %init.body, label %after_init

init.body:                                        ; preds = %init.loop
  %vis.ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis.ptr, align 4
  %next.ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next.ptr, align 8
  %i.next = add i64 %i, 1
  br label %init.loop

after_init:                                       ; preds = %init.loop
  store i64 0, i64* %out_len, align 8
  ; push start
  %stack.slot0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack.slot0, align 8
  ; visited[start] = 1
  %vis.start.ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis.start.ptr, align 4
  ; append start to out
  %len0 = load i64, i64* %out_len, align 8
  %len0.inc = add i64 %len0, 1
  store i64 %len0.inc, i64* %out_len, align 8
  %out.slot0 = getelementptr inbounds i64, i64* %out, i64 %len0
  store i64 %start, i64* %out.slot0, align 8
  br label %outer_check

outer_check:                                      ; preds = %neighbor_found, %after_inner, %after_init
  %stack_sz = phi i64 [ 1, %after_init ], [ %stack_sz.inc, %neighbor_found ], [ %stack_sz.dec, %after_inner ]
  %nonempty = icmp ne i64 %stack_sz, 0
  br i1 %nonempty, label %have_node, label %done

have_node:                                        ; preds = %outer_check
  %top_idx = add i64 %stack_sz, -1
  %top.ptr = getelementptr inbounds i64, i64* %stack, i64 %top_idx
  %u = load i64, i64* %top.ptr, align 8
  %next.u.ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %v.init = load i64, i64* %next.u.ptr, align 8
  br label %inner_cond

inner_cond:                                       ; preds = %inc_v, %have_node
  %v = phi i64 [ %v.init, %have_node ], [ %v.next, %inc_v ]
  %v.lt.n = icmp ult i64 %v, %n
  br i1 %v.lt.n, label %try_neighbor, label %after_inner

try_neighbor:                                     ; preds = %inner_cond
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %aval = load i32, i32* %adj.ptr, align 4
  %has_edge = icmp ne i32 %aval, 0
  br i1 %has_edge, label %check_visited, label %inc_v

check_visited:                                    ; preds = %try_neighbor
  %vis.v.ptr = getelementptr inbounds i32, i32* %visited, i64 %v
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %already = icmp ne i32 %vis.v, 0
  br i1 %already, label %inc_v, label %neighbor_found

neighbor_found:                                   ; preds = %check_visited
  ; next[u] = v + 1
  %v.plus1 = add i64 %v, 1
  store i64 %v.plus1, i64* %next.u.ptr, align 8
  ; visited[v] = 1
  store i32 1, i32* %vis.v.ptr, align 4
  ; append v to out
  %len1 = load i64, i64* %out_len, align 8
  %len1.inc = add i64 %len1, 1
  store i64 %len1.inc, i64* %out_len, align 8
  %out.slot1 = getelementptr inbounds i64, i64* %out, i64 %len1
  store i64 %v, i64* %out.slot1, align 8
  ; push v
  %stack.push.ptr = getelementptr inbounds i64, i64* %stack, i64 %stack_sz
  store i64 %v, i64* %stack.push.ptr, align 8
  %stack_sz.inc = add i64 %stack_sz, 1
  br label %outer_check

inc_v:                                            ; preds = %check_visited, %try_neighbor
  %v.next = add i64 %v, 1
  br label %inner_cond

after_inner:                                      ; preds = %inner_cond
  ; finished scanning neighbors of u, pop stack
  %stack_sz.dec = add i64 %stack_sz, -1
  br label %outer_check

done:                                             ; preds = %outer_check
  call void @free(i8* %pvisited.i8)
  call void @free(i8* %pnext.i8)
  call void @free(i8* %pstack.i8)
  ret void
}