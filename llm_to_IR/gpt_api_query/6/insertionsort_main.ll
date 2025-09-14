; ModuleID = 'recovered_from_binary'
source_filename = "recovered_from_binary.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @insertion_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main() #0 {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  store i64 10, i64* %len, align 8
  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr, align 16

  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %lenval = load i64, i64* %len, align 8
  call void @insertion_sort(i32* noundef %arrdecay, i64 noundef %lenval)

  store i64 0, i64* %i, align 8
  br label %loop

loop:                                             ; preds = %body, %entry
  %idx = load i64, i64* %i, align 8
  %len2 = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %idx, %len2
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idx
  %val = load i32, i32* %elem_ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* noundef %fmt, i32 noundef %val)
  %idx.next = add i64 %idx, 1
  store i64 %idx.next, i64* %i, align 8
  br label %loop

after:                                            ; preds = %loop
  %nl = call i32 @putchar(i32 noundef 10)
  ret i32 0
}

attributes #0 = { sspstrong }