; ModuleID = 'heap_sort_module'
source_filename = "heap_sort.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp1 = icmp ule i64 %n, 1
  br i1 %cmp1, label %exit, label %build_start

build_start:
  %half = lshr i64 %n, 1
  br label %build_loop_header

build_loop_header:
  %i = phi i64 [ %half, %build_start ], [ %i_dec, %build_iter_end ]
  %cont = icmp ne i64 %i, 0
  br i1 %cont, label %sift_down_build_head, label %extract_init

sift_down_build_head:
  %j = phi i64 [ %i, %build_loop_header ], [ %largest_idx, %sift_down_build_swap ]
  %j2 = shl i64 %j, 1
  %left = add i64 %j2, 1
  %has_left = icmp ult i64 %left, %n
  br i1 %has_left, label %check_right_build, label %build_iter_end

check_right_build:
  %right = add i64 %left, 1
  %has_right = icmp ult i64 %right, %n
  %left_gep = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_gep, align 4
  br i1 %has_right, label %cmp_right_build, label %select_left_build

cmp_right_build:
  %right_gep = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_gep, align 4
  %gt_right_left = icmp sgt i32 %right_val, %left_val
  %largest_idx_from_right = select i1 %gt_right_left, i64 %right, i64 %left
  br label %after_select_build

select_left_build:
  br label %after_select_build

after_select_build:
  %largest_idx = phi i64 [ %largest_idx_from_right, %cmp_right_build ], [ %left, %select_left_build ]
  %j_gep = getelementptr inbounds i32, i32* %arr, i64 %j
  %j_val = load i32, i32* %j_gep, align 4
  %largest_gep = getelementptr inbounds i32, i32* %arr, i64 %largest_idx
  %largest_val = load i32, i32* %largest_gep, align 4
  %ge_j_largest = icmp sge i32 %j_val, %largest_val
  br i1 %ge_j_largest, label %build_iter_end, label %sift_down_build_swap

sift_down_build_swap:
  store i32 %largest_val, i32* %j_gep, align 4
  store i32 %j_val, i32* %largest_gep, align 4
  br label %sift_down_build_head

build_iter_end:
  %i_dec = add i64 %i, -1
  br label %build_loop_header

extract_init:
  %heap_end_init = add i64 %n, -1
  br label %extract_loop_header

extract_loop_header:
  %heap_end = phi i64 [ %heap_end_init, %extract_init ], [ %heap_end_next, %decrement_heap_end ]
  %cond = icmp ne i64 %heap_end, 0
  br i1 %cond, label %extract_swap_root, label %exit

extract_swap_root:
  %root_gep = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val = load i32, i32* %root_gep, align 4
  %end_gep = getelementptr inbounds i32, i32* %arr, i64 %heap_end
  %end_val = load i32, i32* %end_gep, align 4
  store i32 %end_val, i32* %root_gep, align 4
  store i32 %root_val, i32* %end_gep, align 4
  br label %sift_down_extract_head

sift_down_extract_head:
  %j_e = phi i64 [ 0, %extract_swap_root ], [ %largest_idx_e, %sift_down_extract_swap ]
  %j2_e = shl i64 %j_e, 1
  %left_e = add i64 %j2_e, 1
  %has_left_e = icmp ult i64 %left_e, %heap_end
  br i1 %has_left_e, label %check_right_extract, label %decrement_heap_end

check_right_extract:
  %right_e = add i64 %left_e, 1
  %has_right_e = icmp ult i64 %right_e, %heap_end
  %left_gep_e = getelementptr inbounds i32, i32* %arr, i64 %left_e
  %left_val_e = load i32, i32* %left_gep_e, align 4
  br i1 %has_right_e, label %cmp_right_extract, label %select_left_extract

cmp_right_extract:
  %right_gep_e = getelementptr inbounds i32, i32* %arr, i64 %right_e
  %right_val_e = load i32, i32* %right_gep_e, align 4
  %gt_right_left_e = icmp sgt i32 %right_val_e, %left_val_e
  %largest_idx_from_right_e = select i1 %gt_right_left_e, i64 %right_e, i64 %left_e
  br label %after_select_extract

select_left_extract:
  br label %after_select_extract

after_select_extract:
  %largest_idx_e = phi i64 [ %largest_idx_from_right_e, %cmp_right_extract ], [ %left_e, %select_left_extract ]
  %j_gep_e = getelementptr inbounds i32, i32* %arr, i64 %j_e
  %j_val_e = load i32, i32* %j_gep_e, align 4
  %largest_gep_e = getelementptr inbounds i32, i32* %arr, i64 %largest_idx_e
  %largest_val_e = load i32, i32* %largest_gep_e, align 4
  %ge_j_largest_e = icmp sge i32 %j_val_e, %largest_val_e
  br i1 %ge_j_largest_e, label %decrement_heap_end, label %sift_down_extract_swap

sift_down_extract_swap:
  store i32 %largest_val_e, i32* %j_gep_e, align 4
  store i32 %j_val_e, i32* %largest_gep_e, align 4
  br label %sift_down_extract_head

decrement_heap_end:
  %heap_end_next = add i64 %heap_end, -1
  br label %extract_loop_header

exit:
  ret void
}