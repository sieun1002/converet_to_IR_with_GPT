; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/BFS_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/BFS_function.ll"
target triple = "x86_64-unknown-linux-gnu"

declare i8* @malloc(i64)

declare void @free(i8*)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out_order, i64* %out_count) {
entry:
  %cmp_start_ge_n.not = icmp ult i64 %start, %n
  br i1 %cmp_start_ge_n.not, label %ldist.cond, label %early_out

common.ret:                                       ; preds = %bfs.end, %early_out_after_alloc, %early_out
  ret void

early_out:                                        ; preds = %entry
  store i64 0, i64* %out_count, align 8
  br label %common.ret

ldist.cond:                                       ; preds = %entry, %ldist.body
  %i = phi i64 [ %i.next, %ldist.body ], [ 0, %entry ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %ldist.body, label %post_init

ldist.body:                                       ; preds = %ldist.cond
  %dist.gep = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.gep, align 4
  %i.next = add i64 %i, 1
  br label %ldist.cond

post_init:                                        ; preds = %ldist.cond
  %malloc_size = shl i64 %n, 3
  %malloc_ptr = call i8* @malloc(i64 %malloc_size)
  %isnull = icmp eq i8* %malloc_ptr, null
  br i1 %isnull, label %early_out_after_alloc, label %after_alloc

early_out_after_alloc:                            ; preds = %post_init
  store i64 0, i64* %out_count, align 8
  br label %common.ret

after_alloc:                                      ; preds = %post_init
  %queue = bitcast i8* %malloc_ptr to i64*
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  store i64 %start, i64* %queue, align 8
  store i64 0, i64* %out_count, align 8
  br label %bfs.cond

bfs.cond:                                         ; preds = %inner.cond, %after_alloc
  %head = phi i64 [ 0, %after_alloc ], [ %head.next, %inner.cond ]
  %tail = phi i64 [ 1, %after_alloc ], [ %tail.cur, %inner.cond ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %bfs.iter, label %bfs.end

bfs.iter:                                         ; preds = %bfs.cond
  %qpop.ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %qpop.ptr, align 8
  %head.next = add i64 %head, 1
  %count.old = load i64, i64* %out_count, align 8
  %count.next = add i64 %count.old, 1
  store i64 %count.next, i64* %out_count, align 8
  %ord.slot = getelementptr inbounds i64, i64* %out_order, i64 %count.old
  store i64 %u, i64* %ord.slot, align 8
  br label %inner.cond

inner.cond:                                       ; preds = %inner.inc_end, %bfs.iter
  %v = phi i64 [ 0, %bfs.iter ], [ %v.next, %inner.inc_end ]
  %tail.cur = phi i64 [ %tail, %bfs.iter ], [ %tail.updated, %inner.inc_end ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner.body, label %bfs.cond

inner.body:                                       ; preds = %inner.cond
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj.elem.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.elem.ptr, align 4
  %hasEdge.not = icmp eq i32 %adj.val, 0
  br i1 %hasEdge.not, label %inner.inc_end, label %check.unseen

check.unseen:                                     ; preds = %inner.body
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %isUnseen = icmp eq i32 %dist.v, -1
  br i1 %isUnseen, label %visit.enqueue, label %inner.inc_end

visit.enqueue:                                    ; preds = %check.unseen
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.plus1 = add i32 %dist.u, 1
  store i32 %dist.u.plus1, i32* %dist.v.ptr, align 4
  %qtail.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.cur
  store i64 %v, i64* %qtail.ptr, align 8
  %tail.after = add i64 %tail.cur, 1
  br label %inner.inc_end

inner.inc_end:                                    ; preds = %inner.body, %check.unseen, %visit.enqueue
  %tail.updated = phi i64 [ %tail.after, %visit.enqueue ], [ %tail.cur, %check.unseen ], [ %tail.cur, %inner.body ]
  %v.next = add i64 %v, 1
  br label %inner.cond

bfs.end:                                          ; preds = %bfs.cond
  call void @free(i8* %malloc_ptr)
  br label %common.ret
}
