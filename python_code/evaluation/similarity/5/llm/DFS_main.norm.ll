; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/DFS_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/DFS_main.ll"
target triple = "x86_64-pc-linux-gnu"

declare i8* @malloc(i64)

declare void @free(i8*)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_count_ptr) {
entry:
  %cmp_n_zero = icmp ne i64 %n, 0
  %start_ge_n.not = icmp ult i64 %start, %n
  %or.cond = select i1 %cmp_n_zero, i1 %start_ge_n.not, i1 false
  br i1 %or.cond, label %allocs, label %early_return

common.ret:                                       ; preds = %cleanup, %alloc_fail, %early_return
  ret void

early_return:                                     ; preds = %entry
  store i64 0, i64* %out_count_ptr, align 8
  br label %common.ret

allocs:                                           ; preds = %entry
  %size_visit_bytes = shl i64 %n, 2
  %malloc_visit_raw = call i8* @malloc(i64 %size_visit_bytes)
  %malloc_visit = bitcast i8* %malloc_visit_raw to i32*
  %size_next_bytes = shl i64 %n, 3
  %malloc_next_raw = call i8* @malloc(i64 %size_next_bytes)
  %malloc_next = bitcast i8* %malloc_next_raw to i64*
  %malloc_stack_raw = call i8* @malloc(i64 %size_next_bytes)
  %malloc_stack = bitcast i8* %malloc_stack_raw to i64*
  %vis_is_null = icmp eq i8* %malloc_visit_raw, null
  %next_is_null = icmp eq i8* %malloc_next_raw, null
  %stack_is_null = icmp eq i8* %malloc_stack_raw, null
  %any_null_tmp = or i1 %vis_is_null, %next_is_null
  %any_null = or i1 %any_null_tmp, %stack_is_null
  br i1 %any_null, label %alloc_fail, label %init.loop

alloc_fail:                                       ; preds = %allocs
  call void @free(i8* %malloc_visit_raw)
  call void @free(i8* %malloc_next_raw)
  call void @free(i8* %malloc_stack_raw)
  store i64 0, i64* %out_count_ptr, align 8
  br label %common.ret

init.loop:                                        ; preds = %allocs, %init.body
  %i.var.0 = phi i64 [ %i.next, %init.body ], [ 0, %allocs ]
  %i.lt.n = icmp ult i64 %i.var.0, %n
  br i1 %i.lt.n, label %init.body, label %after.init

init.body:                                        ; preds = %init.loop
  %vis.gep = getelementptr inbounds i32, i32* %malloc_visit, i64 %i.var.0
  store i32 0, i32* %vis.gep, align 4
  %next.gep = getelementptr inbounds i64, i64* %malloc_next, i64 %i.var.0
  store i64 0, i64* %next.gep, align 8
  %i.next = add i64 %i.var.0, 1
  br label %init.loop

after.init:                                       ; preds = %init.loop
  store i64 0, i64* %out_count_ptr, align 8
  store i64 %start, i64* %malloc_stack, align 8
  %vis.start.ptr = getelementptr inbounds i32, i32* %malloc_visit, i64 %start
  store i32 1, i32* %vis.start.ptr, align 4
  %outcnt.old0 = load i64, i64* %out_count_ptr, align 8
  %out.slot0 = getelementptr inbounds i64, i64* %out, i64 %outcnt.old0
  store i64 %start, i64* %out.slot0, align 8
  %outcnt.new0 = add i64 %outcnt.old0, 1
  store i64 %outcnt.new0, i64* %out_count_ptr, align 8
  br label %main.loop

main.loop:                                        ; preds = %no.more.neighbors, %found.neighbor, %after.init
  %stack.size.0 = phi i64 [ 1, %after.init ], [ %ssz.new1, %found.neighbor ], [ %ssz.minus1, %no.more.neighbors ]
  %ssz.nonzero.not = icmp eq i64 %stack.size.0, 0
  br i1 %ssz.nonzero.not, label %cleanup, label %process.frame

process.frame:                                    ; preds = %main.loop
  %ssz.minus1 = add i64 %stack.size.0, -1
  %top.ptr = getelementptr inbounds i64, i64* %malloc_stack, i64 %ssz.minus1
  %u.val = load i64, i64* %top.ptr, align 8
  %next.u.ptr = getelementptr inbounds i64, i64* %malloc_next, i64 %u.val
  %v.start = load i64, i64* %next.u.ptr, align 8
  br label %neighbor.loop

neighbor.loop:                                    ; preds = %inc.v, %process.frame
  %v.var.0 = phi i64 [ %v.start, %process.frame ], [ %v.next, %inc.v ]
  %v.lt.n = icmp ult i64 %v.var.0, %n
  br i1 %v.lt.n, label %check.edge, label %no.more.neighbors

check.edge:                                       ; preds = %neighbor.loop
  %mul.un = mul i64 %u.val, %n
  %adj.idx = add i64 %mul.un, %v.var.0
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %adj.idx
  %edge.val = load i32, i32* %adj.ptr, align 4
  %edge.zero = icmp eq i32 %edge.val, 0
  br i1 %edge.zero, label %inc.v, label %check.visited

check.visited:                                    ; preds = %check.edge
  %vis.v.ptr = getelementptr inbounds i32, i32* %malloc_visit, i64 %v.var.0
  %vis.v = load i32, i32* %vis.v.ptr, align 4
  %vis.nonzero.not = icmp eq i32 %vis.v, 0
  br i1 %vis.nonzero.not, label %found.neighbor, label %inc.v

inc.v:                                            ; preds = %check.visited, %check.edge
  %v.next = add i64 %v.var.0, 1
  br label %neighbor.loop

found.neighbor:                                   ; preds = %check.visited
  %v.plus1 = add i64 %v.var.0, 1
  store i64 %v.plus1, i64* %next.u.ptr, align 8
  store i32 1, i32* %vis.v.ptr, align 4
  %outcnt.old1 = load i64, i64* %out_count_ptr, align 8
  %out.slot1 = getelementptr inbounds i64, i64* %out, i64 %outcnt.old1
  store i64 %v.var.0, i64* %out.slot1, align 8
  %outcnt.new1 = add i64 %outcnt.old1, 1
  store i64 %outcnt.new1, i64* %out_count_ptr, align 8
  %stack.slot1 = getelementptr inbounds i64, i64* %malloc_stack, i64 %stack.size.0
  store i64 %v.var.0, i64* %stack.slot1, align 8
  %ssz.new1 = add i64 %stack.size.0, 1
  br label %main.loop

no.more.neighbors:                                ; preds = %neighbor.loop
  br label %main.loop

cleanup:                                          ; preds = %main.loop
  call void @free(i8* %malloc_visit_raw)
  call void @free(i8* %malloc_next_raw)
  call void @free(i8* %malloc_stack_raw)
  br label %common.ret
}
