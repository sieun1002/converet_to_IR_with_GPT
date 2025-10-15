; ModuleID = 'dfs_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)

define void @dfs(i32* %arg0, i64 %arg1, i64 %arg2, i64* %arg3, i64* %arg4) {
entry:
  %cmp_n_zero = icmp eq i64 %arg1, 0
  br i1 %cmp_n_zero, label %early, label %check_start

check_start:
  %start_in_range = icmp ult i64 %arg2, %arg1
  br i1 %start_in_range, label %alloc, label %early

early:
  store i64 0, i64* %arg4, align 8
  br label %ret

alloc:
  %size_vis = shl i64 %arg1, 2
  %p_vis_raw = call i8* @malloc(i64 %size_vis)
  %p_vis = bitcast i8* %p_vis_raw to i32*
  %size_q = shl i64 %arg1, 3
  %p_next_raw = call i8* @malloc(i64 %size_q)
  %p_next = bitcast i8* %p_next_raw to i64*
  %p_stack_raw = call i8* @malloc(i64 %size_q)
  %p_stack = bitcast i8* %p_stack_raw to i64*
  %null_vis = icmp eq i8* %p_vis_raw, null
  %null_next = icmp eq i8* %p_next_raw, null
  %null_stack = icmp eq i8* %p_stack_raw, null
  %any_null.tmp = or i1 %null_vis, %null_next
  %any_null = or i1 %any_null.tmp, %null_stack
  br i1 %any_null, label %alloc_fail, label %init

alloc_fail:
  call void @free(i8* %p_vis_raw)
  call void @free(i8* %p_next_raw)
  call void @free(i8* %p_stack_raw)
  store i64 0, i64* %arg4, align 8
  br label %ret

init:
  br label %init_loop

init_loop:
  %i = phi i64 [ 0, %init ], [ %i.next, %init_loop_body ]
  %i_lt_n = icmp ult i64 %i, %arg1
  br i1 %i_lt_n, label %init_loop_body, label %post_init

init_loop_body:
  %vis.ptr = getelementptr inbounds i32, i32* %p_vis, i64 %i
  store i32 0, i32* %vis.ptr, align 4
  %next.ptr = getelementptr inbounds i64, i64* %p_next, i64 %i
  store i64 0, i64* %next.ptr, align 8
  %i.next = add i64 %i, 1
  br label %init_loop

post_init:
  store i64 0, i64* %arg4, align 8
  br label %init_push

init_push:
  %stack.slot0 = getelementptr inbounds i64, i64* %p_stack, i64 0
  store i64 %arg2, i64* %stack.slot0, align 8
  %vis.start.ptr = getelementptr inbounds i32, i32* %p_vis, i64 %arg2
  store i32 1, i32* %vis.start.ptr, align 4
  %cnt.old0 = load i64, i64* %arg4, align 8
  %cnt.new0 = add i64 %cnt.old0, 1
  store i64 %cnt.new0, i64* %arg4, align 8
  %out.ptr0 = getelementptr inbounds i64, i64* %arg3, i64 %cnt.old0
  store i64 %arg2, i64* %out.ptr0, align 8
  br label %loop_header

loop_header:
  %depth = phi i64 [ 1, %init_push ], [ %depth.next.from_take, %take_edge ], [ %depth.next.from_after, %after_neighbors ]
  %depth_nonzero = icmp ne i64 %depth, 0
  br i1 %depth_nonzero, label %iter_begin, label %cleanup

iter_begin:
  %depth.minus1 = add i64 %depth, -1
  %top.ptr = getelementptr inbounds i64, i64* %p_stack, i64 %depth.minus1
  %curr = load i64, i64* %top.ptr, align 8
  %nextidx.ptr = getelementptr inbounds i64, i64* %p_next, i64 %curr
  %neighbor.init = load i64, i64* %nextidx.ptr, align 8
  br label %neighbor_loop_header

neighbor_loop_header:
  %neighbor = phi i64 [ %neighbor.init, %iter_begin ], [ %neighbor.inc, %neighbor_advance ]
  %neighbor_lt_n = icmp ult i64 %neighbor, %arg1
  br i1 %neighbor_lt_n, label %neighbor_try, label %after_neighbors

neighbor_try:
  %mul.cn = mul i64 %curr, %arg1
  %idx.adj = add i64 %mul.cn, %neighbor
  %adj.ptr = getelementptr inbounds i32, i32* %arg0, i64 %idx.adj
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj.zero = icmp eq i32 %adj.val, 0
  br i1 %adj.zero, label %neighbor_advance, label %check_visited

check_visited:
  %vis.nei.ptr = getelementptr inbounds i32, i32* %p_vis, i64 %neighbor
  %vis.nei.val = load i32, i32* %vis.nei.ptr, align 4
  %visited_nonzero = icmp ne i32 %vis.nei.val, 0
  br i1 %visited_nonzero, label %neighbor_advance, label %take_edge

neighbor_advance:
  %neighbor.inc = add i64 %neighbor, 1
  br label %neighbor_loop_header

take_edge:
  %neighbor.plus1 = add i64 %neighbor, 1
  store i64 %neighbor.plus1, i64* %nextidx.ptr, align 8
  store i32 1, i32* %vis.nei.ptr, align 4
  %cnt.old = load i64, i64* %arg4, align 8
  %cnt.new = add i64 %cnt.old, 1
  store i64 %cnt.new, i64* %arg4, align 8
  %out.ptr = getelementptr inbounds i64, i64* %arg3, i64 %cnt.old
  store i64 %neighbor, i64* %out.ptr, align 8
  %stack.push.ptr = getelementptr inbounds i64, i64* %p_stack, i64 %depth
  store i64 %neighbor, i64* %stack.push.ptr, align 8
  %depth.next.from_take = add i64 %depth, 1
  br label %loop_header

after_neighbors:
  %depth.next.from_after = add i64 %depth, -1
  br label %loop_header

cleanup:
  call void @free(i8* %p_vis_raw)
  call void @free(i8* %p_next_raw)
  call void @free(i8* %p_stack_raw)
  br label %ret

ret:
  ret void
}