; ModuleID = 'DFS.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str.pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.elem = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

; Function Attrs: nounwind
define void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out_path, i64* %out_count) #0 {
entry:
  %visited.ptr = alloca i32*, align 8
  %next.ptr = alloca i64*, align 8
  %stack.ptr = alloca i64*, align 8
  %ssz = alloca i64, align 8
  %i = alloca i64, align 8
  %u = alloca i64, align 8
  %v = alloca i64, align 8
  %cmp_n0 = icmp eq i64 %n, 0
  br i1 %cmp_n0, label %zero_ret, label %check_start

check_start:                                      ; preds = %entry
  %cmp_start = icmp uge i64 %start, %n
  br i1 %cmp_start, label %zero_ret, label %allocs

zero_ret:                                         ; preds = %check_start, %entry
  store i64 0, i64* %out_count, align 8
  br label %ret

allocs:                                           ; preds = %check_start
  %s1 = shl i64 %n, 2
  %p1 = call noalias i8* @malloc(i64 %s1)
  %v_c = bitcast i8* %p1 to i32*
  store i32* %v_c, i32** %visited.ptr, align 8
  %s2 = shl i64 %n, 3
  %p2 = call noalias i8* @malloc(i64 %s2)
  %n_c = bitcast i8* %p2 to i64*
  store i64* %n_c, i64** %next.ptr, align 8
  %s3 = shl i64 %n, 3
  %p3 = call noalias i8* @malloc(i64 %s3)
  %stk_c = bitcast i8* %p3 to i64*
  store i64* %stk_c, i64** %stack.ptr, align 8
  %visited_loaded = load i32*, i32** %visited.ptr, align 8
  %isnull_v = icmp eq i32* %visited_loaded, null
  %next_loaded = load i64*, i64** %next.ptr, align 8
  %isnull_n = icmp eq i64* %next_loaded, null
  %stack_loaded = load i64*, i64** %stack.ptr, align 8
  %isnull_s = icmp eq i64* %stack_loaded, null
  %anynull1 = or i1 %isnull_v, %isnull_n
  %anynull = or i1 %anynull1, %isnull_s
  br i1 %anynull, label %alloc_fail, label %init_loop_init

alloc_fail:                                       ; preds = %allocs
  br label %free_visited

free_visited:                                     ; preds = %alloc_fail
  %vptr1 = load i32*, i32** %visited.ptr, align 8
  %isnull_v2 = icmp eq i32* %vptr1, null
  br i1 %isnull_v2, label %free_next, label %do_free_v

do_free_v:                                        ; preds = %free_visited
  %vptr1_i8 = bitcast i32* %vptr1 to i8*
  call void @free(i8* %vptr1_i8)
  br label %free_next

free_next:                                        ; preds = %do_free_v, %free_visited
  %nptr1 = load i64*, i64** %next.ptr, align 8
  %isnull_n2 = icmp eq i64* %nptr1, null
  br i1 %isnull_n2, label %free_stack, label %do_free_n

do_free_n:                                        ; preds = %free_next
  %nptr1_i8 = bitcast i64* %nptr1 to i8*
  call void @free(i8* %nptr1_i8)
  br label %free_stack

free_stack:                                       ; preds = %do_free_n, %free_next
  %sptr1 = load i64*, i64** %stack.ptr, align 8
  %isnull_s2 = icmp eq i64* %sptr1, null
  br i1 %isnull_s2, label %after_fail_free, label %do_free_s

do_free_s:                                        ; preds = %free_stack
  %sptr1_i8 = bitcast i64* %sptr1 to i8*
  call void @free(i8* %sptr1_i8)
  br label %after_fail_free

after_fail_free:                                  ; preds = %do_free_s, %free_stack
  store i64 0, i64* %out_count, align 8
  br label %ret

init_loop_init:                                   ; preds = %allocs
  store i64 0, i64* %i, align 8
  br label %init_loop_cond

init_loop_cond:                                   ; preds = %init_loop_body, %init_loop_init
  %idx = load i64, i64* %i, align 8
  %cond_i = icmp ult i64 %idx, %n
  br i1 %cond_i, label %init_loop_body, label %after_init

init_loop_body:                                   ; preds = %init_loop_cond
  %vbase = load i32*, i32** %visited.ptr, align 8
  %vptr_gep = getelementptr i32, i32* %vbase, i64 %idx
  store i32 0, i32* %vptr_gep, align 4
  %nbase2 = load i64*, i64** %next.ptr, align 8
  %nptr_gep = getelementptr i64, i64* %nbase2, i64 %idx
  store i64 0, i64* %nptr_gep, align 8
  %idx1 = add i64 %idx, 1
  store i64 %idx1, i64* %i, align 8
  br label %init_loop_cond

