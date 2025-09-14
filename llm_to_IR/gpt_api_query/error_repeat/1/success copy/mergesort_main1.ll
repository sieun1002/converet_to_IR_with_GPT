; ModuleID = 'decompiled'
source_filename = "decompiled"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @merge_sort(i32*, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  ; len = 10
  store i64 10, i64* %len, align 8

  ; initialize array: {9,1,5,3,7,2,8,6,4,0}
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %p0 = getelementptr inbounds i32, i32* %arr.base, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %p9, align 4

  ; merge_sort(&arr[0], len)
  %len.val = load i64, i64* %len, align 8
  call void @merge_sort(i32* %arr.base, i64 %len.val)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %n = load i64, i64* %len, align 8
  %cond = icmp ult i64 %iv, %n
  br i1 %cond, label %body, label %after

body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %iv
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %next = add i64 %iv, 1
  store i64 %next, i64* %i, align 8
  br label %loop

after:
  call i32 @putchar(i32 10)
  ret i32 0
}