; ModuleID = 'key_schedule'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_schedule  ; Address: 0x135F
; Intent: DES key schedule (generate 16 48-bit subkeys from a 64-bit key) (confidence=0.94). Evidence: use of PC1/PC2 tables and SHIFTS with 16 rounds; rotl28 on 28-bit halves.

; Preconditions: %out points to space for at least 16 i64 subkeys.
; Postconditions: %out[0..15] filled with 48-bit subkeys in low bits of each i64.

@PC1 = external constant [56 x i8]
@PC2 = external constant [48 x i8]
@SHIFTS = external constant [16 x i32]

declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)

define dso_local void @key_schedule(i64 %key, i64* %out) local_unnamed_addr {
entry:
  %pc1ptr = getelementptr [56 x i8], [56 x i8]* @PC1, i64 0, i64 0
  %pc1 = call i64 @permute(i64 %key, i8* %pc1ptr, i32 56, i32 64)
  %pc1_shr = lshr i64 %pc1, 28
  %c32_tmp = trunc i64 %pc1_shr to i32
  %c0 = and i32 %c32_tmp, 268435455
  %d32_tmp = trunc i64 %pc1 to i32
  %d0 = and i32 %d32_tmp, 268435455
  br label %cond

cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %c = phi i32 [ %c0, %entry ], [ %c.rot, %body ]
  %d = phi i32 [ %d0, %entry ], [ %d.rot, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:
  %idx = zext i32 %i to i64
  %sh.ptr = getelementptr [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %idx
  %sh = load i32, i32* %sh.ptr, align 4
  %c.rot = call i32 @rotl28(i32 %c, i32 %sh)
  %d.rot = call i32 @rotl28(i32 %d, i32 %sh)
  %c64 = zext i32 %c.rot to i64
  %c64.shl = shl i64 %c64, 28
  %d64 = zext i32 %d.rot to i64
  %cd = or i64 %c64.shl, %d64
  %pc2ptr = getelementptr [48 x i8], [48 x i8]* @PC2, i64 0, i64 0
  %subkey = call i64 @permute(i64 %cd, i8* %pc2ptr, i32 48, i32 56)
  %out.gep = getelementptr i64, i64* %out, i64 %idx
  store i64 %subkey, i64* %out.gep, align 8
  %i.next = add i32 %i, 1
  br label %cond

exit:
  ret void
}