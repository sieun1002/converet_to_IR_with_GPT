; ModuleID: heap_sort_demo
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@.str_orig = private unnamed_addr constant [17 x i8] c"Original array:\0A\00", align 1
@.str_sorted = private unnamed_addr constant [15 x i8] c"Sorted array:\0A\00", align 1
@.str_d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @heap_sort(i32*, i64)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16

  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8, align 4

  %orig_fmt_ptr = getelementptr inbounds [17 x i8], [17 x i8]* @.str_orig, i64 0, i64 0
  %call_printf_orig = call i32 (i8*, ...) @printf(i8* %orig_fmt_ptr)

  br label %print_loop1.cond

print_loop1.cond:                                  ; preds = %print_loop1.body, %entry
  %i1 = phi i64 [ 0, %entry ], [ %inc1, %print_loop1.body ]
  %cmp1 = icmp ult i64 %i1, 9
  br i1 %cmp1, label %print_loop1.body, label %after_print1

print_loop1.body:                                  ; preds = %print_loop1.cond
  %elem_ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i1
  %elem1 = load i32, i32* %elem_ptr1, align 4
  %fmt_d_ptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  %call_printf_elem1 = call i32 (i8*, ...) @printf(i8* %fmt_d_ptr1, i32 %elem1)
  %inc1 = add i64 %i1, 1
  br label %print_loop1.cond

after_print1:                                      ; preds = %print_loop1.cond
  %newline1 = call i32 @putchar(i32 10)

  %arr_base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr_base, i64 9)

  %sorted_fmt_ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str_sorted, i64 0, i64 0
  %call_printf_sorted = call i32 (i8*, ...) @printf(i8* %sorted_fmt_ptr)

  br label %print_loop2.cond

print_loop2.cond:                                  ; preds = %print_loop2.body, %after_print1
  %i2 = phi i64 [ 0, %after_print1 ], [ %inc2, %print_loop2.body ]
  %cmp2 = icmp ult i64 %i2, 9
  br i1 %cmp2, label %print_loop2.body, label %after_print2

print_loop2.body:                                  ; preds = %print_loop2.cond
  %elem_ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i2
  %elem2 = load i32, i32* %elem_ptr2, align 4
  %fmt_d_ptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  %call_printf_elem2 = call i32 (i8*, ...) @printf(i8* %fmt_d_ptr2, i32 %elem2)
  %inc2 = add i64 %i2, 1
  br label %print_loop2.cond

after_print2:                                      ; preds = %print_loop2.cond
  %newline2 = call i32 @putchar(i32 10)
  ret i32 0
}