; ModuleID = 'dfs_module'
source_filename = "dfs.ll"
target triple = "x86_64-pc-windows-msvc"

declare dso_local dllimport noalias i8* @malloc(i64)
declare dso_local dllimport void @free(i8*)

define dso_local void @dfs(i32* %adj, i64 %n, i64 %start, i64* %out, i64* %outLenPtr) {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_zero, label %check_start

check_start:                                         ; preds = %entry
  %start_ge_n = icmp uge i64 %start, %n
  br i1 %start_ge_n, label %early_zero, label %alloc

early_zero:                                          ; preds = %check_start, %entry
  store i64 0, i64* %outLenPtr, align 8
  ret void

alloc:                                               ; preds = %check_start
  %size_block = mul i64 %n, 4
  %block_raw = call i8* @malloc(i64 %size_block)
  %block = bitcast i8* %block_raw to i32*
  %size_next = mul i64 %n, 8
  %next_raw = call i8* @malloc(i64 %size_next)
  %next = bitcast i8* %next_raw to i64*
  %size_stack = mul i64 %n, 8
  %stack_raw = call i8* @malloc(i64 %size_stack)
  %stack = bitcast i8* %stack_raw to i64*

  %block_isnull = icmp eq i32* %block, null
  %next_isnull = icmp eq i64* %next, null
  %stack_isnull = icmp eq i64* %stack, null
  %tmp_or = or i1 %block_isnull, %next_isnull
  %anynull = or i1 %tmp_or, %stack_isnull
  br i1 %anynull, label %alloc_fail, label %init

alloc_fail:                                          ; preds = %alloc
  %block_i8 = bitcast i32* %block to i8*
  call void @free(i8* %block_i8)
  %next_i8 = bitcast i64* %next to i8*
  call void @free(i8* %next_i8)
  %stack_i8 = bitcast i64* %stack to i8*
  call void @free(i8* %stack_i8)
  store i64 0, i64* %outLenPtr, align 8
  ret void

init:                                                ; preds = %alloc
  br label %zero_loop_header

zero_loop_header:                                    ; preds = %zero_loop_body, %init
  %i = phi i64 [ 0, %init ], [ %i_next, %zero_loop_body ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %zero_loop_body, label %post_zero

zero_loop_body:                                      ; preds = %zero_loop_header
  %block_gep = getelementptr inbounds i32, i32* %block, i64 %i
  store i32 0, i32* %block_gep, align 4
  %next_gep = getelementptr inbounds i64, i64* %next, i64 %i
  store i64 0, i64* %next_gep, align 8
  %i_next = add i64 %i, 1
  br label %zero_loop_header

post_zero:                                           ; preds = %zero_loop_header
  store i64 0, i64* %outLenPtr, align 8
  %stack_gep0 = getelementptr inbounds i64, i64* %stack, i64 0
  store i64 %start, i64* %stack_gep0, align 8
  %block_start_gep = getelementptr inbounds i32, i32* %block, i64 %start
  store i32 1, i32* %block_start_gep, align 4
  %oldlen = load i64, i64* %outLenPtr, align 8
  %newlen = add i64 %oldlen, 1
  store i64 %newlen, i64* %outLenPtr, align 8
  %out_gep0 = getelementptr inbounds i64, i64* %out, i64 %oldlen
  store i64 %start, i64* %out_gep0, align 8
  br label %outer_header

outer_header:                                        ; preds = %outer_latch, %post_zero
  %stackSize = phi i64 [ 1, %post_zero ], [ %stackSize_after_iter, %outer_latch ]
  %has_elems = icmp ne i64 %stackSize, 0
  br i1 %has_elems, label %outer_body, label %cleanup

outer_body:                                          ; preds = %outer_header
  %top_idx_minus1 = sub i64 %stackSize, 1
  %stack_top_gep = getelementptr inbounds i64, i64* %stack, i64 %top_idx_minus1
  %top = load i64, i64* %stack_top_gep, align 8
  %next_for_top_gep = getelementptr inbounds i64, i64* %next, i64 %top
  %neighbor_init = load i64, i64* %next_for_top_gep, align 8
  br label %inner_header

inner_header:                                        ; preds = %inner_skip, %outer_body
  %neighbor = phi i64 [ %neighbor_init, %outer_body ], [ %neighbor_inc, %inner_skip ]
  %has_neighbor = icmp ult i64 %neighbor, %n
  br i1 %has_neighbor, label %inner_check_edge, label %inner_exhausted

inner_check_edge:                                    ; preds = %inner_header
  %mul = mul i64 %top, %n
  %sum = add i64 %mul, %neighbor
  %edge_gep = getelementptr inbounds i32, i32* %adj, i64 %sum
  %edge_val = load i32, i32* %edge_gep, align 4
  %edge_is_zero = icmp eq i32 %edge_val, 0
  br i1 %edge_is_zero, label %inner_skip, label %inner_check_visited

inner_check_visited:                                 ; preds = %inner_check_edge
  %neighbor_block_gep = getelementptr inbounds i32, i32* %block, i64 %neighbor
  %visited_flag = load i32, i32* %neighbor_block_gep, align 4
  %visited_is_nonzero = icmp ne i32 %visited_flag, 0
  br i1 %visited_is_nonzero, label %inner_skip, label %inner_take

inner_skip:                                          ; preds = %inner_check_visited, %inner_check_edge
  %neighbor_inc = add i64 %neighbor, 1
  br label %inner_header

inner_take:                                          ; preds = %inner_check_visited
  %neighbor_plus1 = add i64 %neighbor, 1
  store i64 %neighbor_plus1, i64* %next_for_top_gep, align 8
  store i32 1, i32* %neighbor_block_gep, align 4
  %oldlen2 = load i64, i64* %outLenPtr, align 8
  %newlen2 = add i64 %oldlen2, 1
  store i64 %newlen2, i64* %outLenPtr, align 8
  %outpos2_gep = getelementptr inbounds i64, i64* %out, i64 %oldlen2
  store i64 %neighbor, i64* %outpos2_gep, align 8
  %push_gep = getelementptr inbounds i64, i64* %stack, i64 %stackSize
  store i64 %neighbor, i64* %push_gep, align 8
  %stackSize_plus1 = add i64 %stackSize, 1
  br label %outer_latch

inner_exhausted:                                     ; preds = %inner_header
  %stackSize_minus1 = add i64 %stackSize, -1
  br label %outer_latch

outer_latch:                                         ; preds = %inner_exhausted, %inner_take
  %stackSize_after_iter = phi i64 [ %stackSize_plus1, %inner_take ], [ %stackSize_minus1, %inner_exhausted ]
  br label %outer_header

cleanup:                                             ; preds = %outer_header
  %block_i8_2 = bitcast i32* %block to i8*
  call void @free(i8* %block_i8_2)
  %next_i8_2 = bitcast i64* %next to i8*
  call void @free(i8* %next_i8_2)
  %stack_i8_2 = bitcast i64* %stack to i8*
  call void @free(i8* %stack_i8_2)
  ret void
}