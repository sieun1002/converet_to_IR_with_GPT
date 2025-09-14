; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x124D
; Intent: Initialize an array, sort it with selection_sort, and print the sorted elements (confidence=0.98). Evidence: call to selection_sort(&array, 5); prints "Sorted array: " then loops printing "%d ".
; Preconditions: selection_sort(int*, int) sorts the array in-place.
; Postconditions: returns 0 after printing the sorted array.

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.int = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %array = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  ; Initialize array: {29, 10, 14, 37, 13}
  %0 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  store i32 29, i32* %0, align 16
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 1
  store i32 10, i32* %1, align 4
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 2
  store i32 14, i32* %2, align 8
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 3
  store i32 37, i32* %3, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 4
  store i32 13, i32* %4, align 16
  ; Call selection_sort(&array[0], 5)
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 0
  call void @selection_sort(i32* %arrdecay, i32 5)
  ; Print header
  %fmt_hdr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_hdr)
  ; i = 0
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %iv, 5
  br i1 %cmp, label %body, label %end

body:                                             ; preds = %loop
  %idx64 = sext i32 %iv to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %array, i64 0, i64 %idx64
  %val = load i32, i32* %elem.ptr, align 4
  %fmt_num = getelementptr inbounds [4 x i8], [4 x i8]* @.str.int, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_num, i32 %val)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

end:                                              ; preds = %loop
  ret i32 0
}