; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/BFS_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/BFS_function.ll"
target triple = "x86_64-pc-linux-gnu"

declare i8* @malloc(i64)

declare void @free(i8*)

define void @bfs(i32* readonly %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %outCount) local_unnamed_addr {
entry:
  %start_ge_n.not = icmp ult i64 %start, %n
  br i1 %start_ge_n.not, label %dist_loop, label %ret_zero

common.ret:                                       ; preds = %done, %ret_zero2, %ret_zero
  ret void

ret_zero:                                         ; preds = %entry
  store i64 0, i64* %outCount, align 8
  br label %common.ret

dist_loop:                                        ; preds = %entry, %dist_loop_body
  %i = phi i64 [ %i.next, %dist_loop_body ], [ 0, %entry ]
  %loop_cond = icmp ult i64 %i, %n
  br i1 %loop_cond, label %dist_loop_body, label %post_init_dist

dist_loop_body:                                   ; preds = %dist_loop
  %dist.ptr.i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.ptr.i, align 4
  %i.next = add i64 %i, 1
  br label %dist_loop

post_init_dist:                                   ; preds = %dist_loop
  %size = shl i64 %n, 3
  %qmem = call i8* @malloc(i64 %size)
  %queue = bitcast i8* %qmem to i64*
  %qnull = icmp eq i8* %qmem, null
  br i1 %qnull, label %ret_zero2, label %setup

ret_zero2:                                        ; preds = %post_init_dist
  store i64 0, i64* %outCount, align 8
  br label %common.ret

setup:                                            ; preds = %post_init_dist
  %start.dist.ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %start.dist.ptr, align 4
  store i64 %start, i64* %queue, align 8
  store i64 0, i64* %outCount, align 8
  br label %bfs_outer

bfs_outer:                                        ; preds = %nbr_loop, %setup
  %front = phi i64 [ 0, %setup ], [ %front.inc, %nbr_loop ]
  %back = phi i64 [ 1, %setup ], [ %back.cur, %nbr_loop ]
  %has = icmp ult i64 %front, %back
  br i1 %has, label %dequeue, label %done

dequeue:                                          ; preds = %bfs_outer
  %q.front.ptr = getelementptr inbounds i64, i64* %queue, i64 %front
  %v = load i64, i64* %q.front.ptr, align 8
  %front.inc = add i64 %front, 1
  %count.old = load i64, i64* %outCount, align 8
  %count.new = add i64 %count.old, 1
  store i64 %count.new, i64* %outCount, align 8
  %out.ptr = getelementptr inbounds i64, i64* %out, i64 %count.old
  store i64 %v, i64* %out.ptr, align 8
  br label %nbr_loop

nbr_loop:                                         ; preds = %nbr_iter_end, %dequeue
  %j = phi i64 [ 0, %dequeue ], [ %j.next, %nbr_iter_end ]
  %back.cur = phi i64 [ %back, %dequeue ], [ %back.next.iter, %nbr_iter_end ]
  %j.cond = icmp ult i64 %j, %n
  br i1 %j.cond, label %nbr_check_edge, label %bfs_outer

nbr_check_edge:                                   ; preds = %nbr_loop
  %row.mul = mul i64 %v, %n
  %idx.adj = add i64 %row.mul, %j
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx.adj
  %adj.val = load i32, i32* %adj.ptr, align 4
  %is_edge.not = icmp eq i32 %adj.val, 0
  br i1 %is_edge.not, label %nbr_iter_end, label %maybe_visit

maybe_visit:                                      ; preds = %nbr_check_edge
  %dist.j.ptr = getelementptr inbounds i32, i32* %dist, i64 %j
  %dist.j.val = load i32, i32* %dist.j.ptr, align 4
  %unvisited = icmp eq i32 %dist.j.val, -1
  br i1 %unvisited, label %visit, label %nbr_iter_end

visit:                                            ; preds = %maybe_visit
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist.v.val = load i32, i32* %dist.v.ptr, align 4
  %dist.v.plus1 = add i32 %dist.v.val, 1
  store i32 %dist.v.plus1, i32* %dist.j.ptr, align 4
  %q.enq.ptr = getelementptr inbounds i64, i64* %queue, i64 %back.cur
  store i64 %j, i64* %q.enq.ptr, align 8
  %back.inc = add i64 %back.cur, 1
  br label %nbr_iter_end

nbr_iter_end:                                     ; preds = %visit, %maybe_visit, %nbr_check_edge
  %back.next.iter = phi i64 [ %back.inc, %visit ], [ %back.cur, %maybe_visit ], [ %back.cur, %nbr_check_edge ]
  %j.next = add i64 %j, 1
  br label %nbr_loop

done:                                             ; preds = %bfs_outer
  call void @free(i8* %qmem)
  br label %common.ret
}
