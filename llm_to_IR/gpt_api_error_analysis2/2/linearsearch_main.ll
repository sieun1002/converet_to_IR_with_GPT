; ModuleID = 'main_module'
target triple = "x86_64-pc-linux-gnu"

@.str.found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str.notfound = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1
@__stack_chk_guard = external global i64

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare void @__stack_chk_fail() noreturn

define dso_local i32 @main() {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %key = alloca i32, align 4
  %res = alloca i32, align 4
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %canary.slot, align 8
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %1, align 4
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %2, align 4
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %3, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %4, align 4
  %5 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %5, align 4
  store i32 5, i32* %n, align 4
  store i32 4, i32* %key, align 4
  %6 = load i32, i32* %n, align 4
  %7 = load i32, i32* %key, align 4
  %8 = call i32 @linear_search(i32* %1, i32 %6, i32 %7)
  store i32 %8, i32* %res, align 4
  %9 = load i32, i32* %res, align 4
  %10 = icmp eq i32 %9, -1
  br i1 %10, label %notfound, label %found

found:
  %11 = load i32, i32* %res, align 4
  %12 = getelementptr inbounds [27 x i8], [27 x i8]* @.str.found, i64 0, i64 0
  %13 = call i32 (i8*, ...) @printf(i8* %12, i32 %11)
  br label %tail

notfound:
  %14 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.notfound, i64 0, i64 0
  %15 = call i32 @puts(i8* %14)
  br label %tail

tail:
  %16 = load i64, i64* %canary.slot, align 8
  %17 = load i64, i64* @__stack_chk_guard, align 8
  %18 = icmp eq i64 %16, %17
  br i1 %18, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}