; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@format = external global i8
@byte_2011 = external global i8
@__stack_chk_guard = external global i64, align 8

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @heap_sort(i32*, i64)
declare dso_local void @__stack_chk_fail() noreturn

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary, align 8
  %0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %0, align 4
  %1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %1, align 4
  %2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %2, align 4
  %3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %3, align 4
  %4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %4, align 4
  %5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %5, align 4
  %6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %6, align 4
  %7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %8, align 4
  call i32 (i8*, ...) @printf(i8* @format)
  store i64 0, i64* %i, align 8
  br label %loop1

loop1:                                            ; preds = %body1, %entry
  %i.val = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.val, 9
  br i1 %cmp, label %body1, label %after1

body1:                                            ; preds = %loop1
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %val = load i32, i32* %elem.ptr, align 4
  %fmtint = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtint, i32 %val)
  %inc = add i64 %i.val, 1
  store i64 %inc, i64* %i, align 8
  br label %loop1

after1:                                           ; preds = %loop1
  call i32 @putchar(i32 10)
  %arrbase = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arrbase, i64 9)
  call i32 (i8*, ...) @printf(i8* @byte_2011)
  store i64 0, i64* %j, align 8
  br label %loop2

loop2:                                            ; preds = %body2, %after1
  %j.val = load i64, i64* %j, align 8
  %cmp2 = icmp ult i64 %j.val, 9
  br i1 %cmp2, label %body2, label %after2

body2:                                            ; preds = %loop2
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %val2 = load i32, i32* %elem2.ptr, align 4
  %fmtint2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtint2, i32 %val2)
  %inc2 = add i64 %j.val, 1
  store i64 %inc2, i64* %j, align 8
  br label %loop2

after2:                                           ; preds = %loop2
  call i32 @putchar(i32 10)
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %saved, %guard2
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %after2
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after2
  ret i32 0
}