; ModuleID = 'module'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @insertion_sort(i32* nocapture, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arrdecay, align 4
  %idx1 = getelementptr inbounds i32, i32* %arrdecay, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arrdecay, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %arrdecay, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arrdecay, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %arrdecay, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %arrdecay, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %arrdecay, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %arrdecay, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %arrdecay, i64 9
  store i32 0, i32* %idx9, align 4

  store i64 10, i64* %len, align 8

  %n = load i64, i64* %len, align 8
  call void @insertion_sort(i32* %arrdecay, i64 %n)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %n2 = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %iv, %n2
  br i1 %cmp, label %body, label %done

body:
  %elem_ptr = getelementptr inbounds i32, i32* %arrdecay, i64 %iv
  %elem = load i32, i32* %elem_ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %next = add i64 %iv, 1
  store i64 %next, i64* %i, align 8
  br label %loop

done:
  call i32 @putchar(i32 10)
  ret i32 0
}