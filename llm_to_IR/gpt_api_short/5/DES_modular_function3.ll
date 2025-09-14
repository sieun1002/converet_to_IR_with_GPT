; ModuleID = 'sboxes_p'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sboxes_p ; Address: 0x123C
; Intent: DES S-box substitution (8×6→8×4) followed by P-permutation (confidence=0.93). Evidence: 8 iterations over 6-bit chunks via shifts by 42-6*i; index into 8*64-byte SBOX; call permute with P and 32-bit sizes.
; Preconditions: Only the lower 48 bits of the input are used.
; Postconditions: Returns the 32-bit P-permuted S-box output, zero-extended to 64 bits.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
@SBOX = external global [512 x i8]
@P = external global [32 x i8]

declare i64 @permute(i64, i8*, i32, i32)

define dso_local i64 @sboxes_p(i64 %in48) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %body ]
  %cond = icmp sle i32 %i, 7
  br i1 %cond, label %body, label %done

body:                                             ; preds = %loop
  %mul6 = mul nsw i32 %i, 6
  %sh32 = sub nsw i32 42, %mul6
  %sh64 = zext i32 %sh32 to i64
  %shr = lshr i64 %in48, %sh64
  %chunk64 = and i64 %shr, 63
  %chunk32 = trunc i64 %chunk64 to i32
  %t1 = lshr i32 %chunk32, 4
  %row_hi = and i32 %t1, 2
  %row_lo = and i32 %chunk32, 1
  %row = or i32 %row_hi, %row_lo
  %t2 = lshr i32 %chunk32, 1
  %col = and i32 %t2, 15
  %row4 = shl i32 %row, 4
  %rc = add i32 %row4, %col
  %i64 = sext i32 %i to i64
  %i64sh6 = shl i64 %i64, 6
  %rc64 = zext i32 %rc to i64
  %sidx = add i64 %i64sh6, %rc64
  %sbox.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %sidx
  %sval8 = load i8, i8* %sbox.ptr, align 1
  %sval = zext i8 %sval8 to i32
  %acc.shl = shl i32 %acc, 4
  %acc.next = or i32 %acc.shl, %sval
  %i.next = add nsw i32 %i, 1
  br label %loop

done:                                             ; preds = %loop
  %acc.z = zext i32 %acc to i64
  %P.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %ret = call i64 @permute(i64 %acc.z, i8* %P.ptr, i32 32, i32 32)
  ret i64 %ret
}