; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt ; Address: 0x1189
; Intent: DES block encryption (confidence=0.99). Evidence: classic DES tables (PC1, PC2, IP, E, SBOX, P, FP) and 16-round Feistel structure
; Preconditions: block and key are 64-bit values (key may include parity bits)
; Postconditions: returns 64-bit DES ciphertext of block under key

@PC1_7 = internal constant [56 x i32] [
  i32 57, i32 49, i32 41, i32 33, i32 25, i32 17, i32 9,
  i32 1,  i32 58, i32 50, i32 42, i32 34, i32 26, i32 18,
  i32 10, i32 2,  i32 59, i32 51, i32 43, i32 35,
  i32 27, i32 19, i32 11, i32 3,  i32 60, i32 52, i32 44, i32 36,
  i32 63, i32 55, i32 47, i32 39, i32 31, i32 23, i32 15,
  i32 7,  i32 62, i32 54, i32 46, i32 38, i32 30, i32 22,
  i32 14, i32 6,  i32 61, i32 53, i32 45, i32 37, i32 29,
  i32 21, i32 13, i32 5,  i32 28, i32 20, i32 12, i32 4
]

@SHIFTS_6 = internal constant [16 x i32] [
  i32 1, i32 1, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2,
  i32 1, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 1
]

@PC2_5 = internal constant [48 x i32] [
  i32 14, i32 17, i32 11, i32 24, i32 1,  i32 5,
  i32 3,  i32 28, i32 15, i32 6,  i32 21, i32 10,
  i32 23, i32 19, i32 12, i32 4,  i32 26, i32 8,
  i32 16, i32 7,  i32 27, i32 20, i32 13, i32 2,
  i32 41, i32 52, i32 31, i32 37, i32 47, i32 55,
  i32 30, i32 40, i32 51, i32 45, i32 33, i32 48,
  i32 44, i32 49, i32 39, i32 56, i32 34, i32 53,
  i32 46, i32 42, i32 50, i32 36, i32 29, i32 32
]

@IP_4 = internal constant [64 x i32] [
  i32 58, i32 50, i32 42, i32 34, i32 26, i32 18, i32 10, i32 2,
  i32 60, i32 52, i32 44, i32 36, i32 28, i32 20, i32 12, i32 4,
  i32 62, i32 54, i32 46, i32 38, i32 30, i32 22, i32 14, i32 6,
  i32 64, i32 56, i32 48, i32 40, i32 32, i32 24, i32 16, i32 8,
  i32 57, i32 49, i32 41, i32 33, i32 25, i32 17, i32 9,  i32 1,
  i32 59, i32 51, i32 43, i32 35, i32 27, i32 19, i32 11, i32 3,
  i32 61, i32 53, i32 45, i32 37, i32 29, i32 21, i32 13, i32 5,
  i32 63, i32 55, i32 47, i32 39, i32 31, i32 23, i32 15, i32 7
]

@E_3 = internal constant [48 x i32] [
  i32 32, i32 1,  i32 2,  i32 3,  i32 4,  i32 5,
  i32 4,  i32 5,  i32 6,  i32 7,  i32 8,  i32 9,
  i32 8,  i32 9,  i32 10, i32 11, i32 12, i32 13,
  i32 12, i32 13, i32 14, i32 15, i32 16, i32 17,
  i32 16, i32 17, i32 18, i32 19, i32 20, i32 21,
  i32 20, i32 21, i32 22, i32 23, i32 24, i32 25,
  i32 24, i32 25, i32 26, i32 27, i32 28, i32 29,
  i32 28, i32 29, i32 30, i32 31, i32 32, i32 1
]

