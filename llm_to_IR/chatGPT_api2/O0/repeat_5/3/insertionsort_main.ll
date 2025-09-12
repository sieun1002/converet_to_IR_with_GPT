; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1247
; Intent: Initialize 10-int array, sort with insertion_sort, print elements, newline, return 0 (confidence=0.95). Evidence: call to insertion_sort with (int*, len), loop printing with "%d ", final putchar(10)
; Preconditions: insertion_sort expects a writable i32* and an i64 length
; Postconditions: prints the sorted numbers followed by a newline; returns 0

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare void @insertion_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary = load i64, i64* @__stack_chk_guard
  %arr = alloca [10 x i32], align 16
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
  call void @insertion_sort(i32* %p0, i64 10)
  br label %loop

loop:                                             ; preds = %loop, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %loop ]
  %elem.ptr = getelementptr inbounds i32, i32* %p0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %inc = add i64 %i, 1
  %cond = icmp ult i64 %inc, 10
  br i1 %cond, label %loop, label %after_loop

after_loop:                                       ; preds = %loop
  %putc = call i32 @putchar(i32 10)
  %canary2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %canary2, %canary
  br i1 %ok, label %ret, label %stack_fail

stack_fail:                                       ; preds = %after_loop
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after_loop
  ret i32 0
}