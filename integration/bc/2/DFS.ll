; ModuleID = 'DFS.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str_dfs = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_elem = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

define void @dfs(i32* nocapture readonly %matrix, i64 %n, i64 %start, i64* nocapture %out, i64* nocapture %countp) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

early_zero:                                       ; preds = %entry
  store i64 0, i64* %countp, align 8
  ret void

check_start:                                      ; preds = %entry
  %start_ge_n = icmp uge i64 %start, %n
  br i1 %start_ge_n, label %early_zero2, label %alloc

early_zero2:                                      ; preds = %check_start
  store i64 0, i64* %countp, align 8
  ret void

alloc:                                            ; preds = %check_start
  %size_vis = mul i64 %n, 4
  %raw_vis = call i8* @malloc(i64 %size_vis)
  %vis = bitcast i8* %raw_vis to i32*
  %size64 = mul i64 %n, 8
  %raw_next = call i8* @malloc(i64 %size64)
  %next = bitcast i8* %raw_next to i64*
  %raw_stack = call i8* @malloc(i64 %size64)
  %stack = bitcast i8* %raw_stack to i64*
  %vis_null = icmp eq i32* %vis, null
  %next_null = icmp eq i64* %next, null
  %stack_null = icmp eq i64* %stack, null
  %any_null_tmp = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null_tmp, %stack_null
  br i1 %any_null, label %malloc_fail, label %init_i

malloc_fail:                                      ; preds = %alloc
  br i1 %vis_null, label %skip_free_vis, label %free_vis

free_vis:                                         ; preds = %malloc_fail
  %vis_bc = bitcast i32* %vis to i8*
  call void @free(i8* %vis_bc)
  br label %skip_free_vis

skip_free_vis:                                    ; preds = %free_vis, %malloc_fail
  br i1 %next_null, label %skip_free_next, label %free_next

free_next:                                        ; preds = %skip_free_vis
  %next_bc = bitcast i64* %next to i8*
  call void @free(i8* %next_bc)
  br label %skip_free_next

skip_free_next:                                   ; preds = %free_next, %skip_free_vis
  br i1 %stack_null, label %after_free_all, label %free_stack

free_stack:                                       ; preds = %skip_free_next
  %stack_bc = bitcast i64* %stack to i8*
  call void @free(i8* %stack_bc)
  br label %after_free_all

after_free_all:                                   ; preds = %free_stack, %skip_free_next
  store i64 0, i64* %countp, align 8
  ret void

init_i:                                           ; preds = %alloc
  br label %init_header

