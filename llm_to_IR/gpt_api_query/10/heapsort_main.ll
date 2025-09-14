; ModuleID = 'main_from_disassembly'
source_filename = "main_from_disassembly.ll"

@.str.before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str.after  = private unnamed_addr constant [8 x i8] c"After: \00", align 1
@.str.d      = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  store i64 9, i64* %n, align 8

  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8, align 4

  %before.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.before, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %before.ptr)

  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                      ; preds = %loop1.body, %entry
  %i.val = load i64, i64* %i, align 8
  %n.val = load i64, i64* %n, align 8
  %cmp1 = icmp ult i64 %i.val, %n.val
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:                                      ; preds = %loop1.cond
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %inc = add i64 %i.val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop1.cond

loop1.end:                                       ; preds = %loop1.cond
  call i32 @putchar(i32 10)

  %base.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n.to.call = load i64, i64* %n, align 8
  call void @heap_sort(i32* %base.ptr, i64 %n.to.call)

  %after.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.str.after, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %after.ptr)

  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:                                      ; preds = %loop2.body, %loop1.end
  %j.val = load i64, i64* %j, align 8
  %n.val2 = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %j.val, %n.val2
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                      ; preds = %loop2.cond
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %fmt2.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i32 %elem2)
  %inc2 = add i64 %j.val, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2.cond

loop2.end:                                       ; preds = %loop2.cond
  call i32 @putchar(i32 10)
  ret i32 0
}