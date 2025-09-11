; ModuleID = 'heapsort_llm.bc'
source_filename = "llvm-link"
target triple = "x86_64-unknown-linux-gnu"

@.str_before = private unnamed_addr constant [9 x i8] c"Before: \00"
@.str_after = private unnamed_addr constant [8 x i8] c"After: \00"
@.fmt_d = private unnamed_addr constant [4 x i8] c"%d \00"

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [9 x i32], align 16
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 4
  %before_s = getelementptr inbounds [9 x i8], [9 x i8]* @.str_before, i64 0, i64 0
  %0 = call i32 (i8*, ...) @printf(i8* %before_s)
  br label %print1.loop

print1.loop:                                      ; preds = %print1.body, %entry
  %i1 = phi i64 [ 0, %entry ], [ %i1.next, %print1.body ]
  %i1.cmp = icmp ult i64 %i1, 9
  br i1 %i1.cmp, label %print1.body, label %print1.end

print1.body:                                      ; preds = %print1.loop
  %elem1.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
  %elem1 = load i32, i32* %elem1.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt_d, i64 0, i64 0
  %1 = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem1)
  %i1.next = add i64 %i1, 1
  br label %print1.loop

print1.end:                                       ; preds = %print1.loop
  %2 = call i32 @putchar(i32 10)
  %a0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %a0, i64 9)
  %after_s = getelementptr inbounds [8 x i8], [8 x i8]* @.str_after, i64 0, i64 0
  %3 = call i32 (i8*, ...) @printf(i8* %after_s)
  br label %print2.loop

print2.loop:                                      ; preds = %print2.body, %print1.end
  %i2 = phi i64 [ 0, %print1.end ], [ %i2.next, %print2.body ]
  %i2.cmp = icmp ult i64 %i2, 9
  br i1 %i2.cmp, label %print2.body, label %print2.end

print2.body:                                      ; preds = %print2.loop
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt_d, i64 0, i64 0
  %4 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %elem2)
  %i2.next = add i64 %i2, 1
  br label %print2.loop

