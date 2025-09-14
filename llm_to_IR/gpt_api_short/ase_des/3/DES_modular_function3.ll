; ModuleID = 'sboxes_p'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sboxes_p ; Address: 0x000000000000123C
; Intent: DES S-box substitution followed by P-permutation (confidence=0.86). Evidence: 8× 6-bit extraction and 8×64 SBOX lookup; final permute over 32 bits using table P.
; Preconditions: Input carries 48 relevant bits positioned to be read at shifts 42−6*i for i=0..7.
; Postconditions: Returns the 32-bit S-box output after P permutation (in the low 32 bits of the i64 result).

; Only the necessary external declarations:
declare i64 @permute(i64, i8*, i32, i32)

@SBOX = external global [512 x i8], align 1
@P = external global [32 x i8], align 1

define dso_local i64 @sboxes_p(i64 %x) local_unnamed_addr {
entry:
  br label %cond

cond:                                             ; preds = %body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %body ]
  %cmp = icmp sle i32 %i, 7
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %cond
  %i.mul6 = mul nsw i32 %i, 6
  %shift = sub nsw i32 42, %i.mul6
  %shift64 = zext i32 %shift to i64
  %shr = lshr i64 %x, %shift64
  %six64 = and i64 %shr, 63
  %six = trunc i64 %six64 to i32
  %b5 = and i32 %six, 32
  %b5s = lshr i32 %b5, 4
  %b0 = and i32 %six, 1
  %row = or i32 %b5s, %b0
  %colshift = lshr i32 %six, 1
  %col = and i32 %colshift, 15
  %row16 = shl i32 %row, 4
  %idx = add i32 %row16, %col
  %i64 = zext i32 %i to i64
  %base = mul nuw nsw i64 %i64, 64
  %idx64 = zext i32 %idx to i64
  %off = add i64 %base, %idx64
  %sbox.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %off
  %sval8 = load i8, i8* %sbox.ptr, align 1
  %sval32 = zext i8 %sval8 to i32
  %accshift = shl i32 %acc, 4
  %acc.next = or i32 %accshift, %sval32
  %i.next = add nsw i32 %i, 1
  br label %cond

exit:                                             ; preds = %cond
  %acc64 = zext i32 %acc to i64
  %P.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %res = call i64 @permute(i64 %acc64, i8* %P.ptr, i32 32, i32 32)
  ret i64 %res
}