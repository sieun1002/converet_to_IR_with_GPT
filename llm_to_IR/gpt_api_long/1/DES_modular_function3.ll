; ModuleID = 'sboxes_p'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: sboxes_p  ; Address: 0x123C
; Intent: DES S-box substitution on 48-bit input then P-permutation (confidence=0.95). Evidence: 8 blocks of 6-bit extraction with SBOX[block*64 + row*16+col], followed by permute with P and 32->32 sizes.
; Preconditions: %in48 uses only lower 48 bits. @SBOX is 8*64 bytes laid out as 8 S-boxes of 64 entries. @P is a 32-entry permutation table.
; Postconditions: Returns 32-bit value (zero-extended to i64) after S-boxes and P-permutation.

@SBOX = external global [512 x i8]
@P = external global [32 x i8]

declare i64 @permute(i64, i8*, i32, i32)

define dso_local i64 @sboxes_p(i64 %in48) local_unnamed_addr {
entry:
  br label %loop.header

loop.header:                                      ; preds = %loop.body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %acc = phi i32 [ 0, %entry ], [ %acc.or, %loop.body ]
  %cmp = icmp sle i32 %i, 7
  br i1 %cmp, label %loop.body, label %after

loop.body:                                        ; preds = %loop.header
  %mul6 = mul i32 %i, 6
  %shift32 = sub i32 42, %mul6
  %shift64 = zext i32 %shift32 to i64
  %shr = lshr i64 %in48, %shift64
  %bits6_64 = and i64 %shr, 63
  %bits6 = trunc i64 %bits6_64 to i32
  %t1 = lshr i32 %bits6, 4
  %t1and = and i32 %t1, 2
  %t2 = and i32 %bits6, 1
  %row = or i32 %t1and, %t2
  %colshift = lshr i32 %bits6, 1
  %col = and i32 %colshift, 15
  %rowshl = shl i32 %row, 4
  %index = add i32 %col, %rowshl
  %i64 = sext i32 %i to i64
  %off_i = shl i64 %i64, 6
  %index64 = zext i32 %index to i64
  %offset = add i64 %off_i, %index64
  %sbox.base = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 0
  %sbox.ptr = getelementptr inbounds i8, i8* %sbox.base, i64 %offset
  %sval8 = load i8, i8* %sbox.ptr, align 1
  %sval32 = zext i8 %sval8 to i32
  %acc.shl = shl i32 %acc, 4
  %acc.or = or i32 %acc.shl, %sval32
  %i.next = add i32 %i, 1
  br label %loop.header

after:                                            ; preds = %loop.header
  %acc.zext = zext i32 %acc to i64
  %P.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %res = call i64 @permute(i64 %acc.zext, i8* %P.ptr, i32 32, i32 32)
  ret i64 %res
}