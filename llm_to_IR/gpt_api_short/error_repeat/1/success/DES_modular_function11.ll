; ModuleID = 'permute'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: permute ; Address: 0x1189
; Intent: Build a bitstring by selecting bits from a 64-bit value according to (base - positions[i]) for i in [0,count), accumulating left-to-right (confidence=0.90). Evidence: lshr of first arg by (ecx - arr[i]) & 63 and fold into accumulator via shift-left/or; loop over rsi[i], i<edx.
; Preconditions: None strictly, but semantics mirror x86-64: shift amounts are effectively masked to 0..63.
; Postconditions: Returns the accumulated 64-bit value; if count <= 0, returns 0.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i64 @permute(i64 %val, i32* %positions, i32 %count, i32 %base) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %do, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %do ]
  %acc = phi i64 [ 0, %entry ], [ %acc.next, %do ]
  %cmp = icmp slt i32 %i, %count
  br i1 %cmp, label %do, label %exit

do:                                               ; preds = %loop
  %idx64 = sext i32 %i to i64
  %pos.ptr = getelementptr inbounds i32, i32* %positions, i64 %idx64
  %pos = load i32, i32* %pos.ptr, align 4
  %shift32 = sub i32 %base, %pos
  %shiftMasked32 = and i32 %shift32, 63
  %shiftMasked64 = zext i32 %shiftMasked32 to i64
  %shifted = lshr i64 %val, %shiftMasked64
  %bit = and i64 %shifted, 1
  %acc.shl = shl i64 %acc, 1
  %acc.next = or i64 %acc.shl, %bit
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i64 %acc
}