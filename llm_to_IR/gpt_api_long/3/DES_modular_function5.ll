; ModuleID = 'key_schedule'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_schedule  ; Address: 0x135F
; Intent: Compute DES 16-round subkeys using PC1/PC2 and rotation schedule (confidence=0.95). Evidence: PC1/PC2/SHIFTS symbols; rotl28 applied to 28-bit halves across 16 iterations.
; Preconditions: %out points to at least 16 contiguous i64 slots.
; Postconditions: %out[i] holds the 48-bit subkey in the low bits for round i (0..15).

@PC1 = external dso_local global [56 x i8]
@PC2 = external dso_local global [48 x i8]
@SHIFTS = external dso_local global [16 x i32]

declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)

define dso_local void @key_schedule(i64 %key, i64* %out) local_unnamed_addr {
entry:
  %pc1_ptr = bitcast [56 x i8]* @PC1 to i8*
  %perm1 = call i64 @permute(i64 %key, i8* %pc1_ptr, i32 56, i32 64)
  %perm1_shr = lshr i64 %perm1, 28
  %c64 = and i64 %perm1_shr, 268435455
  %d64 = and i64 %perm1, 268435455
  %c0 = trunc i64 %c64 to i32
  %d0 = trunc i64 %d64 to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.end ]
  %c = phi i32 [ %c0, %entry ], [ %c.next, %loop.end ]
  %d = phi i32 [ %d0, %entry ], [ %d.next, %loop.end ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %i64 = sext i32 %i to i64
  %shift.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %i64
  %shift = load i32, i32* %shift.ptr, align 4
  %c.rot = call i32 @rotl28(i32 %c, i32 %shift)
  %d.rot = call i32 @rotl28(i32 %d, i32 %shift)
  %c.z = zext i32 %c.rot to i64
  %c.shl = shl i64 %c.z, 28
  %d.z = zext i32 %d.rot to i64
  %cd = or i64 %c.shl, %d.z
  %pc2_ptr = bitcast [48 x i8]* @PC2 to i8*
  %subkey = call i64 @permute(i64 %cd, i8* %pc2_ptr, i32 48, i32 56)
  %out.gep = getelementptr inbounds i64, i64* %out, i64 %i64
  store i64 %subkey, i64* %out.gep, align 8
  br label %loop.end

loop.end:
  %c.next = phi i32 [ %c.rot, %loop.body ]
  %d.next = phi i32 [ %d.rot, %loop.body ]
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:
  ret void
}