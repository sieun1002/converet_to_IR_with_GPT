; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1214
; Intent: test harness for binary_search: searches keys in an int array and prints results (confidence=0.86). Evidence: call to binary_search, prints with "index %ld"/"not found".
; Preconditions: binary_search(int*, long, int) returns signed long index or negative if not found
; Postconditions: prints search outcomes; returns 0

; Only the necessary external declarations:
declare i64 @binary_search(i32*, i64, i32) local_unnamed_addr
declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail()
declare i64 @__stack_chk_guard

@format = private constant [21 x i8] c"key %d -> index %ld\0A\00"
@aKeyDNotFound = private constant [21 x i8] c"key %d -> not found\0A\00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %i = alloca i64, align 8
  %n = alloca i64, align 8
  %num = alloca i64, align 8
  %res = alloca i64, align 8
  %canary = alloca i64, align 8

  %guard0 = load i64, i64* @__stack_chk_guard
  store i64 %guard0, i64* %canary, align 8

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

  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds i32, i32* %keys0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds i32, i32* %keys0, i64 2
  store i32 -5, i32* %keys2, align 4

  store i64 9, i64* %n, align 8
  store i64 3, i64* %num, align 8
  store i64 0, i64* %i, align 8

  br label %loop

loop:                                             ; preds = %inc, %entry
  %iv = load i64, i64* %i, align 8
  %numv = load i64, i64* %num, align 8
  %cond = icmp ult i64 %iv, %numv
  br i1 %cond, label %body, label %end

body:                                             ; preds = %loop
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %iv
  %key = load i32, i32* %keyptr, align 4
  %nv = load i64, i64* %n, align 8
  %res_call = call i64 @binary_search(i32* %arr0, i64 %nv, i32 %key)
  store i64 %res_call, i64* %res, align 8
  %isneg = icmp slt i64 %res_call, 0
  br i1 %isneg, label %notfound, label %found

found:                                            ; preds = %body
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %callp1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key, i64 %res_call)
  br label %inc

notfound:                                         ; preds = %body
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %callp2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %inc

inc:                                              ; preds = %notfound, %found
  %incv = add i64 %iv, 1
  store i64 %incv, i64* %i, align 8
  br label %loop

end:                                              ; preds = %loop
  %guard1 = load i64, i64* @__stack_chk_guard
  %saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %saved, %guard1
  br i1 %ok, label %ret_ok, label %stack_fail

stack_fail:                                       ; preds = %end
  call void @__stack_chk_fail()
  br label %ret_ok

ret_ok:                                           ; preds = %stack_fail, %end
  ret i32 0
}