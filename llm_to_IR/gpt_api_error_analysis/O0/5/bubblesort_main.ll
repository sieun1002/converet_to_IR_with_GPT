; ModuleID = 'main'
source_filename = "main.c"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @bubble_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %arr.gep0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.gep0, align 4
  %arr.gep1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.gep1, align 4
  %arr.gep2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr.gep2, align 4
  %arr.gep3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr.gep3, align 4
  %arr.gep4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr.gep4, align 4
  %arr.gep5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr.gep5, align 4
  %arr.gep6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr.gep6, align 4
  %arr.gep7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.gep7, align 4
  %arr.gep8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.gep8, align 4
  %arr.gep9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.gep9, align 4
  store i64 10, i64* %len, align 8
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %len.load0 = load i64, i64* %len, align 8
  call void @bubble_sort(i32* %arr.ptr, i64 %len.load0)
  br label %loop.cond

loop.cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %len.load1 = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i, %len.load1
  br i1 %cmp, label %loop.body, label %after

loop.body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %i.next = add i64 %i, 1
  br label %loop.cond

after:
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}