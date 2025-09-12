; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1325
; Intent: Initialize an array, quick-sort it, and print the elements (confidence=0.86). Evidence: call to quick_sort with bounds (0, n-1); print loop with "%d " and trailing newline.
; Preconditions: Length > 1 before calling quick_sort.
; Postconditions: Prints the array followed by newline; returns 0.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

declare void @quick_sort(i32*, i64, i64)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main() local_unnamed_addr {
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
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %need_sort = icmp ugt i64 10, 1
  br i1 %need_sort, label %do_sort, label %after_sort

do_sort:                                          ; preds = %entry
  %last = add i64 10, -1
  call void @quick_sort(i32* %arrptr, i64 0, i64 %last)
  br label %after_sort

after_sort:                                       ; preds = %do_sort, %entry
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %after_sort
  %i = phi i64 [ 0, %after_sort ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call = call i32 @_printf(i8* %fmt, i32 %val)
  %i.next = add i64 %i, 1
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %nl = call i32 @_putchar(i32 10)
  ret i32 0
}