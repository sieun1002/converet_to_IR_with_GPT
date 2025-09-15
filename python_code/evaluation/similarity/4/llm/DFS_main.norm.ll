; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/DFS_main.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/DFS_main.ll"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #0

; Function Attrs: nounwind
declare void @free(i8*) #0

; Function Attrs: nounwind
define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out_path, i64* %out_count) local_unnamed_addr #0 {
entry:
  %cmp_n0 = icmp ne i64 %n, 0
  %cmp_start.not = icmp ult i64 %start, %n
  %or.cond = select i1 %cmp_n0, i1 %cmp_start.not, i1 false
  br i1 %or.cond, label %allocs, label %zero_ret

zero_ret:                                         ; preds = %entry
  store i64 0, i64* %out_count, align 8
  br label %ret

allocs:                                           ; preds = %entry
  %s1 = shl i64 %n, 2
  %p1 = call noalias i8* @malloc(i64 %s1)
  %v_c = bitcast i8* %p1 to i32*
  %s2 = shl i64 %n, 3
  %p2 = call noalias i8* @malloc(i64 %s2)
  %n_c = bitcast i8* %p2 to i64*
  %p3 = call noalias i8* @malloc(i64 %s2)
  %stk_c = bitcast i8* %p3 to i64*
  %isnull_v = icmp eq i8* %p1, null
  %isnull_n = icmp eq i8* %p2, null
  %isnull_s = icmp eq i8* %p3, null
  %anynull1 = or i1 %isnull_v, %isnull_n
  %anynull = or i1 %anynull1, %isnull_s
  br i1 %anynull, label %free_visited, label %init_loop_cond

free_visited:                                     ; preds = %allocs
  br i1 %isnull_v, label %free_next, label %do_free_v

do_free_v:                                        ; preds = %free_visited
  call void @free(i8* %p1)
  br label %free_next

free_next:                                        ; preds = %do_free_v, %free_visited
  br i1 %isnull_n, label %free_stack, label %do_free_n

do_free_n:                                        ; preds = %free_next
  call void @free(i8* %p2)
  br label %free_stack

free_stack:                                       ; preds = %do_free_n, %free_next
  br i1 %isnull_s, label %after_fail_free, label %do_free_s

do_free_s:                                        ; preds = %free_stack
  call void @free(i8* %p3)
  br label %after_fail_free

after_fail_free:                                  ; preds = %do_free_s, %free_stack
  store i64 0, i64* %out_count, align 8
  br label %ret

init_loop_cond:                                   ; preds = %allocs, %init_loop_body
  %i.0 = phi i64 [ %idx1, %init_loop_body ], [ 0, %allocs ]
  %cond_i = icmp ult i64 %i.0, %n
  br i1 %cond_i, label %init_loop_body, label %after_init

init_loop_body:                                   ; preds = %init_loop_cond
  %vptr_gep = getelementptr i32, i32* %v_c, i64 %i.0
  store i32 0, i32* %vptr_gep, align 4
  %nptr_gep = getelementptr i64, i64* %n_c, i64 %i.0
  store i64 0, i64* %nptr_gep, align 8
  %idx1 = add i64 %i.0, 1
  br label %init_loop_cond

after_init:                                       ; preds = %init_loop_cond
  store i64 0, i64* %out_count, align 8
  store i64 %start, i64* %stk_c, align 8
  %v_gep_s = getelementptr i32, i32* %v_c, i64 %start
  store i32 1, i32* %v_gep_s, align 4
  store i64 %start, i64* %out_path, align 8
  store i64 1, i64* %out_count, align 8
  br label %outer_cond

outer_cond:                                       ; preds = %after_inner, %found_neighbor, %after_init
  %cnt2 = phi i64 [ 1, %after_init ], [ %cnt3, %found_neighbor ], [ %cnt2, %after_inner ]
  %ssz.0 = phi i64 [ 1, %after_init ], [ %ssz_new, %found_neighbor ], [ %ssz_dec1, %after_inner ]
  %has_items.not = icmp eq i64 %ssz.0, 0
  br i1 %has_items.not, label %cleanup, label %outer_body

outer_body:                                       ; preds = %outer_cond
  %ssz_dec1 = add i64 %ssz.0, -1
  %stack_top_ptr = getelementptr i64, i64* %stk_c, i64 %ssz_dec1
  %uval = load i64, i64* %stack_top_ptr, align 8
  %next_u_ptr = getelementptr i64, i64* %n_c, i64 %uval
  %v_from_next = load i64, i64* %next_u_ptr, align 8
  br label %inner_cond

inner_cond:                                       ; preds = %v_inc, %outer_body
  %v.0 = phi i64 [ %v_from_next, %outer_body ], [ %v_next, %v_inc ]
  %v_lt = icmp ult i64 %v.0, %n
  br i1 %v_lt, label %check_neighbor, label %after_inner

check_neighbor:                                   ; preds = %inner_cond
  %mul = mul i64 %uval, %n
  %sum = add i64 %mul, %v.0
  %adj_gep = getelementptr i32, i32* %adj, i64 %sum
  %adj_val = load i32, i32* %adj_gep, align 4
  %adj_zero = icmp eq i32 %adj_val, 0
  br i1 %adj_zero, label %v_inc, label %check_visited

check_visited:                                    ; preds = %check_neighbor
  %v_ptr2 = getelementptr i32, i32* %v_c, i64 %v.0
  %vis_val = load i32, i32* %v_ptr2, align 4
  %is_vis.not = icmp eq i32 %vis_val, 0
  br i1 %is_vis.not, label %found_neighbor, label %v_inc

found_neighbor:                                   ; preds = %check_visited
  %v_plus1 = add i64 %v.0, 1
  store i64 %v_plus1, i64* %next_u_ptr, align 8
  store i32 1, i32* %v_ptr2, align 4
  %opath_ptr2 = getelementptr i64, i64* %out_path, i64 %cnt2
  store i64 %v.0, i64* %opath_ptr2, align 8
  %cnt3 = add i64 %cnt2, 1
  store i64 %cnt3, i64* %out_count, align 8
  %stack_push_ptr = getelementptr i64, i64* %stk_c, i64 %ssz.0
  store i64 %v.0, i64* %stack_push_ptr, align 8
  %ssz_new = add i64 %ssz.0, 1
  br label %outer_cond

v_inc:                                            ; preds = %check_visited, %check_neighbor
  %v_next = add i64 %v.0, 1
  br label %inner_cond

after_inner:                                      ; preds = %inner_cond
  br label %outer_cond

cleanup:                                          ; preds = %outer_cond
  call void @free(i8* %p1)
  call void @free(i8* %p2)
  call void @free(i8* %p3)
  br label %ret

ret:                                              ; preds = %cleanup, %after_fail_free, %zero_ret
  ret void
}

attributes #0 = { nounwind }
