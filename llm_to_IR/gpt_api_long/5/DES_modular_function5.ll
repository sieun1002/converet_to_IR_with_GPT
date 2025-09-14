; ModuleID = 'key_schedule'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_schedule  ; Address: 0x135F
; Intent: Compute DES round subkeys via PC-1/PC-2 and left-rotations (confidence=0.96). Evidence: PC1/PC2 table perms with 56/48-bit sizes; 28-bit left rotations with SHIFTS schedule.
; Preconditions: %out must point to at least 16 contiguous i64 slots.
; Postconditions: %out[0..15] contain 48-bit DES subkeys (stored as i64) derived from %key.

@PC1 = external global [56 x i8]
@PC2 = external global [48 x i8]
@SHIFTS = external global [16 x i32]

declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)

define dso_local void @key_schedule(i64 %key, i64* %out) local_unnamed_addr {
entry:
  %pc1ptr = getelementptr inbounds [56 x i8], [56 x i8]* @PC1, i64 0, i64 0
  %pc2ptr = getelementptr inbounds [48 x i8], [48 x i8]* @PC2, i64 0, i64 0
  %perm1 = call i64 @permute(i64 %key, i8* %pc1ptr, i32 56, i32 64)
  %t1 = lshr i64 %perm1, 28
  %t1mask = and i64 %t1, 268435455
  %left0 = trunc i64 %t1mask to i32
  %rmask = and i64 %perm1, 268435455
  %right0 = trunc i64 %rmask to i32
  br label %loop.check

loop.check:                                           ; preds = %loop.body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %left.phi = phi i32 [ %left0, %entry ], [ %left.rot, %loop.body ]
  %right.phi = phi i32 [ %right0, %entry ], [ %right.rot, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                            ; preds = %loop.check
  %i64 = zext i32 %i to i64
  %shift.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %i64
  %shift = load i32, i32* %shift.ptr
  %left.rot = call i32 @rotl28(i32 %left.phi, i32 %shift)
  %right.rot = call i32 @rotl28(i32 %right.phi, i32 %shift)
  %l64 = zext i32 %left.rot to i64
  %lshift = shl i64 %l64, 28
  %r64 = zext i32 %right.rot to i64
  %concat = or i64 %lshift, %r64
  %subkey = call i64 @permute(i64 %concat, i8* %pc2ptr, i32 48, i32 56)
  %out.gep = getelementptr inbounds i64, i64* %out, i64 %i64
  store i64 %subkey, i64* %out.gep
  %i.next = add i32 %i, 1
  br label %loop.check

exit:                                                 ; preds = %loop.check
  ret void
}