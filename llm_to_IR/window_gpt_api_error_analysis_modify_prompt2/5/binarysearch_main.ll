; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @binary_search(i32*, i64, i32)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %len = alloca i64, align 8
  %idx = alloca i32, align 4
  %limit = alloca i64, align 8
  %i = alloca i64, align 8

  %arr0.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0.ptr, align 4
  %arr1.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1.ptr, align 4
  %arr2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2.ptr, align 4
  %arr3.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3.ptr, align 4
  %arr4.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4.ptr, align 4
  %arr5.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5.ptr, align 4
  %arr6.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6.ptr, align 4
  %arr7.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7.ptr, align 4
  %arr8.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8.ptr, align 4

  %keys0.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0.ptr, align 4
  %keys1.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1.ptr, align 4
  %keys2.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2.ptr, align 4

  store i64 9, i64* %len, align 8
  store i64 3, i64* %limit, align 8
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.val = load i64, i64* %i, align 8
  %limit.val = load i64, i64* %limit, align 8
  %cmp = icmp ult i64 %i.val, %limit.val
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.val
  %key = load i32, i32* %key.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len.val = load i64, i64* %len, align 8
  %call = call i32 @binary_search(i32* %arr.base, i64 %len.val, i32 %key)
  store i32 %call, i32* %idx, align 4
  %isneg = icmp slt i32 %call, 0
  br i1 %isneg, label %notfound, label %found

found:
  %fmt1.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %idx.val = load i32, i32* %idx, align 4
  %printf.ok = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i32 %key, i32 %idx.val)
  br label %incr

notfound:
  %fmt2.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %printf.nf = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i32 %key)
  br label %incr

incr:
  %i.old = load i64, i64* %i, align 8
  %i.next = add i64 %i.old, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:
  ret i32 0
}