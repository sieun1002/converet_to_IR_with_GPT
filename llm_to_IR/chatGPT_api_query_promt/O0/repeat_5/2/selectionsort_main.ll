; ModuleID = 'recovered'
source_filename = "recovered"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

@__stack_chk_guard = external global i64

declare void @__stack_chk_fail() noreturn
declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)

define i32 @main() {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  %n = alloca i32, align 4

  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %canary, align 8

  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4, align 4

  store i32 5, i32* %n, align 4

  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arrptr, i32 %nval)

  %fmt = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt)

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i_curr = load i32, i32* %i, align 4
  %n_curr = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i_curr, %n_curr
  br i1 %cmp, label %body, label %done

body:
  %idx64 = sext i32 %i_curr to i64
  %elem_ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx64
  %elem = load i32, i32* %elem_ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt2, i32 %elem)
  %inc = add nsw i32 %i_curr, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

done:
  %old_canary = load i64, i64* %canary, align 8
  %guard2 = load i64, i64* @__stack_chk_guard
  %cmp_guard = icmp ne i64 %old_canary, %guard2
  br i1 %cmp_guard, label %stackfail, label %ret

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}