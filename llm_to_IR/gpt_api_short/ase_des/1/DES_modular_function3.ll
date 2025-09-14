; ModuleID = 'sboxes_p'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sboxes_p ; Address: 0x000000000000123C
; Intent: DES S-box substitution over 8 6-bit chunks followed by P-permutation (confidence=0.90). Evidence: 6-bit extraction, row/col mapping, SBOX index (i<<6)+idx, final call permute(..., P, 32, 32)
; Preconditions: None
; Postconditions: Returns permuted 32-bit value zero-extended to 64 bits

; Only the necessary external declarations:
declare i64 @permute(i64, i8*, i32, i32) local_unnamed_addr

@SBOX = external dso_local global [512 x i8], align 1
@P = external dso_local global [32 x i8], align 1

define dso_local i64 @sboxes_p(i64 %in) local_unnamed_addr {
entry:
  br label %check

check:                                            ; preds = %loop, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %loop ]
  %cmp = icmp sle i32 %i, 7
  br i1 %cmp, label %loop, label %end

loop:                                             ; preds = %check
  %mul6 = mul nsw i32 %i, 6
  %shift = sub nsw i32 42, %mul6
  %shift64 = zext i32 %shift to i64
  %shr = lshr i64 %in, %shift64
  %chunk64 = and i64 %shr, 63
  %chunk = trunc i64 %chunk64 to i32

  %rowhi = lshr i32 %chunk, 4
  %rowhi2 = and i32 %rowhi, 2
  %rowlo = and i32 %chunk, 1
  %row = or i32 %rowhi2, %rowlo

  %colshift = lshr i32 %chunk, 1
  %col = and i32 %colshift, 15

  %row4 = shl i32 %row, 4
  %idx = add i32 %row4, %col

  %i64 = zext i32 %i to i64
  %baseOff = shl i64 %i64, 6
  %idx64 = zext i32 %idx to i64
  %sboff = add i64 %baseOff, %idx64

  %sboxptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %sboff
  %sval8 = load i8, i8* %sboxptr, align 1
  %sval = zext i8 %sval8 to i32

  %accsh = shl i32 %acc, 4
  %acc.next = or i32 %accsh, %sval

  %i.next = add nuw nsw i32 %i, 1
  br label %check

end:                                              ; preds = %check
  %acc.zext = zext i32 %acc to i64
  %Pptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %res = call i64 @permute(i64 %acc.zext, i8* %Pptr, i32 32, i32 32)
  ret i64 %res
}