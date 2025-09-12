; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1214
; Intent: Test binary_search on a fixed sorted array and print results for a few keys (confidence=0.95). Evidence: call pattern (array pointer, length, key) and printf with "key %d -> index %ld\n"/"not found".
; Preconditions: binary_search expects a sorted i32 array and returns a signed index (negative if not found).
; Postconditions: prints search results for keys 2, 5, -5; returns 0.

@arr = internal constant [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12], align 16
@keys = internal constant [3 x i32] [i32 2, i32 5, i32 -5], align 16
@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

; Only the needed extern declarations:
declare i64 @binary_search(i32*, i64, i32)
declare i32 @printf(i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* @arr, i64 0, i64 0
  br label %loop

loop:                                             ; preds = %entry, %cont
  %i = phi i64 [ 0, %entry ], [ %i.next, %cont ]
  %cmp.end = icmp ult i64 %i, 3
  br i1 %cmp.end, label %body, label %ret

body:                                             ; preds = %loop
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* @keys, i64 0, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %idx = call i64 @binary_search(i32* %arr.ptr, i64 9, i32 %key)
  %neg = icmp slt i64 %idx, 0
  br i1 %neg, label %notfound, label %found

found:                                            ; preds = %body
  %fmt.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %fmt = bitcast i8* %fmt.ptr to i8*
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %key, i64 %idx)
  br label %cont

notfound:                                         ; preds = %body
  %fmt2.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i32 %key)
  br label %cont

cont:                                             ; preds = %found, %notfound
  %i.next = add i64 %i, 1
  br label %loop

ret:                                              ; preds = %loop
  ret i32 0
}