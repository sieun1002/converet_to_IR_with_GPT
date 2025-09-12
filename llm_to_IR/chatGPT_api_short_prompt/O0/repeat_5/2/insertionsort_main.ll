; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1247
; Intent: Sort an integer array with insertion_sort and print the result (confidence=0.92). Evidence: call to insertion_sort, printf loop with "%d ".
; Preconditions: None
; Postconditions: Prints the sorted array followed by a newline; returns 0.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)
declare void @insertion_sort(i32*, i64)
declare void @___stack_chk_fail()
@__stack_chk_guard = external global i64

@format = private unnamed_addr constant [4 x i8] c"%d \00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  ; stack protector setup
  %canary = alloca i64, align 8
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary, align 8

  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
  %len = alloca i64, align 8

  ; initialize array: [9,1,5,3,7,2,8,6,4,0]
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %e0 = getelementptr inbounds i32, i32* %arr.base, i64 0
  store i32 9, i32* %e0, align 4
  %e1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %e1, align 4
  %e2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5, i32* %e2, align 4
  %e3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3, i32* %e3, align 4
  %e4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %e4, align 4
  %e5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2, i32* %e5, align 4
  %e6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8, i32* %e6, align 4
  %e7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %e7, align 4
  %e8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %e8, align 4
  %e9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %e9, align 4

  store i64 10, i64* %len, align 8

  ; call insertion_sort(arr, len)
  %len.val = load i64, i64* %len, align 8
  call void @insertion_sort(i32* %arr.base, i64 %len.val)

  ; print sorted array
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %n.cur = load i64, i64* %len, align 8
  %lt = icmp ult i64 %i.cur, %n.cur
  br i1 %lt, label %loop.body, label %loop.end

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %i.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call = call i32 (i8*, ...) @_printf(i8* %fmtptr, i32 %elem)
  %inc = add i64 %i.cur, 1
  store i64 %inc, i64* %i, align 8
  br label %loop.cond

loop.end:
  %nl = call i32 @_putchar(i32 10)

  ; stack protector check and return 0
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %guard2, %saved
  br i1 %ok, label %ret.ok, label %stack.fail

stack.fail:
  call void @___stack_chk_fail()
  unreachable

ret.ok:
  ret i32 0
}