; ModuleID = 'des_keyschedule'
target triple = "x86_64-unknown-linux-gnu"

@PC1 = external constant [56 x i8], align 1
@PC2 = external constant [48 x i8], align 1
@SHIFTS = external constant [16 x i32], align 4

declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)

define void @key_schedule(i64 %key, i64* %out) {
entry:
  %pc1ptr = getelementptr inbounds [56 x i8], [56 x i8]* @PC1, i64 0, i64 0
  %k56 = call i64 @permute(i64 %key, i8* %pc1ptr, i32 56, i32 64)
  %lsr = lshr i64 %k56, 28
  %left32 = trunc i64 %lsr to i32
  %left28.init = and i32 %left32, 268435455
  %right32t = trunc i64 %k56 to i32
  %right28.init = and i32 %right32t, 268435455
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %L = phi i32 [ %left28.init, %entry ], [ %L2, %loop ]
  %R = phi i32 [ %right28.init, %entry ], [ %R2, %loop ]

  %idx64 = zext i32 %i to i64
  %shiftptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %idx64
  %shift = load i32, i32* %shiftptr, align 4

  %L2 = call i32 @rotl28(i32 %L, i32 %shift)
  %R2 = call i32 @rotl28(i32 %R, i32 %shift)

  %L2z = zext i32 %L2 to i64
  %Lsh = shl i64 %L2z, 28
  %R2z = zext i32 %R2 to i64
  %combined = or i64 %Lsh, %R2z

  %pc2ptr = getelementptr inbounds [48 x i8], [48 x i8]* @PC2, i64 0, i64 0
  %sub = call i64 @permute(i64 %combined, i8* %pc2ptr, i32 48, i32 56)

  %outptr = getelementptr inbounds i64, i64* %out, i64 %idx64
  store i64 %sub, i64* %outptr, align 8

  %i.next = add i32 %i, 1
  %cont = icmp sle i32 %i.next, 15
  br i1 %cont, label %loop, label %exit

exit:
  ret void
}