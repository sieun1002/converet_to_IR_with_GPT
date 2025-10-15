; ModuleID = 'fixed_module'
source_filename = "fixed_module.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str.index = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.notfound = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dso_local i32 @printf(i8*, ...)

define dso_local void @__main() {
entry:
  ret void
}

declare dso_local i32 @binary_search(i32* %arr, i64 %n, i32 %key)

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %i = alloca i64, align 8
  call void @__main()
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
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2, align 4
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %inc, %entry
  %i.val = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.val, 3
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.cond
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.val
  %key = load i32, i32* %key.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %idx = call i32 @binary_search(i32* %arr.base, i64 9, i32 %key)
  %isneg = icmp slt i32 %idx, 0
  br i1 %isneg, label %notfound, label %found

found:                                            ; preds = %loop.body
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.index, i64 0, i64 0
  %print1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key, i32 %idx)
  br label %inc

notfound:                                         ; preds = %loop.body
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.notfound, i64 0, i64 0
  %print2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %inc

inc:                                              ; preds = %notfound, %found
  %i.cur = load i64, i64* %i, align 8
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

exit:                                             ; preds = %loop.cond
  ret i32 0
}

define dso_local i32 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  %lo = alloca i64, align 8
  %hi = alloca i64, align 8
  %nminus1 = add i64 %n, -1
  store i64 0, i64* %lo, align 8
  store i64 %nminus1, i64* %hi, align 8
  br label %while.cond

while.cond:                                       ; preds = %go.left, %go.right, %entry
  %lo.v = load i64, i64* %lo, align 8
  %hi.v = load i64, i64* %hi, align 8
  %cmp = icmp sle i64 %lo.v, %hi.v
  br i1 %cmp, label %while.body, label %ret.notfound

while.body:                                       ; preds = %while.cond
  %lo.v2 = load i64, i64* %lo, align 8
  %hi.v2 = load i64, i64* %hi, align 8
  %diff = sub i64 %hi.v2, %lo.v2
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo.v2, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %eq = icmp eq i32 %elem, %key
  br i1 %eq, label %ret.found, label %check.lt

check.lt:                                         ; preds = %while.body
  %lt = icmp slt i32 %elem, %key
  br i1 %lt, label %go.right, label %go.left

go.right:                                         ; preds = %check.lt
  %mid.plus = add i64 %mid, 1
  store i64 %mid.plus, i64* %lo, align 8
  br label %while.cond

go.left:                                          ; preds = %check.lt
  %mid.minus = add i64 %mid, -1
  store i64 %mid.minus, i64* %hi, align 8
  br label %while.cond

ret.found:                                        ; preds = %while.body
  %mid.trunc = trunc i64 %mid to i32
  ret i32 %mid.trunc

ret.notfound:                                     ; preds = %while.cond
  ret i32 -1
}