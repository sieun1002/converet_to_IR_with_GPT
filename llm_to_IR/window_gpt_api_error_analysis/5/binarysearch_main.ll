; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

declare dllimport i32 @printf(i8*, ...)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local i32 @binary_search(i32* nocapture %arr, i64 %n, i32 %key) {
entry:
  %lo = alloca i64, align 8
  %hi = alloca i64, align 8
  store i64 0, i64* %lo, align 8
  %nminus1 = add i64 %n, -1
  store i64 %nminus1, i64* %hi, align 8
  br label %loop

loop:                                             ; preds = %setlo, %sethi, %entry
  %loV = load i64, i64* %lo, align 8
  %hiV = load i64, i64* %hi, align 8
  %cmp = icmp sle i64 %loV, %hiV
  br i1 %cmp, label %body, label %notfound

body:                                             ; preds = %loop
  %sum = add i64 %loV, %hiV
  %mid = ashr i64 %sum, 1
  %eltptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %eltptr, align 4
  %eq = icmp eq i32 %key, %val
  br i1 %eq, label %found, label %cont

found:                                            ; preds = %body
  %mid32 = trunc i64 %mid to i32
  ret i32 %mid32

cont:                                             ; preds = %body
  %lt = icmp slt i32 %key, %val
  br i1 %lt, label %sethi, label %setlo

sethi:                                            ; preds = %cont
  %midm1 = add i64 %mid, -1
  store i64 %midm1, i64* %hi, align 8
  br label %loop

setlo:                                            ; preds = %cont
  %midp1 = add i64 %mid, 1
  store i64 %midp1, i64* %lo, align 8
  br label %loop

notfound:                                         ; preds = %loop
  ret i32 -1
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %i = alloca i64, align 8
  store [9 x i32] [i32 -5, i32 -1, i32 0, i32 2, i32 2, i32 3, i32 7, i32 9, i32 12], [9 x i32]* %arr, align 16
  store [3 x i32] [i32 2, i32 5, i32 -5], [3 x i32]* %keys, align 16
  store i64 0, i64* %i, align 8
  br label %loop

loop:                                             ; preds = %inc, %entry
  %iv = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %iv, 3
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %iv
  %key = load i32, i32* %keyptr, align 4
  %arrptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %res = call i32 @binary_search(i32* %arrptr, i64 9, i32 %key)
  %neg = icmp slt i32 %res, 0
  br i1 %neg, label %notfound, label %foundprint

foundprint:                                       ; preds = %body
  %fmtptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %key, i32 %res)
  br label %inc

notfound:                                         ; preds = %body
  %fmtptr2 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmtptr2, i32 %key)
  br label %inc

inc:                                              ; preds = %notfound, %foundprint
  %iv2 = load i64, i64* %i, align 8
  %ivp1 = add i64 %iv2, 1
  store i64 %ivp1, i64* %i, align 8
  br label %loop

done:                                             ; preds = %loop
  ret i32 0
}