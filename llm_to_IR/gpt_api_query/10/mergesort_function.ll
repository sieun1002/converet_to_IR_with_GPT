; LLVM IR (.ll) for function: merge_sort (LLVM 14)

declare i8* @malloc(i64)
declare void @free(i8*)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)

define void @merge_sort(i32* noundef %dest, i64 noundef %n) {
entry:
  %cmp1 = icmp ule i64 %n, 1
  br i1 %cmp1, label %ret, label %alloc

alloc:
  %size_bytes = shl i64 %n, 2
  %buf_i8 = call i8* @malloc(i64 %size_bytes)
  %buf0 = bitcast i8* %buf_i8 to i32*
  %isnull = icmp eq i32* %buf0, null
  br i1 %isnull, label %ret, label %outer_init

outer_init:
  br label %outer_header

outer_header:
  %run = phi i64 [ 1, %outer_init ], [ %run_next, %inner_end ]
  %src_cur = phi i32* [ %dest, %outer_init ], [ %src_next, %inner_end ]
  %buf_cur = phi i32* [ %buf0, %outer_init ], [ %buf_next, %inner_end ]
  %cond_run = icmp ult i64 %run, %n
  br i1 %cond_run, label %inner_init, label %finish

inner_init:
  %double_run = shl i64 %run, 1
  br label %inner_check

inner_check:
  %i = phi i64 [ 0, %inner_init ], [ %i_next, %after_merge ]
  %cond_i = icmp ult i64 %i, %n
  br i1 %cond_i, label %merge_prep, label %inner_end

merge_prep:
  ; l = i
  %l = add i64 %i, 0
  ; m = min(i + run, n)
  %i_plus_run = add i64 %i, %run
  %m_lt = icmp ult i64 %i_plus_run, %n
  %m = select i1 %m_lt, i64 %i_plus_run, i64 %n
  ; r = min(i + 2*run, n)
  %i_plus_2run = add i64 %i, %double_run
  %r_lt = icmp ult i64 %i_plus_2run, %n
  %r = select i1 %r_lt, i64 %i_plus_2run, i64 %n
  ; i1 = l, j = m, k = l
  br label %merge_loop_check

merge_loop_check:
  %k_cur = phi i64 [ %l, %merge_prep ], [ %k_next, %merge_loop_body_end ]
  %i1_cur = phi i64 [ %l, %merge_prep ], [ %i1_next, %merge_loop_body_end ]
  %j_cur = phi i64 [ %m, %merge_prep ], [ %j_next, %merge_loop_body_end ]
  %k_lt_r = icmp ult i64 %k_cur, %r
  br i1 %k_lt_r, label %merge_choose, label %after_merge

merge_choose:
  %i1_lt_m = icmp ult i64 %i1_cur, %m
  br i1 %i1_lt_m, label %check_right, label %take_right

check_right:
  %j_lt_r = icmp ult i64 %j_cur, %r
  br i1 %j_lt_r, label %load_compare, label %take_left

load_compare:
  %i1_ptr = getelementptr inbounds i32, i32* %src_cur, i64 %i1_cur
  %left = load i32, i32* %i1_ptr, align 4
  %j_ptr = getelementptr inbounds i32, i32* %src_cur, i64 %j_cur
  %right = load i32, i32* %j_ptr, align 4
  %le = icmp sle i32 %left, %right
  br i1 %le, label %take_left_loaded, label %take_right_loaded

take_left:
  %i1_ptr2 = getelementptr inbounds i32, i32* %src_cur, i64 %i1_cur
  %left2 = load i32, i32* %i1_ptr2, align 4
  br label %store_left

take_left_loaded:
  br label %store_left

store_left:
  %left_val = phi i32 [ %left2, %take_left ], [ %left, %take_left_loaded ]
  %k_dst = getelementptr inbounds i32, i32* %buf_cur, i64 %k_cur
  store i32 %left_val, i32* %k_dst, align 4
  %k_next_l = add i64 %k_cur, 1
  %i1_next_l = add i64 %i1_cur, 1
  br label %merge_loop_body_end

take_right:
  %j_ptr2 = getelementptr inbounds i32, i32* %src_cur, i64 %j_cur
  %right2 = load i32, i32* %j_ptr2, align 4
  br label %store_right

take_right_loaded:
  br label %store_right

store_right:
  %right_val = phi i32 [ %right2, %take_right ], [ %right, %take_right_loaded ]
  %k_dst_r = getelementptr inbounds i32, i32* %buf_cur, i64 %k_cur
  store i32 %right_val, i32* %k_dst_r, align 4
  %k_next_r = add i64 %k_cur, 1
  %j_next_r = add i64 %j_cur, 1
  br label %merge_loop_body_end

merge_loop_body_end:
  %k_next = phi i64 [ %k_next_l, %store_left ], [ %k_next_r, %store_right ]
  %i1_next = phi i64 [ %i1_next_l, %store_left ], [ %i1_cur, %store_right ]
  %j_next = phi i64 [ %j_cur, %store_left ], [ %j_next_r, %store_right ]
  br label %merge_loop_check

after_merge:
  %i_next = add i64 %i, %double_run
  br label %inner_check

inner_end:
  ; swap src and buf, double run
  %src_next = phi i32* [ %buf_cur, %inner_check ]
  %buf_next = phi i32* [ %src_cur, %inner_check ]
  %run_next = shl i64 %run, 1
  br label %outer_header

finish:
  %src_eq_dest = icmp eq i32* %src_cur, %dest
  br i1 %src_eq_dest, label %free_and_ret, label %do_memcpy

do_memcpy:
  %bytes = shl i64 %n, 2
  %dest_i8 = bitcast i32* %dest to i8*
  %src_i8 = bitcast i32* %src_cur to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %dest_i8, i8* align 4 %src_i8, i64 %bytes, i1 false)
  br label %free_and_ret

free_and_ret:
  %buf_i8_free = bitcast i32* %buf0 to i8*
  call void @free(i8* %buf_i8_free)
  br label %ret

ret:
  ret void
}