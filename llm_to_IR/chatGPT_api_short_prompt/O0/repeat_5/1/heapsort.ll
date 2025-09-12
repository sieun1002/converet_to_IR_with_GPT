; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort ; Address: 0x1189
; Intent: In-place ascending heap sort for 32-bit int array (confidence=0.98). Evidence: max-heapify loops with child index 2*i+1, swap with end, signed compares on i32.
; Preconditions: If n <= 1, array is unchanged. Array must be valid for n 32-bit elements.
; Postconditions: arr[0..n-1] is sorted in nondecreasing order (ascending).

; Only the necessary external declarations:

define dso_local void @heap_sort(i32* nocapture noundef %arr, i64 noundef %n) local_unnamed_addr {
entry:
  %cmp_le1 = icmp ule i64 %n, 1
  br i1 %cmp_le1, label %ret, label %build_init

build_init:                                        ; heap build: i = n >> 1
  %i0 = lshr i64 %n, 1
  br label %build_loop_header

build_loop_header:
  %i = phi i64 [ %i0, %build_init ], [ %j, %sift1_finish ]
  %i_ne0 = icmp ne i64 %i, 0
  br i1 %i_ne0, label %build_predec, label %sort_init

build_predec:
  %j = add i64 %i, -1
  br label %sift1_header

; sift-down with bound = n
sift1_header:
  %cur = phi i64 [ %j, %build_predec ], [ %cur_next, %sift1_iter_end ]
  %cur_shl = shl i64 %cur, 1
  %left = add i64 %cur_shl, 1
  %has_left = icmp ult i64 %left, %n
  br i1 %has_left, label %sift1_hasleft, label %sift1_finish

sift1_hasleft:
  %right = add i64 %left, 1
  %has_right = icmp ult i64 %right, %n
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  br i1 %has_right, label %sift1_hasright, label %sift1_choose_left

sift1_hasright:
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  %child_idx_r = select i1 %right_gt_left, i64 %right, i64 %left
  %child_val_r = select i1 %right_gt_left, i32 %right_val, i32 %left_val
  br label %sift1_compare

sift1_choose_left:
  br label %sift1_compare

sift1_compare:
  %child_idx = phi i64 [ %child_idx_r, %sift1_hasright ], [ %left, %sift1_choose_left ]
  %child_val = phi i32 [ %child_val_r, %sift1_hasright ], [ %left_val, %sift1_choose_left ]
  %parent_ptr = getelementptr inbounds i32, i32* %arr, i64 %cur
  %parent_val = load i32, i32* %parent_ptr, align 4
  %parent_ge_child = icmp sge i32 %parent_val, %child_val
  br i1 %parent_ge_child, label %sift1_finish, label %sift1_swap

sift1_swap:
  ; swap arr[cur] and arr[child_idx]
  %child_ptr = getelementptr inbounds i32, i32* %arr, i64 %child_idx
  store i32 %child_val, i32* %parent_ptr, align 4
  store i32 %parent_val, i32* %child_ptr, align 4
  %cur_next = add i64 %child_idx, 0
  br label %sift1_iter_end

sift1_iter_end:
  br label %sift1_header

sift1_finish:
  br label %build_loop_header

; sort phase
sort_init:
  %limit0 = add i64 %n, -1
  br label %sort_loop_header

sort_loop_header:
  %lim = phi i64 [ %limit0, %sort_init ], [ %lim_dec, %sort_loop_latch ]
  %lim_ne0 = icmp ne i64 %lim, 0
  br i1 %lim_ne0, label %sort_body, label %ret

sort_body:
  ; swap arr[0] with arr[lim]
  %v0 = load i32, i32* %arr, align 4
  %lim_ptr = getelementptr inbounds i32, i32* %arr, i64 %lim
  %vlim = load i32, i32* %lim_ptr, align 4
  store i32 %vlim, i32* %arr, align 4
  store i32 %v0, i32* %lim_ptr, align 4
  br label %sift2_header

; sift-down with bound = lim (exclusive)
sift2_header:
  %cur2 = phi i64 [ 0, %sort_body ], [ %cur2_next, %sift2_iter_end ]
  %cur2_shl = shl i64 %cur2, 1
  %left2 = add i64 %cur2_shl, 1
  %has_left2 = icmp ult i64 %left2, %lim
  br i1 %has_left2, label %sift2_hasleft, label %sift2_done

sift2_hasleft:
  %right2 = add i64 %left2, 1
  %has_right2 = icmp ult i64 %right2, %lim
  %left2_ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  br i1 %has_right2, label %sift2_hasright, label %sift2_choose_left

sift2_hasright:
  %right2_ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %right2_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  %child2_idx_r = select i1 %right2_gt_left2, i64 %right2, i64 %left2
  %child2_val_r = select i1 %right2_gt_left2, i32 %right2_val, i32 %left2_val
  br label %sift2_compare

sift2_choose_left:
  br label %sift2_compare

sift2_compare:
  %child2_idx = phi i64 [ %child2_idx_r, %sift2_hasright ], [ %left2, %sift2_choose_left ]
  %child2_val = phi i32 [ %child2_val_r, %sift2_hasright ], [ %left2_val, %sift2_choose_left ]
  %parent2_ptr = getelementptr inbounds i32, i32* %arr, i64 %cur2
  %parent2_val = load i32, i32* %parent2_ptr, align 4
  %parent2_ge_child2 = icmp sge i32 %parent2_val, %child2_val
  br i1 %parent2_ge_child2, label %sift2_done, label %sift2_swap

sift2_swap:
  %child2_ptr = getelementptr inbounds i32, i32* %arr, i64 %child2_idx
  store i32 %child2_val, i32* %parent2_ptr, align 4
  store i32 %parent2_val, i32* %child2_ptr, align 4
  %cur2_next = add i64 %child2_idx, 0
  br label %sift2_iter_end

sift2_iter_end:
  br label %sift2_header

sift2_done:
  br label %sort_loop_latch

sort_loop_latch:
  %lim_dec = add i64 %lim, -1
  br label %sort_loop_header

ret:
  ret void
}