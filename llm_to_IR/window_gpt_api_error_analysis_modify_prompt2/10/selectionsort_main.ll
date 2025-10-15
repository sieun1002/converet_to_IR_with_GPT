; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 0
  store i32 29, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 1
  store i32 10, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 2
  store i32 14, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 3
  store i32 37, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 4
  store i32 13, i32* %arr4, align 4
  store i32 5, i32* %n, align 4
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 0
  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arrptr, i32 %nval)
  %fmt1 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i32 0, i32 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.cur = load i32, i32* %i, align 4
  %n.cur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i.cur, %n.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %idx.ext = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i32 0, i32 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %elem)
  %i.next = add nsw i32 %i.cur, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop.cond

loop.end:
  ret i32 0
}