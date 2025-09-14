; ModuleID = 'sboxes_p'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sboxes_p ; Address: 0x123C
; Intent: DES S-box substitution of 8x6-bit chunks then P-permutation (confidence=0.95). Evidence: indexing SBOX with i*64+(row<<4|col), final permute with table P of length 32.

; Preconditions: Argument holds 48 relevant bits packed in a 64-bit value.
; Postconditions: Returns 32-bit substituted result permuted by P in a 64-bit return (low 32 bits significant).

; Only the necessary external declarations:
declare dso_local i64 @permute(i64, i8*, i32, i32)

@SBOX = external dso_local constant [512 x i8], align 1
@P = external dso_local constant [32 x i8], align 1

define dso_local i64 @sboxes_p(i64 %x) local_unnamed_addr {
entry:
  br label %test

test:                                             ; loop header
  %i = phi i32 [ 0, %entry ], [ %iNext, %body ]
  %acc = phi i32 [ 0, %entry ], [ %accNew, %body ]
  %cond = icmp sle i32 %i, 7
  br i1 %cond, label %body, label %after

body:
  ; shift_amount = 42 - 6*i
  %mul6 = mul nsw i32 %i, 6
  %sa32 = sub nsw i32 42, %mul6
  %sa64 = zext i32 %sa32 to i64

  ; chunk6 = (x >> shift_amount) & 0x3F
  %shr = lshr i64 %x, %sa64
  %chunk6_64 = and i64 %shr, 63
  %chunk6 = trunc i64 %chunk6_64 to i32

  ; row = ((chunk6 >> 4) & 2) | (chunk6 & 1)
  %t1 = lshr i32 %chunk6, 4
  %t2 = and i32 %t1, 2
  %b0 = and i32 %chunk6, 1
  %row = or i32 %t2, %b0

  ; col = (chunk6 >> 1) & 0xF
  %csh = lshr i32 %chunk6, 1
  %col = and i32 %csh, 15

  ; sindex = (row<<4) + col
  %rowsh = shl i32 %row, 4
  %sindex = add i32 %col, %rowsh

  ; offset = i*64 + sindex
  %i64 = zext i32 %i to i64
  %off_i = mul nuw nsw i64 %i64, 64
  %sindex64 = zext i32 %sindex to i64
  %offset = add i64 %off_i, %sindex64

  ; load SBOX[offset]
  %sboxptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %offset
  %sval.i8 = load i8, i8* %sboxptr, align 1
  %sval = zext i8 %sval.i8 to i32

  ; acc = (acc<<4) | sval
  %accsh = shl i32 %acc, 4
  %accNew = or i32 %accsh, %sval

  ; i++
  %iNext = add i32 %i, 1
  br label %test

after:
  %acc64 = zext i32 %acc to i64
  %Pptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %res = call i64 @permute(i64 %acc64, i8* %Pptr, i32 32, i32 32)
  ret i64 %res
}