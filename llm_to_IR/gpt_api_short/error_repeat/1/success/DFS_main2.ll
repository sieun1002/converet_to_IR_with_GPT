; ModuleID = 'dfs'
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)

define dso_local void @dfs(i32* nocapture readonly %matrix, i64 %n, i64 %start, i64* nocapture %out, i64* nocapture %out_len) local_unnamed_addr {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

early_zero:                                         ; preds = %entry
  store i64 0, i64* %out_len, align 8
  ret void

check_start:                                        ; preds = %entry
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %allocs, label %early_bad_start

early_bad_start:                                    ; preds = %check_start
  store i64 0, i64* %out_len, align 8
  ret void

allocs:                                             ; preds = %check_start
  %size_vis = shl i64 %n, 2
  %raw_vis = call noalias i8* @malloc(i64 %size_vis)
  %visited = bitcast i8* %raw_vis to i32*
  %size_next = shl i64 %n, 3
  %raw_next = call noalias i8* @malloc(i64 %size_next)
  %next = bitcast i8* %raw_next to i64*
  %raw_stack = call noalias i8* @malloc(i64 %size_next)
  %stack = bitcast i8* %raw_stack to i64*
  %vis_null = icmp eq i8* %raw_vis, null
  %next_null = icmp eq i8* %raw_next, null
  %stack_null = icmp eq i8* %raw_stack, null
  %any_null1 = or i1 %vis_null, %next_null
  %any_null = or i1 %any_null1, %stack_null
  br i1 %any_null, label %alloc_fail, label %init_zero

alloc_fail:                                         ; preds = %allocs
  call void @free(i8* %raw_vis)
  call void @free(i8* %raw_next)
  call void @free(i8* %raw_stack)
  store i64 0, i64* %out_len, align 8
  ret void

init_zero:                                          ; preds = %allocs
  br label %init_loop

init_loop:                                          ; preds = %init_zero, %do_init
  %i = phi i64 [ 0, %init_zero ], [ %i.next, %do_init ]
  %done = icmp uge i64 %i, %n
  br i1 %done, label %after_init, label %do_init

do_init:                                            ; preds = %init_loop
  %vis_ptr = getelementptr inbounds i32, i32* %visited, i64 %i
  store i32 0, i32* %vis_ptr, align 4
  %next_ptr = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_ptr, align 8
  %i.next = add nuw i64 %i, 1
  br label %init_loop

after_init:                                         ; preds = %init_loop
  store i64 0, i64* %out_len, align 8
  %stack0_ptr = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack0_ptr, align 8
  %stack_size.init = add i64 0, 1
  %vis_start_ptr = getelementptr inbounds i32, i32* %visited, i64 %start
  store i32 1, i32* %vis_start_ptr, align 4
  %len0 = load i64, i64* %out_len, align 8
  %out_at_len0 = getelementptr inbounds i64, i64* %out, i64 %len0
  store i64 %start, i64* %out_at_len0, align 8
  %len1 = add i64 %len0, 1
  store i64 %len1, i64* %out_len, align 8
  br label %outer_check

outer_check:                                        ; preds = %after_push, %after_inner, %after_init
  %stack_size = phi i64 [ %stack_size.init, %after_init ], [ %stack_size.next, %after_push ], [ %stack_size.pop, %after_inner ]
  %cont = icmp ne i64 %stack_size, 0
  br i1 %cont, label %outer_body, label %done_all

outer_body:                                         ; preds = %outer_check
  %top_idx = add i64 %stack_size, -1
  %top_ptr = getelementptr inbounds i64, i64* %stack, i64 %top_idx
  %top = load i64, i64* %top_ptr, align 8
  %next_top_ptr = getelementptr inbounds i64, i64* %next, i64 %top
  %idx.init = load i64, i64* %next_top_ptr, align 8
  br label %inner_check

inner_check:                                        ; preds = %inc_idx, %outer_body
  %idx = phi i64 [ %idx.init, %outer_body ], [ %idx.next, %inc_idx ]
  %more = icmp ult i64 %idx, %n
  br i1 %more, label %try_edge, label %after_inner

try_edge:                                           ; preds = %inner_check
  %row_mul = mul i64 %top, %n
  %lin = add i64 %row_mul, %idx
  %m_ptr = getelementptr inbounds i32, i32* %matrix, i64 %lin
  %m_val = load i32, i32* %m_ptr, align 4
  %has_edge = icmp ne i32 %m_val, 0
  br i1 %has_edge, label %check_unvisited, label %inc_idx

check_unvisited:                                    ; preds = %try_edge
  %vis_idx_ptr = getelementptr inbounds i32, i32* %visited, i64 %idx
  %vis_flag = load i32, i32* %vis_idx_ptr, align 4
  %is_unvisited = icmp eq i32 %vis_flag, 0
  br i1 %is_unvisited, label %push_neighbor, label %inc_idx

push_neighbor:                                      ; preds = %check_unvisited
  %idx.plus1 = add i64 %idx, 1
  store i64 %idx.plus1, i64* %next_top_ptr, align 8
  store i32 1, i32* %vis_idx_ptr, align 4
  %lenA = load i64, i64* %out_len, align 8
  %out_at_lenA = getelementptr inbounds i64, i64* %out, i64 %lenA
  store i64 %idx, i64* %out_at_lenA, align 8
  %lenB = add i64 %lenA, 1
  store i64 %lenB, i64* %out_len, align 8
  %new_top_ptr = getelementptr inbounds i64, i64* %stack, i64 %stack_size
  store i64 %idx, i64* %new_top_ptr, align 8
  %stack_size.next = add i64 %stack_size, 1
  br label %after_push

inc_idx:                                            ; preds = %check_unvisited, %try_edge
  %idx.next = add i64 %idx, 1
  br label %inner_check

after_inner:                                        ; preds = %inner_check
  %stack_size.pop = add i64 %stack_size, -1
  br label %outer_check

after_push:                                         ; preds = %push_neighbor
  br label %outer_check

done_all:                                           ; preds = %outer_check
  call void @free(i8* %raw_vis)
  call void @free(i8* %raw_next)
  call void @free(i8* %raw_stack)
  ret void
}