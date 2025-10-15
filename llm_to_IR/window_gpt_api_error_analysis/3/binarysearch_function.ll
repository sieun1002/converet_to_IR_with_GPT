; ModuleID = 'binary_search_module'
source_filename = "binary_search_module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  %low = alloca i64, align 8
  %high = alloca i64, align 8
  store i64 0, i64* %low, align 8
  store i64 %n, i64* %high, align 8
  br label %loop

loop:                                             ; preds = %sethigh, %setlow, %entry
  %lowv = load i64, i64* %low, align 8
  %highv = load i64, i64* %high, align 8
  %cmp = icmp ult i64 %lowv, %highv
  br i1 %cmp, label %body, label %afterloop

body:                                             ; preds = %loop
  %diff = sub i64 %highv, %lowv
  %half = lshr i64 %diff, 1
  %mid = add i64 %lowv, %half
  %gep = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %gep, align 4
  %le = icmp sle i32 %key, %val
  br i1 %le, label %sethigh, label %setlow

setlow:                                           ; preds = %body
  %midplus = add i64 %mid, 1
  store i64 %midplus, i64* %low, align 8
  br label %loop

sethigh:                                          ; preds = %body
  store i64 %mid, i64* %high, align 8
  br label %loop

afterloop:                                        ; preds = %loop
  %low2 = load i64, i64* %low, align 8
  %lt_n = icmp ult i64 %low2, %n
  br i1 %lt_n, label %checkval, label %retneg

checkval:                                         ; preds = %afterloop
  %eltptr = getelementptr inbounds i32, i32* %arr, i64 %low2
  %elt = load i32, i32* %eltptr, align 4
  %eq = icmp eq i32 %key, %elt
  br i1 %eq, label %retsucc, label %retneg

retsucc:                                          ; preds = %checkval
  ret i64 %low2

retneg:                                           ; preds = %checkval, %afterloop
  ret i64 4294967295
}