; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt  ; Address: 0x1189
; Intent: DES single-block encryption using 16-round Feistel network with standard tables (confidence=0.95). Evidence: use of IP/E/P/FP tables and 8x64 S-box lookups.
; Preconditions: %block is a 64-bit data block; %key is a 64-bit DES key (parity handling per PC1).
; Postconditions: Returns the 64-bit ciphertext after DES encryption.

@PC1_7 = external constant [56 x i32], align 4
@SHIFTS_6 = external constant [16 x i32], align 4
@PC2_5 = external constant [48 x i32], align 4
@IP_4 = external constant [64 x i32], align 4
@E_3 = external constant [48 x i32], align 4
@SBOX_2 = external constant [512 x i8], align 1
@P_1 = external constant [32 x i32], align 4
@FP_0 = external constant [64 x i32], align 4

; Only the needed extern declarations:

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 8

  ; Build 56-bit key from PC1
  br label %pc1.loop

pc1.loop:
  %pc1.i = phi i32 [ 0, %entry ], [ %pc1.i.next, %pc1.inc ]
  %d0 = phi i64 [ 0, %entry ], [ %d0.next, %pc1.inc ]
  %pc1.cmp = icmp sle i32 %pc1.i, 55
  br i1 %pc1.cmp, label %pc1.body, label %pc1.done

pc1.body:
  %pc1.idx.z = zext i32 %pc1.i to i64
  %pc1.ptr = getelementptr inbounds [56 x i32], [56 x i32]* @PC1_7, i64 0, i64 %pc1.idx.z
  %pc1.val = load i32, i32* %pc1.ptr, align 4
  %pc1.sh32 = sub i32 64, %pc1.val
  %pc1.sh64 = zext i32 %pc1.sh32 to i64
  %pc1.shifted = lshr i64 %key, %pc1.sh64
  %pc1.bit = and i64 %pc1.shifted, 1
  %d0.shl = shl i64 %d0, 1
  %d0.next = or i64 %d0.shl, %pc1.bit
  br label %pc1.inc

pc1.inc:
  %pc1.i.next = add i32 %pc1.i, 1
  br label %pc1.loop

pc1.done:
  ; Split into C and D (28-bit each)
  %d0.high = lshr i64 %d0, 28
  %d0.high.tr = trunc i64 %d0.high to i32
  %C0.mask = and i32 %d0.high.tr, 268435455
  %d0.low.tr = trunc i64 %d0 to i32
  %D0.mask = and i32 %d0.low.tr, 268435455

  ; Generate 16 subkeys
  br label %ks.loop

ks.loop:
  %r = phi i32 [ 0, %pc1.done ], [ %r.next, %ks.inc ]
  %C = phi i32 [ %C0.mask, %pc1.done ], [ %C.next.mask, %ks.inc ]
  %D = phi i32 [ %D0.mask, %pc1.done ], [ %D.next.mask, %ks.inc ]
  %ks.cmp = icmp sle i32 %r, 15
  br i1 %ks.cmp, label %ks.body, label %ks.done

ks.body:
  ; left-rotate C and D by SHIFTS[r]
  %sh.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS_6, i64 0, i64 (zext i32 %r to i64)
  %sh.val = load i32, i32* %sh.ptr, align 4
  %twenty8 = add i32 0, 28
  %invsh = sub i32 %twenty8, %sh.val
  %C.shl = shl i32 %C, %sh.val
  %C.shr = lshr i32 %C, %invsh
  %C.rot = or i32 %C.shl, %C.shr
  %C.next.mask = and i32 %C.rot, 268435455
  %D.shl = shl i32 %D, %sh.val
  %D.shr = lshr i32 %D, %invsh
  %D.rot = or i32 %D.shl, %D.shr
  %D.next.mask = and i32 %D.rot, 268435455

  ; Combine to 56-bit and apply PC2 to form 48-bit subkey
  %C64 = zext i32 %C.next.mask to i64
  %D64 = zext i32 %D.next.mask to i64
  %CD = or i64 (shl i64 %C64, 28), %D64

  br label %pc2.loop

pc2.loop:
  %pc2.i = phi i32 [ 0, %ks.body ], [ %pc2.i.next, %pc2.inc ]
  %sk = phi i64 [ 0, %ks.body ], [ %sk.next, %pc2.inc ]
  %pc2.cmp = icmp sle i32 %pc2.i, 47
  br i1 %pc2.cmp, label %pc2.body, label %pc2.done

