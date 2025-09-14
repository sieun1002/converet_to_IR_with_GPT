; ModuleID = 'sboxes_p'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sboxes_p  ; Address: 0x123C
; Intent: DES S-box substitution (8x 6->4) then P permutation (confidence=0.92). Evidence: 8 iterations of 6-bit chunks (mask 0x3F) indexed into SBOX with i<<6; final call to permute with table P and 32-bit sizes.
; Preconditions: Only low 48 bits of input are used; @SBOX is at least 512 bytes (8*64); @P is at least 32 bytes.
; Postconditions: Returns 32-bit result of S-boxes and P-permutation zero-extended to i64.

@SBOX = external unnamed_addr constant [512 x i8]
@P = external unnamed_addr constant [32 x i8]

declare i64 @permute(i64, i8*, i32, i32)

define dso_local i64 @sboxes_p(i64 %in) local_unnamed_addr {
entry:
  br label %test

test:                                             ; preds = %entry, %body
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %body ]
  %cmp = icmp sle i32 %i, 7
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %test
  %i.ext64 = zext i32 %i to i64
  %i.mul6 = mul nuw nsw i64 %i.ext64, 6
  %shift = sub nsw i64 42, %i.mul6
  %shv = lshr i64 %in, %shift
  %chunk6 = and i64 %shv, 63
  %chunk6.i32 = trunc i64 %chunk6 to i32

  %tmp_sr4 = lshr i32 %chunk6.i32, 4
  %row_high = and i32 %tmp_sr4, 2
  %row_low = and i32 %chunk6.i32, 1
  %row = or i32 %row_high, %row_low

  %tmp_sr1 = lshr i32 %chunk6.i32, 1
  %col = and i32 %tmp_sr1, 15

  %row_shl4 = shl i32 %row, 4
  %index = add i32 %row_shl4, %col
  %index64 = sext i32 %index to i64

  %i.sext = sext i32 %i to i64
  %base = shl i64 %i.sext, 6
  %offset = add i64 %base, %index64

  %sbox.gep = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %offset
  %sbyte = load i8, i8* %sbox.gep, align 1
  %sval = zext i8 %sbyte to i32

  %acc.shl = shl i32 %acc, 4
  %acc.next = or i32 %acc.shl, %sval

  %i.next = add i32 %i, 1
  br label %test

after:                                            ; preds = %test
  %acc64 = zext i32 %acc to i64
  %P.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %res = call i64 @permute(i64 %acc64, i8* %P.ptr, i32 32, i32 32)
  ret i64 %res
}