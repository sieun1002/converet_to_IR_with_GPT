; ModuleID = 'sboxes_module'
target triple = "x86_64-unknown-linux-gnu"

@SBOX = external dso_local global [512 x i8], align 1
@P = external dso_local global [32 x i8], align 1

declare dso_local i64 @permute(i64 noundef, i8* noundef, i32 noundef, i32 noundef)

define dso_local i64 @sboxes_p(i64 noundef %x) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body.end ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %loop.body.end ]
  %cmp = icmp sle i32 %i, 7
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %mul6 = mul nsw i32 %i, 6
  %shift = sub nsw i32 42, %mul6
  %shift64 = sext i32 %shift to i64
  %shr = lshr i64 %x, %shift64
  %masked = and i64 %shr, 63
  %b32 = trunc i64 %masked to i32
  %hi = lshr i32 %b32, 5
  %hi1 = and i32 %hi, 1
  %hi1sh = shl i32 %hi1, 1
  %lo1 = and i32 %b32, 1
  %row = or i32 %hi1sh, %lo1
  %tmp1 = lshr i32 %b32, 1
  %col = and i32 %tmp1, 15
  %rowsh = shl i32 %row, 4
  %idx0 = add nuw nsw i32 %rowsh, %col
  %i_shl6 = shl i32 %i, 6
  %idx = add nuw nsw i32 %i_shl6, %idx0
  %idx64 = zext i32 %idx to i64
  %sbox.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX, i64 0, i64 %idx64
  %sval8 = load i8, i8* %sbox.ptr, align 1
  %sval = zext i8 %sval8 to i32
  %acc.shl = shl i32 %acc, 4
  %acc.next = or i32 %acc.shl, %sval
  %i.next = add nuw nsw i32 %i, 1
  br label %loop.body.end

loop.body.end:
  br label %loop

after.loop:
  %acc64 = zext i32 %acc to i64
  %P.ptr = getelementptr inbounds [32 x i8], [32 x i8]* @P, i64 0, i64 0
  %res = call i64 @permute(i64 noundef %acc64, i8* noundef %P.ptr, i32 noundef 32, i32 noundef 32)
  ret i64 %res
}