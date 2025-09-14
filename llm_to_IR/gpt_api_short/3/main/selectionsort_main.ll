; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x124D
; Intent: sort an int array via selection_sort and print it (confidence=0.85). Evidence: call to selection_sort; prints with "%d ".
; Preconditions:
; Postconditions: Prints "Sorted array: " followed by the sorted values separated by spaces.

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [5 x i32], align 16
  %0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %0, align 4
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %1, align 4
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %2, align 4
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %3, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %4, align 4
  call void @selection_sort(i32* %0, i32 5)
  %5 = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %6 = call i32 (i8*, ...) @printf(i8* %5)
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp slt i32 %i, 5
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %idx64 = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx64
  %val = load i32, i32* %elem.ptr, align 4
  %7 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %8 = call i32 (i8*, ...) @printf(i8* %7, i32 %val)
  %inc = add nsw i32 %i, 1
  br label %loop

exit:
  ret i32 0
}