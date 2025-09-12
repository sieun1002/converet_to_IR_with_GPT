; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x11D7
; Intent: Linear search demo printing result (confidence=0.92). Evidence: call to linear_search(arr, target, n); messages about found/not found
; Preconditions: linear_search has C-ABI signature i32 (i32* arr, i32 target, i32 n) and returns -1 if not found.
; Postconditions: Prints search result and returns 0.

@.str.found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.notfound = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1
@__stack_chk_guard = external global i64

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %saved_canary = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %saved_canary, align 8
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 8, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 4, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4, align 4
  %call.res = call i32 @linear_search(i32* %arr0, i32 5, i32 4)
  %is.neg1 = icmp eq i32 %call.res, -1
  br i1 %is.neg1, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str.found, i64 0, i64 0
  %printf.call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %call.res)
  br label %after

notfound:
  %sptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.notfound, i64 0, i64 0
  %puts.call = call i32 @puts(i8* %sptr)
  br label %after

after:
  %guard.load.end = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %saved_canary, align 8
  %ok = icmp eq i64 %saved, %guard.load.end
  br i1 %ok, label %retblk, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

retblk:
  ret i32 0
}