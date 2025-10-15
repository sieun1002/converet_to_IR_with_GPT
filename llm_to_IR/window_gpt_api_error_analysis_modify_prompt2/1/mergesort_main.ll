; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @merge_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %idx = alloca i64, align 8
  %len = alloca i64, align 8
  %gep0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %gep0, align 4
  %gep1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %gep2, align 4
  %gep3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %gep4, align 4
  %gep5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %gep5, align 4
  %gep6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %gep6, align 4
  %gep7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %gep7, align 4
  %gep8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %gep8, align 4
  %gep9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %gep9, align 4
  store i64 10, i64* %len, align 8
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %lenval = load i64, i64* %len, align 8
  call void @merge_sort(i32* noundef %arrdecay, i64 noundef %lenval)
  store i64 0, i64* %idx, align 8
  br label %loop.cond

loop.body:                                        ; preds = %loop.cond
  %i.cur = load i64, i64* %idx, align 8
  %eptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.cur
  %elem = load i32, i32* %eptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* noundef %fmtptr, i32 noundef %elem)
  %ival2 = load i64, i64* %idx, align 8
  %inc = add i64 %ival2, 1
  store i64 %inc, i64* %idx, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.check = load i64, i64* %idx, align 8
  %len2 = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.check, %len2
  br i1 %cmp, label %loop.body, label %after

after:                                            ; preds = %loop.cond
  %pc = call i32 @putchar(i32 noundef 10)
  ret i32 0
}