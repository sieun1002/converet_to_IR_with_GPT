; ModuleID = 'fixed'
source_filename = "fixed"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str_sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str_fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dllimport i32 @printf(i8*, ...)
declare void @__main()

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %min = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %after_swap, %entry
  %i_val = load i32, i32* %i, align 4
  %n_minus1 = add nsw i32 %n, -1
  %cond_outer = icmp slt i32 %i_val, %n_minus1
  br i1 %cond_outer, label %outer.body, label %outer.end

outer.body:                                       ; preds = %outer.cond
  %i_val2 = load i32, i32* %i, align 4
  store i32 %i_val2, i32* %min, align 4
  %i_val3 = load i32, i32* %i, align 4
  %j_start = add nsw i32 %i_val3, 1
  store i32 %j_start, i32* %j, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %after_update, %outer.body
  %j_val = load i32, i32* %j, align 4
  %cond_inner = icmp slt i32 %j_val, %n
  br i1 %cond_inner, label %inner.body, label %inner.end

inner.body:                                       ; preds = %inner.cond
  %j_val2 = load i32, i32* %j, align 4
  %j_idx = sext i32 %j_val2 to i64
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j_idx
  %j_elem = load i32, i32* %j_ptr, align 4
  %min_val = load i32, i32* %min, align 4
  %min_idx = sext i32 %min_val to i64
  %min_ptr = getelementptr inbounds i32, i32* %arr, i64 %min_idx
  %min_elem = load i32, i32* %min_ptr, align 4
  %is_less = icmp slt i32 %j_elem, %min_elem
  br i1 %is_less, label %update_min, label %no_update_min

update_min:                                       ; preds = %inner.body
  %j_val3 = load i32, i32* %j, align 4
  store i32 %j_val3, i32* %min, align 4
  br label %after_update

no_update_min:                                    ; preds = %inner.body
  br label %after_update

after_update:                                     ; preds = %no_update_min, %update_min
  %j_old = load i32, i32* %j, align 4
  %j_inc = add nsw i32 %j_old, 1
  store i32 %j_inc, i32* %j, align 4
  br label %inner.cond

inner.end:                                        ; preds = %inner.cond
  %min_val2 = load i32, i32* %min, align 4
  %i_val4 = load i32, i32* %i, align 4
  %need_swap = icmp ne i32 %min_val2, %i_val4
  br i1 %need_swap, label %do_swap, label %skip_swap

do_swap:                                          ; preds = %inner.end
  %i_idx = sext i32 %i_val4 to i64
  %i_ptr = getelementptr inbounds i32, i32* %arr, i64 %i_idx
  %min_idx2 = sext i32 %min_val2 to i64
  %min_ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min_idx2
  %i_elem2 = load i32, i32* %i_ptr, align 4
  %min_elem2 = load i32, i32* %min_ptr2, align 4
  store i32 %i_elem2, i32* %tmp, align 4
  store i32 %min_elem2, i32* %i_ptr, align 4
  %tmp_val = load i32, i32* %tmp, align 4
  store i32 %tmp_val, i32* %min_ptr2, align 4
  br label %after_swap

skip_swap:                                        ; preds = %inner.end
  br label %after_swap

after_swap:                                       ; preds = %skip_swap, %do_swap
  %i_old = load i32, i32* %i, align 4
  %i_inc = add nsw i32 %i_old, 1
  store i32 %i_inc, i32* %i, align 4
  br label %outer.cond

outer.end:                                        ; preds = %outer.cond
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %arr0ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4ptr, align 4
  store i32 5, i32* %n, align 4
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arrptr, i32 %nval)
  %fmt_sorted_ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_sorted, i64 0, i64 0
  %call1 = call i32 @printf(i8* %fmt_sorted_ptr)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i_val = load i32, i32* %i, align 4
  %n_val2 = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i_val, %n_val2
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %i_val3 = load i32, i32* %i, align 4
  %i64 = sext i32 %i_val3 to i64
  %elemptr = getelementptr inbounds i32, i32* %arrptr, i64 %i64
  %elem = load i32, i32* %elemptr, align 4
  %fmt_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str_fmt, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i32 %elem)
  %i_old = load i32, i32* %i, align 4
  %i_inc = add nsw i32 %i_old, 1
  store i32 %i_inc, i32* %i, align 4
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  ret i32 0
}