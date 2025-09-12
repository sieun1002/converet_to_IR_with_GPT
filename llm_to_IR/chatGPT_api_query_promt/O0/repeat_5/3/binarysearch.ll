; ModuleID = 'binary_search'
source_filename = "binary_search"
target triple = "x86_64-unknown-linux-gnu"

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %cont, %entry
  %low.phi = phi i64 [ 0, %entry ], [ %low.next, %cont ]
  %high.phi = phi i64 [ %n, %entry ], [ %high.next, %cont ]
  %cmp = icmp ult i64 %low.phi, %high.phi
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %sub = sub i64 %high.phi, %low.phi
  %shr = lshr i64 %sub, 1
  %mid = add i64 %low.phi, %shr
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %key, %val
  br i1 %le, label %take_left, label %take_right

take_left:                                        ; preds = %body
  %low.next.left = %low.phi
  %high.next.left = %mid
  br label %cont

take_right:                                       ; preds = %body
  %mid.plus1 = add i64 %mid, 1
  %low.next.right = %mid.plus1
  %high.next.right = %high.phi
  br label %cont

cont:                                             ; preds = %take_right, %take_left
  %low.next = phi i64 [ %low.next.left, %take_left ], [ %low.next.right, %take_right ]
  %high.next = phi i64 [ %high.next.left, %take_left ], [ %high.next.right, %take_right ]
  br label %loop

after:                                            ; preds = %loop
  %low.final = phi i64 [ %low.phi, %loop ]
  %inrange = icmp ult i64 %low.final, %n
  br i1 %inrange, label %check, label %retneg

check:                                            ; preds = %after
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low.final
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %val2, %key
  br i1 %eq, label %retidx, label %retneg

retidx:                                           ; preds = %check
  ret i64 %low.final

retneg:                                           ; preds = %check, %after
  ret i64 -1
}