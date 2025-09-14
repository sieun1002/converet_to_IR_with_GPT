; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt  ; Address: 0x1189
; Intent: DES block encryption (ECB, single block) with provided 64-bit key (confidence=0.98). Evidence: PC1/PC2/IP/E/P/SBOX/FP tables; 16-round Feistel structure.
; Preconditions: Inputs are 64-bit block and 64-bit key (key may include parity bits).
; Postconditions: Returns 64-bit DES-encrypted block.

@PC1_7 = internal constant [56 x i32] [
  i32 57, i32 49, i32 41, i32 33, i32 25, i32 17, i32 9,
  i32 1,  i32 58, i32 50, i32 42, i32 34, i32 26, i32 18,
  i32 10, i32 2,  i32 59, i32 51, i32 43, i32 35, i32 27, i32 19,
  i32 11, i32 3,  i32 60, i32 52, i32 44, i32 36,
  i32 63, i32 55, i32 47, i32 39, i32 31, i32 23, i32 15, i32 7,
  i32 62, i32 54, i32 46, i32 38, i32 30, i32 22, i32 14, i32 6,
  i32 61, i32 53, i32 45, i32 37, i32 29, i32 21, i32 13, i32 5
], align 4

@SHIFTS_6 = internal constant [16 x i32] [
  i32 1, i32 1, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2,
  i32 1, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 1
], align 4

@PC2_5 = internal constant [48 x i32] [
  i32 14, i32 17, i32 11, i32 24, i32 1,  i32 5,
  i32 3,  i32 28, i32 15, i32 6,  i32 21, i32 10,
  i32 23, i32 19, i32 12, i32 4,  i32 26, i32 8,
  i32 16, i32 7,  i32 27, i32 20, i32 13, i32 2,
  i32 41, i32 52, i32 31, i32 37, i32 47, i32 55,
  i32 30, i32 40, i32 51, i32 45, i32 33, i32 48,
  i32 44, i32 49, i32 39, i32 56, i32 34, i32 53,
  i32 46, i32 42, i32 50, i32 36, i32 29, i32 32
], align 4

@IP_4 = internal constant [64 x i32] [
  i32 58, i32 50, i32 42, i32 34, i32 26, i32 18, i32 10, i32 2,
  i32 60, i32 52, i32 44, i32 36, i32 28, i32 20, i32 12, i32 4,
  i32 62, i32 54, i32 46, i32 38, i32 30, i32 22, i32 14, i32 6,
  i32 64, i32 56, i32 48, i32 40, i32 32, i32 24, i32 16, i32 8,
  i32 57, i32 49, i32 41, i32 33, i32 25, i32 17, i32 9,  i32 1,
  i32 59, i32 51, i32 43, i32 35, i32 27, i32 19, i32 11, i32 3,
  i32 61, i32 53, i32 45, i32 37, i32 29, i32 21, i32 13, i32 5,
  i32 63, i32 55, i32 47, i32 39, i32 31, i32 23, i32 15, i32 7
], align 4

@E_3 = internal constant [48 x i32] [
  i32 32, i32 1,  i32 2,  i32 3,  i32 4,  i32 5,
  i32 4,  i32 5,  i32 6,  i32 7,  i32 8,  i32 9,
  i32 8,  i32 9,  i32 10, i32 11, i32 12, i32 13,
  i32 12, i32 13, i32 14, i32 15, i32 16, i32 17,
  i32 16, i32 17, i32 18, i32 19, i32 20, i32 21,
  i32 20, i32 21, i32 22, i32 23, i32 24, i32 25,
  i32 24, i32 25, i32 26, i32 27, i32 28, i32 29,
  i32 28, i32 29, i32 30, i32 31, i32 32, i32 1
], align 4

@P_1 = internal constant [32 x i32] [
  i32 16, i32 7,  i32 20, i32 21,
  i32 29, i32 12, i32 28, i32 17,
  i32 1,  i32 15, i32 23, i32 26,
  i32 5,  i32 18, i32 31, i32 10,
  i32 2,  i32 8,  i32 24, i32 14,
  i32 32, i32 27, i32 3,  i32 9,
  i32 19, i32 13, i32 30, i32 6,
  i32 22, i32 11, i32 4,  i32 25
], align 4

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
], align 1

