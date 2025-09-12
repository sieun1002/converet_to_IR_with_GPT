; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x124d
; Intent: Sort an int array with selection_sort, then print it (confidence=0.93). Evidence: call to selection_sort; prints "Sorted array: " and each element with "%d ".
; Preconditions: selection_sort(int*, int) must be available.
; Postconditions: Prints the sorted array and returns 0. Stack canary checked via __stack_chk_guard.

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)
declare void @__stack_chk_fail()
@__stack_chk_guard = external global i64

@format = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %g0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %g0, i64* %canary.slot, align 8
  ; initialize array: [29, 10, 14, 37, 13]
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
  %arr.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %n.val = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arr.ptr, i32 %n.val)
  %fmt = getelementptr inbounds [15 x i8], [15 x i8]* @format, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %iv = load i32, i32* %i, align 4
  %n.cur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %iv, %n.cur
  br i1 %cmp, label %loop.body, label %stackchk

loop.body:                                        ; preds = %loop.cond
  %idx = sext i32 %iv * to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %elem)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

stackchk:                                         ; preds = %loop.cond
  %c.saved = load i64, i64* %canary.slot, align 8
  %g1 = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %c.saved, %g1
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %stackchk
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %stackchk
  ret i32 0
}