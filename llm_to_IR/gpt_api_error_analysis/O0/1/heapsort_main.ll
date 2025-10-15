; ModuleID = 'main_module'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.fmt_before = private unnamed_addr constant [8 x i8] c"Before:\00"
@.fmt_after  = private unnamed_addr constant [7 x i8] c"After:\00"
@.fmt_d      = private unnamed_addr constant [4 x i8] c"%d \00"

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32* noundef, i64 noundef)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16

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

  %fmt_before_ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.fmt_before, i64 0, i64 0
  %call_banner1 = call i32 (i8*, ...) @printf(i8* noundef %fmt_before_ptr)
  br label %loop1.cond

loop1.cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.latch ]
  %cmp1 = icmp ult i64 %i, 9
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %fmt_d_ptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt_d, i64 0, i64 0
  %call_print1 = call i32 (i8*, ...) @printf(i8* noundef %fmt_d_ptr1, i32 noundef %elem1)
  br label %loop1.latch

loop1.latch:
  %i.next = add i64 %i, 1
  br label %loop1.cond

loop1.end:
  %nl1 = call i32 @putchar(i32 noundef 10)

  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* noundef %arr.base, i64 noundef 9)

  %fmt_after_ptr = getelementptr inbounds [7 x i8], [7 x i8]* @.fmt_after, i64 0, i64 0
  %call_banner2 = call i32 (i8*, ...) @printf(i8* noundef %fmt_after_ptr)
  br label %loop2.cond

loop2.cond:
  %j = phi i64 [ 0, %loop1.end ], [ %j.next, %loop2.latch ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %fmt_d_ptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt_d, i64 0, i64 0
  %call_print2 = call i32 (i8*, ...) @printf(i8* noundef %fmt_d_ptr2, i32 noundef %elem2)
  br label %loop2.latch

loop2.latch:
  %j.next = add i64 %j, 1
  br label %loop2.cond

loop2.end:
  %nl2 = call i32 @putchar(i32 noundef 10)
  ret i32 0
}