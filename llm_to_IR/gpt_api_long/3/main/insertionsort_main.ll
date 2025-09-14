; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1247
; Intent: Initialize an array, sort it with insertion_sort, and print elements (confidence=0.98). Evidence: call to insertion_sort with int array and length; printf loop with "%d ".
; Preconditions: insertion_sort expects a valid i32* and length in elements (i64).
; Postconditions: prints 10 integers separated by spaces followed by a newline; returns 0.

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Only the needed extern declarations:
declare void @insertion_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [10 x i32]
  %gep0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %gep0
  %gep1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %gep1
  %gep2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %gep2
  %gep3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %gep3
  %gep4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %gep4
  %gep5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %gep5
  %gep6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %gep6
  %gep7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %gep7
  %gep8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %gep8
  %gep9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %gep9
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @insertion_sort(i32* %arrdecay, i64 10)
  br label %for.cond

for.cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %for.body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:
  %putnl = call i32 @putchar(i32 10)
  ret i32 0
}