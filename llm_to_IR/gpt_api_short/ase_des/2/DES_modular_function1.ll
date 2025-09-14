; ModuleID = 'permute'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: permute ; Address: 0x1189
; Intent: Build a bit-gathered value from a 64-bit input using shift positions derived from (base - arr[i]) for count elements (confidence=0.84). Evidence: shr rdx, cl with cl = (base - arr[i]); accumulate via (res<<1)|bit and return.
; Preconditions: count >= 0; arr valid for count 32-bit elements; recommended count <= 64 to avoid high-bit loss.
; Postconditions: Returns a 64-bit value composed of count bits from value.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local i64 @permute(i64 %value, i32* %arr, i32 %count, i32 %base) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:                                            ; preds = %entry, %loop.inc
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %acc = phi i64 [ 0, %entry ], [ %acc.next, %loop.inc ]
  %cmp = icmp slt i32 %i, %count
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                            ; preds = %loop.cond
  %i64 = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %elem = load i32, i32* %elem.ptr, align 4
  %diff = sub i32 %base, %elem
  %diff64 = zext i32 %diff to i64
  %sh = and i64 %diff64, 63
  %shifted = lshr i64 %value, %sh
  %bit = and i64 %shifted, 1
  %acc.shl = shl i64 %acc, 1
  %acc.next = or i64 %acc.shl, %bit
  br label %loop.inc

loop.inc:                                             ; preds = %loop.body
  %i.next = add i32 %i, 1
  br label %loop.cond

exit:                                                 ; preds = %loop.cond
  ret i64 %acc
}