pc2.body:
  %pc2.idx.z = zext i32 %pc2.i to i64
  %pc2.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @PC2_5, i64 0, i64 %pc2.idx.z
  %pc2.val = load i32, i32* %pc2.ptr, align 4
  %pc2.sh32 = sub i32 56, %pc2.val
  %pc2.sh64 = zext i32 %pc2.sh32 to i64
  %pc2.bit64 = lshr i64 %CD, %pc2.sh64
  %pc2.bit = and i64 %pc2.bit64, 1
  %sk.shl = shl i64 %sk, 1
  %sk.next = or i64 %sk.shl, %pc2.bit
  br label %pc2.inc

pc2.inc:
  %pc2.i.next = add i32 %pc2.i, 1
  br label %pc2.loop

pc2.done:
  ; store subkey sk into subkeys[r]
  %sk.slot.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 (zext i32 %r to i64)
  store i64 %sk, i64* %sk.slot.ptr, align 8
  br label %ks.inc

ks.inc:
  %r.next = add i32 %r, 1
  br label %ks.loop

ks.done:
  ; Initial Permutation IP on input block
  br label %ip.loop

ip.loop:
  %ip.i = phi i32 [ 0, %ks.done ], [ %ip.i.next, %ip.inc ]
  %ip.acc = phi i64 [ 0, %ks.done ], [ %ip.acc.next, %ip.inc ]
  %ip.cmp = icmp sle i32 %ip.i, 63
  br i1 %ip.cmp, label %ip.body, label %ip.done

ip.body:
  %ip.idx.z = zext i32 %ip.i to i64
  %ip.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @IP_4, i64 0, i64 %ip.idx.z
  %ip.val = load i32, i32* %ip.ptr, align 4
  %ip.sh32 = sub i32 64, %ip.val
  %ip.sh64 = zext i32 %ip.sh32 to i64
  %ip.bit64 = lshr i64 %block, %ip.sh64
  %ip.bit = and i64 %ip.bit64, 1
  %ip.acc.shl = shl i64 %ip.acc, 1
  %ip.acc.next = or i64 %ip.acc.shl, %ip.bit
  br label %ip.inc

ip.inc:
  %ip.i.next = add i32 %ip.i, 1
  br label %ip.loop

ip.done:
  %L0.hi = lshr i64 %ip.acc, 32
  %L0.tr = trunc i64 %L0.hi to i32
  %R0.tr = trunc i64 %ip.acc to i32

  ; 16 Feistel rounds
  br label %round.loop

round.loop:
  %round = phi i32 [ 0, %ip.done ], [ %round.next, %round.inc ]
  %L = phi i32 [ %L0.tr, %ip.done ], [ %L.next, %round.inc ]
  %R = phi i32 [ %R0.tr, %ip.done ], [ %R.next, %round.inc ]
  %round.cmp = icmp sle i32 %round, 15
  br i1 %round.cmp, label %round.body, label %round.done

round.body:
  ; Expansion E on R to 48 bits
  br label %e.loop

e.loop:
  %e.i = phi i32 [ 0, %round.body ], [ %e.i.next, %e.inc ]
  %Eacc = phi i64 [ 0, %round.body ], [ %Eacc.next, %e.inc ]
  %e.cmp = icmp sle i32 %e.i, 47
  br i1 %e.cmp, label %e.body, label %e.done

e.body:
  %e.idx.z = zext i32 %e.i to i64
  %e.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @E_3, i64 0, i64 %e.idx.z
  %e.val = load i32, i32* %e.ptr, align 4
  %e.sh32 = sub i32 32, %e.val
  %R.sh = lshr i32 %R, %e.sh32
  %R.bit = and i32 %R.sh, 1
  %R.bit64 = zext i32 %R.bit to i64
  %Eacc.shl = shl i64 %Eacc, 1
  %Eacc.next = or i64 %Eacc.shl, %R.bit64
  br label %e.inc

e.inc:
  %e.i.next = add i32 %e.i, 1
  br label %e.loop

e.done:
  ; XOR with subkey
  %sk.load.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 (zext i32 %round to i64)
  %sk.load = load i64, i64* %sk.load.ptr, align 8
  %x = xor i64 %Eacc, %sk.load

  ; S-box substitution to 32 bits
  br label %sbox.loop

