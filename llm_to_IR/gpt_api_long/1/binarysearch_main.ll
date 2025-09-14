; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1214
; Intent: Search several keys in a sorted int array using binary_search and print results (confidence=0.95). Evidence: sorted int array initialized; calls to binary_search; printf with index or not found.
; Preconditions: binary_search(a, n, key) returns a signed i64 index (>=0 on success, negative on failure); a points to an ascending-sorted array of 32-bit ints.
; Postconditions: Prints one line per key: either "key %d -> index %ld" or "key %d -> not found".

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

; Only the needed extern declarations:
declare i64 @binary_search(i32*, i64, i32)
declare i32 @printf(i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  store [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12], [9 x i32]* %arr, align 16
  store [3 x i32] [i32 2, i32 5, i32 -5], [3 x i32]* %keys, align 16
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cond = icmp ult i64 %i, 3
  br i1 %cond, label %loop.body, label %exit

loop.body:
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %arr.decay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %idx = call i64 @binary_search(i32* %arr.decay, i64 9, i32 %key)
  %neg = icmp slt i64 %idx, 0
  br i1 %neg, label %notfound, label %found

found:
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key, i64 %idx)
  br label %loop.inc

notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.notfound, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %loop.inc

loop.inc:
  %i.next = add i64 %i, 1
  br label %loop

exit:
  ret i32 0
}