; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1247
; Intent: Initialize an int array, sort it with insertion_sort, and print the result (confidence=0.95). Evidence: call to insertion_sort, loop with printf("%d ") and putchar('\n')
; Preconditions: insertion_sort expects a valid i32* and length in elements (i64)
; Postconditions: Returns 0 after printing the sorted array

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @insertion_sort(i32* nocapture, i64) local_unnamed_addr
declare dso_local i32 @printf(i8*, ...) local_unnamed_addr
declare dso_local i32 @putchar(i32) local_unnamed_addr

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
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
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @insertion_sort(i32* %base, i64 10)
  br label %loop

loop:                                             ; preds = %entry, %loop
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt = bitcast [4 x i8]* @.str to i8*
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %i.next = add nuw i64 %i, 1
  br label %loop

done:                                             ; preds = %loop
  %call2 = call i32 @putchar(i32 10)
  ret i32 0
}