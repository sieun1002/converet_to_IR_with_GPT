; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1214
; Intent: Drive a binary_search over a sample sorted array and print results (confidence=0.95). Evidence: call to binary_search; printf formats "key %d -> index %ld" and "not found".

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i64 @binary_search(i32*, i64, i32)
declare i32 @printf(i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
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
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2, align 4
  br label %loop.header

loop.header:                                      ; preds = %entry, %loop.cont
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.cont ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %loop.body, label %ret

loop.body:                                        ; preds = %loop.header
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %key.ptr.i = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key.val = load i32, i32* %key.ptr.i, align 4
  %idx = call i64 @binary_search(i32* %arr.ptr, i64 9, i32 %key.val)
  %found = icmp sge i64 %idx, 0
  br i1 %found, label %found.bb, label %notfound.bb

found.bb:                                         ; preds = %loop.body
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmt, i32 %key.val, i64 %idx)
  br label %loop.cont

notfound.bb:                                      ; preds = %loop.body
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %callp2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key.val)
  br label %loop.cont

loop.cont:                                        ; preds = %notfound.bb, %found.bb
  %i.next = add i64 %i, 1
  br label %loop.header

ret:                                              ; preds = %loop.header
  ret i32 0
}