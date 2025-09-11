; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort ; Address: 0x401156
; Intent: In-place ascending heapsort on i32 array (confidence=0.95). Evidence: child index 2*root+1, signed compares with sibling/root and sift-down loops.
; Preconditions: %a points to at least %n consecutive i32 elements.
; Postconditions: The first %n elements at %a are sorted in nondecreasing (signed) order.

; Only the needed extern declarations:

define dso_local void @heap_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
%cmp_n_le1 = icmp ule i64 %n, 1
br i1 %cmp_n_le1, label %ret, label %build_init

build_init:
%i0 = lshr i64 %n, 1
br label %build_header

build_header:
%i = phi i64 [ %i0, %build_init ], [ %i_dec, %build_dec ]
%is_zero = icmp eq i64 %i, 0
br i1 %is_zero, label %sort_init, label %sift_build_entry

sift_build_entry:
%root_init = add i64 %i, -1
br label %sift_build_loop

sift_build_loop:
%root = phi i64 [ %root_init, %sift_build_entry ], [ %swap_idx, %sift_build_swapped ]
%root_x2 = shl i64 %root, 1
%left = add i64 %root_x2, 1
%left_lt_n = icmp ult i64 %left, %n
br i1 %left_lt_n, label %have_left, label %build_dec

have_left:
%right = add i64 %left, 1
%right_lt_n = icmp ult i64 %right, %n
%left_ptr = getelementptr inbounds i32, i32* %a, i64 %left
%left_val = load i32, i32* %left_ptr, align 4
br i1 %right_lt_n, label %have_right, label %choose_left

have_right:
%right_ptr = getelementptr inbounds i32, i32* %a, i64 %right
%right_val = load i32, i32* %right_ptr, align 4
%right_gt_left = icmp sgt i32 %right_val, %left_val
br i1 %right_gt_left, label %choose_right, label %choose_left

choose_left:
%swap_idx_left = phi i64 [ %left, %have_right ], [ %left, %have_left ]
br label %choose_done

choose_right:
%swap_idx_right = phi i64 [ %right, %have_right ]
br label %choose_done

choose_done:
%swap_idx = phi i64 [ %swap_idx_right, %choose_right ], [ %swap_idx_left, %choose_left ]
%root_ptr = getelementptr inbounds i32, i32* %a, i64 %root
%root_val = load i32, i32* %root_ptr, align 4
%swap_ptr = getelementptr inbounds i32, i32* %a, i64 %swap_idx
%swap_val = load i32, i32* %swap_ptr, align 4
%root_lt_swap = icmp slt i32 %root_val, %swap_val
br i1 %root_lt_swap, label %sift_build_swapped, label %build_dec

sift_build_swapped:
store i32 %swap_val, i32* %root_ptr, align 4
store i32 %root_val, i32* %swap_ptr, align 4
br label %sift_build_loop

build_dec:
%i_dec = add i64 %i, -1
br label %build_header

sort_init:
%end0 = add i64 %n, -1
br label %sort_check

sort_check:
%end = phi i64 [ %end0, %sort_init ], [ %end_next, %after_decrement ]
%end_ne_zero = icmp ne i64 %end, 0
br i1 %end_ne_zero, label %sort_body, label %ret

sort_body:
%p0 = getelementptr inbounds i32, i32* %a, i64 0
%v0 = load i32, i32* %p0, align 4
%pend = getelementptr inbounds i32, i32* %a, i64 %end
%vend = load i32, i32* %pend, align 4
store i32 %vend, i32* %p0, align 4
store i32 %v0, i32* %pend, align 4
br label %sift_sort_loop

sift_sort_loop:
%root2 = phi i64 [ 0, %sort_body ], [ %swap_idx2, %do_swap_sort ]
%root2_x2 = shl i64 %root2, 1
%left2 = add i64 %root2_x2, 1
%left2_lt_end = icmp ult i64 %left2, %end
br i1 %left2_lt_end, label %have_left2, label %after_sift

have_left2:
%right2 = add i64 %left2, 1
%right2_lt_end = icmp ult i64 %right2, %end
%left2_ptr = getelementptr inbounds i32, i32* %a, i64 %left2
%left2_val = load i32, i32* %left2_ptr, align 4
br i1 %right2_lt_end, label %have_right2, label %choose_left2

have_right2:
%right2_ptr = getelementptr inbounds i32, i32* %a, i64 %right2
%right2_val = load i32, i32* %right2_ptr, align 4
%right2_gt_left2 = icmp sgt i32 %right2_val, %left2_val
br i1 %right2_gt_left2, label %choose_right2, label %choose_left2

choose_left2:
%swap_idx2_left = phi i64 [ %left2, %have_right2 ], [ %left2, %have_left2 ]
br label %choose_done2

choose_right2:
%swap_idx2_right = phi i64 [ %right2, %have_right2 ]
br label %choose_done2

choose_done2:
%swap_idx2 = phi i64 [ %swap_idx2_right, %choose_right2 ], [ %swap_idx2_left, %choose_left2 ]
%root2_ptr = getelementptr inbounds i32, i32* %a, i64 %root2
%root2_val = load i32, i32* %root2_ptr, align 4
%swap2_ptr = getelementptr inbounds i32, i32* %a, i64 %swap_idx2
%swap2_val = load i32, i32* %swap2_ptr, align 4
%root2_lt_swap2 = icmp slt i32 %root2_val, %swap2_val
br i1 %root2_lt_swap2, label %do_swap_sort, label %after_sift

do_swap_sort:
store i32 %swap2_val, i32* %root2_ptr, align 4
store i32 %root2_val, i32* %swap2_ptr, align 4
br label %sift_sort_loop

after_sift:
%end_next = add i64 %end, -1
br label %after_decrement

after_decrement:
br label %sort_check

ret:
ret void
}