@SBOX_2 = internal constant [512 x i8] [
; S1
  i8 14, i8 4,  i8 13, i8 1,  i8 2,  i8 15, i8 11, i8 8,  i8 3,  i8 10, i8 6,  i8 12, i8 5,  i8 9,  i8 0,  i8 7,
  i8 0,  i8 15, i8 7,  i8 4,  i8 14, i8 2,  i8 13, i8 1,  i8 10, i8 6,  i8 12, i8 11, i8 9,  i8 5,  i8 3,  i8 8,
  i8 4,  i8 1,  i8 14, i8 8,  i8 13, i8 6,  i8 2,  i8 11, i8 15, i8 12, i8 9,  i8 7,  i8 3,  i8 10, i8 5,  i8 0,
  i8 15, i8 12, i8 8,  i8 2,  i8 4,  i8 9,  i8 1,  i8 7,  i8 5,  i8 11, i8 3,  i8 14, i8 10, i8 0,  i8 6,  i8 13,
; S2
  i8 15, i8 1,  i8 8,  i8 14, i8 6,  i8 11, i8 3,  i8 4,  i8 9,  i8 7,  i8 2,  i8 13, i8 12, i8 0,  i8 5,  i8 10,
  i8 3,  i8 13, i8 4,  i8 7,  i8 15, i8 2,  i8 8,  i8 14, i8 12, i8 0,  i8 1,  i8 10, i8 6,  i8 9,  i8 11, i8 5,
  i8 0,  i8 14, i8 7,  i8 11, i8 10, i8 4,  i8 13, i8 1,  i8 5,  i8 8,  i8 12, i8 6,  i8 9,  i8 3,  i8 2,  i8 15,
  i8 13, i8 8,  i8 10, i8 1,  i8 3,  i8 15, i8 4,  i8 2,  i8 11, i8 6,  i8 7,  i8 12, i8 0,  i8 5,  i8 14, i8 9,
; S3
  i8 10, i8 0,  i8 9,  i8 14, i8 6,  i8 3,  i8 15, i8 5,  i8 1,  i8 13, i8 12, i8 7,  i8 11, i8 4,  i8 2,  i8 8,
  i8 13, i8 7,  i8 0,  i8 9,  i8 3,  i8 4,  i8 6,  i8 10, i8 2,  i8 8,  i8 5,  i8 14, i8 12, i8 11, i8 15, i8 1,
  i8 13, i8 6,  i8 4,  i8 9,  i8 8,  i8 15, i8 3,  i8 0,  i8 11, i8 1,  i8 2,  i8 12, i8 5,  i8 10, i8 14, i8 7,
  i8 1,  i8 10, i8 13, i8 0,  i8 6,  i8 9,  i8 8,  i8 7,  i8 4,  i8 15, i8 14, i8 3,  i8 11, i8 5,  i8 2,  i8 12,
; S4
  i8 7,  i8 13, i8 14, i8 3,  i8 0,  i8 6,  i8 9,  i8 10, i8 1,  i8 2,  i8 8,  i8 5,  i8 11, i8 12, i8 4,  i8 15,
  i8 13, i8 8,  i8 11, i8 5,  i8 6,  i8 15, i8 0,  i8 3,  i8 4,  i8 7,  i8 2,  i8 12, i8 1,  i8 10, i8 14, i8 9,
  i8 10, i8 6,  i8 9,  i8 0,  i8 12, i8 11, i8 7,  i8 13, i8 15, i8 1,  i8 3,  i8 14, i8 5,  i8 2,  i8 8,  i8 4,
  i8 3,  i8 15, i8 0,  i8 6,  i8 10, i8 1,  i8 13, i8 8,  i8 9,  i8 4,  i8 5,  i8 11, i8 12, i8 7,  i8 2,  i8 14,
; S5
  i8 2,  i8 12, i8 4,  i8 1,  i8 7,  i8 10, i8 11, i8 6,  i8 8,  i8 5,  i8 3,  i8 15, i8 13, i8 0,  i8 14, i8 9,
  i8 14, i8 11, i8 2,  i8 12, i8 4,  i8 7,  i8 13, i8 1,  i8 5,  i8 0,  i8 15, i8 10, i8 3,  i8 9,  i8 8,  i8 6,
  i8 4,  i8 2,  i8 1,  i8 11, i8 10, i8 13, i8 7,  i8 8,  i8 15, i8 9,  i8 12, i8 5,  i8 6,  i8 3,  i8 0,  i8 14,
  i8 11, i8 8,  i8 12, i8 7,  i8 1,  i8 14, i8 2,  i8 13, i8 6,  i8 15, i8 0,  i8 9,  i8 10, i8 4,  i8 5,  i8 3,
; S6
  i8 12, i8 1,  i8 10, i8 15, i8 9,  i8 2,  i8 6,  i8 8,  i8 0,  i8 13, i8 3,  i8 4,  i8 14, i8 7,  i8 5,  i8 11,
  i8 10, i8 15, i8 4,  i8 2,  i8 7,  i8 12, i8 9,  i8 5,  i8 6,  i8 1,  i8 13, i8 14, i8 0,  i8 11, i8 3,  i8 8,
  i8 9,  i8 14, i8 15, i8 5,  i8 2,  i8 8,  i8 12, i8 3,  i8 7,  i8 0,  i8 4,  i8 10, i8 1,  i8 13, i8 11, i8 6,
  i8 4,  i8 3,  i8 2,  i8 12, i8 9,  i8 5,  i8 15, i8 10, i8 11, i8 14, i8 1,  i8 7,  i8 6,  i8 0,  i8 8,  i8 13,
; S7
  i8 4,  i8 11, i8 2,  i8 14, i8 15, i8 0,  i8 8,  i8 13, i8 3,  i8 12, i8 9,  i8 7,  i8 5,  i8 10, i8 6,  i8 1,
  i8 13, i8 0,  i8 11, i8 7,  i8 4,  i8 9,  i8 1,  i8 10, i8 14, i8 3,  i8 5,  i8 12, i8 2,  i8 15, i8 8,  i8 6,
  i8 1,  i8 4,  i8 11, i8 13, i8 12, i8 3,  i8 7,  i8 14, i8 10, i8 15, i8 6,  i8 8,  i8 0,  i8 5,  i8 9,  i8 2,
  i8 6,  i8 11, i8 13, i8 8,  i8 1,  i8 4,  i8 10, i8 7,  i8 9,  i8 5,  i8 0,  i8 15, i8 14, i8 2,  i8 3,  i8 12,
; S8
  i8 13, i8 2,  i8 8,  i8 4,  i8 6,  i8 15, i8 11, i8 1,  i8 10, i8 9,  i8 3,  i8 14, i8 5,  i8 0,  i8 12, i8 7,
  i8 1,  i8 15, i8 13, i8 8,  i8 10, i8 3,  i8 7,  i8 4,  i8 12, i8 5,  i8 6,  i8 11, i8 0,  i8 14, i8 9,  i8 2,
  i8 7,  i8 11, i8 4,  i8 1,  i8 9,  i8 12, i8 14, i8 2,  i8 0,  i8 6,  i8 10, i8 13, i8 15, i8 3,  i8 5,  i8 8,
  i8 2,  i8 1,  i8 14, i8 7,  i8 4,  i8 10, i8 8,  i8 13, i8 15, i8 12, i8 9,  i8 0,  i8 3,  i8 5,  i8 6,  i8 11
]

