; ModuleID = 'main.ll'
target triple = "x86_64-w64-windows-gnu"

@.str_before = private unnamed_addr constant [9 x i8] c"Before:\0A\00", align 1
@.str_after  = private unnamed_addr constant [8 x i8] c"After:\0A\00", align 1
@.str_d      = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @__main()
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  call void @__main()
  store i64 9, i64* %len, align 8
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 4
  %fmt_before = getelementptr inbounds [9 x i8], [9 x i8]* @.str_before, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt_before)
  br label %loop1.header

loop1.header:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.body.end ]
  %len.load = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i, %len.load
  br i1 %cmp, label %loop1.body, label %after_loop1

loop1.body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmt_d = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt_d, i32 %val)
  br label %loop1.body.end

loop1.body.end:
  %i.next = add i64 %i, 1
  br label %loop1.header

after_loop1:
  %nl = call i32 @putchar(i32 10)
  %arrdecay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len2 = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arrdecay, i64 %len2)
  %fmt_after = getelementptr inbounds [8 x i8], [8 x i8]* @.str_after, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt_after)
  br label %loop2.header

loop2.header:
  %j = phi i64 [ 0, %after_loop1 ], [ %j.next, %loop2.body.end ]
  %len3 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %j, %len3
  br i1 %cmp2, label %loop2.body, label %after_loop2

loop2.body:
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %val2 = load i32, i32* %elem2.ptr, align 4
  %fmt_d2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @printf(i8* %fmt_d2, i32 %val2)
  br label %loop2.body.end

loop2.body.end:
  %j.next = add i64 %j, 1
  br label %loop2.header

after_loop2:
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}