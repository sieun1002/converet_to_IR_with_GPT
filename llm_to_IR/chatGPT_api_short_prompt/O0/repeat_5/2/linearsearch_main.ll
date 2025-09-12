; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x11D7
; Intent: Demonstrate linear search and report index (confidence=0.90). Evidence: calls linear_search on local array; prints "Element found at index %d\n" or "Element not found".
; Preconditions: none
; Postconditions: returns 0; may call ___stack_chk_fail on canary mismatch

@format = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@s = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1
@__stack_chk_guard = external global i64

; Only the necessary external declarations:
declare i32 @linear_search(i32*, i32, i32) local_unnamed_addr
declare i32 @_printf(i8*, ...) local_unnamed_addr
declare i32 @_puts(i8*) local_unnamed_addr
declare void @___stack_chk_fail() local_unnamed_addr

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16

  ; stack canary prologue
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary.slot, align 8

  ; initialize local array: {5, 3, 8, 4, 2}
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

  ; call linear_search(&arr[0], 5, 4)
  %call = call i32 @linear_search(i32* %arr0, i32 5, i32 4)
  %cmp = icmp eq i32 %call, -1
  br i1 %cmp, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @format, i64 0, i64 0
  %printfcall = call i32 (i8*, ...) @_printf(i8* %fmtptr, i32 %call)
  br label %after_print

notfound:
  %sptr = getelementptr inbounds [18 x i8], [18 x i8]* @s, i64 0, i64 0
  %putscall = call i32 @_puts(i8* %sptr)
  br label %after_print

after_print:
  ; stack canary epilogue
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %old = load i64, i64* %canary.slot, align 8
  %ok = icmp eq i64 %old, %guard1
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @___stack_chk_fail()
  unreachable

ret:
  ret i32 0
}