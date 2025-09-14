; ModuleID = 'key_schedule'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_schedule  ; Address: 0x135F
; Intent: Generate DES 16-round subkeys from a 64-bit key (confidence=0.95). Evidence: PC1/PC2 permutations and 16-entry SHIFTS with 28-bit rotations
; Preconditions: %out points to at least 16 contiguous i64 slots; @PC1/@PC2/@SHIFTS are valid external tables
; Postconditions: %out[0..15] contain 48-bit subkeys as 64-bit values (lower 48 bits significant)

@PC1 = external global i8, align 1
@PC2 = external global i8, align 1
@SHIFTS = external global i32, align 4

declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)

define dso_local void @key_schedule(i64 %key, i64* %out) local_unnamed_addr {
entry:
  %perm1 = call i64 @permute(i64 %key, i8* @PC1, i32 56, i32 64)
  %t1_shr = lshr i64 %perm1, 28
  %c_init.trunc = trunc i64 %t1_shr to i32
  %c_init = and i32 %c_init.trunc, 268435455
  %d_mask64 = and i64 %perm1, 268435455
  %d_init = trunc i64 %d_mask64 to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %c = phi i32 [ %c_init, %entry ], [ %c_new, %loop ]
  %d = phi i32 [ %d_init, %entry ], [ %d_new, %loop ]
  %i.zext = zext i32 %i to i64
  %shift.ptr = getelementptr inbounds i32, i32* @SHIFTS, i64 %i.zext
  %shift = load i32, i32* %shift.ptr, align 4
  %c_new = call i32 @rotl28(i32 %c, i32 %shift)
  %d_new = call i32 @rotl28(i32 %d, i32 %shift)
  %c64 = zext i32 %c_new to i64
  %cshifted = shl i64 %c64, 28
  %d64 = zext i32 %d_new to i64
  %cd = or i64 %cshifted, %d64
  %subkey = call i64 @permute(i64 %cd, i8* @PC2, i32 48, i32 56)
  %out.ptr = getelementptr inbounds i64, i64* %out, i64 %i.zext
  store i64 %subkey, i64* %out.ptr, align 8
  %i.next = add nuw nsw i32 %i, 1
  %cond = icmp sle i32 %i.next, 15
  br i1 %cond, label %loop, label %exit

exit:
  ret void
}