after_init:                                       ; preds = %init_loop_cond
  store i64 0, i64* %ssz, align 8
  store i64 0, i64* %out_count, align 8
  %ssz0 = load i64, i64* %ssz, align 8
  %stack_base = load i64*, i64** %stack.ptr, align 8
  %stack_gep = getelementptr i64, i64* %stack_base, i64 %ssz0
  store i64 %start, i64* %stack_gep, align 8
  %ssz1 = add i64 %ssz0, 1
  store i64 %ssz1, i64* %ssz, align 8
  %vbase2 = load i32*, i32** %visited.ptr, align 8
  %v_gep_s = getelementptr i32, i32* %vbase2, i64 %start
  store i32 1, i32* %v_gep_s, align 4
  %cnt0 = load i64, i64* %out_count, align 8
  %opath_gep0 = getelementptr i64, i64* %out_path, i64 %cnt0
  store i64 %start, i64* %opath_gep0, align 8
  %cnt1 = add i64 %cnt0, 1
  store i64 %cnt1, i64* %out_count, align 8
  br label %outer_cond

outer_cond:                                       ; preds = %after_inner, %found_neighbor, %after_init
  %ssz_load = load i64, i64* %ssz, align 8
  %has_items = icmp ne i64 %ssz_load, 0
  br i1 %has_items, label %outer_body, label %cleanup

outer_body:                                       ; preds = %outer_cond
  %ssz_dec1 = add i64 %ssz_load, -1
  %stack_base2 = load i64*, i64** %stack.ptr, align 8
  %stack_top_ptr = getelementptr i64, i64* %stack_base2, i64 %ssz_dec1
  %uval = load i64, i64* %stack_top_ptr, align 8
  store i64 %uval, i64* %u, align 8
  %next_base3 = load i64*, i64** %next.ptr, align 8
  %next_u_ptr = getelementptr i64, i64* %next_base3, i64 %uval
  %v_from_next = load i64, i64* %next_u_ptr, align 8
  store i64 %v_from_next, i64* %v, align 8
  br label %inner_cond

inner_cond:                                       ; preds = %v_inc, %outer_body
  %v_cur = load i64, i64* %v, align 8
  %v_lt = icmp ult i64 %v_cur, %n
  br i1 %v_lt, label %check_neighbor, label %after_inner

check_neighbor:                                   ; preds = %inner_cond
  %mul = mul i64 %uval, %n
  %sum = add i64 %mul, %v_cur
  %adj_gep = getelementptr i32, i32* %adj, i64 %sum
  %adj_val = load i32, i32* %adj_gep, align 4
  %adj_zero = icmp eq i32 %adj_val, 0
  br i1 %adj_zero, label %v_inc, label %check_visited

check_visited:                                    ; preds = %check_neighbor
  %vbase3 = load i32*, i32** %visited.ptr, align 8
  %v_ptr2 = getelementptr i32, i32* %vbase3, i64 %v_cur
  %vis_val = load i32, i32* %v_ptr2, align 4
  %is_vis = icmp ne i32 %vis_val, 0
  br i1 %is_vis, label %v_inc, label %found_neighbor

found_neighbor:                                   ; preds = %check_visited
  %v_plus1 = add i64 %v_cur, 1
  store i64 %v_plus1, i64* %next_u_ptr, align 8
  store i32 1, i32* %v_ptr2, align 4
  %cnt2 = load i64, i64* %out_count, align 8
  %opath_ptr2 = getelementptr i64, i64* %out_path, i64 %cnt2
  store i64 %v_cur, i64* %opath_ptr2, align 8
  %cnt3 = add i64 %cnt2, 1
  store i64 %cnt3, i64* %out_count, align 8
  %ssz_curr = load i64, i64* %ssz, align 8
  %stack_push_ptr = getelementptr i64, i64* %stack_base2, i64 %ssz_curr
  store i64 %v_cur, i64* %stack_push_ptr, align 8
  %ssz_new = add i64 %ssz_curr, 1
  store i64 %ssz_new, i64* %ssz, align 8
  br label %outer_cond

v_inc:                                            ; preds = %check_visited, %check_neighbor
  %v_next = add i64 %v_cur, 1
  store i64 %v_next, i64* %v, align 8
  br label %inner_cond

after_inner:                                      ; preds = %inner_cond
  %ssz_pop = add i64 %ssz_load, -1
  store i64 %ssz_pop, i64* %ssz, align 8
  br label %outer_cond

