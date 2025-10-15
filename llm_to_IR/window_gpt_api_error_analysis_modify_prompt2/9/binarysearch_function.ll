; ModuleID = 'binary_search'
target triple = "x86_64-pc-windows-msvc"

define i64 @binary_search(i32* %arr, i64 %n, i32 %target) {
entry:
  %low = alloca i64, align 8
  %high = alloca i64, align 8
  %mid = alloca i64, align 8
  store i64 0, i64* %low, align 8
  store i64 %n, i64* %high, align 8
  br label %cond

cond:
  %low.load = load i64, i64* %low, align 8
  %high.load = load i64, i64* %high, align 8
  %cmp = icmp ult i64 %low.load, %high.load
  br i1 %cmp, label %body, label %after

body:
  %high2 = load i64, i64* %high, align 8
  %low2 = load i64, i64* %low, align 8
  %sub = sub i64 %high2, %low2
  %shr = lshr i64 %sub, 1
  %midcalc = add i64 %low2, %shr
  store i64 %midcalc, i64* %mid, align 8
  %midval = load i64, i64* %mid, align 8
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %midval
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp_tle = icmp sle i32 %target, %elem
  br i1 %cmp_tle, label %sethigh, label %setlow

sethigh:
  store i64 %midcalc, i64* %high, align 8
  br label %cond

setlow:
  %midplus1 = add i64 %midcalc, 1
  store i64 %midplus1, i64* %low, align 8
  br label %cond

after:
  %low3 = load i64, i64* %low, align 8
  %inrange = icmp ult i64 %low3, %n
  br i1 %inrange, label %checkeq, label %notfound

checkeq:
  %elem.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low3
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %eq = icmp eq i32 %target, %elem2
  br i1 %eq, label %found, label %notfound

found:
  ret i64 %low3

notfound:
  ret i64 4294967295
}