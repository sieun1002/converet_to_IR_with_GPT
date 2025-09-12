; ModuleID = 'binary_to_ir'
source_filename = "binary_to_ir"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @quick_sort(i32*, i32, i64)
declare void @__stack_chk_fail() noreturn

define dso_local i32 @main() {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8

  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %canary.slot, align 8

  ; initialize array: {9,1,5,3,7,2,8,6,4,0}
  %a0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %a0, align 4
  %a1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %a1, align 4
  %a2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %a2, align 4
  %a3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %a3, align 4
  %a4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %a4, align 4
  %a5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %a5, align 4
  %a6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %a6, align 4
  %a7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %a7, align 4
  %a8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %a8, align 4
  %a9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %a9, align 4

  store i64 10, i64* %len, align 8

  ; if (len <= 1) skip sort
  %lenv = load i64, i64* %len, align 8
  %cond = icmp ule i64 %lenv, 1
  br i1 %cond, label %skip_sort, label %do_sort

do_sort:                                          ; preds = %entry
  %lenv2 = load i64, i64* %len, align 8
  %right = add i64 %lenv2, -1
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %base, i32 0, i64 %right)
  br label %skip_sort

skip_sort:                                        ; preds = %do_sort, %entry
  store i64 0, i64* %i, align 8
  br label %loop

loop:                                             ; preds = %loop_body, %skip_sort
  %idx = load i64, i64* %i, align 8
  %lenv3 = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %idx, %lenv3
  br i1 %cmp, label %loop_body, label %after_loop

loop_body:                                        ; preds = %loop
  %eltptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idx
  %elt = load i32, i32* %eltptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elt)
  %next = add i64 %idx, 1
  store i64 %next, i64* %i, align 8
  br label %loop

after_loop:                                       ; preds = %loop
  %call2 = call i32 @putchar(i32 10)

  ; stack protector check
  %canary_loaded = load i64, i64* %canary.slot, align 8
  %guard_again = load i64, i64* @__stack_chk_guard
  %canary_mismatch = icmp ne i64 %canary_loaded, %guard_again
  br i1 %canary_mismatch, label %stack_fail, label %ret

stack_fail:                                       ; preds = %after_loop
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after_loop
  ret i32 0
}