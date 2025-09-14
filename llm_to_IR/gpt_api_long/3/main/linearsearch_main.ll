; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x11D7
; Intent: Drive a linear search over a fixed int array and report the result (confidence=0.95). Evidence: call to linear_search(arr,len,key); prints index or “not found”.
; Preconditions: linear_search returns -1 when not found; 0-based indexing assumed.
; Postconditions: returns 0.

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1
@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare i32 @linear_search(i32*, i32, i32)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %arr = alloca [5 x i32], align 16
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0, align 16
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 8, i32* %arr2, align 8
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 4, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4, align 16
  %idx = call i32 @linear_search(i32* %arr0, i32 5, i32 4)
  %cmp = icmp eq i32 %idx, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %idx)
  br label %check

notfound:
  %sptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %callputs = call i32 @puts(i8* %sptr)
  br label %check

check:
  %guard2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard, %guard2
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}