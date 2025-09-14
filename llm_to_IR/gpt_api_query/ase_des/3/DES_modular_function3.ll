; ModuleID = 'sboxes_p.ll'
source_filename = "sboxes_p"

declare i64 @permute(i64, i8*, i32, i32)

@SBOX = external global [512 x i8], align 16
@P = external global [32 x i8], align 16

define i64 @sboxes_p(i64 %in) {
entry:
  br label %loop

loop:
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %loop ]
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]

  %mul6 = mul nsw i32 %i, 6
  %shift32 = sub nsw i32 42, %mul6
  %shift = zext i32 %shift32 to i64
  %shr = lshr i64 %in, %shift
  %val32 = trunc i64 %shr to i32
  %val6 = and i32 %val32, 63

  %tmpa = ashr i32 %val6, 4
  %rowhi = and i32 %tmpa, 2
  %rowlo = and i32 %val6, 1
  %row = or i32 %rowhi, %rowlo

  %colshift = lshr i32 %val6, 1
  %col = and i32 %colshift, 15

  %row4 = shl i32 %row, 4
  %idx32 = add i32 %row4, %col
  %idx64 = zext i32 %idx32 to i64
  %ibox = zext i32 %i to i64
  %boxoff = shl i64 %ibox, 6
  %off = add i64 %boxoff, %idx64

  %sboxptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %off
  %sbyte = load i8, i8* %sboxptr, align 1
  %nib = zext i8 %sbyte to i32

  %acc.shl = shl i32 %acc, 4
  %acc.next = or i32 %acc.shl, %nib

  %i.next = add nuw nsw i32 %i, 1
  %cont = icmp sle i32 %i.next, 7
  br i1 %cont, label %loop, label %exit

exit:
  %acc64 = zext i32 %acc.next to i64
  %Pptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %res = call i64 @permute(i64 %acc64, i8* %Pptr, i32 32, i32 32)
  ret i64 %res
}