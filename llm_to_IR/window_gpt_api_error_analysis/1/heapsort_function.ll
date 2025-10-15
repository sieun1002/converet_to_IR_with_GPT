; ModuleID = 'heap_sort_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr nounwind {
entry:
  %n_le1 = icmp ule i64 %n, 1
  %half = lshr i64 %n, 1
  br i1 %n_le1, label %ret, label %heapify_control

heapify_control:                                 ; for (i = n/2; i != 0; )
  %i_curr = phi i64 [ %half, %entry ], [ %i_next, %after_sift ]
  %nonzero = icmp ne i64 %i_curr, 0
  %i_dec = add i64 %i_curr, -1
  br i1 %nonzero, label %heapify_body, label %extract_init

heapify_body:
  br label %sift1_head

sift1_head:
  %idx = phi i64 [ %i_dec, %heapify_body ], [ %idx_next1, %sift1_swap ]
  %outer_i = phi i64 [ %i_dec, %heapify_body ], [ %outer_i, %sift1_swap ]
  %idx2mul = shl i64 %idx, 1
  %child = add i64 %idx2mul, 1
  %child_ok = icmp ult i64 %child, %n
  br i1 %child_ok, label %choose_child, label %after_sift

choose_child:
  %childp1 = add i64 %child, 1
  %has_right = icmp ult i64 %childp1, %n
  br i1 %has_right, label %hasright1, label %noright1

hasright1:
  %child_ptr = getelementptr inbounds i32, i32* %arr, i64 %child
  %child_val = load i32, i32* %child_ptr, align 4
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %childp1
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_child = icmp sgt i32 %right_val, %child_val
  %mc_then = select i1 %right_gt_child, i64 %childp1, i64 %child
  br label %mc_join1

noright1:
  br label %mc_join1

mc_join1:
  %maxchild1 = phi i64 [ %mc_then, %hasright1 ], [ %child, %noright1 ]
  br label %cmp1

cmp1:
  %idx_ptr = getelementptr inbounds i32, i32* %arr, i64 %idx
  %idx_val = load i32, i32* %idx_ptr, align 4
  %max_ptr = getelementptr inbounds i32, i32* %arr, i64 %maxchild1
  %max_val = load i32, i32* %max_ptr, align 4
  %lt = icmp slt i32 %idx_val, %max_val
  br i1 %lt, label %sift1_swap, label %after_sift

sift1_swap:
  store i32 %max_val, i32* %idx_ptr, align 4
  store i32 %idx_val, i32* %max_ptr, align 4
  %idx_next1 = add i64 %maxchild1, 0
  br label %sift1_head

after_sift:
  %i_next = phi i64 [ %outer_i, %sift1_head ], [ %outer_i, %cmp1 ]
  br label %heapify_control

extract_init:
  %end_init = add i64 %n, -1
  br label %extract_loop

extract_loop:
  %end_phi = phi i64 [ %end_init, %extract_init ], [ %end_next, %extract_tail ]
  %cont = icmp ne i64 %end_phi, 0
  br i1 %cont, label %extract_body, label %ret

extract_body:
  %a0ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %a0 = load i32, i32* %a0ptr, align 4
  %end_ptr = getelementptr inbounds i32, i32* %arr, i64 %end_phi
  %end_val = load i32, i32* %end_ptr, align 4
  store i32 %end_val, i32* %a0ptr, align 4
  store i32 %a0, i32* %end_ptr, align 4
  br label %sift2_head

sift2_head:
  %i2 = phi i64 [ 0, %extract_body ], [ %idx_next2, %sift2_swap ]
  %i2mul = shl i64 %i2, 1
  %child2 = add i64 %i2mul, 1
  %child2_ok = icmp ult i64 %child2, %end_phi
  br i1 %child2_ok, label %choose_child2, label %extract_tail

choose_child2:
  %child2p1 = add i64 %child2, 1
  %has_right2 = icmp ult i64 %child2p1, %end_phi
  br i1 %has_right2, label %hasright2, label %noright2

hasright2:
  %child2_ptr = getelementptr inbounds i32, i32* %arr, i64 %child2
  %child2_val = load i32, i32* %child2_ptr, align 4
  %right2_ptr = getelementptr inbounds i32, i32* %arr, i64 %child2p1
  %right2_val = load i32, i32* %right2_ptr, align 4
  %right2_gt_child = icmp sgt i32 %right2_val, %child2_val
  %mc_then2 = select i1 %right2_gt_child, i64 %child2p1, i64 %child2
  br label %mc_join2

noright2:
  br label %mc_join2

mc_join2:
  %maxchild2idx = phi i64 [ %mc_then2, %hasright2 ], [ %child2, %noright2 ]
  br label %cmp2

cmp2:
  %i2_ptr = getelementptr inbounds i32, i32* %arr, i64 %i2
  %i2_val = load i32, i32* %i2_ptr, align 4
  %max2_ptr = getelementptr inbounds i32, i32* %arr, i64 %maxchild2idx
  %max2_val = load i32, i32* %max2_ptr, align 4
  %ige = icmp sge i32 %i2_val, %max2_val
  br i1 %ige, label %extract_tail, label %sift2_swap

sift2_swap:
  store i32 %max2_val, i32* %i2_ptr, align 4
  store i32 %i2_val, i32* %max2_ptr, align 4
  %idx_next2 = add i64 %maxchild2idx, 0
  br label %sift2_head

extract_tail:
  %end_next = add i64 %end_phi, -1
  br label %extract_loop

ret:
  ret void
}