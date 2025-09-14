; ModuleID = 'sboxes_p'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sboxes_p  ; Address: 0x123C
; Intent: DES S-box lookup followed by P permutation (confidence=0.95). Evidence: 8 iterations of 6-bit chunking into 4-bit via SBOX, then permute with P and lengths 32.
; Preconditions: Uses only the low 48 bits of %x. Expects external globals SBOX (512 bytes) and P (32 bytes) to be defined compatibly.

@SBOX = external constant [512 x i8]
@P = external constant [32 x i8]

declare i64 @permute(i64, i8*, i64, i64)

define dso_local i64 @sboxes_p(i64 %x) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:                                          ; preds = %entry, %loop.body
  %i = phi i32 [ 0, %entry ], [ %inext, %loop.body ]
  %acc = phi i32 [ 0, %entry ], [ %acc1, %loop.body ]
  %cmp = icmp sle i32 %i, 7
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                          ; preds = %loop.cond
  %mul6 = mul i32 %i, 6
  %shift32 = sub i32 42, %mul6
  %shift64 = zext i32 %shift32 to i64
  %sh = lshr i64 %x, %shift64
  %sh32 = trunc i64 %sh to i32
  %chunk6 = and i32 %sh32, 63
  %t1 = lshr i32 %chunk6, 4
  %t1a = and i32 %t1, 2
  %t2 = and i32 %chunk6, 1
  %row = or i32 %t1a, %t2
  %colpre = lshr i32 %chunk6, 1
  %col = and i32 %colpre, 15
  %rowsh = shl i32 %row, 4
  %idx = add i32 %rowsh, %col
  %blk = shl i32 %i, 6
  %off = add i32 %blk, %idx
  %off64 = zext i32 %off to i64
  %sbox.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %off64
  %sval8 = load i8, i8* %sbox.ptr, align 1
  %sval = zext i8 %sval8 to i32
  %accsh = shl i32 %acc, 4
  %acc1 = or i32 %accsh, %sval
  %inext = add i32 %i, 1
  br label %loop.cond

exit:                                               ; preds = %loop.cond
  %final_acc = phi i32 [ %acc, %loop.cond ]
  %val64 = zext i32 %final_acc to i64
  %Pptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %res = call i64 @permute(i64 %val64, i8* %Pptr, i64 32, i64 32)
  ret i64 %res
}