sbox.loop:
  %sb.i = phi i32 [ 0, %e.done ], [ %sb.i.next, %sbox.inc ]
  %Sacc = phi i32 [ 0, %e.done ], [ %Sacc.next, %sbox.inc ]
  %sbox.cmp = icmp sle i32 %sb.i, 7
  br i1 %sbox.cmp, label %sbox.body, label %sbox.done

sbox.body:
  %mul6 = mul i32 %sb.i, 6
  %sh.base = sub i32 42, %mul6
  %sh.base64 = zext i32 %sh.base to i64
  %chunk64 = lshr i64 %x, %sh.base64
  %chunk6 = and i64 %chunk64, 63
  %chunk32 = trunc i64 %chunk6 to i32
  %top2 = lshr i32 %chunk32, 4
  %row_hi = and i32 %top2, 2
  %row_lo = and i32 %chunk32, 1
  %row = or i32 %row_hi, %row_lo
  %col.pre = lshr i32 %chunk32, 1
  %col = and i32 %col.pre, 15
  %row16 = shl i32 %row, 4
  %sidx = or i32 %row16, %col
  %sb.base = mul i32 %sb.i, 64
  %sidx.total = add i32 %sb.base, %sidx
  %sidx64 = zext i32 %sidx.total to i64
  %s.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX_2, i64 0, i64 %sidx64
  %s.val8 = load i8, i8* %s.ptr, align 1
  %s.val32 = zext i8 %s.val8 to i32
  %Sacc.shl = shl i32 %Sacc, 4
  %Sacc.next = or i32 %Sacc.shl, %s.val32
  br label %sbox.inc

sbox.inc:
  %sb.i.next = add i32 %sb.i, 1
  br label %sbox.loop

sbox.done:
  ; P permutation on Sacc to f(R,K)
  br label %p.loop

p.loop:
  %p.i = phi i32 [ 0, %sbox.done ], [ %p.i.next, %p.inc ]
  %Pacc = phi i32 [ 0, %sbox.done ], [ %Pacc.next, %p.inc ]
  %p.cmp = icmp sle i32 %p.i, 31
  br i1 %p.cmp, label %p.body, label %p.done

p.body:
  %p.idx.z = zext i32 %p.i to i64
  %p.ptr = getelementptr inbounds [32 x i32], [32 x i32]* @P_1, i64 0, i64 %p.idx.z
  %p.val = load i32, i32* %p.ptr, align 4
  %p.sh32 = sub i32 32, %p.val
  %S.sh = lshr i32 %Sacc, %p.sh32
  %S.bit = and i32 %S.sh, 1
  %Pacc.shl = shl i32 %Pacc, 1
  %Pacc.next = or i32 %Pacc.shl, %S.bit
  br label %p.inc

p.inc:
  %p.i.next = add i32 %p.i, 1
  br label %p.loop

p.done:
  ; Feistel swap and combine
  %L.next = %R
  %R.xor = xor i32 %L, %Pacc
  %R.next = %R.xor
  br label %round.inc

round.inc:
  %round.next = add i32 %round, 1
  br label %round.loop

round.done:
  ; Preoutput with final swap: (R << 32) | L
  %R64 = zext i32 %R to i64
  %L64 = zext i32 %L to i64
  %preout.hi = shl i64 %R64, 32
  %preout = or i64 %preout.hi, %L64

  ; Final Permutation FP
  br label %fp.loop

fp.loop:
  %fp.i = phi i32 [ 0, %round.done ], [ %fp.i.next, %fp.inc ]
  %FPacc = phi i64 [ 0, %round.done ], [ %FPacc.next, %fp.inc ]
  %fp.cmp = icmp sle i32 %fp.i, 63
  br i1 %fp.cmp, label %fp.body, label %fp.done

fp.body:
  %fp.idx.z = zext i32 %fp.i to i64
  %fp.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @FP_0, i64 0, i64 %fp.idx.z
  %fp.val = load i32, i32* %fp.ptr, align 4
  %fp.sh32 = sub i32 64, %fp.val
  %fp.sh64 = zext i32 %fp.sh32 to i64
  %fp.bit64 = lshr i64 %preout, %fp.sh64
  %fp.bit = and i64 %fp.bit64, 1
  %FPacc.shl = shl i64 %FPacc, 1
  %FPacc.next = or i64 %FPacc.shl, %fp.bit
  br label %fp.inc

fp.inc:
  %fp.i.next = add i32 %fp.i, 1
  br label %fp.loop

fp.done:
  ret i64 %FPacc
}