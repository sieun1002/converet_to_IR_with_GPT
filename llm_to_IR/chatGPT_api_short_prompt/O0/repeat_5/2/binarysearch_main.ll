; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1214
; Intent: Test binary_search on a sorted int array with several keys and print results (confidence=0.86). Evidence: calls binary_search with array+length and key; prints "index %ld" or "not found".
; Preconditions: array sorted in nondecreasing order for binary_search to work correctly.
; Postconditions: returns 0 after printing results.

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"
@__stack_chk_guard = external global i64

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i64 @binary_search(i32*, i64, i32)
declare void @__stack_chk_fail()

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %canary.slot, align 8
  ; arr = [-5, -1, 0, 2, 2, 3, 7, 9, 12]
  %arr.p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr.p0, align 4
  %arr.p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr.p1, align 4
  %arr.p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr.p2, align 4
  %arr.p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr.p3, align 4
  %arr.p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr.p4, align 4
  %arr.p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr.p5, align 4
  %arr.p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr.p6, align 4
  %arr.p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr.p7, align 4
  %arr.p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr.p8, align 4
  ; keys = [2, 5, -5]
  %keys.p0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys.p0, align 4
  %keys.p1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys.p1, align 4
  %keys.p2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys.p2, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %entry, %loop.inc
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %loop.body, label %after

loop.body:                                        ; preds = %loop.cond
  %keys.elem.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key = load i32, i32* %keys.elem.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %idx = call i64 @binary_search(i32* %arr.base, i64 9, i32 %key)
  %neg = icmp slt i64 %idx, 0
  br i1 %neg, label %notfound, label %found

found:                                            ; preds = %loop.body
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %key, i64 %idx)
  br label %loop.inc

notfound:                                         ; preds = %loop.body
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key)
  br label %loop.inc

loop.inc:                                         ; preds = %found, %notfound
  %i.next = add i64 %i, 1
  br label %loop.cond

after:                                            ; preds = %loop.cond
  %guard.end = load i64, i64* @__stack_chk_guard, align 8
  %stack.val = load i64, i64* %canary.slot, align 8
  %ok = icmp eq i64 %stack.val, %guard.end
  br i1 %ok, label %ret, label %stackfail

stackfail:                                        ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i32 0
}