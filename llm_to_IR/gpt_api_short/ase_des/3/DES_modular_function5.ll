; ModuleID = 'key_schedule'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_schedule ; Address: 0x135F
; Intent: DES key schedule (generate 16 48-bit subkeys) (confidence=0.95). Evidence: PC1/PC2 permutations, SHIFTS, rotl28, 16-round loop.
; Preconditions: out points to storage for at least 16 i64 subkeys.
; Postconditions: out[i] contains the i-th subkey (i=0..15).

; Only the necessary external declarations:
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)
@PC1 = external global i8
@PC2 = external global i8
@SHIFTS = external global i32

define dso_local void @key_schedule(i64 %key, i64* %out) local_unnamed_addr {
entry:
  %perm1 = call i64 @permute(i64 %key, i8* @PC1, i32 56, i32 64)
  %shr28 = lshr i64 %perm1, 28
  %left56 = and i64 %shr28, 268435455
  %left0 = trunc i64 %left56 to i32
  %right56 = and i64 %perm1, 268435455
  %right0 = trunc i64 %right56 to i32
  br label %loop

loop:                                             ; i in [0..15]
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %left = phi i32 [ %left0, %entry ], [ %left.rot, %body ]
  %right = phi i32 [ %right0, %entry ], [ %right.rot, %body ]
  %cmp.end = icmp sgt i32 %i, 15
  br i1 %cmp.end, label %exit, label %body

body:
  %i.z = zext i32 %i to i64
  %shift.ptr = getelementptr inbounds i32, i32* @SHIFTS, i64 %i.z
  %shift = load i32, i32* %shift.ptr, align 4
  %left.rot = call i32 @rotl28(i32 %left, i32 %shift)
  %right.rot = call i32 @rotl28(i32 %right, i32 %shift)
  %left.z = zext i32 %left.rot to i64
  %left.sh = shl i64 %left.z, 28
  %right.z = zext i32 %right.rot to i64
  %combined = or i64 %left.sh, %right.z
  %subkey = call i64 @permute(i64 %combined, i8* @PC2, i32 48, i32 56)
  %out.elem = getelementptr inbounds i64, i64* %out, i64 %i.z
  store i64 %subkey, i64* %out.elem, align 8
  %i.next = add i32 %i, 1
  br label %loop

exit:
  ret void
}