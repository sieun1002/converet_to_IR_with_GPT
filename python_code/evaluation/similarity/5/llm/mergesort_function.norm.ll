; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/mergesort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/mergesort_function.ll"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind
declare i8* @malloc(i64) #0

; Function Attrs: nounwind
declare void @free(i8*) #0

; Function Attrs: nounwind
declare i8* @memcpy(i8*, i8*, i64) #0

define void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp_n = icmp ult i64 %n, 2
  br i1 %cmp_n, label %ret, label %alloc

alloc:                                            ; preds = %entry
  %size = shl i64 %n, 2
  %tmpraw = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %tmpraw, null
  br i1 %isnull, label %ret, label %init

init:                                             ; preds = %alloc
  %tmpbuf = bitcast i8* %tmpraw to i32*
  br label %outer

outer:                                            ; preds = %afterInner, %init
  %src = phi i32* [ %dest, %init ], [ %buf, %afterInner ]
  %buf = phi i32* [ %tmpbuf, %init ], [ %src, %afterInner ]
  %run = phi i64 [ 1, %init ], [ %run_next, %afterInner ]
  %cond_outer = icmp ult i64 %run, %n
  br i1 %cond_outer, label %outer_body, label %outer_end

outer_body:                                       ; preds = %outer_body_end, %outer
  %i = phi i64 [ 0, %outer ], [ %right_pre, %outer_body_end ]
  %cond_i = icmp ult i64 %i, %n
  br i1 %cond_i, label %merge_prep, label %afterInner

merge_prep:                                       ; preds = %outer_body
  %mid_pre = add i64 %i, %run
  %mid_lt_n = icmp ult i64 %mid_pre, %n
  %mid = select i1 %mid_lt_n, i64 %mid_pre, i64 %n
  %run_twice_prep = shl i64 %run, 1
  %right_pre = add i64 %i, %run_twice_prep
  %right_lt_n = icmp ult i64 %right_pre, %n
  %right = select i1 %right_lt_n, i64 %right_pre, i64 %n
  br label %merge_loop

merge_loop:                                       ; preds = %merge_next, %merge_prep
  %k = phi i64 [ %i, %merge_prep ], [ %k_next, %merge_next ]
  %l = phi i64 [ %i, %merge_prep ], [ %l_next_phi, %merge_next ]
  %r = phi i64 [ %mid, %merge_prep ], [ %r_next_phi, %merge_next ]
  %k_lt_right = icmp ult i64 %k, %right
  br i1 %k_lt_right, label %choose, label %outer_body_end

choose:                                           ; preds = %merge_loop
  %l_lt_mid = icmp ult i64 %l, %mid
  br i1 %l_lt_mid, label %check_right_avail, label %take_right_from_choose

check_right_avail:                                ; preds = %choose
  %r_lt_right = icmp ult i64 %r, %right
  br i1 %r_lt_right, label %cmp_values, label %take_left_from_check

cmp_values:                                       ; preds = %check_right_avail
  %l_ptr_cmp = getelementptr inbounds i32, i32* %src, i64 %l
  %l_val_cmp = load i32, i32* %l_ptr_cmp, align 4
  %r_ptr_cmp = getelementptr inbounds i32, i32* %src, i64 %r
  %r_val_cmp = load i32, i32* %r_ptr_cmp, align 4
  %le_cmp.not = icmp sgt i32 %l_val_cmp, %r_val_cmp
  br i1 %le_cmp.not, label %take_right_from_cmp, label %take_left_from_cmp

take_left_from_check:                             ; preds = %check_right_avail
  %l_ptr_store1 = getelementptr inbounds i32, i32* %src, i64 %l
  %l_val_store1 = load i32, i32* %l_ptr_store1, align 4
  %dst_ptr1 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %l_val_store1, i32* %dst_ptr1, align 4
  %l_inc1 = add i64 %l, 1
  br label %merge_next

take_left_from_cmp:                               ; preds = %cmp_values
  %dst_ptr2 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %l_val_cmp, i32* %dst_ptr2, align 4
  %l_inc2 = add i64 %l, 1
  br label %merge_next

take_right_from_choose:                           ; preds = %choose
  %r_ptr_store1 = getelementptr inbounds i32, i32* %src, i64 %r
  %r_val_store1 = load i32, i32* %r_ptr_store1, align 4
  %dst_ptr3 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %r_val_store1, i32* %dst_ptr3, align 4
  %r_inc1 = add i64 %r, 1
  br label %merge_next

take_right_from_cmp:                              ; preds = %cmp_values
  %dst_ptr4 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %r_val_cmp, i32* %dst_ptr4, align 4
  %r_inc2 = add i64 %r, 1
  br label %merge_next

merge_next:                                       ; preds = %take_right_from_cmp, %take_right_from_choose, %take_left_from_cmp, %take_left_from_check
  %l_next_phi = phi i64 [ %l_inc1, %take_left_from_check ], [ %l_inc2, %take_left_from_cmp ], [ %l, %take_right_from_choose ], [ %l, %take_right_from_cmp ]
  %r_next_phi = phi i64 [ %r, %take_left_from_check ], [ %r, %take_left_from_cmp ], [ %r_inc1, %take_right_from_choose ], [ %r_inc2, %take_right_from_cmp ]
  %k_next = add i64 %k, 1
  br label %merge_loop

outer_body_end:                                   ; preds = %merge_loop
  br label %outer_body

afterInner:                                       ; preds = %outer_body
  %run_next = shl i64 %run, 1
  br label %outer

outer_end:                                        ; preds = %outer
  %src_eq_dest = icmp eq i32* %src, %dest
  br i1 %src_eq_dest, label %free_and_ret, label %do_memcpy

do_memcpy:                                        ; preds = %outer_end
  %dest_i8 = bitcast i32* %dest to i8*
  %src_i8 = bitcast i32* %src to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %dest_i8, i8* align 1 %src_i8, i64 %size, i1 false)
  br label %free_and_ret

free_and_ret:                                     ; preds = %do_memcpy, %outer_end
  call void @free(i8* %tmpraw)
  br label %ret

ret:                                              ; preds = %free_and_ret, %alloc, %entry
  ret void
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #1

attributes #0 = { nounwind }
attributes #1 = { argmemonly nofree nounwind willreturn }
