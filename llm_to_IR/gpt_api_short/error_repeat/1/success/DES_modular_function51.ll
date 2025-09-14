; ModuleID = 'key_schedule'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_schedule ; Address: 0x135F
; Intent: DES key schedule (generate 16 48-bit subkeys) (confidence=0.95). Evidence: PC1/PC2 permutations, SHIFTS array and 16-round loop
; Preconditions: out must point to at least 16 contiguous i64 slots
; Postconditions: out[i] contains the i64-encoded 48-bit subkey for round i (i in [0,15])

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @rotl28(i32, i32)
@PC1 = external constant [56 x i8]
@PC2 = external constant [48 x i8]
@SHIFTS = external constant [16 x i32]

define dso_local void @key_schedule(i64 %key, i64* %out) local_unnamed_addr {
entry:
  ; initial PC1 permutation: in=64 bits, out=56 bits
  %pc1.ptr = getelementptr inbounds [56 x i8], [56 x i8]* @PC1, i64 0, i64 0
  %perm1 = call i64 @permute(i64 %key, i8* %pc1.ptr, i32 56, i32 64)
  ; split into 28-bit halves C0 and D0
  %perm1_shr = lshr i64 %perm1, 28
  %C0.tr = trunc i64 %perm1_shr to i32
  %C0 = and i32 %C0.tr, 268435455
  %D0.tr = trunc i64 %perm1 to i32
  %D0 = and i32 %D0.tr, 268435455
  br label %loop

loop:                                             ; 0..15 inclusive
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %C = phi i32 [ %C0, %entry ], [ %rotC, %loop ]
  %D = phi i32 [ %D0, %entry ], [ %rotD, %loop ]
  %i.z = zext i32 %i to i64
  ; load round shift
  %shptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS, i64 0, i64 %i.z
  %shift = load i32, i32* %shptr, align 4
  ; rotate 28-bit halves
  %rotC = call i32 @rotl28(i32 %C, i32 %shift)
  %rotD = call i32 @rotl28(i32 %D, i32 %shift)
  ; combine to 56-bit CD
  %rotC64 = zext i32 %rotC to i64
  %rotC64sh = shl i64 %rotC64, 28
  %rotD64 = zext i32 %rotD to i64
  %CD = or i64 %rotC64sh, %rotD64
  ; PC2 permutation: in=56 bits, out=48 bits
  %pc2.ptr = getelementptr inbounds [48 x i8], [48 x i8]* @PC2, i64 0, i64 0
  %subkey = call i64 @permute(i64 %CD, i8* %pc2.ptr, i32 48, i32 56)
  ; store subkey
  %outptr = getelementptr inbounds i64, i64* %out, i64 %i.z
  store i64 %subkey, i64* %outptr, align 8
  ; next round
  %i.next = add i32 %i, 1
  %cont = icmp sle i32 %i.next, 15
  br i1 %cont, label %loop, label %exit

exit:
  ret void
}