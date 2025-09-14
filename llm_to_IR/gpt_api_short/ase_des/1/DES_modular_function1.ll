; ModuleID = 'permute'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: permute ; Address: 0x1189
; Intent: Build a 64-bit value by concatenating bits extracted from the input based on an index array (confidence=0.92). Evidence: shr rdx,cl; accumulator with shl/or per-iteration.
; Preconditions: arr has at least 'count' elements; 0 <= count <= 64; effective shift amounts are in 0..63.
; Postconditions: Returns the concatenation (in iteration order) of selected bits from 'value'.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i64 @permute(i64 %value, i32* %arr, i32 %count, i32 %base) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %acc = phi i64 [ 0, %entry ], [ %acc.next, %body ]
  %cmp = icmp slt i32 %i, %count
  br i1 %cmp, label %body, label %exit

body:
  %idx64 = sext i32 %i to i64
  %p = getelementptr inbounds i32, i32* %arr, i64 %idx64
  %x = load i32, i32* %p, align 4
  %delta = sub i32 %base, %x
  %delta.mask = and i32 %delta, 63
  %sh = zext i32 %delta.mask to i64
  %shifted = lshr i64 %value, %sh
  %bit = and i64 %shifted, 1
  %acc.shl = shl i64 %acc, 1
  %acc.next = or i64 %acc.shl, %bit
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:
  ret i64 %acc
}