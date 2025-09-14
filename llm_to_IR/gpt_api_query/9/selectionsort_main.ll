; ModuleID = 'binary.ll'
source_filename = "binary"
target triple = "x86_64-pc-linux-gnu"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.int = private unnamed_addr constant [4 x i8] c"%d \00", align 1

@__stack_chk_guard = external global i64
declare void @__stack_chk_fail() cold noreturn nounwind
declare i32 @printf(i8*, ...)
declare void @selection_sort(i32*, i32)

define i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %idx = alloca i32, align 4
  %n = alloca i32, align 4
  %ssp.slot = alloca i64, align 8

  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %ssp.slot, align 8

  %arr0p = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0p, align 4
  %arr1p = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  store i32 10, i32* %arr1p, align 4
  %arr2p = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  store i32 14, i32* %arr2p, align 4
  %arr3p = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  store i32 37, i32* %arr3p, align 4
  %arr4p = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 13, i32* %arr4p, align 4

  store i32 5, i32* %n, align 4
  %nval = load i32, i32* %n, align 4
  call void @selection_sort(i32* nonnull %arr0p, i32 %nval)

  %fmt1 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* nonnull %fmt1)

  store i32 0, i32* %idx, align 4
  br label %loop.cond

loop.cond:
  %idxv = load i32, i32* %idx, align 4
  %nv = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %idxv, %nv
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %idx.ext = sext i32 %idxv to i64
  %elemp = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %idx.ext
  %elem = load i32, i32* %elemp, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.int, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* nonnull %fmt2, i32 %elem)
  %inc = add nsw i32 %idxv, 1
  store i32 %inc, i32* %idx, align 4
  br label %loop.cond

after.loop:
  %guard2 = load i64, i64* @__stack_chk_guard
  %slot = load i64, i64* %ssp.slot, align 8
  %ok = icmp eq i64 %slot, %guard2
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}