init_header:                                      ; preds = %init_body, %init_i
  %i = phi i64 [ 0, %init_i ], [ %i_next, %init_body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %init_body, label %after_init

init_body:                                        ; preds = %init_header
  %vis_ptr = getelementptr inbounds i32, i32* %vis, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr0 = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr0, align 8
  %i_next = add i64 %i, 1
  br label %init_header

after_init:                                       ; preds = %init_header
  store i64 0, i64* %countp, align 8
  %stack_ptr0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_ptr0, align 8
  %vis_start_ptr = getelementptr inbounds i32, i32* %vis, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  %c_old0 = load i64, i64* %countp, align 8
  %c_new0 = add i64 %c_old0, 1
  store i64 %c_new0, i64* %countp, align 8
  %out_ptr0 = getelementptr inbounds i64, i64* %out, i64 %c_old0
  store i64 %start, i64* %out_ptr0, align 8
  %sp_entry = add i64 0, 1
  br label %loop_header

loop_header:                                      ; preds = %after_loop_iter, %after_init
  %sp_phi = phi i64 [ %sp_entry, %after_init ], [ %sp_next, %after_loop_iter ]
  %sp_is_zero = icmp eq i64 %sp_phi, 0
  br i1 %sp_is_zero, label %cleanup, label %process_top

process_top:                                      ; preds = %loop_header
  %top_index = add i64 %sp_phi, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_index
  %current = load i64, i64* %top_ptr, align 8
  %next_ptr_cur = getelementptr inbounds i64, i64* %next, i64 %current
  %idx0 = load i64, i64* %next_ptr_cur, align 8
  br label %neighbor_header

neighbor_header:                                  ; preds = %neighbor_continue, %process_top
  %idx_phi = phi i64 [ %idx0, %process_top ], [ %idx_inc, %neighbor_continue ]
  %idx_lt_n = icmp ult i64 %idx_phi, %n
  br i1 %idx_lt_n, label %check_adj, label %no_more_neighbors

check_adj:                                        ; preds = %neighbor_header
  %row_mul = mul i64 %current, %n
  %lin_idx = add i64 %row_mul, %idx_phi
  %mat_elem_ptr = getelementptr inbounds i32, i32* %matrix, i64 %lin_idx
  %mat_elem = load i32, i32* %mat_elem_ptr, align 4
  %is_edge = icmp ne i32 %mat_elem, 0
  br i1 %is_edge, label %check_visited, label %neighbor_continue

check_visited:                                    ; preds = %check_adj
  %vis_idx_ptr = getelementptr inbounds i32, i32* %vis, i64 %idx_phi
  %vis_val = load i32, i32* %vis_idx_ptr, align 4
  %is_unvisited = icmp eq i32 %vis_val, 0
  br i1 %is_unvisited, label %visit_neighbor, label %neighbor_continue

visit_neighbor:                                   ; preds = %check_visited
  %idx_plus1 = add i64 %idx_phi, 1
  store i64 %idx_plus1, i64* %next_ptr_cur, align 8
  store i32 1, i32* %vis_idx_ptr, align 4
  %c_old = load i64, i64* %countp, align 8
  %c_new = add i64 %c_old, 1
  store i64 %c_new, i64* %countp, align 8
  %out_ptr_i = getelementptr inbounds i64, i64* %out, i64 %c_old
  store i64 %idx_phi, i64* %out_ptr_i, align 8
  %stack_push_ptr = getelementptr inbounds i64, i64* %stack, i64 %sp_phi
  store i64 %idx_phi, i64* %stack_push_ptr, align 8
  %sp_after_push = add i64 %sp_phi, 1
  br label %after_loop_iter

neighbor_continue:                                ; preds = %check_visited, %check_adj
  %idx_inc = add i64 %idx_phi, 1
  br label %neighbor_header

no_more_neighbors:                                ; preds = %neighbor_header
  %sp_after_pop = add i64 %sp_phi, -1
  br label %after_loop_iter

after_loop_iter:                                  ; preds = %no_more_neighbors, %visit_neighbor
  %sp_next = phi i64 [ %sp_after_push, %visit_neighbor ], [ %sp_after_pop, %no_more_neighbors ]
  br label %loop_header

cleanup:                                          ; preds = %loop_header
  %vis_bc2 = bitcast i32* %vis to i8*
  call void @free(i8* %vis_bc2)
  %next_bc2 = bitcast i64* %next to i8*
  call void @free(i8* %next_bc2)
  %stack_bc2 = bitcast i64* %stack to i8*
  call void @free(i8* %stack_bc2)
  ret void
}

declare noalias i8* @malloc(i64) local_unnamed_addr

declare void @free(i8*) local_unnamed_addr

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %out = alloca [49 x i64], align 16
  %out_len = alloca i64, align 8
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8
  %adj.idx1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1, align 4
  %adj.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2, align 4
  %adj.idx7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj.idx7, align 4
  %adj.idx14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj.idx14, align 4
  %adj.idx10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj.idx10, align 4
  %adj.idx22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj.idx22, align 4
  %adj.idx11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj.idx11, align 4
  %adj.idx29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj.idx29, align 4
  %adj.idx19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj.idx19, align 4
  %adj.idx37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj.idx37, align 4
  %adj.idx33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj.idx33, align 4
  %adj.idx39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj.idx39, align 4
  %adj.idx41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj.idx41, align 4
  %adj.idx47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj.idx47, align 4
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  %out.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 0
  call void @dfs(i32* %adj.ptr, i64 %n.val, i64 %start.val, i64* %out.ptr, i64* %out_len)
  %fmt0.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_dfs, i64 0, i64 0
  %start.val2 = load i64, i64* %start, align 8
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt0.ptr, i64 %start.val2)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.ph = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %len.cur = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.ph, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %i.plus1 = add i64 %i.ph, 1
  %len.cur2 = load i64, i64* %out_len, align 8
  %has_space = icmp ult i64 %i.plus1, %len.cur2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %suffix.ptr = select i1 %has_space, i8* %space.ptr, i8* %empty.ptr
  %elem.ptr = getelementptr inbounds [49 x i64], [49 x i64]* %out, i64 0, i64 %i.ph
  %elem.val = load i64, i64* %elem.ptr, align 8
  %fmt1.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_elem, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i64 %elem.val, i8* %suffix.ptr)
  %i.next = add i64 %i.ph, 1
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %nl.call = call i32 @putchar(i32 10)
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