@FP_0 = internal constant [64 x i32] [
  i32 40, i32 8,  i32 48, i32 16, i32 56, i32 24, i32 64, i32 32,
  i32 39, i32 7,  i32 47, i32 15, i32 55, i32 23, i32 63, i32 31,
  i32 38, i32 6,  i32 46, i32 14, i32 54, i32 22, i32 62, i32 30,
  i32 37, i32 5,  i32 45, i32 13, i32 53, i32 21, i32 61, i32 29,
  i32 36, i32 4,  i32 44, i32 12, i32 52, i32 20, i32 60, i32 28,
  i32 35, i32 3,  i32 43, i32 11, i32 51, i32 19, i32 59, i32 27,
  i32 34, i32 2,  i32 42, i32 10, i32 50, i32 18, i32 58, i32 26,
  i32 33, i32 1,  i32 41, i32 9,  i32 49, i32 17, i32 57, i32 25
], align 4

declare void @___stack_chk_fail() noreturn

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %canary = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  %subkeys = alloca [16 x i64], align 16
  ; PC1: generate 56-bit key
  br label %pc1.loop

pc1.loop:
  %k56.phi = phi i64 [ 0, %entry ], [ %k56.next, %pc1.loop.body ]
  %i.phi = phi i32 [ 0, %entry ], [ %i.next, %pc1.loop.body ]
  %pc1.cond = icmp sle i32 %i.phi, 55
  br i1 %pc1.cond, label %pc1.loop.body, label %pc1.done

pc1.loop.body:
  %idx64 = sext i32 %i.phi to i64
  %pc1.ptr = getelementptr inbounds [56 x i32], [56 x i32]* @PC1_7, i64 0, i64 %idx64
  %pc1.val = load i32, i32* %pc1.ptr, align 4
  %pc1.val64 = zext i32 %pc1.val to i64
  %shift1.tmp = sub i64 64, %pc1.val64
  %bit1.shifted = lshr i64 %key, %shift1.tmp
  %bit1 = and i64 %bit1.shifted, 1
  %k56.shl = shl i64 %k56.phi, 1
  %k56.next = or i64 %k56.shl, %bit1
  %i.next = add nsw i32 %i.phi, 1
  br label %pc1.loop

pc1.done:
  ; Split into C and D (28-bit each)
  %C0.pre = lshr i64 %k56.phi, 28
  %C0 = and i64 %C0.pre, 268435455
  %D0 = and i64 %k56.phi, 268435455
  %C0.i32 = trunc i64 %C0 to i32
  %D0.i32 = trunc i64 %D0 to i32
  br label %roundkey.loop

roundkey.loop:
  %rk.i = phi i32 [ 0, %pc1.done ], [ %rk.i.next, %roundkey.after ]
  %C.phi = phi i32 [ %C0.i32, %pc1.done ], [ %C.next, %roundkey.after ]
  %D.phi = phi i32 [ %D0.i32, %pc1.done ], [ %D.next, %roundkey.after ]
  %rk.cond = icmp sle i32 %rk.i, 15
  br i1 %rk.cond, label %roundkey.body, label %roundkey.done

roundkey.body:
  ; left shifts
  %rk.idx64 = sext i32 %rk.i to i64
  %shifts.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS_6, i64 0, i64 %rk.idx64
  %samt32 = load i32, i32* %shifts.ptr, align 4
  %samt = and i32 %samt32, 31
  %inv = sub i32 28, %samt
  %C.shl = shl i32 %C.phi, %samt
  %C.shr = lshr i32 %C.phi, %inv
  %C.or = or i32 %C.shl, %C.shr
  %C.mask = and i32 %C.or, 268435455
  %D.shl = shl i32 %D.phi, %samt
  %D.shr = lshr i32 %D.phi, %inv
  %D.or = or i32 %D.shl, %D.shr
  %D.mask = and i32 %D.or, 268435455
  ; combine 56-bit
  %C64 = zext i32 %C.mask to i64
  %D64 = zext i32 %D.mask to i64
  %Cshift = shl i64 %C64, 28
  %CD = or i64 %Cshift, %D64
  ; PC2 to generate 48-bit subkey
  br label %pc2.loop

pc2.loop:
  %sk.phi = phi i64 [ 0, %roundkey.body ], [ %sk.next, %pc2.body ]
  %j.phi = phi i32 [ 0, %roundkey.body ], [ %j.next, %pc2.body ]
  %pc2.cond = icmp sle i32 %j.phi, 47
  br i1 %pc2.cond, label %pc2.body, label %pc2.done

pc2.body:
  %j64 = sext i32 %j.phi to i64
  %pc2.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @PC2_5, i64 0, i64 %j64
  %pc2.val32 = load i32, i32* %pc2.ptr, align 4
  %pc2.val64 = zext i32 %pc2.val32 to i64
  %shift2 = sub i64 56, %pc2.val64
  %bit2.shifted = lshr i64 %CD, %shift2
  %bit2 = and i64 %bit2.shifted, 1
  %sk.shl = shl i64 %sk.phi, 1
  %sk.next = or i64 %sk.shl, %bit2
  %j.next = add nsw i32 %j.phi, 1
  br label %pc2.loop

