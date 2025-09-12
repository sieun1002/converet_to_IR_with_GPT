; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1214
; Intent: Test driver that calls binary_search on a sorted int array for several keys and prints results (confidence=0.95). Evidence: call pattern (int* , len, key) and printf formats with index %ld.
; Preconditions: binary_search(int* a, i64 n, i32 key) expects a sorted array in ascending order.
; Postconditions: Prints "key %d -> index %ld" when found, otherwise "key %d -> not found".

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"

declare i64 @binary_search(i32*, i64, i32) local_unnamed_addr
declare i32 @_printf(i8*, ...) local_unnamed_addr

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  ; arr = [-5, -1, 0, 2, 2, 3, 7, 9, 12]
  %arr.gep0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr.gep0, align 4
  %arr.gep1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr.gep1, align 4
  %arr.gep2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr.gep2, align 4
  %arr.gep3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr.gep3, align 4
  %arr.gep4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr.gep4, align 4
  %arr.gep5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr.gep5, align 4
  %arr.gep6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr.gep6, align 4
  %arr.gep7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr.gep7, align 4
  %arr.gep8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr.gep8, align 4

  ; keys = [2, 5, -5]
  %keys.gep0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys.gep0, align 4
  %keys.gep1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys.gep1, align 4
  %keys.gep2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys.gep2, align 4

  br label %loop

loop:                                             ; preds = %entry, %cont
  %i = phi i64 [ 0, %entry ], [ %inc, %cont ]
  %cond = icmp ult i64 %i, 3
  br i1 %cond, label %body, label %exit

body:                                             ; preds = %loop
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %res = call i64 @binary_search(i32* %arr.ptr, i64 9, i32 %key)
  %neg = icmp slt i64 %res, 0
  br i1 %neg, label %notfound, label %found

found:                                            ; preds = %body
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @_printf(i8* %fmt1, i32 %key, i64 %res)
  br label %cont

notfound:                                         ; preds = %body
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @_printf(i8* %fmt2, i32 %key)
  br label %cont

cont:                                             ; preds = %found, %notfound
  %inc = add i64 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 0
}