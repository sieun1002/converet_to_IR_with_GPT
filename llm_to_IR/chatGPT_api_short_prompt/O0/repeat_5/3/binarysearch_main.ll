; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1214
; Intent: Query a binary_search over a sorted int array and print indices (confidence=0.86). Evidence: call to binary_search; printf formats "key %d -> index %ld\n"/"not found".
; Preconditions: binary_search(i32*, i64, i32) expects a sorted array and returns -1 on failure.
; Postconditions: Prints result for each key; returns 0.

; Only the necessary external declarations:
declare i64 @binary_search(i32*, i64, i32)
declare i32 @_printf(i8*, ...)
declare void @___stack_chk_fail()

@format = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@aKeyDNotFound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %count = alloca i64, align 8
  %numKeys = alloca i64, align 8
  %i = alloca i64, align 8
  %res = alloca i64, align 8
  %canary = alloca i64, align 8

  ; pseudo stack canary save
  store i64 0, i64* %canary, align 8

  ; arr = {-5, -1, 0, 2, 2, 3, 7, 9, 12}
  %a0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %a0, align 4
  %a1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %a1, align 4
  %a2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %a2, align 4
  %a3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %a3, align 4
  %a4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %a4, align 4
  %a5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %a5, align 4
  %a6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %a6, align 4
  %a7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %a7, align 4
  %a8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %a8, align 4

  ; keys = {2, 5, -5}
  %k0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %k0, align 4
  %k1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %k1, align 4
  %k2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %k2, align 4

  store i64 9, i64* %count, align 8
  store i64 3, i64* %numKeys, align 8
  store i64 0, i64* %i, align 8

  br label %loop

loop:                                             ; preds = %cont, %entry
  %iv = load i64, i64* %i, align 8
  %nk = load i64, i64* %numKeys, align 8
  %cmp = icmp ult i64 %iv, %nk
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %iv
  %key = load i32, i32* %keyptr, align 4
  %arrptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %cnt = load i64, i64* %count, align 8
  %call = call i64 @binary_search(i32* %arrptr, i64 %cnt, i32 %key)
  store i64 %call, i64* %res, align 8
  %isneg = icmp slt i64 %call, 0
  br i1 %isneg, label %notfound, label %found

found:                                            ; preds = %body
  %idx = load i64, i64* %res, align 8
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %callprintf = call i32 @_printf(i8* %fmt, i32 %key, i64 %idx)
  br label %cont

notfound:                                         ; preds = %body
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %callprintf2 = call i32 @_printf(i8* %fmt2, i32 %key)
  br label %cont

cont:                                             ; preds = %notfound, %found
  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

exit:                                             ; preds = %loop
  %c = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %c, %c
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %exit
  call void @___stack_chk_fail()
  br label %ret

ret:                                              ; preds = %fail, %exit
  ret i32 0
}