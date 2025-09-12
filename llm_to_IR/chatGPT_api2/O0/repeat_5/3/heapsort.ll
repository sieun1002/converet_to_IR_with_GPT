; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort  ; Address: 0x1189
; Intent: In-place heapsort of signed 32-bit integers (confidence=0.95). Evidence: child indices 2*i+1 over 4-byte elements; build-heap then extract-max loop
; Preconditions: %a points to at least %n contiguous i32 elements
; Postconditions: %a[0..n) sorted in nondecreasing order (signed 32-bit comparison)

define dso_local void @heap_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_iter

build_iter:
  %i = phi i64 [ %half, %build_init ], [ %i_next, %build_continue ]
  %i_is_zero = icmp eq i64 %i, 0
  br i1 %i_is_zero, label %after_build, label %build_body

build_body:
  %parent0 = add i64 %i, -1
  br label %sift_entry

sift_entry:
  %parent = phi i64 [ %parent0, %build_body ], [ %child, %sift_swap ]
  %inext = phi i64 [ %parent0, %build_body ], [ %inext, %sift_swap ]
  %tmp2 = shl i64 %parent, 1
  %left = add i64 %tmp2, 1
  %left_oob = icmp uge i64 %left, %n
  br i1 %left_oob, label %build_continue, label %have_left

have_left:
  %right = add i64 %left, 1
  %right_inb = icmp ult i64 %right, %n
  %left_ptr = getelementptr inbounds i32, i32* %a, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  br i1 %right_inb, label %check_right, label %choose_left

check_right:
  %right_ptr = getelementptr inbounds i32, i32* %a, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %gt = icmp sgt i32 %right_val, %left_val
  %child_sel = select i1 %gt, i64 %right, i64 %left
  br label %select_done

choose_left:
  %child_sel_left = %left
  br label %select_done

select_done:
  %child = phi i64 [ %child_sel, %check_right ], [ %child_sel_left, %choose_left ]
  %parent_ptr = getelementptr inbounds i32, i32* %a, i64 %parent
  %parent_val = load i32, i32* %parent_ptr, align 4
  %child_ptr = getelementptr inbounds i32, i32* %a, i64 %child
  %child_val = load i32, i32* %child_ptr, align 4
  %ge = icmp sge i32 %parent_val, %child_val
  br i1 %ge, label %build_continue, label %sift_swap

sift_swap:
  store i32 %child_val, i32* %parent_ptr, align 4
  store i32 %parent_val, i32* %child_ptr, align 4
  br label %sift_entry

build_continue:
  %i_next = phi i64 [ %inext, %sift_entry ], [ %inext, %select_done ]
  br label %build_iter

after_build:
  %end0 = add i64 %n, -1
  br label %extract_check

extract_check:
  %e = phi i64 [ %end0, %after_build ], [ %e_next, %extract_after_sift ]
  %e_is_zero = icmp eq i64 %e, 0
  br i1 %e_is_zero, label %ret, label %extract_body

extract_body:
  %root_ptr = getelementptr inbounds i32, i32* %a, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  %e_ptr = getelementptr inbounds i32, i32* %a, i64 %e
  %e_val = load i32, i32* %e_ptr, align 4
  store i32 %e_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %e_ptr, align 4
  br label %sift2_entry

sift2_entry:
  %parent2 = phi i64 [ 0, %extract_body ], [ %child2, %sift2_swap ]
  %limit2 = phi i64 [ %e, %extract_body ], [ %limit2, %sift2_swap ]
  %tmp2_2 = shl i64 %parent2, 1
  %left2 = add i64 %tmp2_2, 1
  %left2_oob = icmp uge i64 %left2, %limit2
  br i1 %left2_oob, label %extract_after_sift, label %have_left2

have_left2:
  %right2 = add i64 %left2, 1
  %right2_inb = icmp ult i64 %right2, %limit2
  %left2_ptr = getelementptr inbounds i32, i32* %a, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  br i1 %right2_inb, label %check_right2, label %choose_left2

check_right2:
  %right2_ptr = getelementptr inbounds i32, i32* %a, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %gt2 = icmp sgt i32 %right2_val, %left2_val
  %child2_sel = select i1 %gt2, i64 %right2, i64 %left2
  br label %select_done2

choose_left2:
  %child2_sel_left = %left2
  br label %select_done2

select_done2:
  %child2 = phi i64 [ %child2_sel, %check_right2 ], [ %child2_sel_left, %choose_left2 ]
  %parent2_ptr = getelementptr inbounds i32, i32* %a, i64 %parent2
  %parent2_val = load i32, i32* %parent2_ptr, align 4
  %child2_ptr = getelementptr inbounds i32, i32* %a, i64 %child2
  %child2_val = load i32, i32* %child2_ptr, align 4
  %ge2 = icmp sge i32 %parent2_val, %child2_val
  br i1 %ge2, label %extract_after_sift, label %sift2_swap

sift2_swap:
  store i32 %child2_val, i32* %parent2_ptr, align 4
  store i32 %parent2_val, i32* %child2_ptr, align 4
  br label %sift2_entry

extract_after_sift:
  %e_next = add i64 %e, -1
  br label %extract_check

ret:
  ret void
}