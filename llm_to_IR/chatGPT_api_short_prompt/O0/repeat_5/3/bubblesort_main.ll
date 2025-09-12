; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x128B
; Intent: Initialize an array, sort it via bubble_sort, print elements, then newline (confidence=0.83). Evidence: call to bubble_sort(arr, 10); loop printing with "%d " followed by putchar('\n')
; Preconditions: bubble_sort must accept (i32* arr, i64 n) and sort in-place
; Postconditions: Prints 10 integers separated by spaces and a trailing newline; returns 0

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the necessary external declarations:
declare void @bubble_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
  %n = alloca i64, align 8
  ; initialize n
  store i64 10, i64* %n, align 8
  ; initialize array: 9,1,5,3,7,2,8,6,4,0
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0
  store i32 9, i32* %arr0, align 16
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5, i32* %arr2, align 8
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7, i32* %arr4, align 16
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8, i32* %arr6, align 8
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %arr8, align 16
  %arr9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0, i32* %arr9, align 4

  ; call bubble_sort(arr, n)
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0
  %nval0 = load i64, i64* %n, align 8
  call void @bubble_sort(i32* %arrptr, i64 %nval0)

  ; for (i = 0; i < n; ++i) printf("%d ", arr[i]);
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %nval = load i64, i64* %n, align 8
  %cmp = icmp ult i64 %iv, %nval
  br i1 %cmp, label %body, label %after

body:
  %eltptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i64 %iv
  %elt = load i32, i32* %eltptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elt)
  %next = add i64 %iv, 1
  store i64 %next, i64* %i, align 8
  br label %loop

after:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}