; ModuleID = 'sub_14000171D.ll'
target triple = "x86_64-pc-windows-msvc"

@.str_before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str_fmt    = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str_after  = private unnamed_addr constant [8 x i8] c"After: \00", align 1

declare void @sub_1400018F0()
declare i32 @sub_140002960(i8*, ...)
declare i32 @sub_140002AF0(i32)
declare void @sub_140001450(i32*, i64)

define i32 @sub_14000171D() {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  %call_init = call void @sub_1400018F0()

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

  %before_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str_before, i64 0, i64 0
  %call_before = call i32 (i8*, ...) @sub_140002960(i8* %before_ptr)

  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %len, align 8
  %cmp1 = icmp ult i64 %i.cur, %len.cur
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.cur
  %elem.val1 = load i32, i32* %elem.ptr1, align 4
  %fmt_ptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_fmt, i64 0, i64 0
  %call_print1 = call i32 (i8*, ...) @sub_140002960(i8* %fmt_ptr1, i32 %elem.val1)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1.cond

loop1.end:
  %call_nl1 = call i32 @sub_140002AF0(i32 10)

  %base.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len.for.sort = load i64, i64* %len, align 8
  %call_sort = call void @sub_140001450(i32* %base.ptr, i64 %len.for.sort)

  %after_ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.str_after, i64 0, i64 0
  %call_after = call i32 (i8*, ...) @sub_140002960(i8* %after_ptr)

  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:
  %j.cur = load i64, i64* %j, align 8
  %len.cur2 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %j.cur, %len.cur2
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.cur
  %elem.val2 = load i32, i32* %elem.ptr2, align 4
  %fmt_ptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_fmt, i64 0, i64 0
  %call_print2 = call i32 (i8*, ...) @sub_140002960(i8* %fmt_ptr2, i32 %elem.val2)
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2.cond

loop2.end:
  %call_nl2 = call i32 @sub_140002AF0(i32 10)
  ret i32 0
}