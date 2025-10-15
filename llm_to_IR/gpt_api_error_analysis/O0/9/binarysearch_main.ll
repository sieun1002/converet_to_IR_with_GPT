; ModuleID = 'bs_main.ll'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare i32 @printf(i8*, ...)
declare i64 @binary_search(i32*, i64, i32)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
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
  %k0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %k0, align 4
  %k1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %k1, align 4
  %k2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %k2, align 4
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %latch ]
  %cond = icmp ult i64 %i, 3
  br i1 %cond, label %body, label %exit

body:
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key = load i32, i32* %keyptr, align 4
  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %idx = call i64 @binary_search(i32* %base, i64 9, i32 %key)
  %neg = icmp slt i64 %idx, 0
  br i1 %neg, label %notfound, label %found

found:
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %callf = call i32 (i8*, ...) @printf(i8* %fmt, i32 %key, i64 %idx)
  br label %latch

notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %callnf = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %latch

latch:
  %i.next = add i64 %i, 1
  br label %loop

exit:
  ret i32 0
}