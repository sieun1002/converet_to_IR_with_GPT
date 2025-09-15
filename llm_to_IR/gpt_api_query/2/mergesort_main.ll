; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @merge_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8

  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr, align 16

  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @merge_sort(i32* %base, i64 10)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %iv, 10
  br i1 %cmp, label %body, label %done

body:
  %elemPtr = getelementptr inbounds i32, i32* %base, i64 %iv
  %val = load i32, i32* %elemPtr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val)
  %next = add i64 %iv, 1
  store i64 %next, i64* %i, align 8
  br label %loop

done:
  call i32 @putchar(i32 10)
  ret i32 0
}