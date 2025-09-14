; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

@format = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@aD = private unnamed_addr constant [4 x i8] c"%d \00", align 1

@__stack_chk_guard = external thread_local global i64

declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)
declare void @___stack_chk_fail()

define dso_local i32 @main() local_unnamed_addr {
entry:
  %guard.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %i = alloca i32, align 4
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %guard.slot, align 8
  %arr0.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0.ptr, align 4
  %arr1.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1.ptr, align 4
  %arr2.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2.ptr, align 4
  %arr3.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3.ptr, align 4
  %arr4.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4.ptr, align 4
  store i32 5, i32* %n, align 4
  %n.val = load i32, i32* %n, align 4
  call void @selection_sort(i32* %arr0.ptr, i32 %n.val)
  %fmt.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @format, i64 0, i64 0
  %call.printf.header = call i32 (i8*, ...) @printf(i8* %fmt.ptr)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.cur = load i32, i32* %i, align 4
  %n.cur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i.cur, %n.cur
  br i1 %cmp, label %loop.body, label %epilogue

loop.body:                                        ; preds = %loop.cond
  %idx.ext = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.num.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @aD, i64 0, i64 0
  %call.printf.num = call i32 (i8*, ...) @printf(i8* %fmt.num.ptr, i32 %elem)
  %inc = add nsw i32 %i.cur, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

epilogue:                                         ; preds = %loop.cond
  %guard.load.end = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %guard.slot, align 8
  %canary.ok = icmp eq i64 %guard.load.end, %guard.saved
  br i1 %canary.ok, label %ret, label %stackchkfail

stackchkfail:                                     ; preds = %epilogue
  call void @___stack_chk_fail()
  unreachable

ret:                                              ; preds = %epilogue
  ret i32 0
}