@P_1 = internal constant [32 x i32] [
  i32 16, i32 7,  i32 20, i32 21, i32 29, i32 12, i32 28, i32 17,
  i32 1,  i32 15, i32 23, i32 26, i32 5,  i32 18, i32 31, i32 10,
  i32 2,  i32 8,  i32 24, i32 14, i32 32, i32 27, i32 3,  i32 9,
  i32 19, i32 13, i32 30, i32 6,  i32 22, i32 11, i32 4,  i32 25
]

@FP_0 = internal constant [64 x i32] [
  i32 40, i32 8,  i32 48, i32 16, i32 56, i32 24, i32 64, i32 32,
  i32 39, i32 7,  i32 47, i32 15, i32 55, i32 23, i32 63, i32 31,
  i32 38, i32 6,  i32 46, i32 14, i32 54, i32 22, i32 62, i32 30,
  i32 37, i32 5,  i32 45, i32 13, i32 53, i32 21, i32 61, i32 29,
  i32 36, i32 4,  i32 44, i32 12, i32 52, i32 20, i32 60, i32 28,
  i32 35, i32 3,  i32 43, i32 11, i32 51, i32 19, i32 59, i32 27,
  i32 34, i32 2,  i32 42, i32 10, i32 50, i32 18, i32 58, i32 26,
  i32 33, i32 1,  i32 41, i32 9,  i32 49, i32 17, i32 57, i32 25
]

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 16

  br label %pc1.cond

