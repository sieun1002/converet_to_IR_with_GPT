; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/BFS_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/BFS_function.ll"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #0

; Function Attrs: nounwind
declare void @free(i8*) #0

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %visited_out, i64* %visited_count_ptr) local_unnamed_addr {
entry:
  %cmp_n_zero = icmp ne i64 %n, 0
  %start_in_range = icmp ult i64 %start, %n
  %or.cond = select i1 %cmp_n_zero, i1 %start_in_range, i1 false
  br i1 %or.cond, label %init_dist.loop, label %early

common.ret:                                       ; preds = %outer.exit, %early
  ret void

early:                                            ; preds = %post_init, %entry
  store i64 0, i64* %visited_count_ptr, align 8
  br label %common.ret

init_dist.loop:                                   ; preds = %entry, %init_dist.loop.body
  %i.phi = phi i64 [ %i.next, %init_dist.loop.body ], [ 0, %entry ]
  %i.cmp = icmp ult i64 %i.phi, %n
  br i1 %i.cmp, label %init_dist.loop.body, label %post_init

init_dist.loop.body:                              ; preds = %init_dist.loop
  %dist.gep = getelementptr inbounds i32, i32* %dist, i64 %i.phi
  store i32 -1, i32* %dist.gep, align 4
  %i.next = add i64 %i.phi, 1
  br label %init_dist.loop

post_init:                                        ; preds = %init_dist.loop
  %size_bytes = shl i64 %n, 3
  %q.raw = call noalias i8* @malloc(i64 %size_bytes)
  %q.null = icmp eq i8* %q.raw, null
  br i1 %q.null, label %early, label %setup

setup:                                            ; preds = %post_init
  %queue = bitcast i8* %q.raw to i64*
  %dist.start.gep = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist.start.gep, align 4
  store i64 %start, i64* %queue, align 8
  store i64 0, i64* %visited_count_ptr, align 8
  br label %outer.header

outer.header:                                     ; preds = %inner.header, %setup
  %head.phi = phi i64 [ 0, %setup ], [ %head.next, %inner.header ]
  %tail.phi = phi i64 [ 1, %setup ], [ %tail.inner.phi, %inner.header ]
  %has_items = icmp ult i64 %head.phi, %tail.phi
  br i1 %has_items, label %outer.body, label %outer.exit

outer.body:                                       ; preds = %outer.header
  %q.deq.ptr = getelementptr inbounds i64, i64* %queue, i64 %head.phi
  %u = load i64, i64* %q.deq.ptr, align 8
  %head.next = add i64 %head.phi, 1
  %vis.old = load i64, i64* %visited_count_ptr, align 8
  %vis.next = add i64 %vis.old, 1
  store i64 %vis.next, i64* %visited_count_ptr, align 8
  %vis.out.ptr = getelementptr inbounds i64, i64* %visited_out, i64 %vis.old
  store i64 %u, i64* %vis.out.ptr, align 8
  br label %inner.header

inner.header:                                     ; preds = %inner.latch, %outer.body
  %j.phi = phi i64 [ 0, %outer.body ], [ %j.next, %inner.latch ]
  %tail.inner.phi = phi i64 [ %tail.phi, %outer.body ], [ %tail.inner.next, %inner.latch ]
  %j.cmp = icmp ult i64 %j.phi, %n
  br i1 %j.cmp, label %inner.body, label %outer.header

inner.body:                                       ; preds = %inner.header
  %u_times_n = mul i64 %u, %n
  %idx = add i64 %u_times_n, %j.phi
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj.nonzero.not = icmp eq i32 %adj.val, 0
  br i1 %adj.nonzero.not, label %inner.latch, label %check.unvisited

check.unvisited:                                  ; preds = %inner.body
  %dist.j.ptr = getelementptr inbounds i32, i32* %dist, i64 %j.phi
  %dist.j.val = load i32, i32* %dist.j.ptr, align 4
  %is.unvisited = icmp eq i32 %dist.j.val, -1
  br i1 %is.unvisited, label %visit.enqueue, label %inner.latch

visit.enqueue:                                    ; preds = %check.unvisited
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist.u.val = load i32, i32* %dist.u.ptr, align 4
  %dist.u.plus1 = add i32 %dist.u.val, 1
  store i32 %dist.u.plus1, i32* %dist.j.ptr, align 4
  %q.enq2.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.inner.phi
  store i64 %j.phi, i64* %q.enq2.ptr, align 8
  %tail.enq.next = add i64 %tail.inner.phi, 1
  br label %inner.latch

inner.latch:                                      ; preds = %inner.body, %check.unvisited, %visit.enqueue
  %tail.inner.next = phi i64 [ %tail.enq.next, %visit.enqueue ], [ %tail.inner.phi, %check.unvisited ], [ %tail.inner.phi, %inner.body ]
  %j.next = add i64 %j.phi, 1
  br label %inner.header

outer.exit:                                       ; preds = %outer.header
  call void @free(i8* %q.raw)
  br label %common.ret
}

attributes #0 = { nounwind }
