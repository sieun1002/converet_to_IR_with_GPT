; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)
declare void @__stack_chk_fail() noreturn

define dso_local i32 @main() {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %g = load i64, i64* @__stack_chk_guard, align 8
  store i64 %g, i64* %canary, align 8
  %0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %0, align 4
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %1, align 4
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %2, align 4
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %3, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %4, align 4
  store i32 5, i32* %n, align 4
  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arrptr, i32 %nval)
  %fmt0 = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt0)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %iv = load i32, i32* %i, align 4
  %ncur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %iv, %ncur
  br i1 %cmp, label %body, label %done

body:
  %idx = sext i32 %iv to i64
  %elptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx
  %val = load i32, i32* %elptr, align 4
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %val)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

done:
  %cstored = load i64, i64* %canary, align 8
  %g2 = load i64, i64* @__stack_chk_guard, align 8
  %cmpc = icmp ne i64 %cstored, %g2
  br i1 %cmpc, label %stackfail, label %ret

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}