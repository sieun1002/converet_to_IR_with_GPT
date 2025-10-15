; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@_Format = internal constant [4 x i8] c"%d \00", align 1

declare void @bubble_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8

  %arr.ptr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.ptr0, align 4
  %arr.ptr1 = getelementptr inbounds i32, i32* %arr.ptr0, i64 1
  store i32 1, i32* %arr.ptr1, align 4
  %arr.ptr2 = getelementptr inbounds i32, i32* %arr.ptr0, i64 2
  store i32 5, i32* %arr.ptr2, align 4
  %arr.ptr3 = getelementptr inbounds i32, i32* %arr.ptr0, i64 3
  store i32 3, i32* %arr.ptr3, align 4
  %arr.ptr4 = getelementptr inbounds i32, i32* %arr.ptr0, i64 4
  store i32 7, i32* %arr.ptr4, align 4
  %arr.ptr5 = getelementptr inbounds i32, i32* %arr.ptr0, i64 5
  store i32 2, i32* %arr.ptr5, align 4
  %arr.ptr6 = getelementptr inbounds i32, i32* %arr.ptr0, i64 6
  store i32 8, i32* %arr.ptr6, align 4
  %arr.ptr7 = getelementptr inbounds i32, i32* %arr.ptr0, i64 7
  store i32 6, i32* %arr.ptr7, align 4
  %arr.ptr8 = getelementptr inbounds i32, i32* %arr.ptr0, i64 8
  store i32 4, i32* %arr.ptr8, align 4
  %arr.ptr9 = getelementptr inbounds i32, i32* %arr.ptr0, i64 9
  store i32 0, i32* %arr.ptr9, align 4

  store i64 10, i64* %n, align 8

  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %len = load i64, i64* %n, align 8
  call void @bubble_sort(i32* %arrdecay, i64 %len)

  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.val = load i64, i64* %i, align 8
  %n.val = load i64, i64* %n, align 8
  %cmp = icmp ult i64 %i.val, %n.val
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arrdecay, i64 %i.val
  %val = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @_Format, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}