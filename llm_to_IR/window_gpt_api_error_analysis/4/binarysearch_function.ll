; ModuleID = 'binary_search'
source_filename = "binary_search.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %target) {
entry:
  %low = alloca i64, align 8
  %high = alloca i64, align 8
  store i64 0, i64* %low, align 8
  store i64 %n, i64* %high, align 8
  br label %loop

loop:
  %lowv = load i64, i64* %low, align 8
  %highv = load i64, i64* %high, align 8
  %cmp = icmp ult i64 %lowv, %highv
  br i1 %cmp, label %body, label %afterloop

body:
  %lowv2 = load i64, i64* %low, align 8
  %highv2 = load i64, i64* %high, align 8
  %diff = sub i64 %highv2, %lowv2
  %half = lshr i64 %diff, 1
  %mid = add i64 %lowv2, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %cmp_le = icmp sle i32 %target, %val
  br i1 %cmp_le, label %sethigh, label %setlow

setlow:
  %midp1 = add i64 %mid, 1
  store i64 %midp1, i64* %low, align 8
  br label %loop

sethigh:
  store i64 %mid, i64* %high, align 8
  br label %loop

afterloop:
  %lowend = load i64, i64* %low, align 8
  %cmp2 = icmp ult i64 %lowend, %n
  br i1 %cmp2, label %check, label %retneg

check:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %lowend
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %target, %val2
  br i1 %eq, label %retlow, label %retneg

retlow:
  ret i64 %lowend

retneg:
  ret i64 -1
}