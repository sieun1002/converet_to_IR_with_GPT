; ModuleID = 'heapsort.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str.before = private unnamed_addr constant [17 x i8] c"Before sorting:\0A\00", align 1
@.str.after = private unnamed_addr constant [16 x i8] c"After sorting:\0A\00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %0, align 4
  %1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %2, align 4
  %3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %3, align 4
  %4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %4, align 4
  %5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %5, align 4
  %6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %6, align 4
  %7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %8, align 4
  %9 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.before, i64 0, i64 0
  %10 = call i32 (i8*, ...) @printf(i8* %9)
  br label %loop1.header

loop1.header:                                     ; preds = %loop1.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.body ]
  %cmp = icmp ult i64 %i, 9
  br i1 %cmp, label %loop1.body, label %loop1.end

loop1.body:                                       ; preds = %loop1.header
  %11 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %12 = load i32, i32* %11, align 4
  %13 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %14 = call i32 (i8*, ...) @printf(i8* %13, i32 %12)
  %i.next = add i64 %i, 1
  br label %loop1.header

loop1.end:                                        ; preds = %loop1.header
  %15 = call i32 @putchar(i32 10)
  %16 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %16, i64 9)
  %17 = getelementptr inbounds [16 x i8], [16 x i8]* @.str.after, i64 0, i64 0
  %18 = call i32 (i8*, ...) @printf(i8* %17)
  br label %loop2.header

