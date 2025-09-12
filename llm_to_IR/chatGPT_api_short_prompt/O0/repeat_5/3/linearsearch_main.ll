; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x11D7
; Intent: Demo linear search on a small array and report result (confidence=0.94). Evidence: call to linear_search; printf/puts messages about found/not found.
; Preconditions: None
; Postconditions: Returns 0; prints whether target 4 is found in the array.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
@__stack_chk_guard = external global i64

@format = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00"
@s = private unnamed_addr constant [18 x i8] c"Element not found\00"

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()

define dso_local i32 @main() local_unnamed_addr {
entry:
  ; stack canary save
  %canary.slot = alloca i64, align 8
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %canary.slot, align 8

  ; locals
  %arr = alloca [5 x i32], align 16

  ; arr = {5, 3, 8, 4, 2}
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

  ; call linear_search(arr, 5, 4)
  %call = call i32 @linear_search(i32* %arr0, i32 5, i32 4)
  %cmp = icmp ne i32 %call, -1
  br i1 %cmp, label %found, label %notfound

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @format, i64 0, i64 0
  %p = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %call)
  br label %cont

notfound:
  %sptr = getelementptr inbounds [18 x i8], [18 x i8]* @s, i64 0, i64 0
  %q = call i32 @puts(i8* %sptr)
  br label %cont

cont:
  ; stack canary check
  %saved = load i64, i64* %canary.slot, align 8
  %guard = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %saved, %guard
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}