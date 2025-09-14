; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x124D
; Intent: Sort an integer array using selection_sort and print the sorted result (confidence=0.95). Evidence: call to selection_sort; loop printing with "%d ".
; Preconditions:
; Postconditions:

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare void @selection_sort(i32*, i32)
declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %saved_guard = alloca i64, align 8
  %guard0 = load i64, i64* @__stack_chk_guard
  store i64 %guard0, i64* %saved_guard, align 8

  %arr = alloca [5 x i32], align 16
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4, align 4

  call void @selection_sort(i32* %arr0, i32 5)

  %fmt_sorted = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call_printf0 = call i32 (i8*, ...) @printf(i8* %fmt_sorted)
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp slt i32 %i, 5
  br i1 %cmp, label %loop.body, label %after

loop.body:
  %idx.ext = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %val = load i32, i32* %elem.ptr, align 4
  %fmt_val = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call_printf1 = call i32 (i8*, ...) @printf(i8* %fmt_val, i32 %val)
  %inc = add nsw i32 %i, 1
  br label %loop

after:
  %guard1 = load i64, i64* @__stack_chk_guard
  %saved = load i64, i64* %saved_guard, align 8
  %ok = icmp eq i64 %saved, %guard1
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}