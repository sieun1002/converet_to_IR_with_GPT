; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

@.str.before = private unnamed_addr constant [17 x i8] c"Before sorting: \00", align 1
@.str.after  = private unnamed_addr constant [16 x i8] c"After sorting: \00", align 1
@.str.d      = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  %arr0ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0ptr, align 4
  %arr1ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2ptr, align 4
  %arr3ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4ptr, align 4
  %arr5ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6ptr, align 4
  %arr7ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8ptr, align 4

  store i64 9, i64* %len, align 8

  %before_ptr = getelementptr inbounds [17 x i8], [17 x i8]* @.str.before, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %before_ptr)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.cur = load i64, i64* %i, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.cur, %len.val
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %inc = add i64 %i.cur, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

loop.end:
  %nl = call i32 @putchar(i32 10)

  %base.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len2 = load i64, i64* %len, align 8
  call void @heap_sort(i32* %base.ptr, i64 %len2)

  %after_ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str.after, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %after_ptr)

  store i64 0, i64* %j, align 8
  br label %loop2

loop2:
  %j.cur = load i64, i64* %j, align 8
  %len3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %j.cur, %len3
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.cur
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmtptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @printf(i8* %fmtptr2, i32 %elem2)
  %inc2 = add i64 %j.cur, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2

loop2.end:
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}