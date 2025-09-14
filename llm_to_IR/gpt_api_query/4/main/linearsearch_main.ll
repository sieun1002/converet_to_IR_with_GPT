; ModuleID = 'binary_to_ir'
source_filename = "binary_to_ir"
target triple = "x86_64-pc-linux-gnu"

@.str_found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1
@.str_not = private unnamed_addr constant [18 x i8] c"Element not found\00", align 1
@__stack_chk_guard = external global i64

declare i32 @linear_search(i32*, i32, i32)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %n = alloca i32, align 4
  %key = alloca i32, align 4
  %result = alloca i32, align 4
  %canary = alloca i64, align 8
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary, align 8

  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 4, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 4

  store i32 5, i32* %n, align 4
  store i32 4, i32* %key, align 4

  %arrptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %nval = load i32, i32* %n, align 4
  %keyval = load i32, i32* %key, align 4
  %call = call i32 @linear_search(i32* %arrptr, i32 %nval, i32 %keyval)
  store i32 %call, i32* %result, align 4

  %res = load i32, i32* %result, align 4
  %cmp = icmp eq i32 %res, -1
  br i1 %cmp, label %notfound, label %found

found:
  %res2 = load i32, i32* %result, align 4
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str_found, i64 0, i64 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %res2)
  br label %after

notfound:
  %strptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str_not, i64 0, i64 0
  %callputs = call i32 @puts(i8* %strptr)
  br label %after

after:
  %guard_end = load i64, i64* @__stack_chk_guard, align 8
  %orig_canary = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %orig_canary, %guard_end
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}