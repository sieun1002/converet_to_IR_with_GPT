; ModuleID = 'min_index'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: min_index ; Address: 0x004013C0
; Intent: Find index of minimum signed 32-bit value among entries where flags[i]==0, or -1 if none (confidence=0.95). Evidence: initializes min to 0x7FFFFFFF, idx to -1; checks flags[i]!=0 to skip; updates when value < current min; returns idx.
; Preconditions: values and flags point to arrays of at least n i32 elements.
; Postconditions: Returns -1 if n<=0 or all flags nonzero.

; Only the necessary external declarations:

define dso_local i32 @min_index(i32* %values, i32* %flags, i32 %n) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %cont, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %minVal = phi i32 [ 2147483647, %entry ], [ %minVal.next, %cont ]
  %minIdx = phi i32 [ -1, %entry ], [ %minIdx.next, %cont ]
  %cmp.ge = icmp sge i32 %i, %n
  br i1 %cmp.ge, label %exit, label %body

body:                                             ; preds = %loop
  %i.sext = sext i32 %i to i64
  %flag.ptr = getelementptr inbounds i32, i32* %flags, i64 %i.sext
  %flag = load i32, i32* %flag.ptr, align 4
  %flag.nonzero = icmp ne i32 %flag, 0
  br i1 %flag.nonzero, label %cont, label %check

check:                                            ; preds = %body
  %val.ptr = getelementptr inbounds i32, i32* %values, i64 %i.sext
  %val = load i32, i32* %val.ptr, align 4
  %is.less = icmp slt i32 %val, %minVal
  br i1 %is.less, label %update, label %cont

update:                                           ; preds = %check
  br label %cont

cont:                                             ; preds = %update, %check, %body
  %minVal.next = phi i32 [ %minVal, %body ], [ %minVal, %check ], [ %val, %update ]
  %minIdx.next = phi i32 [ %minIdx, %body ], [ %minIdx, %check ], [ %i, %update ]
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 %minIdx
}