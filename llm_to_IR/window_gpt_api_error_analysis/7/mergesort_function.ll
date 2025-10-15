; ModuleID = 'merge_sort_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* noundef %arr, i64 noundef %n) {
entry:
  %cmp_init = icmp ule i64 %n, 1
  br i1 %cmp_init, label %ret, label %alloc

alloc:
  %size_bytes = shl i64 %n, 2
  %mem = call i8* @malloc(i64 %size_bytes)
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %ret, label %init

init:
  %block = bitcast i8* %mem to i32*
  br label %outer_loop_cond

outer_loop_cond:
  %run = phi i64 [ 1, %init ], [ %run_next, %after_pass ]
  %src = phi i32* [ %arr, %init ], [ %src_after, %after_pass ]
  %tmp = phi i32* [ %block, %init ], [ %tmp_after, %after_pass ]
  %cmp_run = icmp ult i64 %run, %n
  br i1 %cmp_run, label %pass_loop_cond, label %finish

pass_loop_cond:
  %start = phi i64 [ 0, %outer_loop_cond ], [ %start_next, %pass_loop_end ]
  %cont = icmp ult i64 %start, %n
  br i1 %cont, label %do_merge_prep, label %after_pass

do_merge_prep:
  %left = add i64 %start, 0
  %mid_tmp = add i64 %start, %run
  %mid_gt = icmp ugt i64 %mid_tmp, %n
  %mid = select i1 %mid_gt, i64 %n, i64 %mid_tmp
  %tworun = shl i64 %run, 1
  %rend_tmp = add i64 %start, %tworun
  %rend_gt = icmp ugt i64 %rend_tmp, %n
  %rend = select i1 %rend_gt, i64 %n, i64 %rend_tmp
  br label %merge_loop_cond

merge_loop_cond:
  %i = phi i64 [ %left, %do_merge_prep ], [ %i_next, %merge_loop_latch ]
  %j = phi i64 [ %mid, %do_merge_prep ], [ %j_next, %merge_loop_latch ]
  %k = phi i64 [ %left, %do_merge_prep ], [ %k_next, %merge_loop_latch ]
  %k_lt_end = icmp ult i64 %k, %rend
  br i1 %k_lt_end, label %choose_i, label %pass_loop_end

choose_i:
  %i_in = icmp ult i64 %i, %mid
  br i1 %i_in, label %check_j, label %take_right_noleft

check_j:
  %j_in = icmp ult i64 %j, %rend
  br i1 %j_in, label %both_avail, label %take_left_onlyleft

both_avail:
  %i_ptr = getelementptr inbounds i32, i32* %src, i64 %i
  %left_val = load i32, i32* %i_ptr, align 4
  %j_ptr = getelementptr inbounds i32, i32* %src, i64 %j
  %right_val = load i32, i32* %j_ptr, align 4
  %cmp_gt = icmp sgt i32 %left_val, %right_val
  br i1 %cmp_gt, label %take_right_both, label %take_left_both

take_left_both:
  %k_ptr_l = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %left_val, i32* %k_ptr_l, align 4
  %i_inc_l = add i64 %i, 1
  %k_inc_l = add i64 %k, 1
  br label %merge_loop_latch

take_right_both:
  %k_ptr_r = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %right_val, i32* %k_ptr_r, align 4
  %j_inc_r = add i64 %j, 1
  %k_inc_r = add i64 %k, 1
  br label %merge_loop_latch

take_left_onlyleft:
  %i_ptr2 = getelementptr inbounds i32, i32* %src, i64 %i
  %left_val2 = load i32, i32* %i_ptr2, align 4
  %k_ptr2 = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %left_val2, i32* %k_ptr2, align 4
  %i_inc2 = add i64 %i, 1
  %k_inc2 = add i64 %k, 1
  br label %merge_loop_latch

take_right_noleft:
  %j_ptr2 = getelementptr inbounds i32, i32* %src, i64 %j
  %right_val2 = load i32, i32* %j_ptr2, align 4
  %k_ptr3 = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %right_val2, i32* %k_ptr3, align 4
  %j_inc2 = add i64 %j, 1
  %k_inc3 = add i64 %k, 1
  br label %merge_loop_latch

merge_loop_latch:
  %i_next = phi i64 [ %i_inc_l, %take_left_both ], [ %i, %take_right_both ], [ %i_inc2, %take_left_onlyleft ], [ %i, %take_right_noleft ]
  %j_next = phi i64 [ %j, %take_left_both ], [ %j_inc_r, %take_right_both ], [ %j, %take_left_onlyleft ], [ %j_inc2, %take_right_noleft ]
  %k_next = phi i64 [ %k_inc_l, %take_left_both ], [ %k_inc_r, %take_right_both ], [ %k_inc2, %take_left_onlyleft ], [ %k_inc3, %take_right_noleft ]
  br label %merge_loop_cond

pass_loop_end:
  %start_incr2 = shl i64 %run, 1
  %start_next = add i64 %start, %start_incr2
  br label %pass_loop_cond

after_pass:
  %src_after = add i64 0, 0   ; dummy to keep SSA uniqueness minimal (will be replaced below)
  %tmp_after = add i64 0, 0   ; dummy to keep SSA uniqueness minimal (will be replaced below)
  br label %swap_fixup

swap_fixup:
  %src_after_ptr = phi i32* [ %tmp, %after_pass ]
  %tmp_after_ptr = phi i32* [ %src, %after_pass ]
  %run_next = shl i64 %run, 1
  br label %outer_loop_cond, !llvm.loop !0

finish:
  %src_ne_arr = icmp ne i32* %src, %arr
  br i1 %src_ne_arr, label %do_copy, label %do_free

do_copy:
  %arr_i8 = bitcast i32* %arr to i8*
  %src_i8 = bitcast i32* %src to i8*
  %size_bytes2 = shl i64 %n, 2
  %ignored = call i8* @memcpy(i8* %arr_i8, i8* %src_i8, i64 %size_bytes2)
  br label %do_free

do_free:
  call void @free(i8* %mem)
  br label %ret

ret:
  ret void
}

!0 = distinct !{!0}