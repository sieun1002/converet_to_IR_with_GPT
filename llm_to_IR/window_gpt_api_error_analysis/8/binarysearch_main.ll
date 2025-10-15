; ModuleID = 'module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dso_local i32 @printf(i8*, ...)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local i32 @binary_search(i32* %arr, i32 %n, i32 %key) {
entry:
  %lo = alloca i32, align 4
  %hi = alloca i32, align 4
  store i32 0, i32* %lo, align 4
  %n_minus_1 = add i32 %n, -1
  store i32 %n_minus_1, i32* %hi, align 4
  br label %loop

loop:
  %lo.val = load i32, i32* %lo, align 4
  %hi.val = load i32, i32* %hi, align 4
  %cmp = icmp sle i32 %lo.val, %hi.val
  br i1 %cmp, label %loopbody, label %retneg

loopbody:
  %diff = sub i32 %hi.val, %lo.val
  %half = sdiv i32 %diff, 2
  %mid = add i32 %lo.val, %half
  %mid64 = zext i32 %mid to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid64
  %val = load i32, i32* %elem.ptr, align 4
  %islt = icmp slt i32 %val, %key
  br i1 %islt, label %case_lt, label %not_lt

case_lt:
  %mid.plus1 = add i32 %mid, 1
  store i32 %mid.plus1, i32* %lo, align 4
  br label %loop

not_lt:
  %isgt = icmp sgt i32 %val, %key
  br i1 %isgt, label %case_gt, label %case_eq

case_gt:
  %mid.minus1 = add i32 %mid, -1
  store i32 %mid.minus1, i32* %hi, align 4
  br label %loop

case_eq:
  ret i32 %mid

retneg:
  ret i32 -1
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %n = alloca i32, align 4
  %nk = alloca i64, align 8
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
  store i32 9, i32* %n, align 4
  store i64 3, i64* %nk, align 8
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.val = load i64, i64* %i, align 8
  %nk.val = load i64, i64* %nk, align 8
  %cond = icmp ult i64 %i.val, %nk.val
  br i1 %cond, label %body, label %done

body:
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.val
  %key = load i32, i32* %key.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %n.val = load i32, i32* %n, align 4
  %idx = call i32 @binary_search(i32* %arr.base, i32 %n.val, i32 %key)
  %lt0 = icmp slt i32 %idx, 0
  br i1 %lt0, label %notfound, label %found

found:
  %fmt1 = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %key, i32 %idx)
  br label %inc

notfound:
  %fmt2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %key)
  br label %inc

inc:
  %i.next0 = load i64, i64* %i, align 8
  %i.next1 = add i64 %i.next0, 1
  store i64 %i.next1, i64* %i, align 8
  br label %loop

done:
  ret i32 0
}