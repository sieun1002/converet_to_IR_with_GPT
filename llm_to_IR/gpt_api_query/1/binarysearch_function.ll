; LLVM IR for: binary_search
; Assumed signature: i64 binary_search(i32* base, i64 n, i32 key)

define i64 @binary_search(i32* %base, i64 %n, i32 %key) {
entry:
  %lo = alloca i64, align 8
  %hi = alloca i64, align 8
  store i64 0, i64* %lo, align 8
  store i64 %n, i64* %hi, align 8
  br label %loop

loop:                                             ; preds = %gt_else, %gt_then, %entry
  %lo.v = load i64, i64* %lo, align 8
  %hi.v = load i64, i64* %hi, align 8
  %cmp = icmp ult i64 %lo.v, %hi.v
  br i1 %cmp, label %body, label %after_loop

body:                                             ; preds = %loop
  %diff = sub i64 %hi.v, %lo.v
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo.v, %half
  %ptr = getelementptr inbounds i32, i32* %base, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %gt = icmp sgt i32 %key, %val
  br i1 %gt, label %gt_then, label %gt_else

gt_then:                                          ; preds = %body
  %midp1 = add i64 %mid, 1
  store i64 %midp1, i64* %lo, align 8
  br label %loop

gt_else:                                          ; preds = %body
  store i64 %mid, i64* %hi, align 8
  br label %loop

after_loop:                                       ; preds = %loop
  %lo2 = load i64, i64* %lo, align 8
  %inbounds = icmp ult i64 %lo2, %n
  br i1 %inbounds, label %check_val, label %ret_neg1

check_val:                                        ; preds = %after_loop
  %ptr2 = getelementptr inbounds i32, i32* %base, i64 %lo2
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret_lo, label %ret_neg1

ret_lo:                                           ; preds = %check_val
  ret i64 %lo2

ret_neg1:                                         ; preds = %check_val, %after_loop
  ret i64 -1
}