; ModuleID = 'key_schedule'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_schedule  ; Address: 0x135F
; Intent: DES key schedule generation (confidence=0.98). Evidence: PC1/PC2 permutation tables, 16-round loop with SHIFTS and 28-bit rotations
; Preconditions: %subkeys must point to space for 16 i64 entries. @PC1/@PC2/@SHIFTS/permute/rotl28 must be provided with conventional DES semantics.
; Postconditions: Writes 16 48-bit subkeys (stored in i64 slots) to %subkeys[0..15].

@PC1 = external constant [56 x i8], align 1
@PC2 = external constant [48 x i8], align 1
@SHIFTS = external constant [16 x i32], align 4

declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)

define dso_local void @key_schedule(i64 %key64, i64* %subkeys) local_unnamed_addr {
entry:
  %pc1ptr = getelementptr inbounds [56 x i8], [56 x i8]* @PC1, i64 0, i64 0
  %perm1 = call i64 @permute(i64 %key64, i8* %pc1ptr, i32 56, i32 64)
  %left64.pre = lshr i64 %perm1, 28
  %left32.tr = trunc i64 %left64.pre to i32
  %left0 = and i32 %left32.tr, 268435455
  %right32.tr = trunc i64 %perm1 to i32
  %right0 = and i32 %right32.tr, 268435455
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %L = phi i32 [ %left0, %entry ], [ %L.next, %loop.body ]
  %R = phi i32 [ %right0, %entry ], [ %R.next, %loop.body ]
  %cmp = icmp ule i32 %i, 15
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %idx64 = zext i32 %i to i64
  %shift.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %idx64
  %shift = load i32, i32* %shift.ptr, align 4
  %L.next = call i32 @rotl28(i32 %L, i32 %shift)
  %R.next = call i32 @rotl28(i32 %R, i32 %shift)
  %L.next.z = zext i32 %L.next to i64
  %L.shl = shl i64 %L.next.z, 28
  %R.next.z = zext i32 %R.next to i64
  %cd = or i64 %L.shl, %R.next.z
  %pc2ptr = getelementptr inbounds [48 x i8], [48 x i8]* @PC2, i64 0, i64 0
  %subk = call i64 @permute(i64 %cd, i8* %pc2ptr, i32 48, i32 56)
  %out.ptr = getelementptr inbounds i64, i64* %subkeys, i64 %idx64
  store i64 %subk, i64* %out.ptr, align 8
  %i.next = add i32 %i, 1
  br label %loop.cond

exit:
  ret void
}