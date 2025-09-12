; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1247
; Intent: Initialize array, sort with insertion_sort, print elements (confidence=0.86). Evidence: initialization of 10 ints, call to insertion_sort, looped printf/putchar.
; Preconditions: None
; Postconditions: Prints sorted array elements followed by newline

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @insertion_sort(i32*, i64)
declare void @__stack_chk_fail()
@__stack_chk_guard = external global i64

@.str = private unnamed_addr constant [4 x i8] c"%d \00"

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; stack protector setup
  %canary.slot = alloca i64, align 8
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %canary.slot, align 8

  ; local array
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9, align 4

  ; call insertion_sort(arr, 10)
  call void @insertion_sort(i32* %arr0, i64 10)

  br label %loop

loop:                                             ; preds = %printf.cont, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %printf.cont ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val)
  br label %printf.cont

printf.cont:                                      ; preds = %body
  %inc = add i64 %i, 1
  br label %loop

after:                                            ; preds = %loop
  %put = call i32 @putchar(i32 10)

  ; stack protector check
  %1 = load i64, i64* @__stack_chk_guard, align 8
  %2 = load i64, i64* %canary.slot, align 8
  %ok = icmp eq i64 %2, %1
  br i1 %ok, label %ret, label %stackchkfail

stackchkfail:                                     ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i32 0
}