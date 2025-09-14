; ModuleID = 'bin2ir'
target triple = "x86_64-pc-linux-gnu"

@.str.index = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00"
@.str.notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00"
@__stack_chk_guard = external global i64

declare i64 @binary_search(i32*, i64, i32)
declare i32 @printf(i8*, ...)
declare void @__stack_chk_fail()

define i32 @main() {
entry:
  %canary.slot = alloca i64, align 8
  %arr = alloca [9 x i32], align 16
  %n = alloca i64, align 8
  %keys = alloca [3 x i32], align 16
  %m = alloca i64, align 8
  %i = alloca i64, align 8
  %idx = alloca i64, align 8

  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %canary.slot, align 8

  ; arr = {-5, -1, 0, 2, 2, 3, 7, 9, 12}
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8, align 4

  store i64 9, i64* %n, align 8

  ; keys = {2, 5, -5}
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2, align 4

  store i64 3, i64* %m, align 8
  store i64 0, i64* %i, align 8

  br label %loop

loop:
  %i.val = load i64, i64* %i, align 8
  %m.val = load i64, i64* %m, align 8
  %cond = icmp ult i64 %i.val, %m.val
  br i1 %cond, label %body, label %after

body:
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.val
  %key = load i32, i32* %key.ptr, align 4
  %arr.decay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %res = call i64 @binary_search(i32* %arr.decay, i64 %n.val, i32 %key)
  store i64 %res, i64* %idx, align 8
  %isneg = icmp slt i64 %res, 0
  br i1 %isneg, label %notfound, label %found

found:
  %idxv = load i64, i64* %idx, align 8
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.index, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key, i64 %idxv)
  br label %inc

notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.notfound, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %inc

inc:
  %i.cur = load i64, i64* %i, align 8
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

after:
  %loaded.canary = load i64, i64* %canary.slot, align 8
  %guard2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %loaded.canary, %guard2
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}