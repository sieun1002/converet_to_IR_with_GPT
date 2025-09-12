; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1214
; Intent: test binary_search on a sorted array and print results (confidence=0.90). Evidence: calls binary_search with (int*, len, key); formats "key %d -> index %ld\n"/"not found"
; Preconditions: array is sorted in nondecreasing order
; Postconditions: prints search results and returns 0

@__stack_chk_guard = external global i64
@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@.str_notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail()
declare i64 @binary_search(i32*, i64, i32)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %guard.slot = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %i = alloca i64, align 8
  %idx = alloca i64, align 8
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %guard.slot, align 8
  ; initialize arr = {-5, -1, 0, 2, 2, 3, 7, 9, 12}
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 16
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 0, i32* %arr2, align 8
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4, align 16
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 7, i32* %arr6, align 8
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 12, i32* %arr8, align 16
  ; initialize keys = {2, 5, -5}
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 16
  %keys1 = getelementptr inbounds i32, i32* %keys0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds i32, i32* %keys0, i64 2
  store i32 -5, i32* %keys2, align 8
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.inc, %entry
  %i.val = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.val, 3
  br i1 %cmp, label %loop.body, label %epilogue

loop.body:                                        ; preds = %loop.cond
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.val
  %key = load i32, i32* %key.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %call = call i64 @binary_search(i32* %arr.base, i64 9, i32 %key)
  store i64 %call, i64* %idx, align 8
  %is.neg = icmp slt i64 %call, 0
  br i1 %is.neg, label %print.notfound, label %print.found

print.found:                                      ; preds = %loop.body
  %fmt.found = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  %idx.val = load i64, i64* %idx, align 8
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt.found, i32 %key, i64 %idx.val)
  br label %loop.inc

print.notfound:                                   ; preds = %loop.body
  %fmt.notfound = getelementptr inbounds [21 x i8], [21 x i8]* @.str_notfound, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt.notfound, i32 %key)
  br label %loop.inc

loop.inc:                                         ; preds = %print.notfound, %print.found
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

epilogue:                                         ; preds = %loop.cond
  %guard.end = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %guard.slot, align 8
  %guard.ok = icmp eq i64 %guard.end, %guard.saved
  br i1 %guard.ok, label %ret, label %stackfail

stackfail:                                        ; preds = %epilogue
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %epilogue
  ret i32 0
}