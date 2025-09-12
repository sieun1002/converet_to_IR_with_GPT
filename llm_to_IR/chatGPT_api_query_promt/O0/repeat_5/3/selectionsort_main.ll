; ModuleID = 'bin2ir'
source_filename = "bin2ir.c"
target triple = "x86_64-pc-linux-gnu"

@.strSort = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.strInt  = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64, align 8

declare void @selection_sort(i32*, i32)
declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %i = alloca i32, align 4

  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.slot, align 8

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

  store i32 5, i32* %len, align 4

  %decay = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %lenval = load i32, i32* %len, align 4
  call void @selection_sort(i32* %decay, i32 %lenval)

  %pstr = getelementptr inbounds [15 x i8], [15 x i8]* @.strSort, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %pstr)

  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.val = load i32, i32* %i, align 4
  %len.cur = load i32, i32* %len, align 4
  %cmp = icmp slt i32 %i.val, %len.cur
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %idx.ext = sext i32 %i.val to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.strInt, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %inc = add nsw i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %saved = load i64, i64* %canary.slot, align 8
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %cmpcan = icmp ne i64 %saved, %guard2
  br i1 %cmpcan, label %stack_fail, label %ret

stack_fail:                                       ; preds = %after.loop
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after.loop
  ret i32 0
}