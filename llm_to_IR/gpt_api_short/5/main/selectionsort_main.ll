; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x124D
; Intent: Initialize array, sort with selection_sort, and print results (confidence=0.86). Evidence: call to selection_sort with array pointer and length; printing "Sorted array: " and each element with "%d ".
; Preconditions: selection_sort(int*, int) must be provided.
; Postconditions: None.

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)
declare void @__stack_chk_fail()
@__stack_chk_guard = external global i64

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %i = alloca i32, align 4
  %0 = load i64, i64* @__stack_chk_guard
  store i64 %0, i64* %canary.slot, align 8
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4, align 4
  store i32 5, i32* %len, align 4
  %fmt_sorted = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  call void @selection_sort(i32* %arr0, i32 5)
  %1 = call i32 (i8*, ...) @printf(i8* %fmt_sorted)
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %iv = load i32, i32* %i, align 4
  %lenv = load i32, i32* %len, align 4
  %cmp = icmp slt i32 %iv, %lenv
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx.ext = sext i32 %iv to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %val = load i32, i32* %elem.ptr, align 4
  %fmt_d = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %2 = call i32 (i8*, ...) @printf(i8* %fmt_d, i32 %val)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

exit:                                             ; preds = %loop
  %saved = load i64, i64* %canary.slot, align 8
  %now = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %saved, %now
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %exit
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %exit
  ret i32 0
}