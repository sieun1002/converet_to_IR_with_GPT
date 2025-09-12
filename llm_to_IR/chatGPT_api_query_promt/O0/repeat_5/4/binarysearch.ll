; ModuleID = 'binary_search_module'
source_filename = "binary_search.c"
target triple = "x86_64-unknown-linux-gnu"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  %low = alloca i64, align 8
  %high = alloca i64, align 8
  %mid = alloca i64, align 8
  store i64 0, i64* %low, align 8
  store i64 %n, i64* %high, align 8
  br label %loop.cond

loop.body:                                        ; preds = %loop.cond
  %low.val = load i64, i64* %low, align 8
  %high.val = load i64, i64* %high, align 8
  %diff = sub i64 %high.val, %low.val
  %half = lshr i64 %diff, 1
  %midval = add i64 %low.val, %half
  store i64 %midval, i64* %mid, align 8
  %mid.idx = load i64, i64* %mid, align 8
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid.idx
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp_le = icmp sle i32 %key, %elem
  br i1 %cmp_le, label %set.high, label %set.low

set.low:                                          ; preds = %loop.body
  %mid.plus1 = add i64 %mid.idx, 1
  store i64 %mid.plus1, i64* %low, align 8
  br label %loop.cond

set.high:                                         ; preds = %loop.body
  store i64 %mid.idx, i64* %high, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %set.high, %set.low, %entry
  %low.c = load i64, i64* %low, align 8
  %high.c = load i64, i64* %high, align 8
  %cond = icmp ult i64 %low.c, %high.c
  br i1 %cond, label %loop.body, label %after.loop

after.loop:                                       ; preds = %loop.cond
  %low.fin = load i64, i64* %low, align 8
  %in.range = icmp ult i64 %low.fin, %n
  br i1 %in.range, label %check.eq, label %ret.notfound

check.eq:                                         ; preds = %after.loop
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %low.fin
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %key, %val
  br i1 %eq, label %ret.index, label %ret.notfound

ret.index:                                        ; preds = %check.eq
  ret i64 %low.fin

ret.notfound:                                     ; preds = %check.eq, %after.loop
  ret i64 -1
}