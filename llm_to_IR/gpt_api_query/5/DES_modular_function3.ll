; ModuleID = 'sboxes_p.ll'
source_filename = "sboxes_p"

@SBOX = external global [512 x i8], align 1
@P = external global [32 x i8], align 1

declare i64 @permute(i64, i8*, i32, i32)

define i64 @sboxes_p(i64 %in) {
entry:
  %acc = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %acc, align 4
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %i.val, 7
  br i1 %cmp, label %loop.body, label %after

loop.body:
  %mul6 = mul nsw i32 %i.val, 6
  %shift = sub nsw i32 42, %mul6
  %shift64 = zext i32 %shift to i64
  %shr = lshr i64 %in, %shift64
  %chunk64 = and i64 %shr, 63
  %chunk = trunc i64 %chunk64 to i32

  %tmp = lshr i32 %chunk, 4
  %tmp2 = and i32 %tmp, 2
  %low1 = and i32 %chunk, 1
  %row = or i32 %tmp2, %low1

  %tmp3 = lshr i32 %chunk, 1
  %col = and i32 %tmp3, 15

  %rowsh = shl i32 %row, 4
  %rc = add i32 %rowsh, %col
  %rc64 = zext i32 %rc to i64
  %ibase64 = zext i32 %i.val to i64
  %ibase = shl i64 %ibase64, 6
  %off = add i64 %ibase, %rc64

  %eltptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %off
  %val8 = load i8, i8* %eltptr, align 1
  %val32 = zext i8 %val8 to i32

  %oldacc = load i32, i32* %acc, align 4
  %accsh = shl i32 %oldacc, 4
  %newacc = or i32 %accsh, %val32
  store i32 %newacc, i32* %acc, align 4

  %nexti = add nsw i32 %i.val, 1
  store i32 %nexti, i32* %i, align 4
  br label %loop.cond

after:
  %acc.final = load i32, i32* %acc, align 4
  %acc64 = zext i32 %acc.final to i64
  %Pptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %res = call i64 @permute(i64 %acc64, i8* %Pptr, i32 32, i32 32)
  ret i64 %res
}