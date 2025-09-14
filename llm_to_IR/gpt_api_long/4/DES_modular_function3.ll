; ModuleID = 'sboxes_p'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sboxes_p  ; Address: 0x123C
; Intent: DES S-box substitution (8 groups of 6 bits) followed by P-permutation (confidence=0.92). Evidence: 6-bit chunking with row/column selection and 8x64 SBOX lookup; final permute with 32->32 table P.
; Preconditions: @SBOX is 512 bytes (8 S-boxes * 64 entries), @P is 32-byte permutation table. Input is a 64-bit value whose relevant 48 bits are processed in 8 groups of 6 bits.
; Postconditions: Returns permute(accumulated 32-bit S-box output, P, 32, 32) as 64-bit integer (lower 32 bits significant).

declare i64 @permute(i64, i8*, i32, i32)

@SBOX = external dso_local global [512 x i8]
@P = external dso_local global [32 x i8]

define dso_local i64 @sboxes_p(i64 %in) local_unnamed_addr {
entry:
  br label %cond

cond:                                             ; preds = %body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %body ]
  %cmp = icmp sle i32 %i, 7
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %cond
  %mul6 = mul nsw i32 %i, 6
  %shift32 = sub nsw i32 42, %mul6
  %shift64 = zext i32 %shift32 to i64
  %vshift = lshr i64 %in, %shift64
  %six = and i64 %vshift, 63
  %six32 = trunc i64 %six to i32
  %row_hi = lshr i32 %six32, 4
  %row_bits = and i32 %row_hi, 2
  %lowbit = and i32 %six32, 1
  %row = or i32 %row_bits, %lowbit
  %col_shift = lshr i32 %six32, 1
  %col = and i32 %col_shift, 15
  %row_shl = shl i32 %row, 4
  %idx = add i32 %row_shl, %col
  %idx64 = zext i32 %idx to i64
  %i64 = zext i32 %i to i64
  %base = mul i64 %i64, 64
  %off = add i64 %base, %idx64
  %sbox.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %off
  %sbox.byte = load i8, i8* %sbox.ptr, align 1
  %sval = zext i8 %sbox.byte to i32
  %acc.shl = shl i32 %acc, 4
  %acc.next = or i32 %acc.shl, %sval
  %i.next = add nsw i32 %i, 1
  br label %cond

exit:                                             ; preds = %cond
  %acc64 = zext i32 %acc to i64
  %Pptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %ret = call i64 @permute(i64 %acc64, i8* %Pptr, i32 32, i32 32)
  ret i64 %ret
}