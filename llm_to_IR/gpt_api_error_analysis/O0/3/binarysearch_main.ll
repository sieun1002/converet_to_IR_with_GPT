; ModuleID = 'reconstructed_main'
target triple = "x86_64-unknown-linux-gnu"

@.fmt_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.fmt_notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @printf(i8*, ...)
declare i64 @binary_search(i32*, i64, i32)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16

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

  br label %loop.header

loop.header:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.latch ]
  %cmp.cont = icmp ult i64 %i, 3
  br i1 %cmp.cont, label %loop.body, label %exit

loop.body:
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key.val = load i32, i32* %key.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %bs.res = call i64 @binary_search(i32* %arr.base, i64 9, i32 %key.val)
  %is.neg = icmp slt i64 %bs.res, 0
  br i1 %is.neg, label %print.notfound, label %print.found

print.found:
  %fmt.found.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.fmt_found, i64 0, i64 0
  %call.printf.found = call i32 (i8*, ...) @printf(i8* %fmt.found.ptr, i32 %key.val, i64 %bs.res)
  br label %loop.latch

print.notfound:
  %fmt.notfound.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.fmt_notfound, i64 0, i64 0
  %call.printf.notfound = call i32 (i8*, ...) @printf(i8* %fmt.notfound.ptr, i32 %key.val)
  br label %loop.latch

loop.latch:
  %i.next = add i64 %i, 1
  br label %loop.header

exit:
  ret i32 0
}