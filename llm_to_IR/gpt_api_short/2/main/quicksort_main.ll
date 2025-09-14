; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1325
; Intent: Initialize an array, quick-sort it, and print the sorted elements followed by a newline (confidence=0.94). Evidence: call to quick_sort with (arr, 0, len-1) and loop printing with "%d ".
; Preconditions: None
; Postconditions: Prints sorted array and returns 0

; Only the necessary external declarations:
declare void @quick_sort(i32*, i64, i64)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)
declare void @___stack_chk_fail()
@__stack_chk_guard = external global i64

@format = private unnamed_addr constant [4 x i8] c"%d \00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %saved_guard = alloca i64, align 8
  store i64 %guard, i64* %saved_guard, align 8

  %arr = alloca [10 x i32], align 16

  ; Initialize array: [9,1,5,3,7,2,8,6,4,0]
  %arr0ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4ptr, align 4
  %arr5ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6ptr, align 4
  %arr7ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8ptr, align 4
  %arr9ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9ptr, align 4

  ; len = 10
  %len = add i64 0, 10

  ; if (len > 1) quick_sort(arr, 0, len-1)
  %cmp = icmp ugt i64 %len, 1
  br i1 %cmp, label %do_sort, label %after_sort

do_sort:
  %arr_base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %high = add i64 %len, -1
  call void @quick_sort(i32* %arr_base, i64 0, i64 %high)
  br label %after_sort

after_sort:
  br label %loop

loop:
  ; for (i = 0; i < len; ++i) printf("%d ", arr[i]);
  %i = phi i64 [ 0, %after_sort ], [ %i.next, %loop_body ]
  %cond = icmp ult i64 %i, %len
  br i1 %cond, label %loop_body, label %after_loop

loop_body:
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem_ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %callp = call i32 (i8*, ...) @_printf(i8* %fmtptr, i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop

after_loop:
  %pc = call i32 @_putchar(i32 10)
  ; stack canary check
  %guard_end = load i64, i64* @__stack_chk_guard
  %guard_saved = load i64, i64* %saved_guard, align 8
  %ok = icmp eq i64 %guard_saved, %guard_end
  br i1 %ok, label %ret, label %fail

fail:
  call void @___stack_chk_fail()
  unreachable

ret:
  ret i32 0
}