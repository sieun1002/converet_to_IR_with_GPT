; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1214
; Intent: Demonstrate binary_search on a sorted array and print results (confidence=0.87). Evidence: calls binary_search; printf messages "index" / "not found".
; Preconditions: Input array sorted ascending; length = 9
; Postconditions: Prints search results; returns 0

@format = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@aKeyDNotFound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

; Only the necessary external declarations:
declare i32 @_printf(i8*, ...)
declare i64 @binary_search(i32*, i64, i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %i = alloca i64, align 8

  ; initialize sorted array: [-5, -1, 0, 2, 2, 3, 7, 9, 12]
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 0, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4, align 4
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 7, i32* %arr6, align 4
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 12, i32* %arr8, align 4

  ; initialize keys: [2, 5, -5]
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds i32, i32* %keys0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds i32, i32* %keys0, i64 2
  store i32 -5, i32* %keys2, align 4

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.val = load i64, i64* %i, align 8
  %cmp.end = icmp ult i64 %i.val, 3
  br i1 %cmp.end, label %body, label %exit

body:
  ; key = keys[i]
  %key.ptr = getelementptr inbounds i32, i32* %keys0, i64 %i.val
  %key = load i32, i32* %key.ptr, align 4

  ; idx = binary_search(arr, 9, key)
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %idx = call i64 @binary_search(i32* %arr.ptr, i64 9, i32 %key)

  ; if idx < 0 -> not found
  %neg = icmp slt i64 %idx, 0
  br i1 %neg, label %notfound, label %found

found:
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  ; printf("key %d -> index %ld\n", key, idx)
  %call1 = call i32 (i8*, ...) @_printf(i8* %fmt1, i32 %key, i64 %idx)
  br label %cont

notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  ; printf("key %d -> not found\n", key)
  %call2 = call i32 (i8*, ...) @_printf(i8* %fmt2, i32 %key)
  br label %cont

cont:
  %inc = add i64 %i.val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

exit:
  ret i32 0
}