print2.end:                                       ; preds = %print2.loop
  %5 = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define dso_local void @heap_sort(i32* %a, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build_init

build_init:                                       ; preds = %entry
  %i0 = lshr i64 %n, 1
  br label %build_header

build_header:                                     ; preds = %build_dec, %build_init
  %i = phi i64 [ %i0, %build_init ], [ %i_dec, %build_dec ]
  %is_zero = icmp eq i64 %i, 0
  br i1 %is_zero, label %sort_init, label %sift_build_entry

sift_build_entry:                                 ; preds = %build_header
  %root_init = add i64 %i, -1
  br label %sift_build_loop

sift_build_loop:                                  ; preds = %sift_build_swapped, %sift_build_entry
  %root = phi i64 [ %root_init, %sift_build_entry ], [ %swap_idx, %sift_build_swapped ]
  %root_x2 = shl i64 %root, 1
  %left = add i64 %root_x2, 1
  %left_lt_n = icmp ult i64 %left, %n
  br i1 %left_lt_n, label %have_left, label %build_dec

have_left:                                        ; preds = %sift_build_loop
  %right = add i64 %left, 1
  %right_lt_n = icmp ult i64 %right, %n
  %left_ptr = getelementptr inbounds i32, i32* %a, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  br i1 %right_lt_n, label %have_right, label %choose_left

have_right:                                       ; preds = %have_left
  %right_ptr = getelementptr inbounds i32, i32* %a, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  br i1 %right_gt_left, label %choose_right, label %choose_left

choose_left:                                      ; preds = %have_right, %have_left
  %swap_idx_left = phi i64 [ %left, %have_right ], [ %left, %have_left ]
  br label %choose_done

choose_right:                                     ; preds = %have_right
  %swap_idx_right = phi i64 [ %right, %have_right ]
  br label %choose_done

choose_done:                                      ; preds = %choose_right, %choose_left
  %swap_idx = phi i64 [ %swap_idx_right, %choose_right ], [ %swap_idx_left, %choose_left ]
  %root_ptr = getelementptr inbounds i32, i32* %a, i64 %root
  %root_val = load i32, i32* %root_ptr, align 4
  %swap_ptr = getelementptr inbounds i32, i32* %a, i64 %swap_idx
  %swap_val = load i32, i32* %swap_ptr, align 4
  %root_lt_swap = icmp slt i32 %root_val, %swap_val
  br i1 %root_lt_swap, label %sift_build_swapped, label %build_dec

sift_build_swapped:                               ; preds = %choose_done
  store i32 %swap_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %swap_ptr, align 4
  br label %sift_build_loop

build_dec:                                        ; preds = %choose_done, %sift_build_loop
  %i_dec = add i64 %i, -1
  br label %build_header

sort_init:                                        ; preds = %build_header
  %end0 = add i64 %n, -1
  br label %sort_check

sort_check:                                       ; preds = %after_decrement, %sort_init
  %end = phi i64 [ %end0, %sort_init ], [ %end_next, %after_decrement ]
  %end_ne_zero = icmp ne i64 %end, 0
  br i1 %end_ne_zero, label %sort_body, label %ret

sort_body:                                        ; preds = %sort_check
  %p0 = getelementptr inbounds i32, i32* %a, i64 0
  %v0 = load i32, i32* %p0, align 4
  %pend = getelementptr inbounds i32, i32* %a, i64 %end
  %vend = load i32, i32* %pend, align 4
  store i32 %vend, i32* %p0, align 4
  store i32 %v0, i32* %pend, align 4
  br label %sift_sort_loop

sift_sort_loop:                                   ; preds = %do_swap_sort, %sort_body
  %root2 = phi i64 [ 0, %sort_body ], [ %swap_idx2, %do_swap_sort ]
  %root2_x2 = shl i64 %root2, 1
  %left2 = add i64 %root2_x2, 1
  %left2_lt_end = icmp ult i64 %left2, %end
  br i1 %left2_lt_end, label %have_left2, label %after_sift

have_left2:                                       ; preds = %sift_sort_loop
  %right2 = add i64 %left2, 1
  %right2_lt_end = icmp ult i64 %right2, %end
  %left2_ptr = getelementptr inbounds i32, i32* %a, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  br i1 %right2_lt_end, label %have_right2, label %choose_left2

have_right2:                                      ; preds = %have_left2
  %right2_ptr = getelementptr inbounds i32, i32* %a, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %right2_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  br i1 %right2_gt_left2, label %choose_right2, label %choose_left2

choose_left2:                                     ; preds = %have_right2, %have_left2
  %swap_idx2_left = phi i64 [ %left2, %have_right2 ], [ %left2, %have_left2 ]
  br label %choose_done2

choose_right2:                                    ; preds = %have_right2
  %swap_idx2_right = phi i64 [ %right2, %have_right2 ]
  br label %choose_done2

choose_done2:                                     ; preds = %choose_right2, %choose_left2
  %swap_idx2 = phi i64 [ %swap_idx2_right, %choose_right2 ], [ %swap_idx2_left, %choose_left2 ]
  %root2_ptr = getelementptr inbounds i32, i32* %a, i64 %root2
  %root2_val = load i32, i32* %root2_ptr, align 4
  %swap2_ptr = getelementptr inbounds i32, i32* %a, i64 %swap_idx2
  %swap2_val = load i32, i32* %swap2_ptr, align 4
  %root2_lt_swap2 = icmp slt i32 %root2_val, %swap2_val
  br i1 %root2_lt_swap2, label %do_swap_sort, label %after_sift

do_swap_sort:                                     ; preds = %choose_done2
  store i32 %swap2_val, i32* %root2_ptr, align 4
  store i32 %root2_val, i32* %swap2_ptr, align 4
  br label %sift_sort_loop

after_sift:                                       ; preds = %choose_done2, %sift_sort_loop
  %end_next = add i64 %end, -1
  br label %after_decrement

after_decrement:                                  ; preds = %after_sift
  br label %sort_check

ret:                                              ; preds = %sort_check, %entry
  ret void
}
