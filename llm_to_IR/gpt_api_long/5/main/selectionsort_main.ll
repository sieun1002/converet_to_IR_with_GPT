; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x124D
; Intent: Sort a small local array with selection_sort and print it (confidence=0.92). Evidence: call to selection_sort; printf of "Sorted array:" and each element with "%d ".
; Preconditions: none
; Postconditions: returns 0

; Only the needed extern declarations:
declare void @selection_sort(i32*, i32)
declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail()
@__stack_chk_guard = external thread_local global i64

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %canary = alloca i64, align 8
  store i64 %guard, i64* %canary, align 8

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

  %p1 = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call0 = call i32 @printf(i8* %p1)
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %loop_body_end ]
  %cmp = icmp slt i32 %i, 5
  br i1 %cmp, label %loop_body, label %after_loop

loop_body:
  %idx = zext i32 %i to i64
  %elt.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx
  %elt = load i32, i32* %elt.ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %elt)
  br label %loop_body_end

loop_body_end:
  %inc = add nsw i32 %i, 1
  br label %loop

after_loop:
  %saved = load i64, i64* %canary, align 8
  %guard2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %saved, %guard2
  br i1 %ok, label %ret, label %stack_fail

stack_fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}