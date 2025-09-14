; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x13F7
; Intent: Sort and print an integer array using external merge_sort (confidence=0.89). Evidence: Calls merge_sort(arr, 10); prints each element with "%d " then newline.
; Preconditions: merge_sort(int*, size_t) is available and sorts in-place or produces readable order in the input buffer.
; Postconditions: Prints 10 integers followed by a newline; returns 0.

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the necessary external declarations:
declare dso_local void @merge_sort(i32*, i64)
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

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
  call void @merge_sort(i32* %arrptr, i64 10)
  br label %loop

loop:                                             ; preds = %entry, %loop_body
  %i = phi i64 [ 0, %entry ], [ %inc, %loop_body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop_body, label %done

loop_body:                                        ; preds = %loop
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %inc = add nuw nsw i64 %i, 1
  br label %loop

done:                                             ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}