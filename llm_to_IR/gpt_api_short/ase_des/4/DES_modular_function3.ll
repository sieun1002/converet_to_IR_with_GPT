; ModuleID = 'sboxes_p'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sboxes_p ; Address: 0x123C
; Intent: DES S-box layer followed by P permutation (confidence=0.93). Evidence: 8 iterations extracting 6-bit chunks via shifts by (42-6*i) with 0x3F mask; accumulation of 8 4-bit S-box outputs then permute via table P with 32/32.
; Preconditions: Only low 48 bits of input are used.
; Postconditions: Returns permuted 32-bit result (zero-extended in i64) from S-box layer.

@SBOX = external global [512 x i8]
@P = external global [32 x i8]

declare i64 @permute(i64, i8*, i32, i32)

define dso_local i64 @sboxes_p(i64 %in) local_unnamed_addr {
entry:
  br label %cond

cond:                                             ; preds = %body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %body ]
  %cmp = icmp sle i32 %i, 7
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %cond
  %i.zext = zext i32 %i to i64
  %mul6 = mul nuw nsw i64 %i.zext, 6
  %shiftamt = sub nsw i64 42, %mul6
  %shr = lshr i64 %in, %shiftamt
  %masked = and i64 %shr, 63
  %v32 = trunc i64 %masked to i32
  %t1 = lshr i32 %v32, 4
  %t2 = and i32 %t1, 2
  %t3 = and i32 %v32, 1
  %row = or i32 %t2, %t3
  %col.pre = lshr i32 %v32, 1
  %col = and i32 %col.pre, 15
  %row.shl = shl i32 %row, 4
  %idx = add i32 %col, %row.shl
  %idx64 = zext i32 %idx to i64
  %box_off = shl i64 %i.zext, 6
  %off = add i64 %box_off, %idx64
  %sbox.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %off
  %sbyte = load i8, i8* %sbox.ptr, align 1
  %s32 = zext i8 to i32
  %acc.shl = shl i32 %acc, 4
  %acc.next = or i32 %acc.shl, %s32
  %i.next = add i32 %i, 1
  br label %cond

exit:                                             ; preds = %cond
  %acc64 = zext i32 %acc to i64
  %P.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %call = call i64 @permute(i64 %acc64, i8* %P.ptr, i32 32, i32 32)
  ret i64 %call
}