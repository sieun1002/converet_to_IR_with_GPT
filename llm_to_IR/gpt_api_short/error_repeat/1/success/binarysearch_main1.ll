; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1214
; Intent: Demo/driver: search multiple keys in a sorted int array and print results (confidence=0.88). Evidence: initializes a sorted array and a small key set; calls binary_search and prints index or not found.
; Preconditions: binary_search(int*, size_t, int) returns signed long index or negative on failure
; Postconditions: returns 0

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i64 @binary_search(i32*, i64, i32)

@format = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@aKeyDNotFound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"

define dso_local i32 @main() local_unnamed_addr {
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
  %k0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %k0, align 4
  %k1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %k1, align 4
  %k2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %k2, align 4
  br label %loop

loop:                                             ; preds = %after_print, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %after_print ]
  %cond = icmp ult i64 %i, 3
  br i1 %cond, label %iter, label %done

iter:                                             ; preds = %loop
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key = load i32, i32* %keyptr, align 4
  %arrdecay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %idx = call i64 @binary_search(i32* %arrdecay, i64 9, i32 %key)
  %isneg = icmp slt i64 %idx, 0
  br i1 %isneg, label %notfound, label %found

found:                                            ; preds = %iter
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt, i32 %key, i64 %idx)
  br label %after_print

notfound:                                         ; preds = %iter
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %after_print

after_print:                                      ; preds = %notfound, %found
  %i.next = add nuw nsw i64 %i, 1
  br label %loop

done:                                             ; preds = %loop
  ret i32 0
}