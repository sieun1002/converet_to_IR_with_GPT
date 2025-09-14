; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x0000124D
; Intent: Sort an integer array with selection_sort and print it (confidence=0.86). Evidence: call to selection_sort with array pointer/length; printf of "Sorted array: " and "%d " in a loop.
; Preconditions: None
; Postconditions: Writes sorted numbers to stdout; returns 0. Stack protector enforced.

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external thread_local global i64

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)
declare i32 @_printf(i8*, ...)
declare void @___stack_chk_fail()

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %i = alloca i32, align 4
  %canary = alloca i64, align 8

  %guard.ld = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.ld, i64* %canary, align 8

  %arr.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr.ptr, align 16
  %idx1 = getelementptr inbounds i32, i32* %arr.ptr, i64 1
  store i32 10, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arr.ptr, i64 2
  store i32 14, i32* %idx2, align 8
  %idx3 = getelementptr inbounds i32, i32* %arr.ptr, i64 3
  store i32 37, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arr.ptr, i64 4
  store i32 13, i32* %idx4, align 16

  store i32 5, i32* %len, align 4

  %len.val = load i32, i32* %len, align 4
  call void @selection_sort(i32* %arr.ptr, i32 %len.val)

  %fmt0 = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @_printf(i8* %fmt0)

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i.cur = load i32, i32* %i, align 4
  %len.cur = load i32, i32* %len, align 4
  %cmp = icmp slt i32 %i.cur, %len.cur
  br i1 %cmp, label %body, label %done

body:
  %idx.ext = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr.ptr, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @_printf(i8* %fmt1, i32 %elem)
  %inc = add nsw i32 %i.cur, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

done:
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary, align 8
  %guard.ok = icmp eq i64 %guard.saved, %guard.now
  br i1 %guard.ok, label %ret, label %stkfail

stkfail:
  call void @___stack_chk_fail()
  unreachable

ret:
  ret i32 0
}