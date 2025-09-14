; ModuleID = 'sboxes_p'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sboxes_p  ; Address: 0x123C
; Intent: DES S-box substitution over 48-bit input followed by 32-bit P-permutation (confidence=0.95). Evidence: 8×6-bit extraction with 64-byte stride into SBOX, then pack nibbles and call permute with P and (32,32)
; Preconditions: Lower 48 bits of %x are significant; @SBOX has 8×64 entries (512 bytes); @P has 32 entries.
; Postconditions: Returns 32-bit P-permuted value in low bits of i64.

; Only the needed extern declarations:
declare dso_local i64 @permute(i64, i8*, i32, i32) local_unnamed_addr

@SBOX = external global [512 x i8]
@P = external global [32 x i8]

define dso_local i64 @sboxes_p(i64 %x) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %loop
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %loop ]
  %i.mul6 = mul nsw i32 %i, 6
  %shift = sub nsw i32 42, %i.mul6
  %shift64 = zext i32 %shift to i64
  %shr = lshr i64 %x, %shift64
  %bits6 = and i64 %shr, 63
  %bits6_i32 = trunc i64 %bits6 to i32
  %b_shr4 = lshr i32 %bits6_i32, 4
  %row_a = and i32 %b_shr4, 2
  %b_and1 = and i32 %bits6_i32, 1
  %row = or i32 %row_a, %b_and1
  %b_shr1 = lshr i32 %bits6_i32, 1
  %col = and i32 %b_shr1, 15
  %row_shl4 = shl i32 %row, 4
  %index = add nuw nsw i32 %row_shl4, %col
  %i64 = sext i32 %i to i64
  %baseoff = shl nsw i64 %i64, 6
  %index64 = zext i32 %index to i64
  %totaloff = add i64 %baseoff, %index64
  %sbox_base = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 0
  %elem_ptr = getelementptr inbounds i8, i8* %sbox_base, i64 %totaloff
  %val8 = load i8, i8* %elem_ptr, align 1
  %val32 = zext i8 %val8 to i32
  %acc_shl4 = shl i32 %acc, 4
  %acc.next = or i32 %acc_shl4, %val32
  %i.next = add nsw i32 %i, 1
  %cond = icmp sle i32 %i.next, 7
  br i1 %cond, label %loop, label %after

after:                                            ; preds = %loop
  %acc64 = zext i32 %acc.next to i64
  %p_ptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %ret = call i64 @permute(i64 %acc64, i8* %p_ptr, i32 32, i32 32)
  ret i64 %ret
}