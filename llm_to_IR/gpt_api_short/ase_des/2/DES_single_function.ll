; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt ; Address: 0x1189
; Intent: DES block encryption (Feistel network with PC1/PC2/IP/E/SBOX/P/FP) (confidence=0.98). Evidence: 16-round key schedule via SHIFTS/PC1/PC2 and IP/E/SBOX/P/FP permutations
; Preconditions: PC1_7, SHIFTS_6, PC2_5, IP_4, E_3, SBOX_2, P_1, FP_0 tables match DES specification
; Postconditions: returns 64-bit ciphertext for the given 64-bit plaintext block and 64-bit key (with parity bits)

@PC1_7 = external dso_local local_unnamed_addr constant [56 x i32], align 4
@SHIFTS_6 = external dso_local local_unnamed_addr constant [16 x i32], align 4
@PC2_5 = external dso_local local_unnamed_addr constant [48 x i32], align 4
@IP_4 = external dso_local local_unnamed_addr constant [64 x i32], align 4
@E_3 = external dso_local local_unnamed_addr constant [48 x i32], align 4
@SBOX_2 = external dso_local local_unnamed_addr constant [512 x i8], align 1
@P_1 = external dso_local local_unnamed_addr constant [32 x i32], align 4
@FP_0 = external dso_local local_unnamed_addr constant [64 x i32], align 4

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 16

  br label %pc1.loop

pc1.loop:                                         ; build 56-bit key via PC1
  %pc1.i = phi i32 [ 0, %entry ], [ %pc1.i.next, %pc1.loop.bodyend ]
  %pc1.acc = phi i64 [ 0, %entry ], [ %pc1.acc.next, %pc1.loop.bodyend ]
  %pc1.cmp = icmp sle i32 %pc1.i, 55
  br i1 %pc1.cmp, label %pc1.body, label %pc1.done

pc1.body:
  %pc1.idx64 = sext i32 %pc1.i to i64
  %pc1.ptr = getelementptr inbounds [56 x i32], [56 x i32]* @PC1_7, i64 0, i64 %pc1.idx64
  %pc1.val = load i32, i32* %pc1.ptr, align 4
  %pc1.acc.shl = shl i64 %pc1.acc, 1
  %pc1.shift = sub i32 64, %pc1.val
  %pc1.shift64 = zext i32 %pc1.shift to i64
  %key.shr = lshr i64 %key, %pc1.shift64
  %pc1.bit = and i64 %key.shr, 1
  %pc1.acc.next = or i64 %pc1.acc.shl, %pc1.bit
  br label %pc1.loop.bodyend

pc1.loop.bodyend:
  %pc1.i.next = add i32 %pc1.i, 1
  br label %pc1.loop

pc1.done:
  %C0.pre = lshr i64 %pc1.acc, 28
  %C0.mask = and i64 %C0.pre, 268435455
  %D0.mask = and i64 %pc1.acc, 268435455
  %C0 = trunc i64 %C0.mask to i32
  %D0 = trunc i64 %D0.mask to i32
  br label %ks.loop

ks.loop:                                          ; key schedule rounds 0..15
  %ks.r = phi i32 [ 0, %pc1.done ], [ %ks.r.next, %ks.afterround ]
  %C = phi i32 [ %C0, %pc1.done ], [ %C.next, %ks.afterround ]
  %D = phi i32 [ %D0, %pc1.done ], [ %D.next, %ks.afterround ]
  %ks.cmp = icmp sle i32 %ks.r, 15
  br i1 %ks.cmp, label %ks.body, label %ks.done

ks.body:
  %ks.r64 = sext i32 %ks.r to i64
  %shift.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS_6, i64 0, i64 %ks.r64
  %shift.val = load i32, i32* %shift.ptr, align 4
  %shift.mod = and i32 %shift.val, 31
  %C.shl = shl i32 %C, %shift.mod
  %C.rev = sub i32 28, %shift.mod
  %C.shr = lshr i32 %C, %C.rev
  %C.rot = or i32 %C.shl, %C.shr
  %C.next = and i32 %C.rot, 268435455
  %D.shl = shl i32 %D, %shift.mod
  %D.rev = sub i32 28, %shift.mod
  %D.shr = lshr i32 %D, %D.rev
  %D.rot = or i32 %D.shl, %D.shr
  %D.next = and i32 %D.rot, 268435455
  %C.z = zext i32 %C.next to i64
  %D.z = zext i32 %D.next to i64
  %C.l = shl i64 %C.z, 28
  %CD = or i64 %C.l, %D.z
  br label %pc2.loop

