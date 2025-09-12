; ModuleID = 'quicksort.ll'
source_filename = "quicksort.c"
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.strnl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)

define void @quick_sort(i32* %arr, i64 %left, i64 %right) {
entry:
  %L = alloca i64, align 8
  %R = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %ip1 = alloca i64, align 8
  store i64 %left, i64* %L, align 8
  store i64 %right, i64* %R, align 8
  %l0 = load i64, i64* %L, align 8
  %r0 = load i64, i64* %R, align 8
  %init_cmp = icmp sge i64 %l0, %r0
  br i1 %init_cmp, label %ret, label %outer

outer:
  %Lval = load i64, i64* %L, align 8
  %Rval = load i64, i64* %R, align 8
  store i64 %Lval, i64* %i, align 8
  store i64 %Rval, i64* %j, align 8
  %diff = sub i64 %Rval, %Lval
  %half = ashr i64 %diff, 1
  %mid = add i64 %Lval, %half
  %midptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %midptr, align 4
  %ival0 = load i64, i64* %i, align 8
  %ip1val = add i64 %ival0, 1
  store i64 %ip1val, i64* %ip1, align 8
  br label %part_loop

part_loop:
  %i1 = load i64, i64* %i, align 8
  %ai_ptr = getelementptr inbounds i32, i32* %arr, i64 %i1
  %ai = load i32, i32* %ai_ptr, align 4
  %cmp_ai = icmp slt i32 %ai, %pivot
  br i1 %cmp_ai, label %inc_i, label %check_j

inc_i:
  %i_old = load i64, i64* %i, align 8
  %i_new = add i64 %i_old, 1
  store i64 %i_new, i64* %i, align 8
  store i64 %i_new, i64* %ip1, align 8
  br label %part_loop

check_j:
  %j1 = load i64, i64* %j, align 8
  %aj_ptr = getelementptr inbounds i32, i32* %arr, i64 %j1
  %aj = load i32, i32* %aj_ptr, align 4
  %cmp_j_gt = icmp sgt i32 %aj, %pivot
  br i1 %cmp_j_gt, label %decj_loop, label %post_adjust

decj_loop:
  %j_cur = load i64, i64* %j, align 8
  %j_dec = add i64 %j_cur, -1
  store i64 %j_dec, i64* %j, align 8
  %j2 = load i64, i64* %j, align 8
  %aj2_ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %aj2 = load i32, i32* %aj2_ptr, align 4
  %cmp_again = icmp sgt i32 %aj2, %pivot
  br i1 %cmp_again, label %decj_loop, label %post_adjust

post_adjust:
  %i2 = load i64, i64* %i, align 8
  %j3 = load i64, i64* %j, align 8
  %le = icmp sle i64 %i2, %j3
  br i1 %le, label %do_swap, label %after_partition

do_swap:
  %i3 = load i64, i64* %i, align 8
  %j4 = load i64, i64* %j, align 8
  %ai_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %i3
  %aj_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %j4
  %ai2 = load i32, i32* %ai_ptr2, align 4
  %aj2b = load i32, i32* %aj_ptr2, align 4
  store i32 %aj2b, i32* %ai_ptr2, align 4
  store i32 %ai2, i32* %aj_ptr2, align 4
  %j_dec2 = add i64 %j4, -1
  store i64 %j_dec2, i64* %j, align 8
  %ip1cur = load i64, i64* %ip1, align 8
  store i64 %ip1cur, i64* %i, align 8
  %j_now = load i64, i64* %j, align 8
  %cond_break = icmp sgt i64 %ip1cur, %j_now
  br i1 %cond_break, label %after_partition, label %part_loop

after_partition:
  %Lcur = load i64, i64* %L, align 8
  %Rcur = load i64, i64* %R, align 8
  %j_end = load i64, i64* %j, align 8
  %i_end = load i64, i64* %i, align 8
  %left_size = sub i64 %j_end, %Lcur
  %right_size = sub i64 %Rcur, %i_end
  %cmp_sizes = icmp sge i64 %left_size, %right_size
  br i1 %cmp_sizes, label %right_first, label %left_first

left_first:
  %cond_left = icmp slt i64 %Lcur, %j_end
  br i1 %cond_left, label %recurse_left, label %set_left_to_i

recurse_left:
  call void @quick_sort(i32* %arr, i64 %Lcur, i64 %j_end)
  br label %set_left_to_i

set_left_to_i:
  store i64 %i_end, i64* %L, align 8
  br label %outer_check

right_first:
  %cond_right = icmp sgt i64 %Rcur, %i_end
  br i1 %cond_right, label %recurse_right, label %set_right_to_j

recurse_right:
  call void @quick_sort(i32* %arr, i64 %i_end, i64 %Rcur)
  br label %set_right_to_j

set_right_to_j:
  store i64 %j_end, i64* %R, align 8
  br label %outer_check

outer_check:
  %Lnew = load i64, i64* %L, align 8
  %Rnew = load i64, i64* %R, align 8
  %cond_outer = icmp sgt i64 %Rnew, %Lnew
  br i1 %cond_outer, label %outer, label %ret

ret:
  ret void
}

define i32 @main(i32 %argc, i8** %argv, i8** %envp) {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %0, align 4
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %1, align 4
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %2, align 4
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %3, align 4
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %4, align 4
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %5, align 4
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %6, align 4
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %8, align 4
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %9, align 4

  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %arrdecay, i64 0, i64 9)

  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:
  %iv = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %iv, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %idxext = sext i32 %iv to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arrdecay, i64 %idxext
  %val = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtptr, i32 %val)
  %iv.next = add nsw i32 %iv, 1
  store i32 %iv.next, i32* %i, align 4
  br label %for.cond

for.end:
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.strnl, i64 0, i64 0
  call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlptr)
  ret i32 0
}