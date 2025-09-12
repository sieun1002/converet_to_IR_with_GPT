; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs  ; Address: 0x11C9
; Intent: Iterative DFS over an n×n i32 adjacency matrix; outputs visitation order (i64) and count (confidence=0.95). Evidence: accesses adj[u*n+v], visited array, explicit stack and next-edge indices.
; Preconditions: adj points to at least n*n i32s; out has capacity for up to n i64s; out_count is a valid i64*.

; Only the needed extern declarations:
declare i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  %cmp_n0 = icmp eq i64 %n, 0
  %cmp_start_ge_n = icmp uge i64 %start, %n
  %bad_start_or_n = or i1 %cmp_n0, %cmp_start_ge_n
  br i1 %bad_start_or_n, label %bad_ret, label %alloc

bad_ret:                                           ; preds = %entry
  store i64 0, i64* %out_count, align 8
  ret void

alloc:                                             ; preds = %entry
  %size_vis = shl i64 %n, 2
  %pvis_i8 = call i8* @malloc(i64 %size_vis)
  %pvis = bitcast i8* %pvis_i8 to i32*
  %size_8 = shl i64 %n, 3
  %pnext_i8 = call i8* @malloc(i64 %size_8)
  %pnext = bitcast i8* %pnext_i8 to i64*
  %pstack_i8 = call i8* @malloc(i64 %size_8)
  %pstack = bitcast i8* %pstack_i8 to i64*
  %null_vis = icmp eq i8* %pvis_i8, null
  %null_next = icmp eq i8* %pnext_i8, null
  %null_stack = icmp eq i8* %pstack_i8, null
  %anynull1 = or i1 %null_vis, %null_next
  %anynull = or i1 %anynull1, %null_stack
  br i1 %anynull, label %alloc_fail, label %init.cond

alloc_fail:                                        ; preds = %alloc
  call void @free(i8* %pvis_i8)
  call void @free(i8* %pnext_i8)
  call void @free(i8* %pstack_i8)
  store i64 0, i64* %out_count, align 8
  ret void

init.cond:                                         ; preds = %alloc, %init.body
  %i = phi i64 [ 0, %alloc ], [ %i.next, %init.body ]
  %cmp_i_n = icmp ult i64 %i, %n
  br i1 %cmp_i_n, label %init.body, label %post_init

init.body:                                         ; preds = %init.cond
  %vis_ptr = getelementptr inbounds i32, i32* %pvis, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %pnext, i64 %i
  store i64 0, i64* %next_ptr, align 8
  %i.next = add i64 %i, 1
  br label %init.cond

post_init:                                         ; preds = %init.cond
  store i64 0, i64* %out_count, align 8
  %stack0_ptr = getelementptr inbounds i64, i64* %pstack, i64 0
  store i64 %start, i64* %stack0_ptr, align 8
  %vis_start_ptr = getelementptr inbounds i32, i32* %pvis, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  %oldc = load i64, i64* %out_count, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %oldc
  store i64 %start, i64* %out_slot, align 8
  %newc = add i64 %oldc, 1
  store i64 %newc, i64* %out_count, align 8
  br label %outer.cond

outer.cond:                                        ; preds = %outer.iter_end, %post_init
  %ss = phi i64 [ 1, %post_init ], [ %ss_updated, %outer.iter_end ]
  %not_empty = icmp ne i64 %ss, 0
  br i1 %not_empty, label %outer.iter_begin, label %cleanup

outer.iter_begin:                                  ; preds = %outer.cond
  %top_index = add i64 %ss, -1
  %u_ptr = getelementptr inbounds i64, i64* %pstack, i64 %top_index
  %u = load i64, i64* %u_ptr, align 8
  %nu_ptr = getelementptr inbounds i64, i64* %pnext, i64 %u
  %i0 = load i64, i64* %nu_ptr, align 8
  br label %inner.cond

inner.cond:                                        ; preds = %inner.advance, %outer.iter_begin
  %i.cur = phi i64 [ %i0, %outer.iter_begin ], [ %i.next2, %inner.advance ]
  %i_lt_n = icmp ult i64 %i.cur, %n
  br i1 %i_lt_n, label %inner.body, label %inner.done

inner.body:                                        ; preds = %inner.cond
  %mul = mul i64 %u, %n
  %flat = add i64 %mul, %i.cur
  %adjptr = getelementptr inbounds i32, i32* %adj, i64 %flat
  %edgev = load i32, i32* %adjptr, align 4
  %edge_zero = icmp eq i32 %edgev, 0
  br i1 %edge_zero, label %inner.advance, label %check_visited

check_visited:                                     ; preds = %inner.body
  %vis_i_ptr = getelementptr inbounds i32, i32* %pvis, i64 %i.cur
  %vis_i = load i32, i32* %vis_i_ptr, align 4
  %is_visited = icmp ne i32 %vis_i, 0
  br i1 %is_visited, label %inner.advance, label %found_neighbor

inner.advance:                                     ; preds = %check_visited, %inner.body
  %i.next2 = add i64 %i.cur, 1
  br label %inner.cond

found_neighbor:                                    ; preds = %check_visited
  %iplus = add i64 %i.cur, 1
  store i64 %iplus, i64* %nu_ptr, align 8
  store i32 1, i32* %vis_i_ptr, align 4
  %oldc2 = load i64, i64* %out_count, align 8
  %out_slot2 = getelementptr inbounds i64, i64* %out, i64 %oldc2
  store i64 %i.cur, i64* %out_slot2, align 8
  %newc2 = add i64 %oldc2, 1
  store i64 %newc2, i64* %out_count, align 8
  %stack_pos_ptr = getelementptr inbounds i64, i64* %pstack, i64 %ss
  store i64 %i.cur, i64* %stack_pos_ptr, align 8
  %ss_after_push = add i64 %ss, 1
  br label %outer.iter_end

inner.done:                                        ; preds = %inner.cond
  %ss_after_pop = add i64 %ss, -1
  br label %outer.iter_end

outer.iter_end:                                    ; preds = %inner.done, %found_neighbor
  %ss_updated = phi i64 [ %ss_after_push, %found_neighbor ], [ %ss_after_pop, %inner.done ]
  br label %outer.cond

cleanup:                                           ; preds = %outer.cond
  call void @free(i8* %pvis_i8)
  call void @free(i8* %pnext_i8)
  call void @free(i8* %pstack_i8)
  ret void
}