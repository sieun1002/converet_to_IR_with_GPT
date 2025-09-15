; ModuleID = 'heapsort.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str.before = private unnamed_addr constant [17 x i8] c"Before sorting: \00", align 1
@.str.after = private unnamed_addr constant [16 x i8] c"After sorting: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %arr0ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4ptr, align 4
  %arr5ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6ptr, align 4
  %arr7ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8ptr, align 4
  store i64 9, i64* %len, align 8
  %before_ptr = getelementptr inbounds [17 x i8], [17 x i8]* @.str.before, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %before_ptr)
  store i64 0, i64* %i, align 8
  br label %loop

loop:                                             ; preds = %loop.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.cur, %len.val
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %inc = add i64 %i.cur, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

loop.end:                                         ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  %base.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len2 = load i64, i64* %len, align 8
  call void @heap_sort(i32* %base.ptr, i64 %len2)
  %after_ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str.after, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %after_ptr)
  store i64 0, i64* %j, align 8
  br label %loop2

loop2:                                            ; preds = %loop2.body, %loop.end
  %j.cur = load i64, i64* %j, align 8
  %len3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %j.cur, %len3
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                       ; preds = %loop2
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.cur
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmtptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @printf(i8* %fmtptr2, i32 %elem2)
  %inc2 = add i64 %j.cur, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2

loop2.end:                                        ; preds = %loop2
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %build_init

build_init:                                       ; preds = %entry
  %half0 = lshr i64 %n, 1
  br label %build_loop_cond

build_loop_cond:                                  ; preds = %build_after_sift, %build_init
  %r = phi i64 [ %half0, %build_init ], [ %r_dec, %build_after_sift ]
  %r_is_zero = icmp eq i64 %r, 0
  br i1 %r_is_zero, label %after_build, label %build_body_prep

build_body_prep:                                  ; preds = %build_loop_cond
  %idx0 = add i64 %r, -1
  br label %sift1_loop_cond

sift1_loop_cond:                                  ; preds = %sift1_swapped, %build_body_prep
  %cur = phi i64 [ %idx0, %build_body_prep ], [ %j, %sift1_swapped ]
  %cur_shl = shl i64 %cur, 1
  %left = add i64 %cur_shl, 1
  %cmp_left_n = icmp uge i64 %left, %n
  br i1 %cmp_left_n, label %build_after_sift, label %choose_right

choose_right:                                     ; preds = %sift1_loop_cond
  %right = add i64 %left, 1
  %right_in = icmp ult i64 %right, %n
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %ptr_left, align 4
  br i1 %right_in, label %compare_right, label %child_is_left

compare_right:                                    ; preds = %choose_right
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %ptr_right, align 4
  %cmp_right_left = icmp sgt i32 %val_right, %val_left
  br i1 %cmp_right_left, label %child_is_right, label %child_is_left_from_compare

child_is_right:                                   ; preds = %compare_right
  br label %child_selected

child_is_left_from_compare:                       ; preds = %compare_right
  br label %child_selected

child_is_left:                                    ; preds = %choose_right
  br label %child_selected

child_selected:                                   ; preds = %child_is_left, %child_is_left_from_compare, %child_is_right
  %j = phi i64 [ %right, %child_is_right ], [ %left, %child_is_left_from_compare ], [ %left, %child_is_left ]
  %val_j = phi i32 [ %val_right, %child_is_right ], [ %val_left, %child_is_left_from_compare ], [ %val_left, %child_is_left ]
  %ptr_cur = getelementptr inbounds i32, i32* %arr, i64 %cur
  %val_cur = load i32, i32* %ptr_cur, align 4
  %cmp_cur_child = icmp sge i32 %val_cur, %val_j
  br i1 %cmp_cur_child, label %build_after_sift, label %sift1_swapped

sift1_swapped:                                    ; preds = %child_selected
  store i32 %val_j, i32* %ptr_cur, align 4
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val_cur, i32* %ptr_j, align 4
  br label %sift1_loop_cond

build_after_sift:                                 ; preds = %child_selected, %sift1_loop_cond
  %r_dec = add i64 %r, -1
  br label %build_loop_cond

after_build:                                      ; preds = %build_loop_cond
  %m_init = add i64 %n, -1
  br label %sort_loop_cond

sort_loop_cond:                                   ; preds = %sort_after_sift, %after_build
  %m = phi i64 [ %m_init, %after_build ], [ %m_dec, %sort_after_sift ]
  %m_is_zero = icmp eq i64 %m, 0
  br i1 %m_is_zero, label %ret, label %sort_swap_root

sort_swap_root:                                   ; preds = %sort_loop_cond
  %p0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %p0, align 4
  %pm = getelementptr inbounds i32, i32* %arr, i64 %m
  %vm = load i32, i32* %pm, align 4
  store i32 %vm, i32* %p0, align 4
  store i32 %v0, i32* %pm, align 4
  br label %sift2_loop_cond

sift2_loop_cond:                                  ; preds = %sift2_swapped, %sort_swap_root
  %cur2 = phi i64 [ 0, %sort_swap_root ], [ %j2, %sift2_swapped ]
  %cur2_shl = shl i64 %cur2, 1
  %left2 = add i64 %cur2_shl, 1
  %cmp_left2_m = icmp uge i64 %left2, %m
  br i1 %cmp_left2_m, label %sort_after_sift, label %choose_right2

choose_right2:                                    ; preds = %sift2_loop_cond
  %right2 = add i64 %left2, 1
  %right2_in = icmp ult i64 %right2, %m
  %ptr_left2 = getelementptr inbounds i32, i32* %arr, i64 %left2
  %val_left2 = load i32, i32* %ptr_left2, align 4
  br i1 %right2_in, label %compare_right2, label %child_is_left2

compare_right2:                                   ; preds = %choose_right2
  %ptr_right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %val_right2 = load i32, i32* %ptr_right2, align 4
  %cmp_right_left2 = icmp sgt i32 %val_right2, %val_left2
  br i1 %cmp_right_left2, label %child_is_right2, label %child_is_left_from_compare2

child_is_right2:                                  ; preds = %compare_right2
  br label %child_selected2

child_is_left_from_compare2:                      ; preds = %compare_right2
  br label %child_selected2

child_is_left2:                                   ; preds = %choose_right2
  br label %child_selected2

child_selected2:                                  ; preds = %child_is_left2, %child_is_left_from_compare2, %child_is_right2
  %j2 = phi i64 [ %right2, %child_is_right2 ], [ %left2, %child_is_left_from_compare2 ], [ %left2, %child_is_left2 ]
  %val_j2 = phi i32 [ %val_right2, %child_is_right2 ], [ %val_left2, %child_is_left_from_compare2 ], [ %val_left2, %child_is_left2 ]
  %ptr_cur2 = getelementptr inbounds i32, i32* %arr, i64 %cur2
  %val_cur2 = load i32, i32* %ptr_cur2, align 4
  %cmp_cur_child2 = icmp sge i32 %val_cur2, %val_j2
  br i1 %cmp_cur_child2, label %sort_after_sift, label %sift2_swapped

sift2_swapped:                                    ; preds = %child_selected2
  store i32 %val_j2, i32* %ptr_cur2, align 4
  %ptr_j2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  store i32 %val_cur2, i32* %ptr_j2, align 4
  br label %sift2_loop_cond

sort_after_sift:                                  ; preds = %child_selected2, %sift2_loop_cond
  %m_dec = add i64 %m, -1
  br label %sort_loop_cond

ret:                                              ; preds = %sort_loop_cond, %entry
  ret void
}
