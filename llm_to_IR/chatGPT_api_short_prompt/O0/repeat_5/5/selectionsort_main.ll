; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x124D
; Intent: initialize array, call selection_sort, then print elements (confidence=0.86). Evidence: call to selection_sort; printf of "%d " after "Sorted array: ".
; Preconditions: selection_sort(i32*, i32) expects a valid array pointer and length.
; Postconditions: prints "Sorted array: " followed by the sorted elements separated by spaces; returns 0.

@format = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

; Only the necessary external declarations:
declare dso_local void @selection_sort(i32*, i32)
declare dso_local i32 @_printf(i8*, ...)
declare dso_local void @___stack_chk_fail()

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %i = alloca i32, align 4
  %g0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %g0, i64* %canary, align 8
  ; initialize array: {29, 10, 14, 37, 13}
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
  ; call selection_sort(&arr[0], len)
  %p = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %len.v = load i32, i32* %len, align 4
  call void @selection_sort(i32* %p, i32 %len.v)
  ; printf("Sorted array: ")
  %fmt = getelementptr inbounds [15 x i8], [15 x i8]* @format, i64 0, i64 0
  %callhdr = call i32 (i8*, ...) @_printf(i8* %fmt)
  ; i = 0
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %iv = load i32, i32* %i, align 4
  %len.cur = load i32, i32* %len, align 4
  %cmp = icmp slt i32 %iv, %len.cur
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %idxext = sext i32 %iv to i64
  %eltp = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idxext
  %elt = load i32, i32* %eltp, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call = call i32 (i8*, ...) @_printf(i8* %fmt2, i32 %elt)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:                                            ; preds = %loop
  %g1 = load i64, i64* @__stack_chk_guard, align 8
  %gsaved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %gsaved, %g1
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %after
  call void @___stack_chk_fail()
  br label %ret

ret:                                              ; preds = %fail, %after
  ret i32 0
}