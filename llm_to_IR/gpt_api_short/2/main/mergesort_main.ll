; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13F7
; Intent: sort and print an array using merge sort (confidence=0.90). Evidence: calls merge_sort with array and length; prints elements in a loop
; Preconditions: none
; Postconditions: prints sorted numbers followed by a newline

; Only the necessary external declarations:
declare void @merge_sort(i32*, i64)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
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
  store i64 10, i64* %len, align 8
  %10 = load i64, i64* %len, align 8
  call void @merge_sort(i32* %0, i64 %10)
  store i64 0, i64* %i, align 8
  br label %loop

loop:                                             ; preds = %body, %entry
  %11 = load i64, i64* %i, align 8
  %12 = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %11, %12
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %11
  %val = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 @_printf(i8* %fmt, i32 %val)
  %inc = add i64 %11, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

done:                                             ; preds = %loop
  %call2 = call i32 @_putchar(i32 10)
  ret i32 0
}