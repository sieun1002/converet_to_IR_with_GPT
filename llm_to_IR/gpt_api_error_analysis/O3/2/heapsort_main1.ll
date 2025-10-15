; ModuleID = 'main.ll'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32* noundef, i64 noundef)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %gep0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %gep0, align 4
  %gep1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %gep2, align 4
  %gep3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %gep4, align 4
  %gep5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %gep5, align 4
  %gep6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %gep6, align 4
  %gep7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %gep7, align 4
  %gep8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %gep8, align 4
  store i64 9, i64* %len, align 8
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:
  %i.val = load i64, i64* %i, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp1 = icmp ult i64 %i.val, %len.val
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1.cond

loop1.end:
  %nl = call i32 @putchar(i32 10)
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len2 = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arr.base, i64 %len2)
  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:
  %j.val = load i64, i64* %j, align 8
  %len3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %j.val, %len3
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %fmt.ptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt.ptr2, i32 %elem2)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2.cond

loop2.end:
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}