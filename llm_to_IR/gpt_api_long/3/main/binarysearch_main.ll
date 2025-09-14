; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1214
; Intent: Demo binary search over a sorted array and print results (confidence=0.92). Evidence: initializes sorted i32 array; calls binary_search and prints index or "not found".
; Preconditions: binary_search(arr, n, key) expects ascending-sorted i32 array; returns i64 index or negative on miss.
; Postconditions: returns 0

@__stack_chk_guard = external global i64
@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"

declare i64 @binary_search(i32*, i64, i32)
declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %arr1p = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 -1, i32* %arr1p, align 4
  %arr2p = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 0, i32* %arr2p, align 4
  %arr3p = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 2, i32* %arr3p, align 4
  %arr4p = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4p, align 4
  %arr5p = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 3, i32* %arr5p, align 4
  %arr6p = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 7, i32* %arr6p, align 4
  %arr7p = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 9, i32* %arr7p, align 4
  %arr8p = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 12, i32* %arr8p, align 4
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2, align 4
  br label %loop.test

loop.test:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %loop.body, label %after

loop.body:
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %res = call i64 @binary_search(i32* %arr0, i64 9, i32 %key)
  %neg = icmp slt i64 %res, 0
  br i1 %neg, label %notfound, label %found

found:
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt, i32 %key, i64 %res)
  br label %loop.inc

notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %loop.inc

loop.inc:
  %i.next = add nuw nsw i64 %i, 1
  br label %loop.test

after:
  %guard2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard, %guard2
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}