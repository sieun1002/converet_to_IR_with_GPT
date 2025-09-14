; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1214
; Intent: Test driver for binary_search: searches several keys in a sorted int array and prints results (confidence=0.95). Evidence: calls to binary_search and printf with result formatting.
; Preconditions: binary_search expects a sorted i32 array and returns non-negative index or negative on failure.
; Postconditions: Prints search outcomes and returns 0; stack protector enforced.

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1
@__stack_chk_guard = external global i64

declare i64 @binary_search(i32*, i64, i32)
declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard.ld = load i64, i64* @__stack_chk_guard
  %guard.slot = alloca i64, align 8
  store i64 %guard.ld, i64* %guard.slot, align 8
  %arr = alloca [9 x i32], align 16
  %queries = alloca [3 x i32], align 16
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8, align 4
  %q0 = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 0
  store i32 2, i32* %q0, align 4
  %q1 = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 1
  store i32 5, i32* %q1, align 4
  %q2 = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 2
  store i32 -5, i32* %q2, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.latch, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %loop.latch ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %loop.body, label %after

loop.body:                                        ; preds = %loop.cond
  %q.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 %i
  %key = load i32, i32* %q.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %idx = call i64 @binary_search(i32* %arr.base, i64 9, i32 %key)
  %nonneg = icmp sge i64 %idx, 0
  br i1 %nonneg, label %found, label %notfound

found:                                            ; preds = %loop.body
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key, i64 %idx)
  br label %loop.latch

notfound:                                         ; preds = %loop.body
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %loop.latch

loop.latch:                                       ; preds = %notfound, %found
  %inc = add i64 %i, 1
  br label %loop.cond

after:                                            ; preds = %loop.cond
  %guard.ld2 = load i64, i64* @__stack_chk_guard
  %saved = load i64, i64* %guard.slot, align 8
  %ok = icmp eq i64 %saved, %guard.ld2
  br i1 %ok, label %ret, label %stackfail

stackfail:                                        ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i32 0
}