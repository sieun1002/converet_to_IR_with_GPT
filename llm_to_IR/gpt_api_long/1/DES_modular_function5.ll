; ModuleID = 'key_schedule'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_schedule  ; Address: 0x135F
; Intent: DES key schedule: derive 16 48-bit subkeys from a 64-bit key (confidence=0.97). Evidence: PC1/PC2 permutation tables and 16-entry SHIFTS with rotl28
; Preconditions: %subkeys points to at least 16 contiguous i64 slots; externs (permute/rotl28/PC1/PC2/SHIFTS) follow DES conventions.
; Postconditions: subkeys[i] holds a 48-bit subkey in the low bits (i in [0,15]).

@PC1 = external constant [56 x i8]
@PC2 = external constant [48 x i8]
@SHIFTS = external constant [16 x i32]

; Only the needed extern declarations:
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)

define dso_local void @key_schedule(i64 %key, i64* %subkeys) local_unnamed_addr {
entry:
  %pc1ptr = getelementptr inbounds [56 x i8], [56 x i8]* @PC1, i64 0, i64 0
  %perm56 = call i64 @permute(i64 %key, i8* %pc1ptr, i32 56, i32 64)
  %c_shr = lshr i64 %perm56, 28
  %c32 = trunc i64 %c_shr to i32
  %c_masked = and i32 %c32, 268435455
  %d32t = trunc i64 %perm56 to i32
  %d_masked = and i32 %d32t, 268435455
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %c_phi = phi i32 [ %c_masked, %entry ], [ %c1, %loop ]
  %d_phi = phi i32 [ %d_masked, %entry ], [ %d1, %loop ]
  %idx64 = zext i32 %i to i64
  %shptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %idx64
  %shift = load i32, i32* %shptr, align 4
  %c1 = call i32 @rotl28(i32 %c_phi, i32 %shift)
  %d1 = call i32 @rotl28(i32 %d_phi, i32 %shift)
  %cl = zext i32 %c1 to i64
  %chl = shl i64 %cl, 28
  %dl = zext i32 %d1 to i64
  %comb = or i64 %chl, %dl
  %outptr = getelementptr inbounds i64, i64* %subkeys, i64 %idx64
  %pc2ptr = getelementptr inbounds [48 x i8], [48 x i8]* @PC2, i64 0, i64 0
  %sk = call i64 @permute(i64 %comb, i8* %pc2ptr, i32 48, i32 56)
  store i64 %sk, i64* %outptr, align 8
  %i.next = add i32 %i, 1
  %cont = icmp sle i32 %i.next, 15
  br i1 %cont, label %loop, label %exit

exit:
  ret void
}