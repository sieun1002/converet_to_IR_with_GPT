; ModuleID = 'cases/heapsort3/llm.ll'
source_filename = "llvm-link"
target triple = "x86_64-unknown-linux-gnu"

@.str_before = private unnamed_addr constant [9 x i8] c"Before: \00"
@.str_after = private unnamed_addr constant [8 x i8] c"After: \00"
@.fmt_d = private unnamed_addr constant [4 x i8] c"%d \00"

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [9 x i32], align 16
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 16
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 8
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 16
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 8
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 16
  %0 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([9 x i8], [9 x i8]* @.str_before, i64 0, i64 0))
  br label %print1.loop

print1.loop:                                      ; preds = %print1.body, %entry
  %i1 = phi i64 [ 0, %entry ], [ %i1.next, %print1.body ]
  %i1.cmp = icmp ult i64 %i1, 9
  br i1 %i1.cmp, label %print1.body, label %print1.end

print1.body:                                      ; preds = %print1.loop
  %elem1.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
  %elem1 = load i32, i32* %elem1.ptr, align 4
  %1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_d, i64 0, i64 0), i32 %elem1)
  %i1.next = add i64 %i1, 1
  br label %print1.loop

print1.end:                                       ; preds = %print1.loop
  %2 = call i32 @putchar(i32 10)
  call void @heap_sort(i32* nonnull %p0, i64 9)
  %3 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([8 x i8], [8 x i8]* @.str_after, i64 0, i64 0))
  br label %print2.loop

print2.loop:                                      ; preds = %print2.body, %print1.end
  %i2 = phi i64 [ 0, %print1.end ], [ %i2.next, %print2.body ]
  %i2.cmp = icmp ult i64 %i2, 9
  br i1 %i2.cmp, label %print2.body, label %print2.end

print2.body:                                      ; preds = %print2.loop
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %4 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_d, i64 0, i64 0), i32 %elem2)
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
  %cmp_n_le1 = icmp ult i64 %n, 2
  br i1 %cmp_n_le1, label %ret, label %build_init

build_init:                                       ; preds = %entry
  %i0 = lshr i64 %n, 1
  br label %build_header

build_header:                                     ; preds = %build_dec, %build_init
  %i = phi i64 [ %i0, %build_init ], [ %root_init, %build_dec ]
  %is_zero = icmp eq i64 %i, 0
  br i1 %is_zero, label %sort_check, label %sift_build_entry

sift_build_entry:                                 ; preds = %build_header
  %root_init = add i64 %i, -1
  br label %sift_build_loop

sift_build_loop:                                  ; preds = %sift_build_swapped, %sift_build_entry
  %root = phi i64 [ %root_init, %sift_build_entry ], [ %swap_idx, %sift_build_swapped ]
  %root_x2 = shl i64 %root, 1
  %left = or i64 %root_x2, 1
  %left_lt_n = icmp ult i64 %left, %n
  br i1 %left_lt_n, label %have_left, label %build_dec

have_left:                                        ; preds = %sift_build_loop
  %right = add i64 %root_x2, 2
  %right_lt_n = icmp ult i64 %right, %n
  br i1 %right_lt_n, label %have_right, label %choose_done

have_right:                                       ; preds = %have_left
  %left_ptr = getelementptr inbounds i32, i32* %a, i64 %left
  %left_val = load i32, i32* %left_ptr, align 4
  %right_ptr = getelementptr inbounds i32, i32* %a, i64 %right
  %right_val = load i32, i32* %right_ptr, align 4
  %right_gt_left = icmp sgt i32 %right_val, %left_val
  %spec.select = select i1 %right_gt_left, i64 %right, i64 %left
  br label %choose_done

choose_done:                                      ; preds = %have_right, %have_left
  %swap_idx = phi i64 [ %left, %have_left ], [ %spec.select, %have_right ]
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
  br label %build_header

sort_check:                                       ; preds = %build_header, %after_decrement
  %end.in = phi i64 [ %end, %after_decrement ], [ %n, %build_header ]
  %end = add i64 %end.in, -1
  %end_ne_zero.not = icmp eq i64 %end, 0
  br i1 %end_ne_zero.not, label %ret, label %sort_body

sort_body:                                        ; preds = %sort_check
  %v0 = load i32, i32* %a, align 4
  %pend = getelementptr inbounds i32, i32* %a, i64 %end
  %vend = load i32, i32* %pend, align 4
  store i32 %vend, i32* %a, align 4
  store i32 %v0, i32* %pend, align 4
  br label %sift_sort_loop

sift_sort_loop:                                   ; preds = %do_swap_sort, %sort_body
  %root2 = phi i64 [ 0, %sort_body ], [ %swap_idx2, %do_swap_sort ]
  %root2_x2 = shl i64 %root2, 1
  %left2 = or i64 %root2_x2, 1
  %left2_lt_end = icmp ult i64 %left2, %end
  br i1 %left2_lt_end, label %have_left2, label %after_decrement

have_left2:                                       ; preds = %sift_sort_loop
  %right2 = add i64 %root2_x2, 2
  %right2_lt_end = icmp ult i64 %right2, %end
  br i1 %right2_lt_end, label %have_right2, label %choose_done2

have_right2:                                      ; preds = %have_left2
  %left2_ptr = getelementptr inbounds i32, i32* %a, i64 %left2
  %left2_val = load i32, i32* %left2_ptr, align 4
  %right2_ptr = getelementptr inbounds i32, i32* %a, i64 %right2
  %right2_val = load i32, i32* %right2_ptr, align 4
  %right2_gt_left2 = icmp sgt i32 %right2_val, %left2_val
  %spec.select1 = select i1 %right2_gt_left2, i64 %right2, i64 %left2
  br label %choose_done2

choose_done2:                                     ; preds = %have_right2, %have_left2
  %swap_idx2 = phi i64 [ %left2, %have_left2 ], [ %spec.select1, %have_right2 ]
  %root2_ptr = getelementptr inbounds i32, i32* %a, i64 %root2
  %root2_val = load i32, i32* %root2_ptr, align 4
  %swap2_ptr = getelementptr inbounds i32, i32* %a, i64 %swap_idx2
  %swap2_val = load i32, i32* %swap2_ptr, align 4
  %root2_lt_swap2 = icmp slt i32 %root2_val, %swap2_val
  br i1 %root2_lt_swap2, label %do_swap_sort, label %after_decrement

do_swap_sort:                                     ; preds = %choose_done2
  store i32 %swap2_val, i32* %root2_ptr, align 4
  store i32 %root2_val, i32* %swap2_ptr, align 4
  br label %sift_sort_loop

after_decrement:                                  ; preds = %sift_sort_loop, %choose_done2
  br label %sort_check

ret:                                              ; preds = %sort_check, %entry
  ret void
}