pc2.done:
  ; store subkey
  %subkeys.ptr0 = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %rk.idx64
  store i64 %sk.phi, i64* %subkeys.ptr0, align 8
  ; carry C and D
  %C.next = %C.mask
  %D.next = %D.mask
  %rk.i.next = add nsw i32 %rk.i, 1
  br label %roundkey.loop

roundkey.done:
  ; Initial Permutation on input block
  br label %ip.loop

ip.loop:
  %ip.acc.phi = phi i64 [ 0, %roundkey.done ], [ %ip.acc.next, %ip.body ]
  %ip.i.phi = phi i32 [ 0, %roundkey.done ], [ %ip.i.next, %ip.body ]
  %ip.cond = icmp sle i32 %ip.i.phi, 63
  br i1 %ip.cond, label %ip.body, label %ip.done

ip.body:
  %ip.idx64 = sext i32 %ip.i.phi to i64
  %ip.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @IP_4, i64 0, i64 %ip.idx64
  %ip.val32 = load i32, i32* %ip.ptr, align 4
  %ip.val64 = zext i32 %ip.val32 to i64
  %ip.shift = sub i64 64, %ip.val64
  %ip.bit.shifted = lshr i64 %block, %ip.shift
  %ip.bit = and i64 %ip.bit.shifted, 1
  %ip.acc.shl = shl i64 %ip.acc.phi, 1
  %ip.acc.next = or i64 %ip.acc.shl, %ip.bit
  %ip.i.next = add nsw i32 %ip.i.phi, 1
  br label %ip.loop

ip.done:
  %L0_64 = lshr i64 %ip.acc.phi, 32
  %L0_32 = trunc i64 %L0_64 to i32
  %R0_32 = trunc i64 %ip.acc.phi to i32
  br label %rounds.loop

rounds.loop:
  %round.i = phi i32 [ 0, %ip.done ], [ %round.i.next, %round.end ]
  %L.phi = phi i32 [ %L0_32, %ip.done ], [ %L.next, %round.end ]
  %R.phi = phi i32 [ %R0_32, %ip.done ], [ %R.next, %round.end ]
  %round.cond = icmp sle i32 %round.i, 15
  br i1 %round.cond, label %round.body, label %rounds.done

round.body:
  ; E-expansion of R
  %R.z64 = zext i32 %R.phi to i64
  br label %e.loop

e.loop:
  %e.acc.phi = phi i64 [ 0, %round.body ], [ %e.acc.next, %e.body ]
  %e.i.phi = phi i32 [ 0, %round.body ], [ %e.i.next, %e.body ]
  %e.cond = icmp sle i32 %e.i.phi, 47
  br i1 %e.cond, label %e.body, label %e.done

e.body:
  %e.idx64 = sext i32 %e.i.phi to i64
  %e.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @E_3, i64 0, i64 %e.idx64
  %e.val32 = load i32, i32* %e.ptr, align 4
  %e.val32.mask = and i32 %e.val32, 31
  %e.val64 = zext i32 %e.val32.mask to i64
  %e.shift = sub i64 32, %e.val64
  %e.bit.shifted = lshr i64 %R.z64, %e.shift
  %e.bit = and i64 %e.bit.shifted, 1
  %e.acc.shl = shl i64 %e.acc.phi, 1
  %e.acc.next = or i64 %e.acc.shl, %e.bit
  %e.i.next = add nsw i32 %e.i.phi, 1
  br label %e.loop

e.done:
  ; XOR with subkey[round.i]
  %rk.idx64.2 = sext i32 %round.i to i64
  %subkey.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %rk.idx64.2
  %subkey.val = load i64, i64* %subkey.ptr, align 8
  %x = xor i64 %e.acc.phi, %subkey.val
  ; S-boxes
  br label %s.loop

s.loop:
  %s.acc.phi = phi i32 [ 0, %e.done ], [ %s.acc.next, %s.body ]
  %s.i.phi = phi i32 [ 0, %e.done ], [ %s.i.next, %s.body ]
  %s.cond = icmp sle i32 %s.i.phi, 7
  br i1 %s.cond, label %s.body, label %s.done

