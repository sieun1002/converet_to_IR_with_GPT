; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort ; Address: 0x11E9
; Intent: Bottom-up stable merge sort of i32 array (confidence=0.97). Evidence: malloc(n*4), iterative two-way merge, final memcpy, free.
; Preconditions: dest != NULL; n = number of 32-bit elements. If n <= 1 or malloc fails, returns without changes.
; Postconditions: If allocation succeeds, dest is sorted ascending (stable).

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %after_check

after_check:
  %bytes = shl i64 %n, 2
  %buf_i8 = call i8* @malloc(i64 %bytes)
  %buf = bitcast i8* %buf_i8 to i32*
  %isnull = icmp eq i32* %buf, null
  br i1 %isnull, label %ret, label %init

init:
  br label %outer_cond

outer_cond:
  %run_phi = phi i64 [ 1, %init ], [ %run2, %after_inner ]
  %src_phi = phi i32* [ %dest, %init ], [ %tmp_phi2, %after_inner ]
  %tmp_phi = phi i32* [ %buf, %init ], [ %src_phi2, %after_inner ]
  %cond_run = icmp ult i64 %run_phi, %n
  br i1 %cond_run, label %outer_body, label %outer_exit

outer_body:
  br label %inner_head

inner_head:
  %base_phi = phi i64 [ 0, %outer_body ], [ %base_next, %after_merge_block ]
  %cond_base = icmp ult i64 %base_phi, %n
  br i1 %cond_base, label %merge_prep, label %after_inner

merge_prep:
  %left0 = add i64 %base_phi, 0
  %mid_calc = add i64 %base_phi, %run_phi
  %mid_lt_n = icmp ult i64 %mid_calc, %n
  %mid = select i1 %mid_lt_n, i64 %mid_calc, i64 %n
  %tworun = shl i64 %run_phi, 1
  %right_calc = add i64 %base_phi, %tworun
  %right_lt_n = icmp ult i64 %right_calc, %n
  %right = select i1 %right_lt_n, i64 %right_calc, i64 %n
  %out0 = add i64 %base_phi, 0
  %right_idx0 = add i64 %mid, 0
  br label %merge_loop_head

merge_loop_head:
  %out_phi = phi i64 [ %out0, %merge_prep ], [ %out_next_phi, %merge_loop_body_end ]
  %left_phi2 = phi i64 [ %left0, %merge_prep ], [ %left_next_phi, %merge_loop_body_end ]
  %right_phi2 = phi i64 [ %right_idx0, %merge_prep ], [ %right_next_phi, %merge_loop_body_end ]
  %cond_out = icmp ult i64 %out_phi, %right
  br i1 %cond_out, label %choose, label %after_merge_block

choose:
  %has_left = icmp ult i64 %left_phi2, %mid
  br i1 %has_left, label %check_right_has, label %take_right

check_right_has:
  %has_right = icmp ult i64 %right_phi2, %right
  br i1 %has_right, label %compare_lr, label %take_left

compare_lr:
  %left_ptr = getelementptr inbounds i32, i32* %src_phi, i64 %left_phi2
  %left_val = load i32, i32* %left_ptr, align 4
  %right_ptr = getelementptr inbounds i32, i32* %src_phi, i64 %right_phi2
  %right_val = load i32, i32* %right_ptr, align 4
  %cmp_lr = icmp sgt i32 %left_val, %right_val
  br i1 %cmp_lr, label %take_right, label %take_left

take_left:
  %left_ptr2 = getelementptr inbounds i32, i32* %src_phi, i64 %left_phi2
  %v_left = load i32, i32* %left_ptr2, align 4
  %out_ptr = getelementptr inbounds i32, i32* %tmp_phi, i64 %out_phi
  store i32 %v_left, i32* %out_ptr, align 4
  %left_next = add i64 %left_phi2, 1
  %out_next = add i64 %out_phi, 1
  br label %merge_loop_body_end

take_right:
  %right_ptr2 = getelementptr inbounds i32, i32* %src_phi, i64 %right_phi2
  %v_right = load i32, i32* %right_ptr2, align 4
  %out_ptr2 = getelementptr inbounds i32, i32* %tmp_phi, i64 %out_phi
  store i32 %v_right, i32* %out_ptr2, align 4
  %right_next2 = add i64 %right_phi2, 1
  %out_next2 = add i64 %out_phi, 1
  br label %merge_loop_body_end

merge_loop_body_end:
  %left_next_phi = phi i64 [ %left_next, %take_left ], [ %left_phi2, %take_right ]
  %right_next_phi = phi i64 [ %right_phi2, %take_left ], [ %right_next2, %take_right ]
  %out_next_phi = phi i64 [ %out_next, %take_left ], [ %out_next2, %take_right ]
  br label %merge_loop_head

after_merge_block:
  %tworun2 = shl i64 %run_phi, 1
  %base_next = add i64 %base_phi, %tworun2
  br label %inner_head

after_inner:
  ; swap src and tmp, double run
  %src_phi2 = phi i32* [ %src_phi, %inner_head ]
  %tmp_phi2 = phi i32* [ %tmp_phi, %inner_head ]
  %run2 = shl i64 %run_phi, 1
  br label %outer_cond

outer_exit:
  %src_final = phi i32* [ %src_phi, %outer_cond ]
  %need_copy = icmp ne i32* %src_final, %dest
  br i1 %need_copy, label %do_copy, label %after_copy

do_copy:
  %bytes2 = shl i64 %n, 2
  %dest_i8 = bitcast i32* %dest to i8*
  %src_i8 = bitcast i32* %src_final to i8*
  %memcpy_ret = call i8* @memcpy(i8* %dest_i8, i8* %src_i8, i64 %bytes2)
  br label %after_copy

after_copy:
  call void @free(i8* %buf_i8)
  br label %ret

ret:
  ret void
}