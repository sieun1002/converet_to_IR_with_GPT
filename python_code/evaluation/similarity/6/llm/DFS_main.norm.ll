; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/DFS_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/DFS_main.ll"
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64)

declare void @free(i8* nocapture)

define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %out_len) {
entry:
  %start_ge_n.not = icmp ult i64 %start, %n
  br i1 %start_ge_n.not, label %alloc, label %ret_zero

ret_zero:                                         ; preds = %entry
  store i64 0, i64* %out_len, align 8
  br label %ret

alloc:                                            ; preds = %entry
  %size4 = shl i64 %n, 2
  %m1 = call i8* @malloc(i64 %size4)
  %visited = bitcast i8* %m1 to i32*
  %size8 = shl i64 %n, 3
  %m2 = call i8* @malloc(i64 %size8)
  %next = bitcast i8* %m2 to i64*
  %m3 = call i8* @malloc(i64 %size8)
  %stack = bitcast i8* %m3 to i64*
  %vnull = icmp eq i8* %m1, null
  %nnull = icmp eq i8* %m2, null
  %snull = icmp eq i8* %m3, null
  %tmp_or = or i1 %vnull, %nnull
  %anynull = or i1 %tmp_or, %snull
  br i1 %anynull, label %alloc_fail, label %init_loop

alloc_fail:                                       ; preds = %alloc
  call void @free(i8* %m1)
  call void @free(i8* %m2)
  call void @free(i8* %m3)
  store i64 0, i64* %out_len, align 8
  br label %ret

init_loop:                                        ; preds = %alloc, %init_body
  %i = phi i64 [ %i_next, %init_body ], [ 0, %alloc ]
  %more = icmp ult i64 %i, %n
  br i1 %more, label %init_body, label %after_init

init_body:                                        ; preds = %init_loop
  %v_slot = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %v_slot, align 4
  %ni_slot = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %ni_slot, align 8
  %i_next = add i64 %i, 1
  br label %init_loop

after_init:                                       ; preds = %init_loop
  store i64 0, i64* %out_len, align 8
  store i64 %start, i64* %stack, align 8
  %vis_s = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_s, align 4
  store i64 1, i64* %out_len, align 8
  store i64 %start, i64* %out, align 8
  br label %outer_header

outer_header:                                     ; preds = %after_inner, %after_init
  %stack_size = phi i64 [ 1, %after_init ], [ %spec.select, %after_inner ]
  %has.not = icmp eq i64 %stack_size, 0
  br i1 %has.not, label %cleanup, label %have_stack

have_stack:                                       ; preds = %outer_header
  %ssm1 = add i64 %stack_size, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %ssm1
  %top = load i64, i64* %top_ptr, align 8
  %nxtptr = getelementptr inbounds i64, i64* %next, i64 %top
  %idx0 = load i64, i64* %nxtptr, align 8
  br label %inner_loop

inner_loop:                                       ; preds = %inner_body_failed, %have_stack
  %idx = phi i64 [ %idx0, %have_stack ], [ %idx_inc, %inner_body_failed ]
  %lt = icmp ult i64 %idx, %n
  br i1 %lt, label %inner_body, label %after_inner

inner_body:                                       ; preds = %inner_loop
  %mul = mul i64 %top, %n
  %sum = add i64 %mul, %idx
  %a_ptr = getelementptr inbounds i32, i32* %adj, i64 %sum
  %edge = load i32, i32* %a_ptr, align 4
  %zero = icmp eq i32 %edge, 0
  br i1 %zero, label %inner_body_failed, label %check_vis

inner_body_failed:                                ; preds = %check_vis, %inner_body
  %idx_inc = add i64 %idx, 1
  br label %inner_loop

check_vis:                                        ; preds = %inner_body
  %vptr2 = getelementptr inbounds i32, i32* %visited, i64 %idx
  %vval = load i32, i32* %vptr2, align 4
  %vis0 = icmp eq i32 %vval, 0
  br i1 %vis0, label %found, label %inner_body_failed

found:                                            ; preds = %check_vis
  %idx1 = add i64 %idx, 1
  store i64 %idx1, i64* %nxtptr, align 8
  store i32 1, i32* %vptr2, align 4
  %olen = load i64, i64* %out_len, align 8
  %nlen = add i64 %olen, 1
  store i64 %nlen, i64* %out_len, align 8
  %oslot = getelementptr inbounds i64, i64* %out, i64 %olen
  store i64 %idx, i64* %oslot, align 8
  %push_slot = getelementptr inbounds i64, i64* %stack, i64 %stack_size
  store i64 %idx, i64* %push_slot, align 8
  %ss_push = add i64 %stack_size, 1
  %.pre = add i64 %ss_push, -1
  br label %after_inner

after_inner:                                      ; preds = %inner_loop, %found
  %ss_pop.pre-phi = phi i64 [ %ssm1, %inner_loop ], [ %.pre, %found ]
  %ss_cur = phi i64 [ %ss_push, %found ], [ %stack_size, %inner_loop ]
  %eqn = icmp eq i64 %idx, %n
  %spec.select = select i1 %eqn, i64 %ss_pop.pre-phi, i64 %ss_cur
  br label %outer_header

cleanup:                                          ; preds = %outer_header
  call void @free(i8* %m1)
  call void @free(i8* %m2)
  call void @free(i8* %m3)
  br label %ret

ret:                                              ; preds = %cleanup, %alloc_fail, %ret_zero
  ret void
}
