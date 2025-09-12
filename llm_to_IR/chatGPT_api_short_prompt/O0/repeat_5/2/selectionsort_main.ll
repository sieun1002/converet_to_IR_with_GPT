; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x124D
; Intent: Sort a small array using selection_sort and print the sorted result (confidence=0.93). Evidence: call to selection_sort; printing with "%d ".
; Preconditions: selection_sort must accept (int* arr, int n) and sort in place.
; Postconditions: Prints "Sorted array: " followed by the sorted 5 integers; returns 0.

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [5 x i32], align 16
  %i = alloca i32, align 4

  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arrptr, align 4
  %e1 = getelementptr inbounds i32, i32* %arrptr, i64 1
  store i32 10, i32* %e1, align 4
  %e2 = getelementptr inbounds i32, i32* %arrptr, i64 2
  store i32 14, i32* %e2, align 4
  %e3 = getelementptr inbounds i32, i32* %arrptr, i64 3
  store i32 37, i32* %e3, align 4
  %e4 = getelementptr inbounds i32, i32* %arrptr, i64 4
  store i32 13, i32* %e4, align 4

  call void @selection_sort(i32* %arrptr, i32 5)

  %fmt0 = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt0)

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %iv = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %iv, 5
  br i1 %cmp, label %body, label %done

body:
  %idx64 = sext i32 %iv to i64
  %p = getelementptr inbounds i32, i32* %arrptr, i64 %idx64
  %val = load i32, i32* %p, align 4
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %val)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

done:
  ret i32 0
}