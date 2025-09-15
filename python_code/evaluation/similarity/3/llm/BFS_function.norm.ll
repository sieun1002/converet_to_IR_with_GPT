; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/BFS_function.ll'
source_filename = "bfs_module"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #0

; Function Attrs: nounwind
declare void @free(i8* nocapture) #0

; Function Attrs: nounwind
define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %count) local_unnamed_addr #0 {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_ret0, label %check_start

common.ret:                                       ; preds = %done, %malloc_fail, %early_ret0_2, %early_ret0
  ret void

early_ret0:                                       ; preds = %entry
  store i64 0, i64* %count, align 8
  br label %common.ret

check_start:                                      ; preds = %entry
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %init_loop, label %early_ret0_2

early_ret0_2:                                     ; preds = %check_start
  store i64 0, i64* %count, align 8
  br label %common.ret

init_loop:                                        ; preds = %check_start, %init_body
  %i = phi i64 [ %i.next, %init_body ], [ 0, %check_start ]
  %i_cond = icmp ult i64 %i, %n
  br i1 %i_cond, label %init_body, label %after_init

init_body:                                        ; preds = %init_loop
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop

after_init:                                       ; preds = %init_loop
  %size.bytes = shl i64 %n, 3
  %q.raw = call i8* @malloc(i64 %size.bytes)
  %q = bitcast i8* %q.raw to i64*
  %q.isnull = icmp eq i8* %q.raw, null
  br i1 %q.isnull, label %malloc_fail, label %post_alloc

malloc_fail:                                      ; preds = %after_init
  store i64 0, i64* %count, align 8
  br label %common.ret

post_alloc:                                       ; preds = %after_init
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  store i64 %start, i64* %q, align 8
  store i64 0, i64* %count, align 8
  br label %bfs_loop

bfs_loop:                                         ; preds = %neighbors, %post_alloc
  %head = phi i64 [ 0, %post_alloc ], [ %head.next0, %neighbors ]
  %tail = phi i64 [ 1, %post_alloc ], [ %tail.cur, %neighbors ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %dequeue, label %done

dequeue:                                          ; preds = %bfs_loop
  %u.ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %u.ptr, align 8
  %head.next0 = add i64 %head, 1
  %cnt.old = load i64, i64* %count, align 8
  %out.slot = getelementptr inbounds i64, i64* %out, i64 %cnt.old
  store i64 %u, i64* %out.slot, align 8
  %cnt.new = add i64 %cnt.old, 1
  store i64 %cnt.new, i64* %count, align 8
  br label %neighbors

neighbors:                                        ; preds = %neighbors_latch, %dequeue
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %neighbors_latch ]
  %tail.cur = phi i64 [ %tail, %dequeue ], [ %tail.next, %neighbors_latch ]
  %more_v = icmp ult i64 %v, %n
  br i1 %more_v, label %neighbors_body, label %bfs_loop

neighbors_body:                                   ; preds = %neighbors
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj.zero = icmp eq i32 %adj.val, 0
  br i1 %adj.zero, label %neighbors_latch, label %check_unvis

check_unvis:                                      ; preds = %neighbors_body
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %is_unvis = icmp eq i32 %dist.v, -1
  br i1 %is_unvis, label %visit_neighbor, label %neighbors_latch

visit_neighbor:                                   ; preds = %check_unvis
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.plus1 = add nsw i32 %dist.u, 1
  store i32 %dist.u.plus1, i32* %dist.v.ptr, align 4
  %q.tail.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.cur
  store i64 %v, i64* %q.tail.ptr, align 8
  %tail.inc = add i64 %tail.cur, 1
  br label %neighbors_latch

neighbors_latch:                                  ; preds = %neighbors_body, %check_unvis, %visit_neighbor
  %tail.next = phi i64 [ %tail.inc, %visit_neighbor ], [ %tail.cur, %check_unvis ], [ %tail.cur, %neighbors_body ]
  %v.next = add i64 %v, 1
  br label %neighbors

done:                                             ; preds = %bfs_loop
  call void @free(i8* %q.raw)
  br label %common.ret
}

attributes #0 = { nounwind }
