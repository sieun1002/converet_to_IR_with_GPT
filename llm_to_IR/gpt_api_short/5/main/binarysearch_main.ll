; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1214
; Intent: test binary_search and print results (confidence=0.93). Evidence: constructs sorted int array and query keys; calls binary_search; prints index or not found.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

@format = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@aKeyDNotFound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"

declare i64 @binary_search(i32*, i64, i32)
declare i32 @_printf(i8*, ...)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %queries = alloca [3 x i32], align 16
  store [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12], [9 x i32]* %arr, align 16
  store [3 x i32] [i32 2, i32 5, i32 -5], [3 x i32]* %queries, align 16
  br label %loop.cond

loop.cond:                                         ; preds = %loop.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %loop.body, label %end

loop.body:                                         ; preds = %loop.cond
  %qptr = getelementptr inbounds [3 x i32], [3 x i32]* %queries, i64 0, i64 %i
  %key = load i32, i32* %qptr, align 4
  %aptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %idx = call i64 @binary_search(i32* %aptr, i64 9, i32 %key)
  %found = icmp sge i64 %idx, 0
  br i1 %found, label %print_found, label %print_not_found

print_found:                                       ; preds = %loop.body
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @_printf(i8* %fmt, i32 %key, i64 %idx)
  br label %loop.inc

print_not_found:                                   ; preds = %loop.body
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @aKeyDNotFound, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @_printf(i8* %fmt2, i32 %key)
  br label %loop.inc

loop.inc:                                          ; preds = %print_not_found, %print_found
  %i.next = add i64 %i, 1
  br label %loop.cond

end:                                               ; preds = %loop.cond
  ret i32 0
}