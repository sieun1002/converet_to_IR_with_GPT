; ModuleID = 'binary_search'
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @binary_search(i32* %arr, i64 %n, i32 %target) {
entry:
  %lo = alloca i64, align 8
  %hi = alloca i64, align 8
  %mid = alloca i64, align 8
  store i64 0, i64* %lo, align 8
  store i64 %n, i64* %hi, align 8
  br label %loop.cond

loop.cond:                                       ; preds = %sethi, %setlo, %entry
  %lo.v = load i64, i64* %lo, align 8
  %hi.v = load i64, i64* %hi, align 8
  %cmp = icmp ult i64 %lo.v, %hi.v
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                       ; preds = %loop.cond
  %hi2 = load i64, i64* %hi, align 8
  %lo2 = load i64, i64* %lo, align 8
  %diff = sub i64 %hi2, %lo2
  %half = lshr i64 %diff, 1
  %midcalc = add i64 %lo2, %half
  store i64 %midcalc, i64* %mid, align 8
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %midcalc
  %elem = load i32, i32* %elem.ptr, align 4
  %le = icmp sle i32 %target, %elem
  br i1 %le, label %sethi, label %setlo

setlo:                                           ; preds = %loop.body
  %mid.val = load i64, i64* %mid, align 8
  %mid.plus = add i64 %mid.val, 1
  store i64 %mid.plus, i64* %lo, align 8
  br label %loop.cond

sethi:                                           ; preds = %loop.body
  %mid.val2 = load i64, i64* %mid, align 8
  store i64 %mid.val2, i64* %hi, align 8
  br label %loop.cond

after.loop:                                      ; preds = %loop.cond
  %lo.end = load i64, i64* %lo, align 8
  %in.range = icmp ult i64 %lo.end, %n
  br i1 %in.range, label %checkval, label %retneg

checkval:                                        ; preds = %after.loop
  %elem.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %lo.end
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %eq = icmp eq i32 %target, %elem2
  br i1 %eq, label %retidx, label %retneg

retidx:                                          ; preds = %checkval
  %idx32 = trunc i64 %lo.end to i32
  ret i32 %idx32

retneg:                                          ; preds = %checkval, %after.loop
  ret i32 -1
}