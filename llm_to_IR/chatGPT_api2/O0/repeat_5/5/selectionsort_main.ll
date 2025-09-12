; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x124D
; Intent: Initialize an int array, sort it with selection_sort, then print the sorted elements (confidence=0.95). Evidence: call to selection_sort; printf of "%d ".
; Preconditions: None
; Postconditions: Returns 0 after printing the sorted array.

@__stack_chk_guard = external global i64
@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00"
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00"

; Only the needed extern declarations:
declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)
declare void @___stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary = load i64, i64* @__stack_chk_guard
  %arr = alloca [5 x i32]
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
  call void @selection_sort(i32* nonnull %arr0, i32 5)
  %fmt = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* nonnull %fmt)
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp slt i32 %i, 5
  br i1 %cmp, label %body, label %done

body:
  %idx = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %idx
  %val = load i32, i32* %elem.ptr, align 4
  %fmt.num = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* nonnull %fmt.num, i32 %val)
  %inc = add nsw i32 %i, 1
  br label %loop

done:
  %canary2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %canary, %canary2
  br i1 %ok, label %ret, label %stkfail

stkfail:
  call void @___stack_chk_fail()
  unreachable

ret:
  ret i32 0
}