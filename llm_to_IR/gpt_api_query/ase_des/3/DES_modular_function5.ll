; ModuleID = 'key_schedule.ll'
source_filename = "key_schedule"

@PC1 = external constant [56 x i8], align 1
@PC2 = external constant [48 x i8], align 1
@SHIFTS = external constant [16 x i32], align 4

declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)

define void @key_schedule(i64 %key, i64* nocapture %out) {
entry:
  %pc1ptr = getelementptr inbounds [56 x i8], [56 x i8]* @PC1, i64 0, i64 0
  %v = call i64 @permute(i64 %key, i8* %pc1ptr, i32 56, i32 64)
  %c0sh = lshr i64 %v, 28
  %c0t = trunc i64 %c0sh to i32
  %c.init = and i32 %c0t, 268435455
  %d0t = trunc i64 %v to i32
  %d.init = and i32 %d0t, 268435455
  br label %check

check:
  %i = phi i32 [0, %entry], [%i.next, %body]
  %c = phi i32 [%c.init, %entry], [%c.new, %body]
  %d = phi i32 [%d.init, %entry], [%d.new, %body]
  %cond = icmp sle i32 %i, 15
  br i1 %cond, label %body, label %exit

body:
  %idx64 = zext i32 %i to i64
  %shiftptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %idx64
  %shift = load i32, i32* %shiftptr, align 4
  %c.new = call i32 @rotl28(i32 %c, i32 %shift)
  %d.new = call i32 @rotl28(i32 %d, i32 %shift)
  %cz = zext i32 %c.new to i64
  %shl = shl i64 %cz, 28
  %dz = zext i32 %d.new to i64
  %cd = or i64 %shl, %dz
  %pc2ptr = getelementptr inbounds [48 x i8], [48 x i8]* @PC2, i64 0, i64 0
  %subkey = call i64 @permute(i64 %cd, i8* %pc2ptr, i32 48, i32 56)
  %outptr = getelementptr inbounds i64, i64* %out, i64 %idx64
  store i64 %subkey, i64* %outptr, align 8
  %i.next = add i32 %i, 1
  br label %check

exit:
  ret void
}