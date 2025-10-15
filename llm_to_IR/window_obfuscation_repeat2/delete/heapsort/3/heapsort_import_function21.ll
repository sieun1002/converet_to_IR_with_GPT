; ModuleID = 'heapsort_sub_140001450'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define void @sub_140001450(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp1 = icmp ule i64 %n, 1
  br i1 %cmp1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_loop_cond

build_loop_cond:
  %i_curr = phi i64 [ %half, %build_init ], [ %i1_forward, %build_sift_end ]
  %cond = icmp ne i64 %i_curr, 0
  br i1 %cond, label %build_predec, label %phase2_init

build_predec:
  %i1 = add i64 %i_curr, -1
  br label %sift_build_entry

sift_build_entry:
  br label %sift_build_loop

sift_build_loop:
  %idx = phi i64 [ %i1, %sift_build_entry ], [ %j_sel_final, %do_swap_build ]
  %i1_keep = phi i64 [ %i1, %sift_build_entry ], [ %i1_keep, %do_swap_build ]
  %twice = shl i64 %idx, 1
  %child = add i64 %twice, 1
  %child_ge_n = icmp uge i64 %child, %n
  br i1 %child_ge_n, label %build_sift_end_from_ge, label %build_child2_check

build_child2_check:
  %childp1 = add i64 %child, 1
  %has2 = icmp ult i64 %childp1, %n
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %child
  %left = load i32, i32* %left_ptr, align 4
  br i1 %has2, label %build_has2, label %build_choose_done

build_has2:
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %childp1
  %right = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right, %left
  %j_sel = select i1 %right_gt_left, i64 %childp1, i64 %child
  br label %build_choose_done

build_choose_done:
  %j_sel_final = phi i64 [ %j_sel, %build_has2 ], [ %child, %build_child2_check ]
  %parent_ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %parent_val = load i32, i32* %parent_ptr, align 4
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j_sel_final
  %j_val = load i32, i32* %j_ptr, align 4
  %need_swap_build = icmp slt i32 %parent_val, %j_val
  br i1 %need_swap_build, label %do_swap_build, label %build_sift_end_from_break

do_swap_build:
  store i32 %j_val, i32* %parent_ptr, align 4
  store i32 %parent_val, i32* %j_ptr, align 4
  br label %sift_build_loop

build_sift_end_from_ge:
  br label %build_sift_end

build_sift_end_from_break:
  br label %build_sift_end

build_sift_end:
  %i1_forward = phi i64 [ %i1_keep, %build_sift_end_from_ge ], [ %i1_keep, %build_sift_end_from_break ]
  br label %build_loop_cond

phase2_init:
  %limit0 = add i64 %n, -1
  br label %phase2_loop_cond

phase2_loop_cond:
  %limit = phi i64 [ %limit0, %phase2_init ], [ %limit_next, %phase2_sift_end ]
  %has_more = icmp ne i64 %limit, 0
  br i1 %has_more, label %phase2_swap, label %ret

phase2_swap:
  %ptr0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %ptr0, align 4
  %pl = getelementptr inbounds i32, i32* %arr, i64 %limit
  %vl = load i32, i32* %pl, align 4
  store i32 %vl, i32* %ptr0, align 4
  store i32 %v0, i32* %pl, align 4
  br label %sift2_entry

sift2_entry:
  br label %sift2_loop

sift2_loop:
  %idx2 = phi i64 [ 0, %sift2_entry ], [ %j2, %do_swap2 ]
  %limit_keep = phi i64 [ %limit, %sift2_entry ], [ %limit_keep, %do_swap2 ]
  %twice2 = shl i64 %idx2, 1
  %child2 = add i64 %twice2, 1
  %child_ge_lim = icmp uge i64 %child2, %limit_keep
  br i1 %child_ge_lim, label %phase2_sift_end_from_ge, label %phase2_child2_check

phase2_child2_check:
  %child2p1 = add i64 %child2, 1
  %has2_2 = icmp ult i64 %child2p1, %limit_keep
  %left_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %child2
  %left2 = load i32, i32* %left_ptr2, align 4
  br i1 %has2_2, label %phase2_has2, label %phase2_choose_done

phase2_has2:
  %right_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %child2p1
  %right2 = load i32, i32* %right_ptr2, align 4
  %right_gt_left2 = icmp sgt i32 %right2, %left2
  %j2_sel = select i1 %right_gt_left2, i64 %child2p1, i64 %child2
  br label %phase2_choose_done

phase2_choose_done:
  %j2 = phi i64 [ %j2_sel, %phase2_has2 ], [ %child2, %phase2_child2_check ]
  %parent_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %idx2
  %parent2 = load i32, i32* %parent_ptr2, align 4
  %j_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  %jval2 = load i32, i32* %j_ptr2, align 4
  %need_swap2 = icmp slt i32 %parent2, %jval2
  br i1 %need_swap2, label %do_swap2, label %phase2_sift_end_from_break

do_swap2:
  store i32 %jval2, i32* %parent_ptr2, align 4
  store i32 %parent2, i32* %j_ptr2, align 4
  br label %sift2_loop

phase2_sift_end_from_ge:
  br label %phase2_sift_end

phase2_sift_end_from_break:
  br label %phase2_sift_end

phase2_sift_end:
  %limit_pass = phi i64 [ %limit_keep, %phase2_sift_end_from_ge ], [ %limit_keep, %phase2_sift_end_from_break ]
  %limit_next = add i64 %limit_pass, -1
  br label %phase2_loop_cond

ret:
  ret void
}