pc2.loop:                                         ; PC2 -> 48-bit subkey
  %pc2.i = phi i32 [ 0, %ks.body ], [ %pc2.i.next, %pc2.loop.bodyend ]
  %pc2.acc = phi i64 [ 0, %ks.body ], [ %pc2.acc.next, %pc2.loop.bodyend ]
  %pc2.cmp = icmp sle i32 %pc2.i, 47
  br i1 %pc2.cmp, label %pc2.body, label %pc2.done

pc2.body:
  %pc2.idx64 = sext i32 %pc2.i to i64
  %pc2.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @PC2_5, i64 0, i64 %pc2.idx64
  %pc2.val = load i32, i32* %pc2.ptr, align 4
  %pc2.acc.shl = shl i64 %pc2.acc, 1
  %pc2.shift = sub i32 56, %pc2.val
  %pc2.shift64 = zext i32 %pc2.shift to i64
  %CD.shr = lshr i64 %CD, %pc2.shift64
  %pc2.bit = and i64 %CD.shr, 1
  %pc2.acc.next = or i64 %pc2.acc.shl, %pc2.bit
  br label %pc2.loop.bodyend

pc2.loop.bodyend:
  %pc2.i.next = add i32 %pc2.i, 1
  br label %pc2.loop

pc2.done:
  %skptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %ks.r64
  store i64 %pc2.acc, i64* %skptr, align 8
  br label %ks.afterround

ks.afterround:
  %ks.r.next = add i32 %ks.r, 1
  br label %ks.loop

ks.done:
  br label %ip.loop

ip.loop:                                          ; initial permutation IP
  %ip.i = phi i32 [ 0, %ks.done ], [ %ip.i.next, %ip.loop.bodyend ]
  %ip.acc = phi i64 [ 0, %ks.done ], [ %ip.acc.next, %ip.loop.bodyend ]
  %ip.cmp = icmp sle i32 %ip.i, 63
  br i1 %ip.cmp, label %ip.body, label %ip.done

ip.body:
  %ip.idx64 = sext i32 %ip.i to i64
  %ip.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @IP_4, i64 0, i64 %ip.idx64
  %ip.val = load i32, i32* %ip.ptr, align 4
  %ip.acc.shl = shl i64 %ip.acc, 1
  %ip.shift = sub i32 64, %ip.val
  %ip.shift64 = zext i32 %ip.shift to i64
  %block.shr = lshr i64 %block, %ip.shift64
  %ip.bit = and i64 %block.shr, 1
  %ip.acc.next = or i64 %ip.acc.shl, %ip.bit
  br label %ip.loop.bodyend

ip.loop.bodyend:
  %ip.i.next = add i32 %ip.i, 1
  br label %ip.loop

ip.done:
  %L0.ext = lshr i64 %ip.acc, 32
  %L0 = trunc i64 %L0.ext to i32
  %R0 = trunc i64 %ip.acc to i32
  br label %round.loop

round.loop:                                       ; 16 Feistel rounds
  %rnd.i = phi i32 [ 0, %ip.done ], [ %rnd.i.next, %after.round ]
  %L = phi i32 [ %L0, %ip.done ], [ %L.next, %after.round ]
  %R = phi i32 [ %R0, %ip.done ], [ %R.next, %after.round ]
  %rnd.cmp = icmp sle i32 %rnd.i, 15
  br i1 %rnd.cmp, label %round.body, label %rounds.done

round.body:
  br label %e.loop

e.loop:                                           ; expansion E (32 -> 48)
  %e.i = phi i32 [ 0, %round.body ], [ %e.i.next, %e.loop.bodyend ]
  %e.acc = phi i64 [ 0, %round.body ], [ %e.acc.next, %e.loop.bodyend ]
  %e.cmp = icmp sle i32 %e.i, 47
  br i1 %e.cmp, label %e.body, label %e.done

e.body:
  %e.idx64 = sext i32 %e.i to i64
  %e.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @E_3, i64 0, i64 %e.idx64
  %e.val = load i32, i32* %e.ptr, align 4
  %e.acc.shl = shl i64 %e.acc, 1
  %e.shift = sub i32 32, %e.val
  %e.shift32 = and i32 %e.shift, 31
  %R.shr = lshr i32 %R, %e.shift32
  %e.bit32 = and i32 %R.shr, 1
  %e.bit = zext i32 %e.bit32 to i64
  %e.acc.next = or i64 %e.acc.shl, %e.bit
  br label %e.loop.bodyend

e.loop.bodyend:
  %e.i.next = add i32 %e.i, 1
  br label %e.loop

e.done:
  %rnd.i64 = sext i32 %rnd.i to i64
  %skptr2 = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %rnd.i64
  %sk = load i64, i64* %skptr2, align 8
  %xored = xor i64 %e.acc, %sk
  br label %s.loop

