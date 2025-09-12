; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort  ; Address: 0x1189
; Intent: In-place heap sort of a 32-bit integer array (confidence=0.95). Evidence: child indices i*2+1, sift-down loops with swaps.
; Preconditions: a points to at least n 32-bit integers (if n > 0).
; Postconditions: a is sorted in non-decreasing order (by signed 32-bit comparison).

define dso_local void @heap_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp_len = icmp ule i64 %n, 1
  br i1 %cmp_len, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_top

build_top:
  %rem = phi i64 [ %half, %build_init ], [ %rem.next, %build_after_sift ]
  %cond = icmp ne i64 %rem, 0
  br i1 %cond, label %sift_prep, label %build_done

sift_prep:
  %i_idx = add i64 %rem, -1
  br label %sift_loop

sift_loop:
  %j = phi i64 [ %i_idx, %sift_prep ], [ %j.cont, %sift_continue ]
  %j_dbl = shl i64 %j, 1
  %left = add i64 %j_dbl, 1
  %left_oob = icmp uge i64 %left, %n
  br i1 %left_oob, label %sift_end, label %have_left

have_left:
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  br i1 %right_in, label %cmp_children, label %choose_left

cmp_children:
  %ptr_r = getelementptr inbounds i32, i32* %a, i64 %right
  %val_r = load i32, i32* %ptr_r, align 4
  %ptr_l = getelementptr inbounds i32, i32* %a, i64 %left
  %val_l = load i32, i32* %ptr_l, align 4
  %r_gt_l = icmp sgt i32 %val_r, %val_l
  br i1 %r_gt_l, label %choose_right, label %choose_left

choose_right:
  br label %after_choose

choose_left:
  br label %after_choose

after_choose:
  %maxchild = phi i64 [ %right, %choose_right ], [ %left, %choose_left ]
  %ptr_j = getelementptr inbounds i32, i32* %a, i64 %j
  %val_j = load i32, i32* %ptr_j, align 4
  %ptr_m = getelementptr inbounds i32, i32* %a, i64 %maxchild
  %val_m = load i32, i32* %ptr_m, align 4
  %j_ge_m = icmp sge i32 %val_j, %val_m
  br i1 %j_ge_m, label %sift_end, label %sift_swap

sift_swap:
  store i32 %val_m, i32* %ptr_j, align 4
  store i32 %val_j, i32* %ptr_m, align 4
  br label %sift_continue

sift_continue:
  %j.cont = phi i64 [ %maxchild, %sift_swap ]
  br label %sift_loop

sift_end:
  br label %build_after_sift

build_after_sift:
  %rem.next = phi i64 [ %i_idx, %sift_end ]
  br label %build_top

build_done:
  %hs.init = add i64 %n, -1
  br label %sort_loop_head

sort_loop_head:
  %hs = phi i64 [ %hs.init, %build_done ], [ %hs.dec, %after_sift2 ]
  %hs_ne0 = icmp ne i64 %hs, 0
  br i1 %hs_ne0, label %extract, label %ret

extract:
  %p0 = getelementptr inbounds i32, i32* %a, i64 0
  %v0 = load i32, i32* %p0, align 4
  %pE = getelementptr inbounds i32, i32* %a, i64 %hs
  %vE = load i32, i32* %pE, align 4
  store i32 %vE, i32* %p0, align 4
  store i32 %v0, i32* %pE, align 4
  br label %sift2_loop

sift2_loop:
  %jB = phi i64 [ 0, %extract ], [ %jB.cont, %sift2_continue ]
  %dblB = shl i64 %jB, 1
  %leftB = add i64 %dblB, 1
  %left_oobB = icmp uge i64 %leftB, %hs
  br i1 %left_oobB, label %after_sift2, label %have_leftB

have_leftB:
  %rightB = add i64 %leftB, 1
  %right_inB = icmp ult i64 %rightB, %hs
  br i1 %right_inB, label %cmp_childrenB, label %choose_leftB

cmp_childrenB:
  %ptr_rB = getelementptr inbounds i32, i32* %a, i64 %rightB
  %val_rB = load i32, i32* %ptr_rB, align 4
  %ptr_lB = getelementptr inbounds i32, i32* %a, i64 %leftB
  %val_lB = load i32, i32* %ptr_lB, align 4
  %r_gt_lB = icmp sgt i32 %val_rB, %val_lB
  br i1 %r_gt_lB, label %choose_rightB, label %choose_leftB

choose_rightB:
  br label %after_chooseB

choose_leftB:
  br label %after_chooseB

after_chooseB:
  %maxchildB = phi i64 [ %rightB, %choose_rightB ], [ %leftB, %choose_leftB ]
  %ptr_jB = getelementptr inbounds i32, i32* %a, i64 %jB
  %val_jB = load i32, i32* %ptr_jB, align 4
  %ptr_mB = getelementptr inbounds i32, i32* %a, i64 %maxchildB
  %val_mB = load i32, i32* %ptr_mB, align 4
  %j_ge_mB = icmp sge i32 %val_jB, %val_mB
  br i1 %j_ge_mB, label %after_sift2, label %sift2_swap

sift2_swap:
  store i32 %val_mB, i32* %ptr_jB, align 4
  store i32 %val_jB, i32* %ptr_mB, align 4
  br label %sift2_continue

sift2_continue:
  %jB.cont = phi i64 [ %maxchildB, %sift2_swap ]
  br label %sift2_loop

after_sift2:
  %hs.dec = add i64 %hs, -1
  br label %sort_loop_head

ret:
  ret void
}