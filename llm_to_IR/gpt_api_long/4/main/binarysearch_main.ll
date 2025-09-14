; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1214
; Intent: test binary_search over a sorted int array and print indices (confidence=0.95). Evidence: call to binary_search; printf formats with key/index.
; Preconditions: array is sorted ascending; binary_search signature assumed: (i32* arr, i64 n, i32 key).
; Postconditions: prints lookup results; returns 0.

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"

declare i64 @binary_search(i32*, i64, i32)
declare i32 @printf(i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %queries = alloca [3 x i32], align 16
  store [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12], [9 x i32]* %arr, align 16
  store [3 x i32] [i32 2, i32 5, i32 -5], [3 x i32]* %queries, align 16
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %for.body, label %ret

for.body:                                         ; preds = %for.cond
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %q.elem.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 %i
  %key = load i32, i32* %q.elem.ptr, align 4
  %res = call i64 @binary_search(i32* %arr.ptr, i64 9, i32 %key)
  %neg = icmp slt i64 %res, 0
  br i1 %neg, label %notfound, label %found

found:                                            ; preds = %for.body
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt, i32 %key, i64 %res)
  br label %for.inc

notfound:                                         ; preds = %for.body
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %for.inc

for.inc:                                          ; preds = %notfound, %found
  %i.next = add i64 %i, 1
  br label %for.cond

ret:                                              ; preds = %for.cond
  ret i32 0
}