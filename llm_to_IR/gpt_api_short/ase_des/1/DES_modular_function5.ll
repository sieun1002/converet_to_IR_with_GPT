; ModuleID = 'key_schedule'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_schedule ; Address: 0x135F
; Intent: DES key schedule generation (confidence=0.98). Evidence: use of PC1/PC2 permutations and 16-round 28-bit rotations via SHIFTS
; Preconditions: out points to storage for at least 16 i64 subkeys
; Postconditions: out[0..15] contain 48-bit subkeys (in low bits)

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
@PC1 = external dso_local constant [56 x i8], align 1
@PC2 = external dso_local constant [48 x i8], align 1
@SHIFTS = external dso_local constant [16 x i32], align 4
declare dso_local i64 @permute(i64, i8*, i32, i32)
declare dso_local i32 @rotl28(i32, i32)

define dso_local void @key_schedule(i64 %in, i64* %out) local_unnamed_addr {
entry:
  %pc1.ptr = getelementptr inbounds [56 x i8], [56 x i8]* @PC1, i64 0, i64 0
  %p56 = call i64 @permute(i64 %in, i8* %pc1.ptr, i32 56, i32 64)
  %p56_trunc = trunc i64 %p56 to i32
  %D0_masked = and i32 %p56_trunc, 268435455
  %p56_shr28 = lshr i64 %p56, 28
  %p56_shr28_tr = trunc i64 %p56_shr28 to i32
  %C0 = and i32 %p56_shr28_tr, 268435455
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %C = phi i32 [ %C0, %entry ], [ %C.rot, %body ]
  %D = phi i32 [ %D0_masked, %entry ], [ %D.rot, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:
  %i.zext = zext i32 %i to i64
  %shifts.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %i.zext
  %shift = load i32, i32* %shifts.ptr, align 4
  %C.rot = call i32 @rotl28(i32 %C, i32 %shift)
  %D.rot = call i32 @rotl28(i32 %D, i32 %shift)
  %C.z = zext i32 %C.rot to i64
  %C.shl28 = shl i64 %C.z, 28
  %D.z = zext i32 %D.rot to i64
  %CD = or i64 %C.shl28, %D.z
  %pc2.ptr = getelementptr inbounds [48 x i8], [48 x i8]* @PC2, i64 0, i64 0
  %subkey = call i64 @permute(i64 %CD, i8* %pc2.ptr, i32 48, i32 56)
  %out.idx = getelementptr inbounds i64, i64* %out, i64 %i.zext
  store i64 %subkey, i64* %out.idx, align 8
  %i.next = add i32 %i, 1
  br label %loop

exit:
  ret void
}