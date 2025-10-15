; ModuleID = 'main.ll'
source_filename = "main.c"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-w64-windows-gnu"

@.str.before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str.after  = private unnamed_addr constant [8 x i8] c"After: \00", align 1
@.str.int    = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @__main()
declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)
declare dso_local void @heap_sort(i32* noundef, i64 noundef)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  call void @__main()
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
  store i64 9, i64* %len, align 8
  %fmt_before_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.before, i64 0, i64 0
  %call_printf_before = call i32 (i8*, ...) @printf(i8* noundef %fmt_before_ptr)
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                      ; preds = %loop1.body, %entry
  %i.val = load i64, i64* %i, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.val, %len.val
  br i1 %cmp, label %loop1.body, label %loop1.end

loop1.body:                                      ; preds = %loop1.cond
  %idx = load i64, i64* %i, align 8
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %idx
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt_int_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.int, i64 0, i64 0
  %call_printf_elem = call i32 (i8*, ...) @printf(i8* noundef %fmt_int_ptr, i32 noundef %elem)
  %inc = add i64 %idx, 1
  store i64 %inc, i64* %i, align 8
  br label %loop1.cond

loop1.end:                                       ; preds = %loop1.cond
  %nl1 = call i32 @putchar(i32 noundef 10)
  %arr.first = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len2 = load i64, i64* %len, align 8
  call void @heap_sort(i32* noundef %arr.first, i64 noundef %len2)
  %fmt_after_ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.str.after, i64 0, i64 0
  %call_printf_after = call i32 (i8*, ...) @printf(i8* noundef %fmt_after_ptr)
  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:                                      ; preds = %loop2.body, %loop1.end
  %j.val = load i64, i64* %j, align 8
  %len3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %j.val, %len3
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                      ; preds = %loop2.cond
  %j.idx = load i64, i64* %j, align 8
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.idx
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmt_int_ptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.int, i64 0, i64 0
  %call_printf_elem2 = call i32 (i8*, ...) @printf(i8* noundef %fmt_int_ptr2, i32 noundef %elem2)
  %inc2 = add i64 %j.idx, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2.cond

loop2.end:                                       ; preds = %loop2.cond
  %nl2 = call i32 @putchar(i32 noundef 10)
  ret i32 0
}