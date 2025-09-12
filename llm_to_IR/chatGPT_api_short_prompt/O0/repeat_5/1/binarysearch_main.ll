; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1214
; Intent: Test harness that calls binary_search on a sorted array with several keys and prints results (confidence=0.86). Evidence: Calls binary_search with (array,len,key); prints "index %ld" or "not found".
; Preconditions: binary_search expects a sorted int32 array and returns a signed long index (negative if not found).
; Postconditions: Prints one line per key with the found index or "not found".

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; (declare only other externs that are needed)
declare i32 @printf(i8*, ...)
declare i64 @binary_search(i32*, i64, i32)

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  store [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12], [9 x i32]* %arr, align 16
  store [3 x i32] [i32 2, i32 5, i32 -5], [3 x i32]* %keys, align 16
  br label %loop

loop:                                             ; preds = %after, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %after ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %keys.elem.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key = load i32, i32* %keys.elem.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %res = call i64 @binary_search(i32* %arr.base, i64 9, i32 %key)
  %neg = icmp slt i64 %res, 0
  br i1 %neg, label %notfound, label %found

found:                                            ; preds = %body
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %key, i64 %res)
  br label %after

notfound:                                         ; preds = %body
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key)
  br label %after

after:                                            ; preds = %notfound, %found
  %i.next = add i64 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 0
}