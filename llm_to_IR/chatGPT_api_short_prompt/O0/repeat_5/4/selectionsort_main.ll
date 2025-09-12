; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x124D
; Intent: Sort a small int array with selection_sort and print it (confidence=0.93). Evidence: call to selection_sort with array+length; printf of "Sorted array: " and "%d " in a loop
; Preconditions: selection_sort(int*, int) must sort in-place; stdout available
; Postconditions: returns 0; prints sorted array values

@format = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

; Only the necessary external declarations:
declare void @selection_sort(i32*, i32) local_unnamed_addr
declare i32 @_printf(i8*, ...) local_unnamed_addr
declare void @___stack_chk_fail() noreturn local_unnamed_addr

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %i = alloca i32, align 4

  ; stack protector prologue
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.slot, align 8

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

  store i32 5, i32* %n, align 4

  ; call selection_sort(&arr[0], n)
  %arr_ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %n.val = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arr_ptr, i32 %n.val)

  ; printf("Sorted array: ")
  %fmt = getelementptr inbounds [15 x i8], [15 x i8]* @format, i64 0, i64 0
  %call_printf0 = call i32 (i8*, ...) @_printf(i8* %fmt)

  ; i = 0
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %loop.body, %entry
  %i.cur = load i32, i32* %i, align 4
  %n.cur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i.cur, %n.cur
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop
  %idxext = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idxext
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call_printf1 = call i32 (i8*, ...) @_printf(i8* %fmt2, i32 %elem)
  %inc = add nsw i32 %i.cur, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after.loop:                                       ; preds = %loop
  ; stack protector epilogue
  %guard.end = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary.slot, align 8
  %cmpcan = icmp eq i64 %guard.end, %guard.saved
  br i1 %cmpcan, label %ret.ok, label %stackfail

stackfail:                                        ; preds = %after.loop
  call void @___stack_chk_fail()
  unreachable

ret.ok:                                           ; preds = %after.loop
  ret i32 0
}