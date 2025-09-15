; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/4/DFS.ll'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str.pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.elem = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

; Function Attrs: nounwind
define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out_path, i64* %out_count) #0 {
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

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #0

; Function Attrs: nounwind
declare void @free(i8*) #0

define dso_local i32 @main() local_unnamed_addr {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [8 x i64], align 16
  %out_len = alloca i64, align 8
  %adj0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %out0 = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 0
  br label %zero.loop

zero.loop:                                        ; preds = %zero.body, %entry
  %zi = phi i64 [ 0, %entry ], [ %zi.next, %zero.body ]
  %zcmp = icmp ult i64 %zi, 49
  br i1 %zcmp, label %zero.body, label %zero.end

zero.body:                                        ; preds = %zero.loop
  %zptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %zi
  store i32 0, i32* %zptr, align 4
  %zi.next = add i64 %zi, 1
  br label %zero.loop

zero.end:                                         ; preds = %zero.loop
  %p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %p2, align 8
  %p3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %p3, align 8
  %p4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %p4, align 8
  %p5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %p5, align 4
  %p6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %p6, align 4
  %p7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %p7, align 4
  %p8 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %p8, align 4
  %p9 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %p9, align 4
  %p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %p11, align 4
  %p12 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p12, align 4
  store i64 0, i64* %out_len, align 8
  call void @dfs(i32* nonnull %adj0, i64 7, i64 0, i64* nonnull %out0, i64* nonnull %out_len)
  %ph1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0), i64 0)
  br label %print.cond

print.cond:                                       ; preds = %print.body, %zero.end
  %i = phi i64 [ 0, %zero.end ], [ %i.plus1, %print.body ]
  %len.cur = load i64, i64* %out_len, align 8
  %loop.cont = icmp ult i64 %i, %len.cur
  br i1 %loop.cont, label %print.body, label %print.end

print.body:                                       ; preds = %print.cond
  %i.plus1 = add i64 %i, 1
  %has_more = icmp ult i64 %i.plus1, %len.cur
  %delim = select i1 %has_more, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0)
  %val.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %i
  %val = load i64, i64* %val.ptr, align 8
  %ph2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.elem, i64 0, i64 0), i64 %val, i8* %delim)
  br label %print.cond

print.end:                                        ; preds = %print.cond
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

attributes #0 = { nounwind }
