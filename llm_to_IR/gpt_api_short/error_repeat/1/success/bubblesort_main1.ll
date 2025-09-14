; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x128B
; Intent: sort an integer array and print it (confidence=0.98). Evidence: calls bubble_sort with array and length; prints each element with "%d " then newline.
; Preconditions: None
; Postconditions: Prints ten integers then a newline; returns 0

; Only the necessary external declarations:
declare void @bubble_sort(i32*, i64) local_unnamed_addr
declare i32 @printf(i8*, ...) local_unnamed_addr
declare i32 @putchar(i32) local_unnamed_addr
declare void @__stack_chk_fail() local_unnamed_addr
@__stack_chk_guard = external global i64

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %idx = alloca i64, align 8
  %g = load i64, i64* @__stack_chk_guard
  store i64 %g, i64* %canary, align 8

  ; Initialize array: {9,1,5,3,7,2,8,6,4,0}
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4

  ; bubble_sort(&arr[0], 10)
  %arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @bubble_sort(i32* %arrptr, i64 10)

  store i64 0, i64* %idx, align 8
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = load i64, i64* %idx, align 8
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %body, label %after

body:                                             ; preds = %loop
  %ep = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %ep, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %i.next = add nuw nsw i64 %i, 1
  store i64 %i.next, i64* %idx, align 8
  br label %loop

after:                                            ; preds = %loop
  %put = call i32 @putchar(i32 10)

  ; Stack protector check
  %g2 = load i64, i64* @__stack_chk_guard
  %gs = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %g2, %gs
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i32 0
}