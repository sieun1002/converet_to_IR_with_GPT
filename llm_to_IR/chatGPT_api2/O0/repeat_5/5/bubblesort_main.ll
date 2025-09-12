; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x128B
; Intent: Sort and print an integer array using bubble_sort (confidence=0.90). Evidence: call to bubble_sort and loop printing elements with "%d ".
; Preconditions: bubble_sort expects a pointer to i32 array and a length (i64).
; Postconditions: Prints the sorted array followed by a newline; returns 0.

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare dso_local void @bubble_sort(i32* nocapture, i64) local_unnamed_addr
declare dso_local i32 @printf(i8*, ...) local_unnamed_addr
declare dso_local i32 @putchar(i32) local_unnamed_addr
declare dso_local void @__stack_chk_fail() local_unnamed_addr

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %0, align 4
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %1, align 4
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %2, align 4
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %3, align 4
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %4, align 4
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %5, align 4
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %6, align 4
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %8, align 4
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %9, align 4
  call void @bubble_sort(i32* %0, i64 10)
  br label %loop

loop:                                             ; preds = %printf_cont, %entry
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %printf_cont ]
  %cmp = icmp ult i64 %iv, 10
  br i1 %cmp, label %body, label %after_loop

body:                                             ; preds = %loop
  %elem.ptr = getelementptr inbounds i32, i32* %0, i64 %iv
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  br label %printf_cont

printf_cont:                                      ; preds = %body
  %iv.next = add i64 %iv, 1
  br label %loop

after_loop:                                       ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  %guard2 = load i64, i64* @__stack_chk_guard
  %can_ok = icmp eq i64 %guard, %guard2
  br i1 %can_ok, label %ok, label %fail

fail:                                             ; preds = %after_loop
  call void @__stack_chk_fail()
  unreachable

ok:                                               ; preds = %after_loop
  ret i32 0
}