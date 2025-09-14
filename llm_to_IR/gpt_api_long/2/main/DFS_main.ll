; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dfs  ; Address: 0x11C9
; Intent: Iterative DFS over an N×N adjacency matrix, recording visit order (confidence=0.95). Evidence: row-major index u*N+i with 4-byte loads; visited/next arrays and explicit stack.
; Preconditions: adj points to at least n*n i32s; out points to at least n i64s; out_count is non-null; 0 <= start < n.
; Postconditions: *out_count holds number of visited nodes; out[0..*out_count-1] contains visit order starting from start.

; Only the needed extern declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count) local_unnamed_addr {
entry:
  %cmp_n0 = icmp eq i64 %n, 0
  %cmp_start = icmp uge i64 %start, %n
  %bad = or i1 %cmp_n0, %cmp_start
  br i1 %bad, label %ret_zero, label %alloc

ret_zero:
  store i64 0, i64* %out_count, align 8
  ret void

alloc:
  %size_vis = shl i64 %n, 2
  %raw_vis = call i8* @malloc(i64 %size_vis)
  %vis = bitcast i8* %raw_vis to i32*
  %size_8 = shl i64 %n, 3
  %raw_next = call i8* @malloc(i64 %size_8)
  %next = bitcast i8* %raw_next to i64*
  %raw_stack = call i8* @malloc(i64 %size_8)
  %stack = bitcast i8* %raw_stack to i64*
  %vis_null = icmp eq i8* %raw_vis, null
  %next_null = icmp eq i8* %raw_next, null
  %stack_null = icmp eq i8* %raw_stack, null
  %any_null1 = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null1, %stack_null
  br i1 %any_null, label %cleanup_fail, label %init

cleanup_fail:
  call void @free(i8* %raw_vis)
  call void @free(i8* %raw_next)
  call void @free(i8* %raw_stack)
  store i64 0, i64* %out_count, align 8
  ret void

init:
  br label %zero_loop

zero_loop:
  %i.0 = phi i64 [ 0, %init ], [ %i.next, %zero_continue ]
  %i.lt = icmp ult i64 %i.0, %n
  br i1 %i.lt, label %zero_body, label %post_zero

zero_body:
  %vis.i.ptr = getelementptr inbounds i32, i32* %vis, i64 %i.0
  store i32 0, i32* %vis.i.ptr, align 4
  %next.i.ptr = getelementptr inbounds i64, i64* %next, i64 %i.0
  store i64 0, i64* %next.i.ptr, align 8
  br label %zero_continue

zero_continue:
  %i.next = add i64 %i.0, 1
  br label %zero_loop

post_zero:
  store i64 0, i64* %out_count, align 8
  %stack0.ptr = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack0.ptr, align 8
  %vis.start.ptr = getelementptr inbounds i32, i32* %vis, i64 %start
  store i32 1, i32* %vis.start.ptr, align 4
  %cnt0 = load i64, i64* %out_count, align 8
  %cnt0.next = add i64 %cnt0, 1
  store i64 %cnt0.next, i64* %out_count, align 8
  %out.ptr0 = getelementptr inbounds i64, i64* %out, i64 %cnt0
  store i64 %start, i64* %out.ptr0, align 8
  br label %outer_loop

outer_loop:
  %sp.0 = phi i64 [ 1, %post_zero ], [ %sp.next.iter, %outer_continue ]
  %sp.nz = icmp ne i64 %sp.0, 0
  br i1 %sp.nz, label %process_frame, label %end

process_frame:
  %spm1 = add i64 %sp.0, -1
  %stack.top.ptr = getelementptr inbounds i64, i64* %stack, i64 %spm1
  %u = load i64, i64* %stack.top.ptr, align 8
  %next.u.ptr = getelementptr inbounds i64, i64* %next, i64 %u
  %i.init = load i64, i64* %next.u.ptr, align 8
  br label %inner_loop

inner_loop:
  %i.1 = phi i64 [ %i.init, %process_frame ], [ %i.inc, %inc_i ]
  %i.lt.n = icmp ult i64 %i.1, %n
  br i1 %i.lt.n, label %check_edge, label %after_inner

check_edge:
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %i.1
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %edge.nz = icmp ne i32 %adj.val, 0
  br i1 %edge.nz, label %check_visited, label %inc_i

check_visited:
  %vis.i.ptr2 = getelementptr inbounds i32, i32* %vis, i64 %i.1
  %vis.i.val = load i32, i32* %vis.i.ptr2, align 4
  %not.vis = icmp eq i32 %vis.i.val, 0
  br i1 %not.vis, label %found, label %inc_i

found:
  %i.plus1 = add i64 %i.1, 1
  store i64 %i.plus1, i64* %next.u.ptr, align 8
  store i32 1, i32* %vis.i.ptr2, align 4
  %cnt = load i64, i64* %out_count, align 8
  %cnt.next = add i64 %cnt, 1
  store i64 %cnt.next, i64* %out_count, align 8
  %out.ptr.i = getelementptr inbounds i64, i64* %out, i64 %cnt
  store i64 %i.1, i64* %out.ptr.i, align 8
  %stack.sp.ptr = getelementptr inbounds i64, i64* %stack, i64 %sp.0
  store i64 %i.1, i64* %stack.sp.ptr, align 8
  %sp.inc = add i64 %sp.0, 1
  br label %outer_continue

inc_i:
  %i.inc = add i64 %i.1, 1
  br label %inner_loop

after_inner:
  %sp.dec = add i64 %sp.0, -1
  br label %outer_continue

outer_continue:
  %sp.next.iter = phi i64 [ %sp.inc, %found ], [ %sp.dec, %after_inner ]
  br label %outer_loop

end:
  call void @free(i8* %raw_vis)
  call void @free(i8* %raw_next)
  call void @free(i8* %raw_stack)
  ret void
}