; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local void @quick_sort(i32* %arr, i32 %left, i32 %right) {
entry:
  %cmp0 = icmp sge i32 %left, %right
  br i1 %cmp0, label %ret, label %cont

cont:
  %sum = add nsw i32 %left, %right
  %mid = sdiv i32 %sum, 2
  %mid_ext = sext i32 %mid to i64
  %arr_mid_ptr = getelementptr inbounds i32, i32* %arr, i64 %mid_ext
  %pivot = load i32, i32* %arr_mid_ptr, align 4
  br label %partition

partition:
  %i.part = phi i32 [ %left, %cont ], [ %i_after_swap, %do_swap ]
  %j.part = phi i32 [ %right, %cont ], [ %j_after_swap, %do_swap ]
  br label %left_loop

left_loop:
  %i.l = phi i32 [ %i.part, %partition ], [ %i_l_next, %left_loop ]
  %i.l.ext = sext i32 %i.l to i64
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i.l.ext
  %val_i = load i32, i32* %ptr_i, align 4
  %cmp_i = icmp slt i32 %val_i, %pivot
  br i1 %cmp_i, label %left_loop_inc, label %left_done

left_loop_inc:
  %i_l_next = add nsw i32 %i.l, 1
  br label %left_loop

left_done:
  br label %right_loop

right_loop:
  %j.l = phi i32 [ %j.part, %left_done ], [ %j_l_next, %right_loop ]
  %i.fixed = phi i32 [ %i.l, %left_done ], [ %i.fixed, %right_loop ]
  %j.l.ext = sext i32 %j.l to i64
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j.l.ext
  %val_j = load i32, i32* %ptr_j, align 4
  %cmp_j = icmp sgt i32 %val_j, %pivot
  br i1 %cmp_j, label %right_loop_dec, label %right_done

right_loop_dec:
  %j_l_next = add nsw i32 %j.l, -1
  br label %right_loop

right_done:
  %cmp_ij = icmp sle i32 %i.fixed, %j.l
  br i1 %cmp_ij, label %do_swap, label %recurse

do_swap:
  %i.ptr.swap.ext = sext i32 %i.fixed to i64
  %j.ptr.swap.ext = sext i32 %j.l to i64
  %ptr_i_swap = getelementptr inbounds i32, i32* %arr, i64 %i.ptr.swap.ext
  %ptr_j_swap = getelementptr inbounds i32, i32* %arr, i64 %j.ptr.swap.ext
  %tmp_i = load i32, i32* %ptr_i_swap, align 4
  %tmp_j = load i32, i32* %ptr_j_swap, align 4
  store i32 %tmp_j, i32* %ptr_i_swap, align 4
  store i32 %tmp_i, i32* %ptr_j_swap, align 4
  %i_after_swap = add nsw i32 %i.fixed, 1
  %j_after_swap = add nsw i32 %j.l, -1
  br label %partition

recurse:
  %cond1 = icmp slt i32 %left, %j.l
  br i1 %cond1, label %recurse_call1, label %after_call1

recurse_call1:
  call void @quick_sort(i32* %arr, i32 %left, i32 %j.l)
  br label %after_call1

after_call1:
  %cond2 = icmp slt i32 %i.fixed, %right
  br i1 %cond2, label %recurse_call2, label %ret

recurse_call2:
  call void @quick_sort(i32* %arr, i32 %i.fixed, i32 %right)
  br label %ret

ret:
  ret void
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %arr0ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 1
  store i32 1, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 2
  store i32 5, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 3
  store i32 3, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 4
  store i32 7, i32* %arr4ptr, align 4
  %arr5ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 5
  store i32 2, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 6
  store i32 8, i32* %arr6ptr, align 4
  %arr7ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 7
  store i32 6, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 8
  store i32 4, i32* %arr8ptr, align 4
  %arr9ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 9
  store i32 0, i32* %arr9ptr, align 4
  %n = alloca i32, align 4
  store i32 10, i32* %n, align 4
  %nval = load i32, i32* %n, align 4
  %cmpn = icmp ule i32 %nval, 1
  br i1 %cmpn, label %after_sort, label %do_sort

do_sort:
  %nminus1 = add nsw i32 %nval, -1
  call void @quick_sort(i32* %arr0ptr, i32 0, i32 %nminus1)
  br label %after_sort

after_sort:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop_cond

loop_cond:
  %i_val = load i32, i32* %i, align 4
  %nval2 = load i32, i32* %n, align 4
  %cmp = icmp ult i32 %i_val, %nval2
  br i1 %cmp, label %loop_body, label %after_loop

loop_body:
  %i_ext = zext i32 %i_val to i64
  %elem_ptr = getelementptr inbounds i32, i32* %arr0ptr, i64 %i_ext
  %elem = load i32, i32* %elem_ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %i_next = add nsw i32 %i_val, 1
  store i32 %i_next, i32* %i, align 4
  br label %loop_cond

after_loop:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}