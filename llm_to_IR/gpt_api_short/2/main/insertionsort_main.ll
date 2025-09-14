; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1247
; Intent: Initialize an array, sort it with insertion_sort, and print the result (confidence=0.94). Evidence: call to insertion_sort(arr, 10); loop printing with "%d ".
; Preconditions: None
; Postconditions: Prints 10 integers and a newline to stdout; returns 0

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @insertion_sort(i32*, i64)

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 9, i32* %0, align 4
  store i32 1, i32* %1, align 4
  store i32 5, i32* %2, align 4
  store i32 3, i32* %3, align 4
  store i32 7, i32* %4, align 4
  store i32 2, i32* %5, align 4
  store i32 8, i32* %6, align 4
  store i32 6, i32* %7, align 4
  store i32 4, i32* %8, align 4
  store i32 0, i32* %9, align 4
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @insertion_sort(i32* %arr.ptr, i64 10)
  br label %loop.header

loop.header:                                      ; preds = %entry, %loop.body
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.header
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %val)
  %i.next = add i64 %i, 1
  br label %loop.header

after.loop:                                       ; preds = %loop.header
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}