; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x11d7
; Intent: Demo: build array, call linear_search, print result (confidence=0.95). Evidence: call to linear_search; result checked against -1 and printed.
; Preconditions:
; - linear_search(arr, n, target) returns index or -1 on failure (assumed).
; Postconditions:
; - Prints index if found; otherwise prints "Element not found".

@.str_found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str_notfound = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1
@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %arr = alloca [5 x i32], align 16
  %0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %0, align 4
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %2, align 4
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %3, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %4, align 4
  %call = call i32 @linear_search(i32* %0, i32 5, i32 4)
  %cmp = icmp ne i32 %call, -1
  br i1 %cmp, label %found, label %notfound

found:                                            ; preds = %entry
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str_found, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %call)
  br label %after

notfound:                                         ; preds = %entry
  %nfptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str_notfound, i64 0, i64 0
  %call2 = call i32 @puts(i8* %nfptr)
  br label %after

after:                                            ; preds = %notfound, %found
  %guard2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard2, %guard
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i32 0
}