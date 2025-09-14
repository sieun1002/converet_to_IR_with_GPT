; ModuleID = 'key_schedule'
source_filename = "key_schedule"

@PC1 = external constant [56 x i8], align 1
@PC2 = external constant [48 x i8], align 1
@SHIFTS = external constant [16 x i32], align 4

declare i64 @permute(i64 %in, i8* %table, i32 %outbits, i32 %inbits)
declare i32 @rotl28(i32 %v, i32 %s)

define void @key_schedule(i64 %key, i64* %out) {
entry:
  %pc1ptr = getelementptr inbounds [56 x i8], [56 x i8]* @PC1, i64 0, i64 0
  %cd56 = call i64 @permute(i64 %key, i8* %pc1ptr, i32 56, i32 64)

  %cd56_shr = lshr i64 %cd56, 28
  %C0_64 = and i64 %cd56_shr, 268435455
  %C0 = trunc i64 %C0_64 to i32

  %D0_64 = and i64 %cd56, 268435455
  %D0 = trunc i64 %D0_64 to i32

  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %body_end ]
  %C = phi i32 [ %C0, %entry ], [ %C.rot, %body_end ]
  %D = phi i32 [ %D0, %entry ], [ %D.rot, %body_end ]

  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:
  %idx.ext = sext i32 %i to i64
  %shift.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %idx.ext
  %s = load i32, i32* %shift.ptr, align 4

  %C.rot = call i32 @rotl28(i32 %C, i32 %s)
  %D.rot = call i32 @rotl28(i32 %D, i32 %s)

  %C.z = zext i32 %C.rot to i64
  %C.shl = shl i64 %C.z, 28
  %D.z = zext i32 %D.rot to i64
  %CD = or i64 %D.z, %C.shl

  %pc2ptr = getelementptr inbounds [48 x i8], [48 x i8]* @PC2, i64 0, i64 0
  %subkey = call i64 @permute(i64 %CD, i8* %pc2ptr, i32 48, i32 56)

  %out.idx.ptr = getelementptr inbounds i64, i64* %out, i64 %idx.ext
  store i64 %subkey, i64* %out.idx.ptr, align 8

  br label %body_end

body_end:
  %i.next = add i32 %i, 1
  br label %loop

exit:
  ret void
}