pc1.cond:                                          ; PC-1 loop (56 bits)
  %pc1.i = phi i32 [ 0, entry ], [ %pc1.i.next, %pc1.body ]
  %pc1.acc = phi i64 [ 0, entry ], [ %pc1.acc.next, %pc1.body ]
  %pc1.cmp = icmp sle i32 %pc1.i, 55
  br i1 %pc1.cmp, label %pc1.body, label %pc1.end

pc1.body:
  %pc1.idx64 = zext i32 %pc1.i to i64
  %pc1.ptr = getelementptr inbounds [56 x i32], [56 x i32]* @PC1_7, i64 0, i64 %pc1.idx64
  %pc1.val = load i32, i32* %pc1.ptr, align 4
  %pc1.val64 = zext i32 %pc1.val to i64
  %pc1.sh = sub i64 64, %pc1.val64
  %key.sh = lshr i64 %key, %pc1.sh
  %pc1.bit = and i64 %key.sh, 1
  %pc1.acc.shl = shl i64 %pc1.acc, 1
  %pc1.acc.next = or i64 %pc1.acc.shl, %pc1.bit
  %pc1.i.next = add i32 %pc1.i, 1
  br label %pc1.cond

pc1.end:
  %sel = phi i64 [ %pc1.acc, %pc1.cond ]
  %sel_sh28 = lshr i64 %sel, 28
  %L0.tr = trunc i64 %sel_sh28 to i32
  %L0 = and i32 %L0.tr, 268435455
  %R0.z = and i64 %sel, 268435455
  %R0 = trunc i64 %R0.z to i32

  br label %ks.cond

ks.cond:                                           ; key schedule rounds 0..15
  %ks.r = phi i32 [ 0, %pc1.end ], [ %ks.r.next, %ks.afterpc2 ]
  %L = phi i32 [ %L0, %pc1.end ], [ %L.next, %ks.afterpc2 ]
  %R = phi i32 [ %R0, %pc1.end ], [ %R.next, %ks.afterpc2 ]
  %ks.cmp = icmp sle i32 %ks.r, 15
  br i1 %ks.cmp, label %ks.body, label %ks.end

ks.body:
  %ks.r64 = zext i32 %ks.r to i64
  %sh.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS_6, i64 0, i64 %ks.r64
  %sh.val = load i32, i32* %sh.ptr, align 4
  %rotL.sh = and i32 %sh.val, 31
  %L.shl = shl i32 %L, %rotL.sh
  %L.rsamt = sub i32 28, %rotL.sh
  %L.lshr = lshr i32 %L, %L.rsamt
  %L.rot = or i32 %L.shl, %L.lshr
  %L.next = and i32 %L.rot, 268435455

  %rotR.sh = and i32 %sh.val, 31
  %R.shl = shl i32 %R, %rotR.sh
  %R.rsamt = sub i32 28, %rotR.sh
  %R.lshr = lshr i32 %R, %R.rsamt
  %R.rot = or i32 %R.shl, %R.lshr
  %R.next = and i32 %R.rot, 268435455

  %L64 = zext i32 %L.next to i64
  %combL = shl i64 %L64, 28
  %R64 = zext i32 %R.next to i64
  %comb = or i64 %combL, %R64

  br label %pc2.cond

pc2.cond:                                          ; PC-2 loop (48 bits)
  %pc2.j = phi i32 [ 0, %ks.body ], [ %pc2.j.next, %pc2.body ]
  %pc2.acc = phi i64 [ 0, %ks.body ], [ %pc2.acc.next, %pc2.body ]
  %pc2.cmp = icmp sle i32 %pc2.j, 47
  br i1 %pc2.cmp, label %pc2.body, label %pc2.end

pc2.body:
  %pc2.j64 = zext i32 %pc2.j to i64
  %pc2.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @PC2_5, i64 0, i64 %pc2.j64
  %pc2.val = load i32, i32* %pc2.ptr, align 4
  %pc2.val64 = zext i32 %pc2.val to i64
  %pc2.sh = sub i64 56, %pc2.val64
  %comb.sh = lshr i64 %comb, %pc2.sh
  %pc2.bit = and i64 %comb.sh, 1
  %pc2.acc.shl = shl i64 %pc2.acc, 1
  %pc2.acc.next = or i64 %pc2.acc.shl, %pc2.bit
  %pc2.j.next = add i32 %pc2.j, 1
  br label %pc2.cond

