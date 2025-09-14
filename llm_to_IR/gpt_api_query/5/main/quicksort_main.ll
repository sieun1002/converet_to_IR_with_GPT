; ModuleID = 'decompiled'
source_filename = "decompiled.c"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare void @quick_sort(i32* nocapture, i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %saved_canary = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8

  %g = load i64, i64* @__stack_chk_guard, align 8
  store i64 %g, i64* %saved_canary, align 8

  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9, align 4

  store i64 10, i64* %n, align 8

  %nval = load i64, i64* %n, align 8
  %cmp = icmp ugt i64 %nval, 1
  br i1 %cmp, label %qs, label %loop_init

qs:
  %n_minus1 = add i64 %nval, -1
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %arrdecay, i64 0, i64 %n_minus1)
  br label %loop_init

loop_init:
  store i64 0, i64* %i, align 8
  br label %loop_cond

loop_cond:
  %i_val = load i64, i64* %i, align 8
  %nval2 = load i64, i64* %n, align 8
  %lt = icmp ult i64 %i_val, %nval2
  br i1 %lt, label %loop_body, label %after_loop

loop_body:
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i_val
  %elem = load i32, i32* %elem_ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %i, align 8
  br label %loop_cond

after_loop:
  %pc = call i32 @putchar(i32 10)

  %g2 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %saved_canary, align 8
  %ok = icmp eq i64 %saved, %g2
  br i1 %ok, label %ret, label %stack_fail

stack_fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}