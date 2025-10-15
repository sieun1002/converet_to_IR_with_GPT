target triple = "x86_64-pc-windows-msvc"

@_Format = unnamed_addr constant [15 x i8] c"Sorted array: \00"
@aD = unnamed_addr constant [4 x i8] c"%d \00"

declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %arr0ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4ptr, align 4
  store i32 5, i32* %n, align 4
  %arrdecay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arrdecay, i32 %nval)
  %fmtptr0 = getelementptr inbounds [15 x i8], [15 x i8]* @_Format, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmtptr0)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.cur = load i32, i32* %i, align 4
  %n.cur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i.cur, %n.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %i.cur2 = load i32, i32* %i, align 4
  %idx64 = sext i32 %i.cur2 to i64
  %elemptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx64
  %val = load i32, i32* %elemptr, align 4
  %fmtptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmtptr1, i32 %val)
  %i.next = add nsw i32 %i.cur2, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop.cond

loop.end:
  ret i32 0
}