; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

define void @sub_140001450(i32* %a, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_check

build_check:
  %tNext = phi i64 [ %half, %build_init ], [ %tNext_dec, %after_sift_build ]
  %cond = icmp ne i64 %tNext, 0
  br i1 %cond, label %build_body, label %sort_prep

build_body:
  %tNext_dec = add i64 %tNext, -1
  br label %sift_build_loop_header

sift_build_loop_header:
  %root = phi i64 [ %tNext_dec, %build_body ], [ %childIdxPhi, %do_swap_build ]
  %root_shl1 = shl i64 %root, 1
  %left = add i64 %root_shl1, 1
  %cmpLeft = icmp ult i64 %left, %n
  br i1 %cmpLeft, label %choose_child_build, label %after_sift_build

choose_child_build:
  %ptrLeft = getelementptr inbounds i32, i32* %a, i64 %left
  %valLeft = load i32, i32* %ptrLeft, align 4
  %right = add i64 %left, 1
  %condRight = icmp ult i64 %right, %n
  br i1 %condRight, label %both_present, label %only_left

both_present:
  %ptrRight = getelementptr inbounds i32, i32* %a, i64 %right
  %valRight = load i32, i32* %ptrRight, align 4
  %cmpChildren = icmp sgt i32 %valRight, %valLeft
  %childIdx_both = select i1 %cmpChildren, i64 %right, i64 %left
  %childVal_both = select i1 %cmpChildren, i32 %valRight, i32 %valLeft
  br label %compare_root_child

only_left:
  %childIdx_only = add i64 %left, 0
  %childVal_only = add i32 %valLeft, 0
  br label %compare_root_child

compare_root_child:
  %childIdxPhi = phi i64 [ %childIdx_both, %both_present ], [ %childIdx_only, %only_left ]
  %childValPhi = phi i32 [ %childVal_both, %both_present ], [ %childVal_only, %only_left ]
  %ptrRoot = getelementptr inbounds i32, i32* %a, i64 %root
  %rootVal = load i32, i32* %ptrRoot, align 4
  %needSwap = icmp slt i32 %rootVal, %childValPhi
  br i1 %needSwap, label %do_swap_build, label %after_sift_build

do_swap_build:
  %ptrRoot2 = getelementptr inbounds i32, i32* %a, i64 %root
  %ptrChild2 = getelementptr inbounds i32, i32* %a, i64 %childIdxPhi
  store i32 %childValPhi, i32* %ptrRoot2, align 4
  store i32 %rootVal, i32* %ptrChild2, align 4
  br label %sift_build_loop_header

after_sift_build:
  br label %build_check

sort_prep:
  %end_init = add i64 %n, -1
  br label %outer_check

outer_check:
  %end = phi i64 [ %end_init, %sort_prep ], [ %end_next, %outer_after_inner ]
  %condEnd = icmp ne i64 %end, 0
  br i1 %condEnd, label %outer_body, label %ret

outer_body:
  %ptrEnd0 = getelementptr inbounds i32, i32* %a, i64 %end
  %val0 = load i32, i32* %a, align 4
  %valEnd0 = load i32, i32* %ptrEnd0, align 4
  store i32 %valEnd0, i32* %a, align 4
  store i32 %val0, i32* %ptrEnd0, align 4
  br label %inner_header

inner_header:
  %j = phi i64 [ 0, %outer_body ], [ %newJ, %inner_swap ]
  %j_shl1 = shl i64 %j, 1
  %left2 = add i64 %j_shl1, 1
  %cmpLeft2 = icmp ult i64 %left2, %end
  br i1 %cmpLeft2, label %inner_choose, label %inner_break

inner_choose:
  %ptrLeft2 = getelementptr inbounds i32, i32* %a, i64 %left2
  %valLeft2 = load i32, i32* %ptrLeft2, align 4
  %right2 = add i64 %left2, 1
  %condR2 = icmp ult i64 %right2, %end
  br i1 %condR2, label %inner_both, label %inner_onlyleft

inner_both:
  %ptrRight2 = getelementptr inbounds i32, i32* %a, i64 %right2
  %valRight2 = load i32, i32* %ptrRight2, align 4
  %cmpChild2 = icmp sgt i32 %valRight2, %valLeft2
  %childIdx_b2 = select i1 %cmpChild2, i64 %right2, i64 %left2
  %childVal_b2 = select i1 %cmpChild2, i32 %valRight2, i32 %valLeft2
  br label %inner_compare

inner_onlyleft:
  %childIdx_o2 = add i64 %left2, 0
  %childVal_o2 = add i32 %valLeft2, 0
  br label %inner_compare

inner_compare:
  %childIdx2 = phi i64 [ %childIdx_b2, %inner_both ], [ %childIdx_o2, %inner_onlyleft ]
  %childVal2 = phi i32 [ %childVal_b2, %inner_both ], [ %childVal_o2, %inner_onlyleft ]
  %ptrJ = getelementptr inbounds i32, i32* %a, i64 %j
  %valJ = load i32, i32* %ptrJ, align 4
  %swapNeeded2 = icmp slt i32 %valJ, %childVal2
  br i1 %swapNeeded2, label %inner_swap, label %inner_break

inner_swap:
  %ptrChildIn = getelementptr inbounds i32, i32* %a, i64 %childIdx2
  store i32 %childVal2, i32* %ptrJ, align 4
  store i32 %valJ, i32* %ptrChildIn, align 4
  %newJ = add i64 %childIdx2, 0
  br label %inner_header

inner_break:
  br label %outer_after_inner

outer_after_inner:
  %end_next = add i64 %end, -1
  br label %outer_check

ret:
  ret void
}