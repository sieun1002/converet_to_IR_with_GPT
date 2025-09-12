; ModuleID = 'main_from_disasm'
source_filename = "main_from_disasm.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str.init = private unnamed_addr constant [16 x i8] c"Initial array: \00", align 1
@.str.num = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  ; initialize array: 7,3,9,1,4,8,2,6,5
  %a0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %a0, align 4
  %a1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %a1, align 4
  %a2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %a2, align 4
  %a3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %a3, align 4
  %a4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %a4, align 4
  %a5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %a5, align 4
  %a6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %a6, align 4
  %a7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %a7, align 4
  %a8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %a8, align 4

  store i64 9, i64* %len, align 8

  ; printf("Initial array: ")
  %p.init = getelementptr inbounds [16 x i8], [16 x i8]* @.str.init, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %p.init)

  ; first print loop
  store i64 0, i64* %i, align 8
  br label %loop1

loop1:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %len, align 8
  %lt1 = icmp ult i64 %i.cur, %len.cur
  br i1 %lt1, label %body1, label %end1

body1:
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.cur
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %p.num = getelementptr inbounds [4 x i8], [4 x i8]* @.str.num, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %p.num, i32 %elem1)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1

end1:
  call i32 @putchar(i32 10)

  ; heap_sort(arr, len)
  %arr.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len.val = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arr.ptr, i64 %len.val)

  ; printf("Sorted array: ")
  %p.sorted = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %p.sorted)

  ; second print loop
  store i64 0, i64* %j, align 8
  br label %loop2

loop2:
  %j.cur = load i64, i64* %j, align 8
  %len.cur2 = load i64, i64* %len, align 8
  %lt2 = icmp ult i64 %j.cur, %len.cur2
  br i1 %lt2, label %body2, label %end2

body2:
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.cur
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %p.num2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.num, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %p.num2, i32 %elem2)
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2

end2:
  call i32 @putchar(i32 10)

  ret i32 0
}