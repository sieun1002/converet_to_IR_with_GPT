; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x11D7
; Intent: Demo linear search on a small int array and report index or not-found (confidence=0.86). Evidence: calls linear_search; prints based on -1 check.
; Preconditions: none
; Postconditions: returns 0

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.1 = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1
@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()
declare i32 @linear_search(i32*, i32, i32)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %stack_canary = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %0 = load i64, i64* @__stack_chk_guard
  store i64 %0, i64* %stack_canary, align 8
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
  %cmp = icmp ne i32 %call, -1
  br i1 %cmp, label %found, label %notfound

found:
  %fmt = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %1 = call i32 (i8*, ...) @printf(i8* %fmt, i32 %call)
  br label %postprint

notfound:
  %msg = getelementptr inbounds [18 x i8], [18 x i8]* @.str.1, i64 0, i64 0
  %2 = call i32 @puts(i8* %msg)
  br label %postprint

postprint:
  %saved = load i64, i64* %stack_canary, align 8
  %cur = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %saved, %cur
  br i1 %ok, label %ret, label %stkfail

stkfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}