; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1247
; Intent: Sort an int array using insertion_sort and print the result (confidence=0.83). Evidence: call to insertion_sort(arr, 10); loop printing with "%d " and final putchar('\n').
; Preconditions: insertion_sort takes (i32* array, i64 count).
; Postconditions: Prints 10 integers separated by spaces followed by a newline; returns 0.

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @insertion_sort(i32*, i64)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %base, align 4
  %idx1 = getelementptr inbounds i32, i32* %base, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %base, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %base, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %base, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %base, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %base, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %base, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %base, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %base, i64 9
  store i32 0, i32* %idx9, align 4
  call void @insertion_sort(i32* %base, i64 10)
  br label %loop

loop:                                             ; preds = %loop, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %loop ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val)
  %inc = add i64 %i, 1
  br label %loop

done:                                             ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}