cleanup:                                          ; preds = %outer_cond
  %vptr_free = load i32*, i32** %visited.ptr, align 8
  %vptr_free_i8 = bitcast i32* %vptr_free to i8*
  call void @free(i8* %vptr_free_i8)
  %nptr_free = load i64*, i64** %next.ptr, align 8
  %nptr_free_i8 = bitcast i64* %nptr_free to i8*
  call void @free(i8* %nptr_free_i8)
  %sptr_free = load i64*, i64** %stack.ptr, align 8
  %sptr_free_i8 = bitcast i64* %sptr_free to i8*
  call void @free(i8* %sptr_free_i8)
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
  %total = mul i64 7, 7
  br label %zero.loop

zero.loop:                                        ; preds = %zero.body, %entry
  %zi = phi i64 [ 0, %entry ], [ %zi.next, %zero.body ]
  %zcmp = icmp ult i64 %zi, %total
  br i1 %zcmp, label %zero.body, label %zero.end

zero.body:                                        ; preds = %zero.loop
  %zptr = getelementptr inbounds i32, i32* %adj0, i64 %zi
  store i32 0, i32* %zptr, align 4
  %zi.next = add i64 %zi, 1
  br label %zero.loop

zero.end:                                         ; preds = %zero.loop
  %twoN = add i64 7, 7
  %threeN = add i64 %twoN, 7
  %fourN = shl i64 7, 2
  %fiveN = add i64 %fourN, 7
  %sixN = add i64 %threeN, %threeN
  %idx1 = mul i64 7, 1
  %p1 = getelementptr inbounds i32, i32* %adj0, i64 %idx1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %adj0, i64 %twoN
  store i32 1, i32* %p2, align 4
  %idx3 = add i64 7, 3
  %p3 = getelementptr inbounds i32, i32* %adj0, i64 %idx3
  store i32 1, i32* %p3, align 4
  %idx4 = add i64 %threeN, 1
  %p4 = getelementptr inbounds i32, i32* %adj0, i64 %idx4
  store i32 1, i32* %p4, align 4
  %idx5 = add i64 7, 4
  %p5 = getelementptr inbounds i32, i32* %adj0, i64 %idx5
  store i32 1, i32* %p5, align 4
  %idx6 = add i64 %fourN, 1
  %p6 = getelementptr inbounds i32, i32* %adj0, i64 %idx6
  store i32 1, i32* %p6, align 4
  %idx7 = add i64 %twoN, 5
  %p7 = getelementptr inbounds i32, i32* %adj0, i64 %idx7
  store i32 1, i32* %p7, align 4
  %idx8 = add i64 %fiveN, 2
  %p8 = getelementptr inbounds i32, i32* %adj0, i64 %idx8
  store i32 1, i32* %p8, align 4
  %idx9 = add i64 %fourN, 5
  %p9 = getelementptr inbounds i32, i32* %adj0, i64 %idx9
  store i32 1, i32* %p9, align 4
  %idx10 = add i64 %fiveN, 4
  %p10 = getelementptr inbounds i32, i32* %adj0, i64 %idx10
  store i32 1, i32* %p10, align 4
  %idx11 = add i64 %fiveN, 6
  %p11 = getelementptr inbounds i32, i32* %adj0, i64 %idx11
  store i32 1, i32* %p11, align 4
  %idx12 = add i64 %sixN, 5
  %p12 = getelementptr inbounds i32, i32* %adj0, i64 %idx12
  store i32 1, i32* %p12, align 4
  store i64 0, i64* %out_len, align 8
  call void @dfs(i32* %adj0, i64 7, i64 0, i64* %out0, i64* %out_len)
  %fmt1 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.pre, i64 0, i64 0
  %ph1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 0)
  br label %print.cond

print.cond:                                       ; preds = %print.body, %zero.end
  %i = phi i64 [ 0, %zero.end ], [ %i.next, %print.body ]
  %len.cur = load i64, i64* %out_len, align 8
  %loop.cont = icmp ult i64 %i, %len.cur
  br i1 %loop.cont, label %print.body, label %print.end

print.body:                                       ; preds = %print.cond
  %i.plus1 = add i64 %i, 1
  %len.cur2 = load i64, i64* %out_len, align 8
  %has_more = icmp ult i64 %i.plus1, %len.cur2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %delim = select i1 %has_more, i8* %space.ptr, i8* %empty.ptr
  %val.ptr = getelementptr inbounds [8 x i64], [8 x i64]* %out, i64 0, i64 %i
  %val = load i64, i64* %val.ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.elem, i64 0, i64 0
  %ph2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %val, i8* %delim)
  %i.next = add i64 %i, 1
  br label %print.cond

print.end:                                        ; preds = %print.cond
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

attributes #0 = { nounwind }
