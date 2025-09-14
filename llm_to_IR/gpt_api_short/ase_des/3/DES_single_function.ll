; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt ; Address: 0x1189
; Intent: DES block encryption (confidence=0.98). Evidence: PC1/PC2/IP/E/SBOX/P/FP tables; 16 Feistel rounds
; Preconditions: Tables PC1_7, SHIFTS_6, PC2_5, IP_4, E_3, SBOX_2, P_1, FP_0 must be initialized per DES
; Postconditions: Returns 64-bit ciphertext for given 64-bit plaintext and 64-bit key

@PC1_7 = external constant [56 x i32], align 4
@SHIFTS_6 = external constant [16 x i32], align 4
@PC2_5 = external constant [48 x i32], align 4
@IP_4 = external constant [64 x i32], align 4
@E_3 = external constant [48 x i32], align 4
@SBOX_2 = external constant [512 x i8], align 1
@P_1 = external constant [32 x i32], align 4
@FP_0 = external constant [64 x i32], align 4

define dso_local i64 @des_encrypt(i64 %data, i64 %key) local_unnamed_addr {
entry:
  %rk = alloca [16 x i64], align 16

  ; Build 56-bit key via PC-1
  br label %pc1.loop

pc1.loop: ; i in [0..55]
  %pc1.i = phi i32 [ 0, %entry ], [ %pc1.i.next, %pc1.body ]
  %pc1.acc = phi i64 [ 0, %entry ], [ %pc1.acc.next, %pc1.body ]
  %pc1.cond = icmp sle i32 %pc1.i, 55
  br i1 %pc1.cond, label %pc1.body, label %pc1.done

pc1.body:
  %pc1.i.z = zext i32 %pc1.i to i64
  %pc1.gep = getelementptr inbounds [56 x i32], [56 x i32]* @PC1_7, i64 0, i64 %pc1.i.z
  %pc1.val = load i32, i32* %pc1.gep, align 4
  %pc1.val.z = zext i32 %pc1.val to i64
  %pc1.sh = sub i64 64, %pc1.val.z
  %pc1.shifted = lshr i64 %key, %pc1.sh
  %pc1.bit = and i64 %pc1.shifted, 1
  %pc1.acc.shl = shl i64 %pc1.acc, 1
  %pc1.acc.next = or i64 %pc1.acc.shl, %pc1.bit
  %pc1.i.next = add i32 %pc1.i, 1
  br label %pc1.loop

pc1.done:
  ; Split into C and D (28-bit each)
  %cd56 = phi i64 [ %pc1.acc, %pc1.loop ]
  %C0.tmp = lshr i64 %cd56, 28
  %C0.tr = trunc i64 %C0.tmp to i32
  %C0 = and i32 %C0.tr, 268435455
  %D0.tr = trunc i64 %cd56 to i32
  %D0 = and i32 %D0.tr, 268435455

  ; Generate 16 round keys
  br label %rk.rounds

rk.rounds: ; r in [0..15]
  %r = phi i32 [ 0, %pc1.done ], [ %r.next, %rk.next ]
  %C = phi i32 [ %C0, %pc1.done ], [ %C.next, %rk.next ]
  %D = phi i32 [ %D0, %pc1.done ], [ %D.next, %rk.next ]
  %rk.cond = icmp sle i32 %r, 15
  br i1 %rk.cond, label %rk.body, label %rk.done

rk.body:
  ; left-rotate C and D by SHIFTS_6[r] over 28 bits
  %r.z = zext i32 %r to i64
  %sh.gep = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS_6, i64 0, i64 %r.z
  %sh.val = load i32, i32* %sh.gep, align 4
  %sh.amt32 = and i32 %sh.val, 31
  %C.shl = shl i32 %C, %sh.amt32
  %C.sr.amt = sub i32 28, %sh.amt32
  %C.shr = lshr i32 %C, %C.sr.amt
  %C.rot.or = or i32 %C.shl, %C.shr
  %C.next = and i32 %C.rot.or, 268435455

  %D.shl = shl i32 %D, %sh.amt32
  %D.sr.amt = sub i32 28, %sh.amt32
  %D.shr = lshr i32 %D, %D.sr.amt
  %D.rot.or = or i32 %D.shl, %D.shr
  %D.next = and i32 %D.rot.or, 268435455

  ; merge to 56-bit
  %C64 = zext i32 %C.next to i64
  %D64 = zext i32 %D.next to i64
  %Cshift = shl i64 %C64, 28
  %CD56 = or i64 %Cshift, %D64

  ; PC-2 to get 48-bit subkey
  br label %pc2.loop

pc2.loop: ; i in [0..47]
  %pc2.i = phi i32 [ 0, %rk.body ], [ %pc2.i.next, %pc2.body ]
  %pc2.acc = phi i64 [ 0, %rk.body ], [ %pc2.acc.next, %pc2.body ]
  %pc2.cond = icmp sle i32 %pc2.i, 47
  br i1 %pc2.cond, label %pc2.body, label %pc2.done

pc2.body:
  %pc2.i.z = zext i32 %pc2.i to i64
  %pc2.gep = getelementptr inbounds [48 x i32], [48 x i32]* @PC2_5, i64 0, i64 %pc2.i.z
  %pc2.val = load i32, i32* %pc2.gep, align 4
  %pc2.val.z = zext i32 %pc2.val to i64
  %pc2.sh = sub i64 56, %pc2.val.z
  %pc2.shifted = lshr i64 %CD56, %pc2.sh
  %pc2.bit = and i64 %pc2.shifted, 1
  %pc2.acc.shl = shl i64 %pc2.acc, 1
  %pc2.acc.next = or i64 %pc2.acc.shl, %pc2.bit
  %pc2.i.next = add i32 %pc2.i, 1
  br label %pc2.loop

pc2.done:
  %subkey = phi i64 [ %pc2.acc, %pc2.loop ]
  ; store subkey
  %rk.ptr0 = getelementptr inbounds [16 x i64], [16 x i64]* %rk, i64 0, i64 %r.z
  store i64 %subkey, i64* %rk.ptr0, align 8
  %r.next = add i32 %r, 1
  br label %rk.rounds

rk.done:
  ; Initial Permutation on data
  br label %ip.loop

ip.loop: ; i in [0..63]
  %ip.i = phi i32 [ 0, %rk.done ], [ %ip.i.next, %ip.body ]
  %ip.acc = phi i64 [ 0, %rk.done ], [ %ip.acc.next, %ip.body ]
  %ip.cond = icmp sle i32 %ip.i, 63
  br i1 %ip.cond, label %ip.body, label %ip.done

ip.body:
  %ip.i.z = zext i32 %ip.i to i64
  %ip.gep = getelementptr inbounds [64 x i32], [64 x i32]* @IP_4, i64 0, i64 %ip.i.z
  %ip.val = load i32, i32* %ip.gep, align 4
  %ip.val.z = zext i32 %ip.val to i64
  %ip.sh = sub i64 64, %ip.val.z
  %ip.shifted = lshr i64 %data, %ip.sh
  %ip.bit = and i64 %ip.shifted, 1
  %ip.acc.shl = shl i64 %ip.acc, 1
  %ip.acc.next = or i64 %ip.acc.shl, %ip.bit
  %ip.i.next = add i32 %ip.i, 1
  br label %ip.loop

ip.done:
  %ip.res = phi i64 [ %ip.acc, %ip.loop ]
  %L0.tmp = lshr i64 %ip.res, 32
  %L0 = trunc i64 %L0.tmp to i32
  %R0.tr = trunc i64 %ip.res to i32
  %R0 = and i32 %R0.tr, 4294967295

  ; 16 Feistel rounds
  br label %round.loop

round.loop: ; round in [0..15]
  %round = phi i32 [ 0, %ip.done ], [ %round.next, %round.end ]
  %L = phi i32 [ %L0, %ip.done ], [ %L.next, %round.end ]
  %R = phi i32 [ %R0, %ip.done ], [ %R.next, %round.end ]
  %round.cond = icmp sle i32 %round, 15
  br i1 %round.cond, label %round.body, label %rounds.done

round.body:
  ; E-expansion of R (32 -> 48)
  br label %E.loop

E.loop: ; i in [0..47]
  %E.i = phi i32 [ 0, %round.body ], [ %E.i.next, %E.body ]
  %E.acc = phi i64 [ 0, %round.body ], [ %E.acc.next, %E.body ]
  %E.cond = icmp sle i32 %E.i, 47
  br i1 %E.cond, label %E.body, label %E.done

E.body:
  %E.i.z = zext i32 %E.i to i64
  %E.gep = getelementptr inbounds [48 x i32], [48 x i32]* @E_3, i64 0, i64 %E.i.z
  %E.val = load i32, i32* %E.gep, align 4
  %E.sh.amt = sub i32 32, %E.val
  %R.shifted = lshr i32 %R, %E.sh.amt
  %R.bit = and i32 %R.shifted, 1
  %R.bit.z = zext i32 %R.bit to i64
  %E.acc.shl = shl i64 %E.acc, 1
  %E.acc.next = or i64 %E.acc.shl, %R.bit.z
  %E.i.next = add i32 %E.i, 1
  br label %E.loop

E.done:
  %B48 = phi i64 [ %E.acc, %E.loop ]
  ; XOR with round key
  %round.z = zext i32 %round to i64
  %rk.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %rk, i64 0, i64 %round.z
  %rk.val = load i64, i64* %rk.ptr, align 8
  %A48 = xor i64 %B48, %rk.val

  ; S-box substitution to 32 bits
  br label %sbox.loop

sbox.loop: ; j in [0..7]
  %j = phi i32 [ 0, %E.done ], [ %j.next, %sbox.body ]
  %S.acc = phi i32 [ 0, %E.done ], [ %S.acc.next, %sbox.body ]
  %sbox.cond = icmp sle i32 %j, 7
  br i1 %sbox.cond, label %sbox.body, label %sbox.done

sbox.body:
  ; extract 6-bit chunk starting at bit 42 - 6*j
  %j.mul6 = mul i32 %j, 6
  %shift.base = sub i32 42, %j.mul6
  %shift.base.z = zext i32 %shift.base to i64
  %chunk.shifted = lshr i64 %A48, %shift.base.z
  %chunk6 = and i64 %chunk.shifted, 63
  %chunk6.i32 = trunc i64 %chunk6 to i32

  ; row = ((val>>4)&2) | (val&1)
  %row.hi = lshr i32 %chunk6.i32, 4
  %row.hi2 = and i32 %row.hi, 2
  %row.lo = and i32 %chunk6.i32, 1
  %row = or i32 %row.hi2, %row.lo

  ; col = (val>>1) & 0xF
  %col.tmp = lshr i32 %chunk6.i32, 1
  %col = and i32 %col.tmp, 15

  %row.shl4 = shl i32 %row, 4
  %s.idx.in = add i32 %row.shl4, %col
  %j.shl6 = shl i32 %j, 6
  %s.idx = add i32 %s.idx.in, %j.shl6
  %s.idx.z = zext i32 %s.idx to i64
  %s.gep = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX_2, i64 0, i64 %s.idx.z
  %s.val8 = load i8, i8* %s.gep, align 1
  %s.val32 = zext i8 %s.val8 to i32

  %S.acc.shl = shl i32 %S.acc, 4
  %S.acc.next = or i32 %S.acc.shl, %s.val32
  %j.next = add i32 %j, 1
  br label %sbox.loop

sbox.done:
  %S32 = phi i32 [ %S.acc, %sbox.loop ]

  ; P permutation (32 -> 32)
  br label %P.loop

P.loop: ; i in [0..31]
  %P.i = phi i32 [ 0, %sbox.done ], [ %P.i.next, %P.body ]
  %P.acc = phi i32 [ 0, %sbox.done ], [ %P.acc.next, %P.body ]
  %P.cond = icmp sle i32 %P.i, 31
  br i1 %P.cond, label %P.body, label %P.done

P.body:
  %P.i.z = zext i32 %P.i to i64
  %P.gep = getelementptr inbounds [32 x i32], [32 x i32]* @P_1, i64 0, i64 %P.i.z
  %P.val = load i32, i32* %P.gep, align 4
  %P.sh.amt = sub i32 32, %P.val
  %S.shifted = lshr i32 %S32, %P.sh.amt
  %S.bit = and i32 %S.shifted, 1
  %P.acc.shl = shl i32 %P.acc, 1
  %P.acc.next = or i32 %P.acc.shl, %S.bit
  %P.i.next = add i32 %P.i, 1
  br label %P.loop

P.done:
  %fout = phi i32 [ %P.acc, %P.loop ]

  ; Feistel combine
  %R.save = %R
  %L.xor = xor i32 %L, %fout
  %L.next = %R.save
  %R.next = %L.xor
  %round.next = add i32 %round, 1
  br label %round.loop

rounds.done:
  ; Combine R||L (note swap) then final permutation
  %R.z = zext i32 %R to i64
  %L.z = zext i32 %L to i64
  %pre.shl = shl i64 %R.z, 32
  %pre = or i64 %pre.shl, %L.z

  br label %fp.loop

fp.loop: ; i in [0..63]
  %fp.i = phi i32 [ 0, %rounds.done ], [ %fp.i.next, %fp.body ]
  %fp.acc = phi i64 [ 0, %rounds.done ], [ %fp.acc.next, %fp.body ]
  %fp.cond = icmp sle i32 %fp.i, 63
  br i1 %fp.cond, label %fp.body, label %fp.done

fp.body:
  %fp.i.z = zext i32 %fp.i to i64
  %fp.gep = getelementptr inbounds [64 x i32], [64 x i32]* @FP_0, i64 0, i64 %fp.i.z
  %fp.val = load i32, i32* %fp.gep, align 4
  %fp.val.z = zext i32 %fp.val to i64
  %fp.sh = sub i64 64, %fp.val.z
  %fp.shifted = lshr i64 %pre, %fp.sh
  %fp.bit = and i64 %fp.shifted, 1
  %fp.acc.shl = shl i64 %fp.acc, 1
  %fp.acc.next = or i64 %fp.acc.shl, %fp.bit
  %fp.i.next = add i32 %fp.i, 1
  br label %fp.loop

fp.done:
  %out = phi i64 [ %fp.acc, %fp.loop ]
  ret i64 %out
}