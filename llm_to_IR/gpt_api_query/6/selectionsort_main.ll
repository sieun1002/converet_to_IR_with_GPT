; ModuleID = 'recovered'
; LLVM version: 14

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

@__stack_chk_guard = external global i64
declare void @__stack_chk_fail() noreturn
declare void @selection_sort(i32* noundef, i32 noundef)
declare i32 @printf(i8* noundef, ...)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [5 x i32], align 16
  %i = alloca i32, align 4
  %n = alloca i32, align 4
  %canary = alloca i64, align 8

  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary, align 8

  ; initialize array: {29, 10, 14, 37, 13}
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0, align 16
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2, align 8
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4, align 16

  store i32 5, i32* %n, align 4

  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* noundef %arr0, i32 noundef %nval)

  %pfx = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %pfx)

  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %i.cur = load i32, i32* %i, align 4
  %n.cur = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %i.cur, %n.cur
  br i1 %cmp, label %body, label %post

body:                                             ; preds = %loop
  %idx.ext = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %fmt, i32 noundef %elem)
  %inc = add nsw i32 %i.cur, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

post:                                             ; preds = %loop
  %canary.cur = load i64, i64* %canary, align 8
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %canary.cur, %guard2
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %post
  call void @__stack_chk_fail() noreturn
  unreachable

ret:                                              ; preds = %post
  ret i32 0
}