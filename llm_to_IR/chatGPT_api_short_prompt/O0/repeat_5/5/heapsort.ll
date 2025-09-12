; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort ; Address: 0x1189
; Intent: In-place ascending heap sort of 32-bit integers (confidence=0.96). Evidence: 4-byte element addressing; classic heapify and sift-down loops with children 2*i+1 and 2*i+2.
; Preconditions: arr points to at least n 32-bit integers.
; Postconditions: arr[0..n-1] is sorted in nondecreasing order.

; Only the necessary external declarations:
; (none)

define dso_local void @heap_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %exit, label %build_init

build_init:
  %half = lshr i64 %n, 1
  br label %build_loop.header

build_loop.header:
  %t = phi i64 [ %half, %build_init ], [ %t_next, %after_sift1 ]
  %t_ne_0 = icmp ne i64 %t, 0
  br i1 %t_ne_0, label %build_loop.body, label %after_build

build_loop.body:
  %i0 = add i64 %t, -1
  br label %sift1.header

sift1.header:
  %j = phi i64 [ %i0, %build_loop.body ], [ %j_next, %sift1.swap ]
  %left = add i64 (mul i64 %j, 2), 1
  %left_in_range = icmp ult i64 %left, %n
  br i1 %left_in_range, label %sift1.checkRight, label %after_sift1

sift1.checkRight:
  %right = add i64 %left, 1
  %right_in_range = icmp ult i64 %right, %n
  %left_ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  br i1 %right_in_range, label %sift1.compareChildren, label %sift1.chooseLeft

sift1.compareChildren:
  %right_ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  %maxChild_idx = select i1 %right_gt_left, i64 %right, i64 %left
  br label %sift1.compareAndMaybeSwap

sift1.chooseLeft:
  br label %sift1.compareAndMaybeSwap

sift1.compareAndMaybeSwap:
  %max_idx = phi i64 [ %left, %sift1.chooseLeft ], [ %maxChild_idx, %sift1.compareChildren ]
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j_val = load i32, i32* %j_ptr, align 4
  %max_ptr = getelementptr inbounds i32, i32* %arr, i64 %max_idx
  %max_val = load i32, i32* %max_ptr, align 4
  %j_ge_max = icmp sge i32 %j_val, %max_val
  br i1 %j_ge_max, label %after_sift1, label %sift1.swap

sift1.swap:
  %tmp1 = load i32, i32* %j_ptr, align 4
  store i32 %max_val, i32* %j_ptr, align 4
  store i32 %tmp1, i32* %max_ptr, align 4
  %j_next = phi i64 [ %max_idx, %sift1.compareAndMaybeSwap ]
  br label %sift1.header

after_sift1:
  %t_next = add i64 %t, -1
  br label %build_loop.header

after_build:
  %k_init = add i64 %n, -1
  br label %outer2.header

outer2.header:
  %k = phi i64 [ %k_init, %after_build ], [ %k_next, %after_sift2 ]
  %k_ne_0 = icmp ne i64 %k, 0
  br i1 %k_ne_0, label %outer2.body, label %exit

outer2.body:
  ; swap arr[0] and arr[k]
  %root_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  store i32 %k_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %k_ptr, align 4
  br label %sift2.header

sift2.header:
  %j2 = phi i64 [ 0, %outer2.body ], [ %j2_next, %sift2.swap ]
  %left2 = add i64 (mul i64 %j2, 2), 1
  %left2_in_range = icmp ult i64 %left2, %k
  br i1 %left2_in_range, label %sift2.checkRight, label %after_sift2

sift2.checkRight:
  %right2 = add i64 %left2, 1
  %right2_in_range = icmp ult i64 %right2, %k
  %left2_ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  br i1 %right2_in_range, label %sift2.compareChildren, label %sift2.chooseLeft

sift2.compareChildren:
  %right2_ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %right2_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  %maxChild2_idx = select i1 %right2_gt_left2, i64 %right2, i64 %left2
  br label %sift2.compareAndMaybeSwap

sift2.chooseLeft:
  br label %sift2.compareAndMaybeSwap

sift2.compareAndMaybeSwap:
  %max2_idx = phi i64 [ %left2, %sift2.chooseLeft ], [ %maxChild2_idx, %sift2.compareChildren ]
  %j2_ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j2_val = load i32, i32* %j2_ptr, align 4
  %max2_ptr = getelementptr inbounds i32, i32* %arr, i64 %max2_idx
  %max2_val = load i32, i32* %max2_ptr, align 4
  %j2_ge_max2 = icmp sge i32 %j2_val, %max2_val
  br i1 %j2_ge_max2, label %after_sift2, label %sift2.swap

sift2.swap:
  %tmp2 = load i32, i32* %j2_ptr, align 4
  store i32 %max2_val, i32* %j2_ptr, align 4
  store i32 %tmp2, i32* %max2_ptr, align 4
  %j2_next = phi i64 [ %max2_idx, %sift2.compareAndMaybeSwap ]
  br label %sift2.header

after_sift2:
  %k_next = add i64 %k, -1
  br label %outer2.header

exit:
  ret void
}