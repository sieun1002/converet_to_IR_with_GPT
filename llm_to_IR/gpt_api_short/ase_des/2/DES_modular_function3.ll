; ModuleID = 'sboxes_p'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sboxes_p ; Address: 0x123C
; Intent: DES S-box substitution on 48-bit input followed by P permutation (confidence=0.82). Evidence: accesses SBOX with 6-bit chunks and calls permute with P and 32-bit sizes.
; Preconditions: Input x has relevant data in its lower 48 bits.
; Postconditions: Returns permute(SBOX_substitution(x), P, 32, 32).

; Only the necessary external declarations:
declare i32 @permute(i64, i8*, i32, i32)

@SBOX = external dso_local global [512 x i8]
@P = external dso_local global [32 x i8]

define dso_local i32 @sboxes_p(i64 %x) local_unnamed_addr {
entry:
  br label %cond

cond:                                             ; preds = %body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %y = phi i32 [ 0, %entry ], [ %ynew, %body ]
  %cmp = icmp sle i32 %i, 7
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %cond
  %mul6 = mul nsw i32 %i, 6
  %s = sub nsw i32 42, %mul6
  %s64 = zext i32 %s to i64
  %shr = lshr i64 %x, %s64
  %bits64 = and i64 %shr, 63
  %bits = trunc i64 %bits64 to i32

  ; row = ((bits >> 4) & 2) | (bits & 1)
  %t1 = lshr i32 %bits, 4
  %t2 = and i32 %t1, 2
  %t3 = and i32 %bits, 1
  %row = or i32 %t2, %t3

  ; col = (bits >> 1) & 0xF
  %t4 = lshr i32 %bits, 1
  %col = and i32 %t4, 15

  %row_shl4 = shl i32 %row, 4
  %rc = add i32 %row_shl4, %col
  %i64mul = mul nsw i32 %i, 64
  %idx = add i32 %i64mul, %rc
  %idx64 = zext i32 %idx to i64
  %sbox.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %idx64
  %val8 = load i8, i8* %sbox.ptr, align 1
  %val32 = zext i8 %val8 to i32

  %yshift = shl i32 %y, 4
  %ynew = or i32 %yshift, %val32

  %i.next = add i32 %i, 1
  br label %cond

exit:                                             ; preds = %cond
  %yext = zext i32 %y to i64
  %P.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %ret = call i32 @permute(i64 %yext, i8* %P.ptr, i32 32, i32 32)
  ret i32 %ret
}