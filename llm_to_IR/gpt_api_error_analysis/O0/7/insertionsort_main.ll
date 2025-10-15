; ModuleID = 'main.ll'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external thread_local global i64

declare void @insertion_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %canary, align 8
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %1, align 4
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %2, align 4
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %3, align 4
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %4, align 4
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %5, align 4
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %6, align 4
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %7, align 4
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %8, align 4
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %9, align 4
  %10 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %10, align 4
  call void @insertion_sort(i32* %1, i64 10)
  br label %loop.check

loop.check:
  %11 = phi i64 [ 0, %entry ], [ %15, %loop.body ]
  %12 = icmp ult i64 %11, 10
  br i1 %12, label %loop.body, label %after.loop

loop.body:
  %13 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %11
  %14 = load i32, i32* %13, align 4
  %15 = add i64 %11, 1
  %16 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %17 = call i32 (i8*, ...) @printf(i8* %16, i32 %14)
  br label %loop.check

after.loop:
  %18 = call i32 @putchar(i32 10)
  %19 = load i64, i64* @__stack_chk_guard, align 8
  %20 = load i64, i64* %canary, align 8
  %21 = icmp eq i64 %20, %19
  br i1 %21, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}