loop2.header:                                     ; preds = %loop2.body, %loop1.end
  %j = phi i64 [ 0, %loop1.end ], [ %j.next, %loop2.body ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                       ; preds = %loop2.header
  %19 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %20 = load i32, i32* %19, align 4
  %21 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %22 = call i32 (i8*, ...) @printf(i8* %21, i32 %20)
  %j.next = add i64 %j, 1
  br label %loop2.header

loop2.end:                                        ; preds = %loop2.header
  %23 = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %exit, label %build_setup

build_setup:                                      ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build_header

build_header:                                     ; preds = %build_latch, %build_setup
  %i_prev = phi i64 [ %half, %build_setup ], [ %i_dec, %build_latch ]
  %i_dec = add i64 %i_prev, -1
  %cont_build = icmp ne i64 %i_prev, 0
  br i1 %cont_build, label %sift_entry, label %after_build

sift_entry:                                       ; preds = %build_header
  br label %sift_head

sift_head:                                        ; preds = %sift_swap, %sift_entry
  %curr = phi i64 [ %i_dec, %sift_entry ], [ %child, %sift_swap ]
  %mul = shl i64 %curr, 1
  %left = add i64 %mul, 1
  %left_in_range = icmp ult i64 %left, %n
  br i1 %left_in_range, label %check_right, label %build_latch

check_right:                                      ; preds = %sift_head
  %right = add i64 %left, 1
  %right_in_range = icmp ult i64 %right, %n
  br i1 %right_in_range, label %cmp_children, label %choose_left

choose_left:                                      ; preds = %cmp_children, %check_right
  br label %child_chosen

cmp_children:                                     ; preds = %check_right
  %gep_right = getelementptr inbounds i32, i32* %arr, i64 %right
  %val_right = load i32, i32* %gep_right, align 4
  %gep_left_c = getelementptr inbounds i32, i32* %arr, i64 %left
  %val_left = load i32, i32* %gep_left_c, align 4
  %right_gt_left = icmp sgt i32 %val_right, %val_left
  br i1 %right_gt_left, label %choose_right, label %choose_left

choose_right:                                     ; preds = %cmp_children
  br label %child_chosen

child_chosen:                                     ; preds = %choose_right, %choose_left
  %child = phi i64 [ %left, %choose_left ], [ %right, %choose_right ]
  %gep_curr = getelementptr inbounds i32, i32* %arr, i64 %curr
  %val_curr = load i32, i32* %gep_curr, align 4
  %gep_child = getelementptr inbounds i32, i32* %arr, i64 %child
  %val_child = load i32, i32* %gep_child, align 4
  %curr_ge_child = icmp sge i32 %val_curr, %val_child
  br i1 %curr_ge_child, label %build_latch, label %sift_swap

sift_swap:                                        ; preds = %child_chosen
  store i32 %val_child, i32* %gep_curr, align 4
  store i32 %val_curr, i32* %gep_child, align 4
  br label %sift_head

build_latch:                                      ; preds = %child_chosen, %sift_head
  br label %build_header

after_build:                                      ; preds = %build_header
  %end_init = add i64 %n, -1
  br label %sort_cond

sort_cond:                                        ; preds = %sort_after_sift, %after_build
  %end = phi i64 [ %end_init, %after_build ], [ %end_next, %sort_after_sift ]
  %end_nonzero = icmp ne i64 %end, 0
  br i1 %end_nonzero, label %sort_body, label %exit

sort_body:                                        ; preds = %sort_cond
  %gep_zero = getelementptr inbounds i32, i32* %arr, i64 0
  %val_zero = load i32, i32* %gep_zero, align 4
  %gep_end = getelementptr inbounds i32, i32* %arr, i64 %end
  %val_end = load i32, i32* %gep_end, align 4
  store i32 %val_end, i32* %gep_zero, align 4
  store i32 %val_zero, i32* %gep_end, align 4
  br label %sort_sift_head

sort_sift_head:                                   ; preds = %sc_swap, %sort_body
  %sc_curr = phi i64 [ 0, %sort_body ], [ %sc_child, %sc_swap ]
  %sc_mul = shl i64 %sc_curr, 1
  %sc_left = add i64 %sc_mul, 1
  %sc_left_in = icmp ult i64 %sc_left, %end
  br i1 %sc_left_in, label %sc_check_right, label %sort_after_sift

sc_check_right:                                   ; preds = %sort_sift_head
  %sc_right = add i64 %sc_left, 1
  %sc_right_in = icmp ult i64 %sc_right, %end
  br i1 %sc_right_in, label %sc_cmp_children, label %sc_choose_left

sc_choose_left:                                   ; preds = %sc_cmp_children, %sc_check_right
  br label %sc_child_chosen

sc_cmp_children:                                  ; preds = %sc_check_right
  %sc_gep_right = getelementptr inbounds i32, i32* %arr, i64 %sc_right
  %sc_val_right = load i32, i32* %sc_gep_right, align 4
  %sc_gep_left = getelementptr inbounds i32, i32* %arr, i64 %sc_left
  %sc_val_left = load i32, i32* %sc_gep_left, align 4
  %sc_right_gt_left = icmp sgt i32 %sc_val_right, %sc_val_left
  br i1 %sc_right_gt_left, label %sc_choose_right, label %sc_choose_left

sc_choose_right:                                  ; preds = %sc_cmp_children
  br label %sc_child_chosen

sc_child_chosen:                                  ; preds = %sc_choose_right, %sc_choose_left
  %sc_child = phi i64 [ %sc_left, %sc_choose_left ], [ %sc_right, %sc_choose_right ]
  %sc_gep_curr = getelementptr inbounds i32, i32* %arr, i64 %sc_curr
  %sc_val_curr = load i32, i32* %sc_gep_curr, align 4
  %sc_gep_child = getelementptr inbounds i32, i32* %arr, i64 %sc_child
  %sc_val_child = load i32, i32* %sc_gep_child, align 4
  %sc_curr_ge_child = icmp sge i32 %sc_val_curr, %sc_val_child
  br i1 %sc_curr_ge_child, label %sort_after_sift, label %sc_swap

sc_swap:                                          ; preds = %sc_child_chosen
  store i32 %sc_val_child, i32* %sc_gep_curr, align 4
  store i32 %sc_val_curr, i32* %sc_gep_child, align 4
  br label %sort_sift_head

sort_after_sift:                                  ; preds = %sc_child_chosen, %sort_sift_head
  %end_next = add i64 %end, -1
  br label %sort_cond

exit:                                             ; preds = %sort_cond, %entry
  ret void
}
