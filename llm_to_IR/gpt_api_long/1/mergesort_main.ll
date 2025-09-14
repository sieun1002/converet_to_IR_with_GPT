; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x13F7
; Intent: Create an array, sort it with merge_sort, and print the result (confidence=0.95). Evidence: call to merge_sort with pointer+length; loop printing with "%d ".
; Preconditions: merge_sort expects a valid i32* array and length (i64).
; Postconditions: Prints the sorted array elements followed by a newline; returns 0.

@.str = private unnamed_addr constant [4 x i8] c"%d \00"

declare void @merge_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr_i32 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr_i32, align 4
  %gep1 = getelementptr inbounds i32, i32* %arr_i32, i64 1
  store i32 1, i32* %gep1, align 4
  %gep2 = getelementptr inbounds i32, i32* %arr_i32, i64 2
  store i32 5, i32* %gep2, align 4
  %gep3 = getelementptr inbounds i32, i32* %arr_i32, i64 3
  store i32 3, i32* %gep3, align 4
  %gep4 = getelementptr inbounds i32, i32* %arr_i32, i64 4
  store i32 7, i32* %gep4, align 4
  %gep5 = getelementptr inbounds i32, i32* %arr_i32, i64 5
  store i32 2, i32* %gep5, align 4
  %gep6 = getelementptr inbounds i32, i32* %arr_i32, i64 6
  store i32 8, i32* %gep6, align 4
  %gep7 = getelementptr inbounds i32, i32* %arr_i32, i64 7
  store i32 6, i32* %gep7, align 4
  %gep8 = getelementptr inbounds i32, i32* %arr_i32, i64 8
  store i32 4, i32* %gep8, align 4
  %gep9 = getelementptr inbounds i32, i32* %arr_i32, i64 9
  store i32 0, i32* %gep9, align 4

  call void @merge_sort(i32* %arr_i32, i64 10)

  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %loop.body, label %after

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr_i32, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop

after:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}