; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x128B
; Intent: sort and print an integer array (confidence=0.93). Evidence: call to bubble_sort, loop printing "%d " then newline
; Preconditions: bubble_sort must accept (i32* array, i64 count) and sort in-place
; Postconditions: prints the sorted array elements separated by spaces, then a newline, returns 0

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @bubble_sort(i32*, i64)
declare void @__stack_chk_fail()
@__stack_chk_guard = external global i64

@format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %idx = alloca i64, align 8
  %canaryslot = alloca i64, align 8
  %guard0 = load i64, i64* @__stack_chk_guard
  store i64 %guard0, i64* %canaryslot, align 8
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arrptr, align 4
  %p1 = getelementptr inbounds i32, i32* %arrptr, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arrptr, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arrptr, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arrptr, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arrptr, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arrptr, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arrptr, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arrptr, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arrptr, i64 9
  store i32 0, i32* %p9, align 4
  store i64 10, i64* %n, align 8
  %len = load i64, i64* %n, align 8
  call void @bubble_sort(i32* %arrptr, i64 %len)
  store i64 0, i64* %idx, align 8
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = load i64, i64* %idx, align 8
  %N = load i64, i64* %n, align 8
  %cmp = icmp ult i64 %i, %N
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %elemptr = getelementptr inbounds i32, i32* %arrptr, i64 %i
  %val = load i32, i32* %elemptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @format, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %inext = add i64 %i, 1
  store i64 %inext, i64* %idx, align 8
  br label %loop

after:                                            ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  %guard1 = load i64, i64* @__stack_chk_guard
  %saved = load i64, i64* %canaryslot, align 8
  %ok = icmp eq i64 %saved, %guard1
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i32 0
}