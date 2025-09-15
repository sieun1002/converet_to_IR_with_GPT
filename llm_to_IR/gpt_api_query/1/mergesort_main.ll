; ModuleID = 'recovered'
source_filename = "recovered"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @merge_sort(i32* nocapture, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8

  store i64 10, i64* %n, align 8
  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr, align 16

  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %nval = load i64, i64* %n, align 8
  call void @merge_sort(i32* %arrdecay, i64 %nval)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %ncur = load i64, i64* %n, align 8
  %cond = icmp ult i64 %iv, %ncur
  br i1 %cond, label %body, label %after

body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %iv
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %next = add i64 %iv, 1
  store i64 %next, i64* %i, align 8
  br label %loop

after:
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}