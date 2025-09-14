; ModuleID = 'key_schedule'
source_filename = "key_schedule.ll"
target triple = "x86_64-unknown-linux-gnu"

declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)

@PC1 = external global [56 x i8], align 1
@PC2 = external global [48 x i8], align 1
@SHIFTS = external global [16 x i32], align 4

define void @key_schedule(i64 %key, i64* %subkeys) {
entry:
  %pc1ptr = getelementptr inbounds [56 x i8], [56 x i8]* @PC1, i64 0, i64 0
  %t0 = call i64 @permute(i64 %key, i8* %pc1ptr, i32 56, i32 64)
  %C64 = lshr i64 %t0, 28
  %C32t = trunc i64 %C64 to i32
  %C0 = and i32 %C32t, 268435455
  %D32t = trunc i64 %t0 to i32
  %D0 = and i32 %D32t, 268435455
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %C = phi i32 [ %C0, %entry ], [ %Cnew, %loop ]
  %D = phi i32 [ %D0, %entry ], [ %Dnew, %loop ]
  %idx64 = sext i32 %i to i64
  %shift.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %idx64
  %sh = load i32, i32* %shift.ptr, align 4
  %Cnew = call i32 @rotl28(i32 %C, i32 %sh)
  %Dnew = call i32 @rotl28(i32 %D, i32 %sh)
  %Cext = zext i32 %Cnew to i64
  %Cshl = shl i64 %Cext, 28
  %Dext = zext i32 %Dnew to i64
  %cd = or i64 %Cshl, %Dext
  %pc2ptr = getelementptr inbounds [48 x i8], [48 x i8]* @PC2, i64 0, i64 0
  %subkey = call i64 @permute(i64 %cd, i8* %pc2ptr, i32 48, i32 56)
  %outidx = zext i32 %i to i64
  %outptr = getelementptr inbounds i64, i64* %subkeys, i64 %outidx
  store i64 %subkey, i64* %outptr, align 8
  %i.next = add i32 %i, 1
  %cond = icmp sle i32 %i.next, 15
  br i1 %cond, label %loop, label %exit

exit:
  ret void
}