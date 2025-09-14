; ModuleID = 'module'
source_filename = "module"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @merge_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8

  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arrdecay, align 4
  %gep1 = getelementptr inbounds i32, i32* %arrdecay, i64 1
  store i32 1, i32* %gep1, align 4
  %gep2 = getelementptr inbounds i32, i32* %arrdecay, i64 2
  store i32 5, i32* %gep2, align 4
  %gep3 = getelementptr inbounds i32, i32* %arrdecay, i64 3
  store i32 3, i32* %gep3, align 4
  %gep4 = getelementptr inbounds i32, i32* %arrdecay, i64 4
  store i32 7, i32* %gep4, align 4
  %gep5 = getelementptr inbounds i32, i32* %arrdecay, i64 5
  store i32 2, i32* %gep5, align 4
  %gep6 = getelementptr inbounds i32, i32* %arrdecay, i64 6
  store i32 8, i32* %gep6, align 4
  %gep7 = getelementptr inbounds i32, i32* %arrdecay, i64 7
  store i32 6, i32* %gep7, align 4
  %gep8 = getelementptr inbounds i32, i32* %arrdecay, i64 8
  store i32 4, i32* %gep8, align 4
  %gep9 = getelementptr inbounds i32, i32* %arrdecay, i64 9
  store i32 0, i32* %gep9, align 4

  store i64 10, i64* %n, align 8

  %nval = load i64, i64* %n, align 8
  call void @merge_sort(i32* %arrdecay, i64 %nval)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i1 = load i64, i64* %i, align 8
  %n1 = load i64, i64* %n, align 8
  %cmp = icmp ult i64 %i1, %n1
  br i1 %cmp, label %body, label %after

body:
  %elem_ptr = getelementptr inbounds i32, i32* %arrdecay, i64 %i1
  %val = load i32, i32* %elem_ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val)
  %i2 = add i64 %i1, 1
  store i64 %i2, i64* %i, align 8
  br label %loop

after:
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}