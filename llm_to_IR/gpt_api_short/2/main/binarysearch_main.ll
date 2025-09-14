; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x00001214
; Intent: Test binary_search on a sorted array with several keys and print results (confidence=0.93). Evidence: Calls binary_search; prints "key %d -> index %ld" or "not found".
; Preconditions: None
; Postconditions: Returns 0 after printing results for each key.

@format = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@aKeyDNotFound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

; Only the necessary external declarations:
declare i64 @binary_search(i32*, i64, i32)
declare i32 @_printf(i8*, ...)
declare void @___stack_chk_fail()
declare i64 @__stack_chk_guard

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  %keys = alloca [3 x i32], align 16
  %key_count = alloca i64, align 8
  %i = alloca i64, align 8

  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.slot, align 8

  ; initialize arr = [-5, -1, 0, 2, 2, 3, 7, 9, 12]
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

  store i64 9, i64* %n, align 8

  ; initialize keys = [2, 5, -5]
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 16
  %keys1 = getelementptr inbounds i32, i32* %keys0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds i32, i32* %keys0, i64 2
  store i32 -5, i32* %keys2, align 8

  store i64 3, i64* %key_count, align 8
  store i64 0, i64* %i, align 8

  br label %loop.cond

loop.cond:                                        ; preds = %loop.inc, %entry
  %i.val = load i64, i64* %i, align 8
  %kc.val = load i64, i64* %key_count, align 8
  %cmp = icmp ult i64 %i.val, %kc.val
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.val
  %key = load i32, i32* %key.ptr, align 4
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %res = call i64 @binary_search(i32* %arr.ptr, i64 %n.val, i32 %key)
  %found = icmp sge i64 %res, 0
  br i1 %found, label %print.found, label %print.notfound

print.found:                                      ; preds = %loop.body
  %fmt.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @_printf(i8* %fmt.ptr, i32 %key, i64 %res)
  br label %loop.inc

print.notfound:                                   ; preds = %loop.body
  %fmt2.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @_printf(i8* %fmt2.ptr, i32 %key)
  br label %loop.inc

loop.inc:                                         ; preds = %print.notfound, %print.found
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %guard.saved = load i64, i64* %canary.slot, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %guard.ok = icmp eq i64 %guard.saved, %guard.now
  br i1 %guard.ok, label %ret, label %fail

fail:                                             ; preds = %after.loop
  call void @___stack_chk_fail()
  unreachable

ret:                                              ; preds = %after.loop
  ret i32 0
}