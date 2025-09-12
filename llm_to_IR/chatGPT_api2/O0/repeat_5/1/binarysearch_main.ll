; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1214
; Intent: Test harness for binary_search that searches several keys and prints results (confidence=0.95). Evidence: call to binary_search; printf formats "key %d -> index %ld" and "not found".
; Preconditions: binary_search expects a sorted i32 array; returns non-negative index on success, negative on failure.
; Postconditions: prints one line per query key.

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@.str_not_found = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"
@arr = internal constant [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12]
@keys = internal constant [3 x i32] [i32 2, i32 5, i32 -5]

; Only the needed extern declarations:
declare i64 @binary_search(i32*, i64, i32)
declare i32 @printf(i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  br label %loop.check

loop.check:                                        ; preds = %loop.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                         ; preds = %loop.check
  %keys.base = getelementptr inbounds [3 x i32], [3 x i32]* @keys, i64 0, i64 0
  %key.ptr = getelementptr inbounds i32, i32* %keys.base, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* @arr, i64 0, i64 0
  %idx = call i64 @binary_search(i32* %arr.base, i64 9, i32 %key)
  %neg = icmp slt i64 %idx, 0
  br i1 %neg, label %notfound, label %found

found:                                             ; preds = %loop.body
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_found, i64 0, i64 0
  %call_printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key, i64 %idx)
  br label %loop.inc

notfound:                                          ; preds = %loop.body
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str_not_found, i64 0, i64 0
  %call_printf2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %loop.inc

loop.inc:                                          ; preds = %notfound, %found
  %i.next = add i64 %i, 1
  br label %loop.check

exit:                                              ; preds = %loop.check
  ret i32 0
}