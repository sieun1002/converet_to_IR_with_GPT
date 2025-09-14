; ModuleID = 'sboxes_p.ll'

@SBOX = external global [512 x i8], align 16
@P = external global [32 x i8], align 16

declare i64 @permute(i64, i8*, i32, i32)

define i64 @sboxes_p(i64 %x) {
entry:
  br label %loop.header

loop.header:
  %i = phi i32 [ 0, entry ], [ %i.next, %loop.body ]
  %acc = phi i32 [ 0, entry ], [ %acc.next, %loop.body ]
  %cmp = icmp sle i32 %i, 7
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %mul6 = mul nuw nsw i32 %i, 6
  %shsub = sub nsw i32 42, %mul6
  %shamt = zext i32 %shsub to i64
  %shifted = lshr i64 %x, %shamt
  %six64 = and i64 %shifted, 63
  %six8 = trunc i64 %six64 to i8
  %six32 = zext i8 %six8 to i32

  ; row = ((six >> 4) & 2) | (six & 1)
  %t1 = lshr i32 %six32, 4
  %t2 = and i32 %t1, 2
  %t3 = and i32 %six32, 1
  %row = or i32 %t2, %t3

  ; col = (six >> 1) & 0xF
  %t4 = lshr i32 %six32, 1
  %col = and i32 %t4, 15

  %rowsh = shl i32 %row, 4
  %index = add nuw nsw i32 %rowsh, %col

  %i64 = zext i32 %i to i64
  %off64mul = shl nuw nsw i64 %i64, 6
  %index64 = zext i32 %index to i64
  %sbox_off = add nuw nsw i64 %off64mul, %index64
  %sbox_ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %sbox_off
  %sval8 = load i8, i8* %sbox_ptr, align 1
  %sval32 = zext i8 %sval8 to i32

  %accsh = shl i32 %acc, 4
  %acc.next = or i32 %accsh, %sval32

  %i.next = add nuw nsw i32 %i, 1
  br label %loop.header

exit:
  %acc64 = zext i32 %acc to i64
  %Pptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %ret = call i64 @permute(i64 %acc64, i8* %Pptr, i32 32, i32 32)
  ret i64 %ret
}