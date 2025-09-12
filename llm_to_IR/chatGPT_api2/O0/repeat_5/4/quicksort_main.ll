; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1325
; Intent: Initialize an int array, quicksort it, then print elements. (confidence=0.92). Evidence: call to quick_sort and looped printf of array elements.
; Preconditions: quick_sort sorts the array in-place; expects valid bounds [0, n-1].
; Postconditions: prints the (sorted) array elements followed by a newline; returns 0.

@.str = private unnamed_addr constant [4 x i8] c"%d \00"

; Only the needed extern declarations:
declare void @quick_sort(i32* nocapture, i64, i64)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %0, align 16
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %1, align 4
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %2, align 8
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %3, align 4
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %4, align 16
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %5, align 4
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %6, align 8
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %8, align 16
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %9, align 4
  ; n = 10
  ; if (n > 1) quick_sort(arr, 0, n-1)
  tail call void @quick_sort(i32* nonnull %0, i64 0, i64 9)
  br label %loop.cond

loop.cond:                                        ; preds = %entry, %loop.body
  %i = phi i64 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = tail call i32 (i8*, ...) @_printf(i8* nonnull %fmtptr, i32 %val)
  %inc = add i64 %i, 1
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %putc = tail call i32 @_putchar(i32 10)
  ret i32 0
}