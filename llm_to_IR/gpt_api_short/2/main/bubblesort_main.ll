; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x128B
; Intent: Initialize array, sort via bubble_sort, print elements (confidence=0.96). Evidence: call bubble_sort(arr, 10), loop printing "%d ", putchar('\n')
; Preconditions: none
; Postconditions: returns 0 after printing sorted array

; Only the necessary external declarations:
declare void @bubble_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()
@__stack_chk_guard = external global i64

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %canary = alloca i64, align 8

  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %canary, align 8

  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %p0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %p0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %p0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %p0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %p0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %p0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %p0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %p0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %p0, i64 9
  store i32 0, i32* %p9, align 4

  store i64 10, i64* %len, align 8

  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %lenval = load i64, i64* %len, align 8
  call void @bubble_sort(i32* %arrdecay, i64 %lenval)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %lv = load i64, i64* %len, align 8
  %cond = icmp ult i64 %iv, %lv
  br i1 %cond, label %body, label %after

body:
  %ep = getelementptr inbounds i32, i32* %arrdecay, i64 %iv
  %val = load i32, i32* %ep, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %next = add i64 %iv, 1
  store i64 %next, i64* %i, align 8
  br label %loop

after:
  %nl = call i32 @putchar(i32 10)

  %guard_end = load i64, i64* @__stack_chk_guard
  %saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %saved, %guard_end
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}