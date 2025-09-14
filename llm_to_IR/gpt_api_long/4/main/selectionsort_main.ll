; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x124D
; Intent: Initialize an array, sort it with selection_sort, and print it (confidence=0.93). Evidence: call to selection_sort; prints "Sorted array:" followed by integers in a loop
; Preconditions: selection_sort expects a valid i32 array pointer and non-negative length.
; Postconditions: Prints "Sorted array: " followed by the sorted integers separated by spaces.

@.str.sorted = private unnamed_addr constant [16 x i8] c"Sorted array: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external thread_local global i64

declare void @selection_sort(i32*, i32)
declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary = load i64, i64* @__stack_chk_guard
  %arr = alloca [5 x i32], align 16
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
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* %arrptr, i32 5)
  %fmt = getelementptr inbounds [16 x i8], [16 x i8]* @.str.sorted, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt)
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp slt i32 %i, 5
  br i1 %cmp, label %loop.body, label %check

loop.body:
  %idx64 = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx64
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %elem)
  %inc = add i32 %i, 1
  br label %loop

check:
  %guard2 = load i64, i64* @__stack_chk_guard
  %eq = icmp eq i64 %canary, %guard2
  br i1 %eq, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}