s.body:
  %si = %s.i.phi
  %si.mul6 = mul nsw i32 %si, 6
  %shift.base = sub nsw i32 42, %si.mul6
  %shift.base64 = zext i32 %shift.base to i64
  %chunk.shifted = lshr i64 %x, %shift.base64
  %chunk = and i64 %chunk.shifted, 63
  %chunk.i32 = trunc i64 %chunk to i32
  %row.high = and i32 %chunk.i32, 32
  %row.high.sh = lshr i32 %row.high, 4
  %row.low = and i32 %chunk.i32, 1
  %row = or i32 %row.high.sh, %row.low
  %col.tmp = lshr i32 %chunk.i32, 1
  %col = and i32 %col.tmp, 15
  %row.mul16 = shl i32 %row, 4
  %s.index = add nsw i32 %row.mul16, %col
  %base64 = mul nsw i32 %si, 64
  %s.offset = add nsw i32 %base64, %s.index
  %s.offset64 = sext i32 %s.offset to i64
  %s.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX_2, i64 0, i64 %s.offset64
  %s.val.i8 = load i8, i8* %s.ptr, align 1
  %s.val.i32 = zext i8 %s.val.i8 to i32
  %s.acc.shl = shl i32 %s.acc.phi, 4
  %s.acc.next = or i32 %s.acc.shl, %s.val.i32
  %s.i.next = add nsw i32 %s.i.phi, 1
  br label %s.loop

s.done:
  ; P permutation on 32-bit s.acc
  br label %p.loop

p.loop:
  %p.acc.phi = phi i32 [ 0, %s.done ], [ %p.acc.next, %p.body ]
  %p.i.phi = phi i32 [ 0, %s.done ], [ %p.i.next, %p.body ]
  %p.cond = icmp sle i32 %p.i.phi, 31
  br i1 %p.cond, label %p.body, label %p.done

p.body:
  %p.idx64 = sext i32 %p.i.phi to i64
  %p.ptr = getelementptr inbounds [32 x i32], [32 x i32]* @P_1, i64 0, i64 %p.idx64
  %p.val32 = load i32, i32* %p.ptr, align 4
  %p.val32.mask = and i32 %p.val32, 31
  %p.shift = sub i32 32, %p.val32.mask
  %p.bit.shifted = lshr i32 %s.acc.phi, %p.shift
  %p.bit = and i32 %p.bit.shifted, 1
  %p.acc.shl = shl i32 %p.acc.phi, 1
  %p.acc.next = or i32 %p.acc.shl, %p.bit
  %p.i.next = add nsw i32 %p.i.phi, 1
  br label %p.loop

p.done:
  %Lnext = %R.phi
  %pacc64 = zext i32 %p.acc.phi to i64
  %L64 = zext i32 %L.phi to i64
  %xor64 = xor i64 %L64, %pacc64
  %Rnext = trunc i64 %xor64 to i32
  br label %round.end

round.end:
  %L.next = %Lnext
  %R.next = %Rnext
  %round.i.next = add nsw i32 %round.i, 1
  br label %rounds.loop

rounds.done:
  ; Pre-output swap: (R << 32) | L
  %R.out64 = zext i32 %R.phi to i64
  %L.out64 = zext i32 %L.phi to i64
  %R.shl32 = shl i64 %R.out64, 32
  %preout = or i64 %R.shl32, %L.out64
  ; Final Permutation
  br label %fp.loop

fp.loop:
  %fp.acc.phi = phi i64 [ 0, %rounds.done ], [ %fp.acc.next, %fp.body ]
  %fp.i.phi = phi i32 [ 0, %rounds.done ], [ %fp.i.next, %fp.body ]
  %fp.cond = icmp sle i32 %fp.i.phi, 63
  br i1 %fp.cond, label %fp.body, label %epilogue

fp.body:
  %fp.idx64 = sext i32 %fp.i.phi to i64
  %fp.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @FP_0, i64 0, i64 %fp.idx64
  %fp.val32 = load i32, i32* %fp.ptr, align 4
  %fp.val64 = zext i32 %fp.val32 to i64
  %fp.shift = sub i64 64, %fp.val64
  %fp.bit.shifted = lshr i64 %preout, %fp.shift
  %fp.bit = and i64 %fp.bit.shifted, 1
  %fp.acc.shl = shl i64 %fp.acc.phi, 1
  %fp.acc.next = or i64 %fp.acc.shl, %fp.bit
  %fp.i.next = add nsw i32 %fp.i.phi, 1
  br label %fp.loop

epilogue:
  %end_canary = call i64 asm sideeffect "movq %fs:0x28, $0", "=r"()
  %canary.ok = icmp eq i64 %canary, %end_canary
  br i1 %canary.ok, label %ret, label %stkfail

stkfail:
  call void @___stack_chk_fail()
  unreachable

ret:
  ret i64 %fp.acc.phi
}