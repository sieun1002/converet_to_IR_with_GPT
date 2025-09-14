; ModuleID = 'sboxes_p.ll'
target triple = "x86_64-pc-linux-gnu"

@SBOX = external global [512 x i8], align 1
@P = external global [32 x i8], align 1

declare i64 @permute(i64, i8*, i32, i32)

define i64 @sboxes_p(i64 %in) {
entry:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.inc ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %loop.inc ]
  %cmp = icmp sle i32 %i, 7
  br i1 %cmp, label %loop.body, label %after

loop.body:
  ; shift = 42 - 6*i
  %mul = mul nsw i32 %i, 6
  %shift32 = sub nsw i32 42, %mul
  %shift = zext i32 %shift32 to i64

  ; chunk = ((in >> shift) & 0x3f)
  %shr = lshr i64 %in, %shift
  %chunk64 = and i64 %shr, 63
  %chunk = trunc i64 %chunk64 to i32

  ; row = ((chunk >> 4) & 2) | (chunk & 1)
  %t1 = lshr i32 %chunk, 4
  %t2 = and i32 %t1, 2
  %t3 = and i32 %chunk, 1
  %row = or i32 %t2, %t3

  ; col = (chunk >> 1) & 0xf
  %t4 = lshr i32 %chunk, 1
  %col = and i32 %t4, 15

  ; index = (row << 4) | col
  %row.shl = shl i32 %row, 4
  %index = or i32 %row.shl, %col

  ; sbox byte = SBOX[i*64 + index]
  %i.z = zext i32 %i to i64
  %i.off = shl i64 %i.z, 6
  %index.z = zext i32 %index to i64
  %sbox.off = add i64 %i.off, %index.z
  %sbox.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %sbox.off
  %sbox.val8 = load i8, i8* %sbox.ptr, align 1
  %sbox.val = zext i8 %sbox.val8 to i32

  ; acc = (acc << 4) | sbox.val
  %acc.shl = shl i32 %acc, 4
  %acc.next = or i32 %acc.shl, %sbox.val
  br label %loop.inc

loop.inc:
  %i.next = add nuw nsw i32 %i, 1
  br label %loop.cond

after:
  ; call permute(acc, P, 32, 32)
  %acc64 = zext i32 %acc to i64
  %P.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %ret = call i64 @permute(i64 %acc64, i8* %P.ptr, i32 32, i32 32)
  ret i64 %ret
}