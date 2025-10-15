; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

define i32 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %cont, %entry
  %lo = phi i64 [ 0, %entry ], [ %lo.next, %cont ]
  %hi = phi i64 [ %n, %entry ], [ %hi.next, %cont ]
  %cmp = icmp ult i64 %lo, %hi
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %sub = sub i64 %hi, %lo
  %half = lshr i64 %sub, 1
  %mid = add i64 %lo, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %cmp2 = icmp sle i32 %key, %val
  br i1 %cmp2, label %sethi, label %setlo

sethi:                                            ; preds = %body
  br label %cont

setlo:                                            ; preds = %body
  %midplus = add i64 %mid, 1
  br label %cont

cont:                                             ; preds = %setlo, %sethi
  %lo.next = phi i64 [ %lo, %sethi ], [ %midplus, %setlo ]
  %hi.next = phi i64 [ %mid, %sethi ], [ %hi, %setlo ]
  br label %loop

after:                                            ; preds = %loop
  %cmp3 = icmp ult i64 %lo, %n
  br i1 %cmp3, label %check, label %ret_fail

check:                                            ; preds = %after
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %lo
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret_ok, label %ret_fail

ret_ok:                                           ; preds = %check
  %retv = trunc i64 %lo to i32
  ret i32 %retv

ret_fail:                                         ; preds = %check, %after
  ret i32 -1
}