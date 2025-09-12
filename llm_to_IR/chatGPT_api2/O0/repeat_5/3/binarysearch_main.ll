; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1214
; Intent: test a binary_search over a sorted int array and print results (confidence=0.95). Evidence: call to binary_search with array and length; printf with "index %ld" or "not found".
; Preconditions: binary_search returns non-negative index on success, negative on failure.

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"
@arr = private unnamed_addr constant [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12]
@keys = private unnamed_addr constant [3 x i32] [i32 2, i32 5, i32 -5]

declare i64 @binary_search(i32*, i64, i32) local_unnamed_addr
declare i32 @printf(i8*, ...) local_unnamed_addr
declare void @__stack_chk_fail() local_unnamed_addr

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %inc
  %i = phi i64 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %body, label %end

body:                                             ; preds = %loop
  %kptr = getelementptr inbounds [3 x i32], [3 x i32]* @keys, i64 0, i64 %i
  %key = load i32, i32* %kptr, align 4
  %arrptr = getelementptr inbounds [9 x i32], [9 x i32]* @arr, i64 0, i64 0
  %idx = call i64 @binary_search(i32* %arrptr, i64 9, i32 %key)
  %neg = icmp slt i64 %idx, 0
  br i1 %neg, label %notfound, label %found

found:                                            ; preds = %body
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key, i64 %idx)
  br label %inc

notfound:                                         ; preds = %body
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %inc

inc:                                              ; preds = %found, %notfound
  %i.next = add nuw nsw i64 %i, 1
  br label %loop

end:                                              ; preds = %loop
  %guard_ok = icmp eq i64 0, 0
  br i1 %guard_ok, label %ret, label %stackfail

stackfail:                                        ; preds = %end
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %end
  ret i32 0
}