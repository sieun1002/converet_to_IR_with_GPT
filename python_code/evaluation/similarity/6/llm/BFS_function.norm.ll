; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/BFS_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/BFS_function.ll"
target triple = "x86_64-pc-linux-gnu"

declare noalias i8* @malloc(i64)

declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %count) {
entry:
  %n_is_zero = icmp ne i64 %n, 0
  %start_ok = icmp ult i64 %start, %n
  %or.cond = select i1 %n_is_zero, i1 %start_ok, i1 false
  br i1 %or.cond, label %loop_init, label %early_zero

common.ret:                                       ; preds = %done, %early_zero
  ret void

early_zero:                                       ; preds = %after_init, %entry
  store i64 0, i64* %count, align 8
  br label %common.ret

loop_init:                                        ; preds = %entry, %loop_body
  %i = phi i64 [ %i.next, %loop_body ], [ 0, %entry ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %loop_body, label %after_init

loop_body:                                        ; preds = %loop_init
  %gep = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %gep, align 4
  %i.next = add i64 %i, 1
  br label %loop_init

after_init:                                       ; preds = %loop_init
  %size = shl i64 %n, 3
  %mem = call i8* @malloc(i64 %size)
  %q = bitcast i8* %mem to i64*
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %early_zero, label %init_bfs

init_bfs:                                         ; preds = %after_init
  %start_idx_gep = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %start_idx_gep, align 4
  store i64 %start, i64* %q, align 8
  store i64 0, i64* %count, align 8
  br label %bfs_loop

bfs_loop:                                         ; preds = %for_cond, %init_bfs
  %head = phi i64 [ 0, %init_bfs ], [ %head.next, %for_cond ]
  %tail = phi i64 [ 1, %init_bfs ], [ %tail.phi, %for_cond ]
  %cond2 = icmp ult i64 %head, %tail
  br i1 %cond2, label %dequeue, label %done

dequeue:                                          ; preds = %bfs_loop
  %qhepptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %qhepptr, align 8
  %head.next = add i64 %head, 1
  %oldcnt = load i64, i64* %count, align 8
  %newcnt = add i64 %oldcnt, 1
  store i64 %newcnt, i64* %count, align 8
  %outptr = getelementptr inbounds i64, i64* %out, i64 %oldcnt
  store i64 %u, i64* %outptr, align 8
  br label %for_cond

for_cond:                                         ; preds = %for_v_inc, %dequeue
  %v.phi = phi i64 [ 0, %dequeue ], [ %v.next, %for_v_inc ]
  %tail.phi = phi i64 [ %tail, %dequeue ], [ %tail.phi.next, %for_v_inc ]
  %lt = icmp ult i64 %v.phi, %n
  br i1 %lt, label %body_edge, label %bfs_loop

body_edge:                                        ; preds = %for_cond
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v.phi
  %adjptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edgeval = load i32, i32* %adjptr, align 4
  %edge_nonzero.not = icmp eq i32 %edgeval, 0
  br i1 %edge_nonzero.not, label %for_v_inc, label %check_unvisited

check_unvisited:                                  ; preds = %body_edge
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v.phi
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %is_unvisited = icmp eq i32 %dist_v, -1
  br i1 %is_unvisited, label %visit, label %for_v_inc

visit:                                            ; preds = %check_unvisited
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_plus1 = add nsw i32 %dist_u, 1
  store i32 %dist_u_plus1, i32* %dist_v_ptr, align 4
  %tail.enq = add i64 %tail.phi, 1
  %qposptr2 = getelementptr inbounds i64, i64* %q, i64 %tail.phi
  store i64 %v.phi, i64* %qposptr2, align 8
  br label %for_v_inc

for_v_inc:                                        ; preds = %body_edge, %check_unvisited, %visit
  %tail.phi.next = phi i64 [ %tail.enq, %visit ], [ %tail.phi, %check_unvisited ], [ %tail.phi, %body_edge ]
  %v.next = add i64 %v.phi, 1
  br label %for_cond

done:                                             ; preds = %bfs_loop
  call void @free(i8* %mem)
  br label %common.ret
}