pc2.end:
  %roundkey = phi i64 [ %pc2.acc, %pc2.cond ]
  %sk.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %ks.r64
  store i64 %roundkey, i64* %sk.ptr, align 8
  br label %ks.afterpc2

ks.afterpc2:
  %ks.r.next = add i32 %ks.r, 1
  br label %ks.cond

ks.end:
  br label %ip.cond

ip.cond:                                           ; Initial Permutation (64 bits)
  %ip.i = phi i32 [ 0, %ks.end ], [ %ip.i.next, %ip.body ]
  %ip.acc = phi i64 [ 0, %ks.end ], [ %ip.acc.next, %ip.body ]
  %ip.cmp = icmp sle i32 %ip.i, 63
  br i1 %ip.cmp, label %ip.body, label %ip.end

ip.body:
  %ip.i64 = zext i32 %ip.i to i64
  %ip.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @IP_4, i64 0, i64 %ip.i64
  %ip.val = load i32, i32* %ip.ptr, align 4
  %ip.val64 = zext i32 %ip.val to i64
  %ip.sh = sub i64 64, %ip.val64
  %blk.sh = lshr i64 %block, %ip.sh
  %ip.bit = and i64 %blk.sh, 1
  %ip.acc.shl = shl i64 %ip.acc, 1
  %ip.acc.next = or i64 %ip.acc.shl, %ip.bit
  %ip.i.next = add i32 %ip.i, 1
  br label %ip.cond

ip.end:
  %ip.res = phi i64 [ %ip.acc, %ip.cond ]
  %L.init.sh = lshr i64 %ip.res, 32
  %L.init.tr = trunc i64 %L.init.sh to i32
  %R.init.tr = trunc i64 %ip.res to i32

  br label %rounds.cond

rounds.cond:                                       ; 16 Feistel rounds
  %rnd.i = phi i32 [ 0, %ip.end ], [ %rnd.i.next, %rounds.endbody ]
  %Lr = phi i32 [ %L.init.tr, %ip.end ], [ %Lr.next, %rounds.endbody ]
  %Rr = phi i32 [ %R.init.tr, %ip.end ], [ %Rr.next, %rounds.endbody ]
  %rnd.cmp = icmp sle i32 %rnd.i, 15
  br i1 %rnd.cmp, label %rounds.body, label %rounds.end

rounds.body:
  br label %exp.cond

exp.cond:                                          ; E expansion (48 bits)
  %e.j = phi i32 [ 0, %rounds.body ], [ %e.j.next, %exp.body ]
  %e.acc = phi i64 [ 0, %rounds.body ], [ %e.acc.next, %exp.body ]
  %e.cmp = icmp sle i32 %e.j, 47
  br i1 %e.cmp, label %exp.body, label %exp.end

exp.body:
  %e.j64 = zext i32 %e.j to i64
  %e.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @E_3, i64 0, i64 %e.j64
  %e.val = load i32, i32* %e.ptr, align 4
  %e.sh32 = sub i32 32, %e.val
  %Rr.sh = lshr i32 %Rr, %e.sh32
  %e.bit32 = and i32 %Rr.sh, 1
  %e.bit64 = zext i32 %e.bit32 to i64
  %e.acc.shl = shl i64 %e.acc, 1
  %e.acc.next = or i64 %e.acc.shl, %e.bit64
  %e.j.next = add i32 %e.j, 1
  br label %exp.cond

exp.end:
  %Eout = phi i64 [ %e.acc, %exp.cond ]
  %sk.ptr2 = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 (zext (i32 %rnd.i) to i64)
  %subk = load i64, i64* %sk.ptr2, align 8
  %A0 = xor i64 %Eout, %subk

  br label %sbox.cond

sbox.cond:                                         ; 8 S-boxes
  %sb.i = phi i32 [ 0, %exp.end ], [ %sb.i.next, %sbox.body ]
  %sb.acc = phi i32 [ 0, %exp.end ], [ %sb.acc.next, %sbox.body ]
  %sb.cmp = icmp sle i32 %sb.i, 7
  br i1 %sb.cmp, label %sbox.body, label %sbox.end

