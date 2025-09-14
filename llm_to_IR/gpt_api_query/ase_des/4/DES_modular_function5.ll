; ModuleID = 'key_schedule'
source_filename = "key_schedule.ll"

@PC1 = external global [56 x i8], align 1
@PC2 = external global [48 x i8], align 1
@SHIFTS = external global [16 x i32], align 4

declare i64 @permute(i64 %in, i8* %table, i32 %outbits, i32 %inbits)
declare i32 @rotl28(i32 %val, i32 %shift)

define void @key_schedule(i64 %key, i64* %out) {
entry:
  %pc1ptr = bitcast [56 x i8]* @PC1 to i8*
  %perm1 = call i64 @permute(i64 %key, i8* %pc1ptr, i32 56, i32 64)
  %c64 = lshr i64 %perm1, 28
  %c32 = trunc i64 %c64 to i32
  %c = and i32 %c32, 268435455
  %d64 = and i64 %perm1, 268435455
  %d = trunc i64 %d64 to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.end ]
  %c.phi = phi i32 [ %c, %entry ], [ %c.next, %loop.end ]
  %d.phi = phi i32 [ %d, %entry ], [ %d.next, %loop.end ]

  %idx.ext = zext i32 %i to i64
  %shift.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %idx.ext
  %shift = load i32, i32* %shift.ptr, align 4

  %c.rot = call i32 @rotl28(i32 %c.phi, i32 %shift)
  %d.rot = call i32 @rotl28(i32 %d.phi, i32 %shift)

  %c.z = zext i32 %c.rot to i64
  %c.shl = shl i64 %c.z, 28
  %d.z = zext i32 %d.rot to i64
  %cd = or i64 %d.z, %c.shl

  %pc2ptr = bitcast [48 x i8]* @PC2 to i8*
  %subkey = call i64 @permute(i64 %cd, i8* %pc2ptr, i32 48, i32 56)

  %out.ptr = getelementptr inbounds i64, i64* %out, i64 %idx.ext
  store i64 %subkey, i64* %out.ptr, align 8

  %i.next = add nuw nsw i32 %i, 1
  br label %loop.end

loop.end:
  %cmp = icmp sle i32 %i.next, 15
  br i1 %cmp, label %loop, label %ret

ret:
  ret void
}