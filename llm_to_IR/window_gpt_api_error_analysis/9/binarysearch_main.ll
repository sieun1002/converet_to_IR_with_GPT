; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dso_local i32 @printf(i8*, ...)

define dso_local i32 @binary_search(i32* %arr, i32 %n, i32 %key) local_unnamed_addr {
entry:
  %l = alloca i32, align 4
  %r = alloca i32, align 4
  store i32 0, i32* %l, align 4
  %nminus1 = add i32 %n, -1
  store i32 %nminus1, i32* %r, align 4
  br label %loop

loop:
  %lcur = load i32, i32* %l, align 4
  %rcur = load i32, i32* %r, align 4
  %cmp = icmp sle i32 %lcur, %rcur
  br i1 %cmp, label %body, label %ret_not

body:
  %sum = add i32 %lcur, %rcur
  %mid = ashr i32 %sum, 1
  %mid64 = sext i32 %mid to i64
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid64
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %val, %key
  br i1 %eq, label %ret_mid, label %cmp2

cmp2:
  %lt = icmp slt i32 %val, %key
  br i1 %lt, label %go_right, label %go_left

go_right:
  %midp1 = add i32 %mid, 1
  store i32 %midp1, i32* %l, align 4
  br label %loop

go_left:
  %midm1 = add i32 %mid, -1
  store i32 %midm1, i32* %r, align 4
  br label %loop

ret_mid:
  ret i32 %mid

ret_not:
  ret i32 -1
}

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %i = alloca i64, align 8
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 0, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 2, i32* %arr4, align 4
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 7, i32* %arr6, align 4
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 12, i32* %arr8, align 4
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds i32, i32* %keys0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds i32, i32* %keys0, i64 2
  store i32 -5, i32* %keys2, align 4
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.cur = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.cur, 3
  br i1 %cmp, label %body, label %done

body:
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.cur
  %key = load i32, i32* %key.ptr, align 4
  %res = call i32 @binary_search(i32* %arr0, i32 9, i32 %key)
  %neg = icmp slt i32 %res, 0
  br i1 %neg, label %notfound, label %found

found:
  %fmtptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %callf = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %key, i32 %res)
  br label %cont

notfound:
  %fmtptr2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.notfound, i64 0, i64 0
  %callnf = call i32 (i8*, ...) @printf(i8* %fmtptr2, i32 %key)
  br label %cont

cont:
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

done:
  ret i32 0
}