s.loop:                                           ; S-boxes (8 x 6 -> 4)
  %s.i = phi i32 [ 0, %e.done ], [ %s.i.next, %s.loop.bodyend ]
  %s.acc = phi i32 [ 0, %e.done ], [ %s.acc.next, %s.loop.bodyend ]
  %s.cmp = icmp sle i32 %s.i, 7
  br i1 %s.cmp, label %s.body, label %s.done

s.body:
  %s.mul6 = mul nsw i32 %s.i, 6
  %s.shift = sub nsw i32 42, %s.mul6
  %s.shift64 = zext i32 %s.shift to i64
  %chunk = lshr i64 %xored, %s.shift64
  %chunk6 = and i64 %chunk, 63
  %chunk8 = trunc i64 %chunk6 to i8
  %shr4 = lshr i8 %chunk8, 4
  %row2 = and i8 %shr4, 2
  %bit0 = and i8 %chunk8, 1
  %row = or i8 %row2, %bit0
  %row.z = zext i8 %row to i32
  %shr1 = lshr i8 %chunk8, 1
  %col4 = and i8 %shr1, 15
  %col.z = zext i8 %col4 to i32
  %row.shl4 = shl i32 %row.z, 4
  %idx6 = add i32 %row.shl4, %col.z
  %s.i64 = sext i32 %s.i to i64
  %off64 = shl i64 %s.i64, 6
  %idx6.z64 = zext i32 %idx6 to i64
  %tot.off = add i64 %off64, %idx6.z64
  %sbox.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX_2, i64 0, i64 %tot.off
  %sbox.val = load i8, i8* %sbox.ptr, align 1
  %sbox.z = zext i8 %sbox.val to i32
  %s.acc.shl = shl i32 %s.acc, 4
  %s.acc.next = or i32 %s.acc.shl, %sbox.z
  br label %s.loop.bodyend

s.loop.bodyend:
  %s.i.next = add i32 %s.i, 1
  br label %s.loop

s.done:
  br label %p.loop

p.loop:                                           ; permutation P (32 -> 32)
  %p.i = phi i32 [ 0, %s.done ], [ %p.i.next, %p.loop.bodyend ]
  %p.acc = phi i32 [ 0, %s.done ], [ %p.acc.next, %p.loop.bodyend ]
  %p.cmp = icmp sle i32 %p.i, 31
  br i1 %p.cmp, label %p.body, label %p.done

p.body:
  %p.idx64 = sext i32 %p.i to i64
  %p.ptr = getelementptr inbounds [32 x i32], [32 x i32]* @P_1, i64 0, i64 %p.idx64
  %p.val = load i32, i32* %p.ptr, align 4
  %p.acc.shl = shl i32 %p.acc, 1
  %p.shift = sub i32 32, %p.val
  %p.shift32 = and i32 %p.shift, 31
  %s.acc.shr = lshr i32 %s.acc, %p.shift32
  %p.bit = and i32 %s.acc.shr, 1
  %p.acc.next = or i32 %p.acc.shl, %p.bit
  br label %p.loop.bodyend

p.loop.bodyend:
  %p.i.next = add i32 %p.i, 1
  br label %p.loop

p.done:
  %L.next = %R
  %R.xor = xor i32 %L, %p.acc
  %R.next = %R.xor
  br label %after.round

after.round:
  %rnd.i.next = add i32 %rnd.i, 1
  br label %round.loop

rounds.done:
  %R.z = zext i32 %R to i64
  %L.z = zext i32 %L to i64
  %R.shl32 = shl i64 %R.z, 32
  %preout = or i64 %R.shl32, %L.z
  br label %fp.loop

fp.loop:                                          ; final permutation FP
  %fp.i = phi i32 [ 0, %rounds.done ], [ %fp.i.next, %fp.loop.bodyend ]
  %fp.acc = phi i64 [ 0, %rounds.done ], [ %fp.acc.next, %fp.loop.bodyend ]
  %fp.cmp = icmp sle i32 %fp.i, 63
  br i1 %fp.cmp, label %fp.body, label %fp.done

fp.body:
  %fp.idx64 = sext i32 %fp.i to i64
  %fp.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @FP_0, i64 0, i64 %fp.idx64
  %fp.val = load i32, i32* %fp.ptr, align 4
  %fp.acc.shl = shl i64 %fp.acc, 1
  %fp.shift = sub i32 64, %fp.val
  %fp.shift64 = zext i32 %fp.shift to i64
  %preout.shr = lshr i64 %preout, %fp.shift64
  %fp.bit = and i64 %preout.shr, 1
  %fp.acc.next = or i64 %fp.acc.shl, %fp.bit
  br label %fp.loop.bodyend

fp.loop.bodyend:
  %fp.i.next = add i32 %fp.i, 1
  br label %fp.loop

fp.done:
  ret i64 %fp.acc
}