; ModuleID = 'binary_search_module'
source_filename = "binary_search.ll"
target triple = "x86_64-pc-windows-msvc"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  %lo = alloca i64, align 8
  %hi = alloca i64, align 8
  store i64 0, i64* %lo, align 8
  store i64 %n, i64* %hi, align 8
  br label %loop

loop:
  %lo.v = load i64, i64* %lo, align 8
  %hi.v = load i64, i64* %hi, align 8
  %cmp = icmp ult i64 %lo.v, %hi.v
  br i1 %cmp, label %body, label %after_loop

body:
  %diff = sub i64 %hi.v, %lo.v
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo.v, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %cmp2 = icmp sle i32 %key, %val
  br i1 %cmp2, label %set_hi, label %set_lo

set_hi:
  store i64 %mid, i64* %hi, align 8
  br label %loop

set_lo:
  %mid.plus1 = add i64 %mid, 1
  store i64 %mid.plus1, i64* %lo, align 8
  br label %loop

after_loop:
  %lo2 = load i64, i64* %lo, align 8
  %cmp3 = icmp ult i64 %lo2, %n
  br i1 %cmp3, label %check_eq, label %ret_notfound

check_eq:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %lo2
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret_found, label %ret_notfound

ret_found:
  ret i64 %lo2

ret_notfound:
  ret i64 4294967295
}