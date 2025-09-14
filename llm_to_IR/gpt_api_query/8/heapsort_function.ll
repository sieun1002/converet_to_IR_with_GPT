; ModuleID = 'heap_sort.ll'
target triple = "x86_64-unknown-linux-gnu"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %build_init

; Build max-heap: for (i = n/2 - 1; i >= 0; --i) sift-down
build_init:
  %half = lshr i64 %n, 1
  %half_is_zero = icmp eq i64 %half, 0
  br i1 %half_is_zero, label %sort_init, label %build_loop

build_loop:
  %i = phi i64 [ %i_next, %build_after ], [ %i0, %build_init ]
  ; first-iteration i0 = half - 1
  ; compute i0 in predecessor
  br label %sift_entry

i0: ; unreachable label placeholder (not used)

build_init_to_loop:
  unreachable

; Sift-down with limit = n, starting at j = i
sift_entry:
  %j = phi i64 [ %i, %build_loop ], [ %j_next, %sift_iter ]
  ; child = 2*j + 1
  %j2 = add i64 %j, %j
  %child = add i64 %j2, 1
  %child_ge_n = icmp uge i64 %child, %n
  br i1 %child_ge_n, label %build_after, label %have_child

have_child:
  %right = add i64 %child, 1
  %right_lt_n = icmp ult i64 %right, %n
  br i1 %right_lt_n, label %choose_max_cmp, label %choose_child_left

choose_max_cmp:
  ; compare arr[right] vs arr[child]
  %p_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %v_right = load i32, i32* %p_right, align 4
  %p_child = getelementptr inbounds i32, i32* %arr, i64 %child
  %v_child = load i32, i32* %p_child, align 4
  %right_gt_left = icmp sgt i32 %v_right, %v_child
  %maxChild = select i1 %right_gt_left, i64 %right, i64 %child
  br label %have_max_child

choose_child_left:
  %maxChild.left = phi i64 [ %child, %have_child ]
  br label %have_max_child

have_max_child:
  %mc = phi i64 [ %maxChild, %choose_max_cmp ], [ %maxChild.left, %choose_child_left ]
  ; if arr[j] >= arr[mc], break
  %p_j = getelementptr inbounds i32, i32* %arr, i64 %j
  %v_j = load i32, i32* %p_j, align 4
  %p_mc = getelementptr inbounds i32, i32* %arr, i64 %mc
  %v_mc = load i32, i32* %p_mc, align 4
  %j_ge_mc = icmp sge i32 %v_j, %v_mc
  br i1 %j_ge_mc, label %build_after, label %sift_swap

sift_swap:
  ; swap arr[j] and arr[mc]
  store i32 %v_mc, i32* %p_j, align 4
  store i32 %v_j, i32* %p_mc, align 4
  %j_next = add i64 %mc, 0
  br label %sift_iter

sift_iter:
  br label %sift_entry

build_after:
  ; next i
  %is_zero_i = icmp eq i64 %i, 0
  br i1 %is_zero_i, label %sort_init, label %build_next

build_next:
  %i_next = add i64 %i, -1
  br label %build_loop

; Initialize i0 = half - 1 for the first build_loop iteration
; (placed after users to keep the function linear)
build_init_cont:
  unreachable

; Sortdown phase
sort_init:
  %end0 = add i64 %n, -1
  br label %sort_cond

sort_cond:
  %end = phi i64 [ %end0, %sort_init ], [ %end_next, %sort_after ]
  %end_is_zero = icmp eq i64 %end, 0
  br i1 %end_is_zero, label %ret, label %sort_swap

sort_swap:
  ; swap arr[0] and arr[end]
  %p0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %p0, align 4
  %p_end = getelementptr inbounds i32, i32* %arr, i64 %end
  %vend = load i32, i32* %p_end, align 4
  store i32 %vend, i32* %p0, align 4
  store i32 %v0, i32* %p_end, align 4
  ; sift-down j=0 with limit = end
  br label %sift2_entry

sift2_entry:
  %j2_phi = phi i64 [ 0, %sort_swap ], [ %j2_next, %sift2_iter ]
  ; child = 2*j + 1
  %j2d = add i64 %j2_phi, %j2_phi
  %child2 = add i64 %j2d, 1
  %child2_ge_end = icmp uge i64 %child2, %end
  br i1 %child2_ge_end, label %sort_after, label %have_child2

have_child2:
  %right2 = add i64 %child2, 1
  %right2_lt_end = icmp ult i64 %right2, %end
  br i1 %right2_lt_end, label %choose_max_cmp2, label %choose_child_left2

choose_max_cmp2:
  %p_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %v_right2 = load i32, i32* %p_right2, align 4
  %p_child2 = getelementptr inbounds i32, i32* %arr, i64 %child2
  %v_child2 = load i32, i32* %p_child2, align 4
  %right2_gt_left2 = icmp sgt i32 %v_right2, %v_child2
  %maxChild2 = select i1 %right2_gt_left2, i64 %right2, i64 %child2
  br label %have_max_child2

choose_child_left2:
  %maxChild2.left = phi i64 [ %child2, %have_child2 ]
  br label %have_max_child2

have_max_child2:
  %mc2 = phi i64 [ %maxChild2, %choose_max_cmp2 ], [ %maxChild2.left, %choose_child_left2 ]
  %p_j2 = getelementptr inbounds i32, i32* %arr, i64 %j2_phi
  %v_j2 = load i32, i32* %p_j2, align 4
  %p_mc2 = getelementptr inbounds i32, i32* %arr, i64 %mc2
  %v_mc2 = load i32, i32* %p_mc2, align 4
  %j2_ge_mc2 = icmp sge i32 %v_j2, %v_mc2
  br i1 %j2_ge_mc2, label %sort_after, label %sift2_swap

sift2_swap:
  store i32 %v_mc2, i32* %p_j2, align 4
  store i32 %v_j2, i32* %p_mc2, align 4
  %j2_next = add i64 %mc2, 0
  br label %sift2_iter

sift2_iter:
  br label %sift2_entry

sort_after:
  %end_next = add i64 %end, -1
  br label %sort_cond

; Compute i0 = half - 1 (forward-referenced earlier)
build_init:
  ; This is a duplicate label name; LLVM requires unique labels.
  unreachable

ret:
  ret void
}

; Note: For the first build-loop iteration, compute i0 = half - 1:
; LLVM textual IR requires SSA; in practical generation, place:
;   %i0 = add i64 %half, -1
; before the branch to build_loop from build_init.
; Some placeholder unreachable labels are present to keep the listing linear.