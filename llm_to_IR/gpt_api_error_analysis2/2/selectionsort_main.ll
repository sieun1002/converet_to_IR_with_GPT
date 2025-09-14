; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @selection_sort(i32*, i32)
declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %p0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %p0, align 4
  %p1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %p1, align 4
  %p2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %p2, align 4
  %p3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %p3, align 4
  %p4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %p4, align 4
  store i32 5, i32* %n, align 4
  %nval = load i32, i32* %n, align 4
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  call void @selection_sort(i32* %arrdecay, i32 %nval)
  %fmt_sorted = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt_sorted)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %iv = load i32, i32* %i, align 4
  %ncur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %iv, %ncur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %idx = sext i32 %iv to i64
  %eltptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx
  %elt = load i32, i32* %eltptr, align 4
  %fmt_num = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt_num, i32 %elt)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

loop.end:
  ret i32 0
}