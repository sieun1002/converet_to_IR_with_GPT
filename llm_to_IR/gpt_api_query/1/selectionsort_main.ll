; target: x86_64 Linux, LLVM 14 IR

target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)
declare void @__stack_chk_fail()

define i32 @main() {
entry:
  %guard = alloca i64, align 8
  %i = alloca i32, align 4
  %arr = alloca [5 x i32], align 16

  ; stack canary prologue
  %gload = load i64, i64* @__stack_chk_guard, align 8
  store i64 %gload, i64* %guard, align 8

  ; initialize array: {29, 10, 14, 37, 13}
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0, align 16
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2, align 8
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4, align 16

  ; call selection_sort(arr, 5)
  %decay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* %decay, i32 5)

  ; printf("Sorted array: ")
  %fmt0 = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt0)

  ; i = 0
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %iv, 5
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %idxext = sext i32 %iv to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idxext
  %val = load i32, i32* %elem.ptr, align 4
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt1, i32 %val)
  %next = add nsw i32 %iv, 1
  store i32 %next, i32* %i, align 4
  br label %loop

after:                                            ; preds = %loop
  ; stack canary epilogue
  %gstored = load i64, i64* %guard, align 8
  %gcurr = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %gstored, %gcurr
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i32 0
}