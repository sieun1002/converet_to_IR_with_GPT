; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x11D7
; Intent: Demo: search for key 4 in a 5-int array via linear_search; print index or "not found" (confidence=0.95). Evidence: call to linear_search; printf/puts messages
; Preconditions: Assumes: i32 linear_search(i32* arr, i32 n, i32 key) returns index or -1 if not found
; Postconditions: Prints result and returns 0

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00"
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00"
@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare i32 @linear_search(i32*, i32, i32)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard0 = load i64, i64* @__stack_chk_guard
  %arr = alloca [5 x i32], align 16
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
  %call = call i32 @linear_search(i32* %arr0, i32 5, i32 4)
  %cmp = icmp eq i32 %call, -1
  br i1 %cmp, label %notfound, label %found

found:                                            ; preds = %entry
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %call_printf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %call)
  br label %afterprint

notfound:                                         ; preds = %entry
  %strptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %call_puts = call i32 @puts(i8* %strptr)
  br label %afterprint

afterprint:                                       ; preds = %notfound, %found
  %guard1 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard0, %guard1
  br i1 %ok, label %ret, label %stackfail

ret:                                              ; preds = %afterprint
  ret i32 0

stackfail:                                        ; preds = %afterprint
  call void @__stack_chk_fail()
  unreachable
}