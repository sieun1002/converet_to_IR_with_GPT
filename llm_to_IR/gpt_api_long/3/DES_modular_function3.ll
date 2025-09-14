; ModuleID = 'sboxes_p'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sboxes_p  ; Address: 0x123C
; Intent: DES S-box substitution on 48-bit input followed by P permutation (confidence=0.95). Evidence: 8 iterations extracting 6-bit chunks with DES-style row/col indexing, final call permute(..., P, 32, 32).
; Preconditions: Only the low 48 bits of the input are used; higher bits are ignored.
; Postconditions: Returns 32-bit result (in low bits of i64) equal to P-permutation of concatenated S-box outputs.

@SBOX = external global [512 x i8], align 1
@P = external global [32 x i8], align 1

declare dso_local i64 @permute(i64, i8*, i32, i32)

define dso_local i64 @sboxes_p(i64 %x) local_unnamed_addr {
entry:
  br label %loop.header

loop.header:                                      ; preds = %entry, %loop.body
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %sum = phi i32 [ 0, %entry ], [ %sum.next, %loop.body ]
  %cmp = icmp sle i32 %i, 7
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.header
  %mul6 = mul nsw i32 %i, 6
  %shift32 = sub nsw i32 42, %mul6
  %shift64 = zext i32 %shift32 to i64
  %shr = lshr i64 %x, %shift64
  %v6 = and i64 %shr, 63
  %v6_i32 = trunc i64 %v6 to i32
  %row_tmp = lshr i32 %v6_i32, 4
  %row_hi = and i32 %row_tmp, 2
  %row_lo = and i32 %v6_i32, 1
  %row = or i32 %row_hi, %row_lo
  %col_tmp = lshr i32 %v6_i32, 1
  %col = and i32 %col_tmp, 15
  %row_shl = shl i32 %row, 4
  %idx_small = add i32 %row_shl, %col
  %idx_small64 = zext i32 %idx_small to i64
  %i64 = zext i32 %i to i64
  %boxoff_base = shl i64 %i64, 6
  %idx_total = add i64 %boxoff_base, %idx_small64
  %sbox.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %idx_total
  %sbox.val.i8 = load i8, i8* %sbox.ptr, align 1
  %sbox.val.i32 = zext i8 %sbox.val.i8 to i32
  %sum_shl = shl i32 %sum, 4
  %sum.next = or i32 %sum_shl, %sbox.val.i32
  %i.next = add nsw i32 %i, 1
  br label %loop.header

exit:                                             ; preds = %loop.header
  %sum64 = zext i32 %sum to i64
  %P.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %res = call i64 @permute(i64 %sum64, i8* %P.ptr, i32 32, i32 32)
  ret i64 %res
}