sbox.body:
  %sb.i64 = zext i32 %sb.i to i64
  %mul6 = mul i64 %sb.i64, 6
  %shift6 = sub i64 42, %mul6
  %chunk = lshr i64 %A0, %shift6
  %chunk32a = trunc i64 %chunk to i32
  %chunk32 = and i32 %chunk32a, 63
  %rowhi = and i32 %chunk32, 32
  %rowhi2 = lshr i32 %rowhi, 4
  %rowlo = and i32 %chunk32, 1
  %row = or i32 %rowhi2, %rowlo
  %coltmp = lshr i32 %chunk32, 1
  %col = and i32 %coltmp, 15
  %rowx16 = shl i32 %row, 4
  %sidx = add i32 %rowx16, %col
  %sb.base = mul i32 %sb.i, 64
  %sb.off = add i32 %sb.base, %sidx
  %sb.off64 = zext i32 %sb.off to i64
  %sb.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX_2, i64 0, i64 %sb.off64
  %sb.val8 = load i8, i8* %sb.ptr, align 1
  %sb.val32 = zext i8 %sb.val8 to i32
  %sb.acc.shl = shl i32 %sb.acc, 4
  %sb.acc.next = or i32 %sb.acc.shl, %sb.val32
  %sb.i.next = add i32 %sb.i, 1
  br label %sbox.cond

sbox.end:
  %Fin = phi i32 [ %sb.acc, %sbox.cond ]

  br label %perm.cond

perm.cond:                                         ; P permutation (32 bits)
  %p.j = phi i32 [ 0, %sbox.end ], [ %p.j.next, %perm.body ]
  %p.acc = phi i32 [ 0, %sbox.end ], [ %p.acc.next, %perm.body ]
  %p.cmp = icmp sle i32 %p.j, 31
  br i1 %p.cmp, label %perm.body, label %perm.end

perm.body:
  %p.j64 = zext i32 %p.j to i64
  %p.ptr = getelementptr inbounds [32 x i32], [32 x i32]* @P_1, i64 0, i64 %p.j64
  %p.val = load i32, i32* %p.ptr, align 4
  %p.sh = sub i32 32, %p.val
  %Fin.sh = lshr i32 %Fin, %p.sh
  %p.bit = and i32 %Fin.sh, 1
  %p.acc.shl = shl i32 %p.acc, 1
  %p.acc.next = or i32 %p.acc.shl, %p.bit
  %p.j.next = add i32 %p.j, 1
  br label %perm.cond

perm.end:
  %Fout = phi i32 [ %p.acc, %perm.cond ]
  %Lr.next = %Rr
  %Rr.x = xor i32 %Lr, %Fout
  %Rr.next = %Rr.x
  %rnd.i.next = add i32 %rnd.i, 1
  br label %rounds.cond

rounds.end:
  ; After 16 rounds, preoutput is (R16 << 32) | L16
  %Rfin64 = zext i32 %Rr to i64
  %Lfin64 = zext i32 %Lr to i64
  %preL = shl i64 %Rfin64, 32
  %pre = or i64 %preL, %Lfin64

  br label %fp.cond

fp.cond:                                           ; Final Permutation (64 bits)
  %fp.i = phi i32 [ 0, %rounds.end ], [ %fp.i.next, %fp.body ]
  %fp.acc = phi i64 [ 0, %rounds.end ], [ %fp.acc.next, %fp.body ]
  %fp.cmp = icmp sle i32 %fp.i, 63
  br i1 %fp.cmp, label %fp.body, label %fp.end

fp.body:
  %fp.i64 = zext i32 %fp.i to i64
  %fp.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @FP_0, i64 0, i64 %fp.i64
  %fp.val = load i32, i32* %fp.ptr, align 4
  %fp.val64 = zext i32 %fp.val to i64
  %fp.sh = sub i64 64, %fp.val64
  %pre.sh = lshr i64 %pre, %fp.sh
  %fp.bit = and i64 %pre.sh, 1
  %fp.acc.shl = shl i64 %fp.acc, 1
  %fp.acc.next = or i64 %fp.acc.shl, %fp.bit
  %fp.i.next = add i32 %fp.i, 1
  br label %fp.cond

fp.end:
  %out = phi i64 [ %fp.acc, %fp.cond ]
  ret i64 %out
}