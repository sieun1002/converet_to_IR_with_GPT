; External tables (sizes inferred from usage)
@PC1_7   = external constant [56 x i32], align 4
@SHIFTS_6 = external constant [16 x i32], align 4
@PC2_5   = external constant [48 x i32], align 4
@IP_4    = external constant [64 x i32], align 4
@E_3     = external constant [48 x i32], align 4
@SBOX_2  = external constant [512 x i8], align 1
@P_1     = external constant [32 x i32], align 4
@FP_0    = external constant [64 x i32], align 4

define i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  ; round keys buffer
  %rk = alloca [16 x i64], align 8

  ; ----- PC-1 permutation on key -----
  br label %pc1.cond

pc1.cond:
  %pc1.i = phi i32 [ 0, %entry ], [ %pc1.i.next, %pc1.body ]
  %pc1.acc = phi i64 [ 0, %entry ], [ %pc1.acc.next, %pc1.body ]
  %pc1.cmp = icmp ult i32 %pc1.i, 56
  br i1 %pc1.cmp, label %pc1.body, label %pc1.end

pc1.body:
  %pc1.idx = zext i32 %pc1.i to i64
  %pc1.ptr = getelementptr inbounds [56 x i32], [56 x i32]* @PC1_7, i64 0, i64 %pc1.idx
  %pc1.val.i32 = load i32, i32* %pc1.ptr, align 4
  %pc1.val = zext i32 %pc1.val.i32 to i64
  %pc1.sh = sub i64 64, %pc1.val
  %pc1.bit.s = lshr i64 %key, %pc1.sh
  %pc1.bit = and i64 %pc1.bit.s, 1
  %pc1.acc.shl = shl i64 %pc1.acc, 1
  %pc1.acc.next = or i64 %pc1.acc.shl, %pc1.bit
  %pc1.i.next = add i32 %pc1.i, 1
  br label %pc1.cond

pc1.end:
  ; split into 28-bit halves
  %acc.final = phi i64 [ %pc1.acc, %pc1.cond ]
  %acc.sh28 = lshr i64 %acc.final, 28
  %left0.t = trunc i64 %acc.sh28 to i32
  %left0 = and i32 %left0.t, 268435455          ; 0x0FFFFFFF
  %right0.t = trunc i64 %acc.final to i32
  %right0 = and i32 %right0.t, 268435455

  ; ----- Generate 16 round keys -----
  br label %rk.cond

rk.cond:
  %rk.i = phi i32 [ 0, %pc1.end ], [ %rk.i.next, %rk.body.end ]
  %L28 = phi i32 [ %left0, %pc1.end ], [ %L28.next, %rk.body.end ]
  %R28 = phi i32 [ %right0, %pc1.end ], [ %R28.next, %rk.body.end ]
  %rk.cmp = icmp ult i32 %rk.i, 16
  br i1 %rk.cmp, label %rk.body, label %rk.end

rk.body:
  ; rotation amount
  %sh.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS_6, i64 0, i64 (zext i32 %rk.i to i64)
  %sh.val = load i32, i32* %sh.ptr, align 4
  ; left rotate L28 and R28 by sh.val within 28 bits
  %rotL.shl = shl i32 %L28, %sh.val
  %rotL.rem = sub i32 28, %sh.val
  %rotL.shr = lshr i32 %L28, %rotL.rem
  %rotL.or = or i32 %rotL.shl, %rotL.shr
  %L28.next = and i32 %rotL.or, 268435455

  %rotR.shl = shl i32 %R28, %sh.val
  %rotR.rem = sub i32 28, %sh.val
  %rotR.shr = lshr i32 %R28, %rotR.rem
  %rotR.or = or i32 %rotR.shl, %rotR.shr
  %R28.next = and i32 %rotR.or, 268435455

  ; combine into 56-bit
  %L56 = zext i32 %L28.next to i64
  %L56.sh = shl i64 %L56, 28
  %R56 = zext i32 %R28.next to i64
  %C56 = or i64 %L56.sh, %R56

  ; PC-2 to form 48-bit round key
  br label %pc2.cond

pc2.cond:
  %pc2.j = phi i32 [ 0, %rk.body ], [ %pc2.j.next, %pc2.body ]
  %pc2.acc = phi i64 [ 0, %rk.body ], [ %pc2.acc.next, %pc2.body ]
  %pc2.cmp = icmp ult i32 %pc2.j, 48
  br i1 %pc2.cmp, label %pc2.body, label %pc2.end

pc2.body:
  %pc2.idx = zext i32 %pc2.j to i64
  %pc2.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @PC2_5, i64 0, i64 %pc2.idx
  %pc2.val.i32 = load i32, i32* %pc2.ptr, align 4
  %pc2.val = zext i32 %pc2.val.i32 to i64
  %pc2.sh = sub i64 56, %pc2.val
  %pc2.bit.s = lshr i64 %C56, %pc2.sh
  %pc2.bit = and i64 %pc2.bit.s, 1
  %pc2.acc.shl = shl i64 %pc2.acc, 1
  %pc2.acc.next = or i64 %pc2.acc.shl, %pc2.bit
  %pc2.j.next = add i32 %pc2.j, 1
  br label %pc2.cond

pc2.end:
  %rkval = phi i64 [ %pc2.acc, %pc2.cond ]
  %rk.slot.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %rk, i64 0, i64 (zext i32 %rk.i to i64)
  store i64 %rkval, i64* %rk.slot.ptr, align 8
  br label %rk.body.end

rk.body.end:
  %rk.i.next = add i32 %rk.i, 1
  br label %rk.cond

rk.end:
  ; ----- Initial Permutation (IP) on block -----
  br label %ip.cond

ip.cond:
  %ip.i = phi i32 [ 0, %rk.end ], [ %ip.i.next, %ip.body ]
  %ip.acc = phi i64 [ 0, %rk.end ], [ %ip.acc.next, %ip.body ]
  %ip.cmp = icmp ult i32 %ip.i, 64
  br i1 %ip.cmp, label %ip.body, label %ip.end

ip.body:
  %ip.idx = zext i32 %ip.i to i64
  %ip.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @IP_4, i64 0, i64 %ip.idx
  %ip.val.i32 = load i32, i32* %ip.ptr, align 4
  %ip.val = zext i32 %ip.val.i32 to i64
  %ip.sh = sub i64 64, %ip.val
  %ip.bit.s = lshr i64 %block, %ip.sh
  %ip.bit = and i64 %ip.bit.s, 1
  %ip.acc.shl = shl i64 %ip.acc, 1
  %ip.acc.next = or i64 %ip.acc.shl, %ip.bit
  %ip.i.next = add i32 %ip.i, 1
  br label %ip.cond

ip.end:
  %ip.final = phi i64 [ %ip.acc, %ip.cond ]
  %L0.sh = lshr i64 %ip.final, 32
  %L0.t = trunc i64 %L0.sh to i32
  %R0.t = trunc i64 %ip.final to i32
  br label %rounds.cond

; ----- 16 Feistel rounds -----
rounds.cond:
  %round.i = phi i32 [ 0, %ip.end ], [ %round.i.next, %rounds.end ]
  %L = phi i32 [ %L0.t, %ip.end ], [ %L.next, %rounds.end ]
  %R = phi i32 [ %R0.t, %ip.end ], [ %R.next, %rounds.end ]
  %round.cmp = icmp ult i32 %round.i, 16
  br i1 %round.cmp, label %rounds.body, label %rounds.done

rounds.body:
  ; Expansion E on R -> 48 bits
  br label %e.cond

e.cond:
  %e.j = phi i32 [ 0, %rounds.body ], [ %e.j.next, %e.body ]
  %e.acc = phi i64 [ 0, %rounds.body ], [ %e.acc.next, %e.body ]
  %e.cmp = icmp ult i32 %e.j, 48
  br i1 %e.cmp, label %e.body, label %e.end

e.body:
  %e.idx = zext i32 %e.j to i64
  %e.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @E_3, i64 0, i64 %e.idx
  %e.val = load i32, i32* %e.ptr, align 4
  %e.sh = sub i32 32, %e.val
  %R.z = zext i32 %R to i32
  %e.bit32.s = lshr i32 %R.z, %e.sh
  %e.bit32 = and i32 %e.bit32.s, 1
  %e.bit = zext i32 %e.bit32 to i64
  %e.acc.shl = shl i64 %e.acc, 1
  %e.acc.next = or i64 %e.acc.shl, %e.bit
  %e.j.next = add i32 %e.j, 1
  br label %e.cond

e.end:
  %E48 = phi i64 [ %e.acc, %e.cond ]
  ; XOR with round key
  %rk.ptr2 = getelementptr inbounds [16 x i64], [16 x i64]* %rk, i64 0, i64 (zext i32 %round.i to i64)
  %rk.val2 = load i64, i64* %rk.ptr2, align 8
  %A48 = xor i64 %E48, %rk.val2

  ; S-Boxes to 32-bit
  br label %s.cond

s.cond:
  %s.j = phi i32 [ 0, %e.end ], [ %s.j.next, %s.body ]
  %s.acc = phi i32 [ 0, %e.end ], [ %s.acc.next, %s.body ]
  %s.cmp = icmp ult i32 %s.j, 8
  br i1 %s.cmp, label %s.body, label %s.end

s.body:
  %j64 = zext i32 %s.j to i64
  %mul6 = mul i32 %s.j, 6
  %shiftF = sub i32 42, %mul6
  %shiftF64 = zext i32 %shiftF to i64
  %seg.s = lshr i64 %A48, %shiftF64
  %seg32.t = trunc i64 %seg.s to i32
  %seg32 = and i32 %seg32.t, 63
  ; row bits: ((b5<<?)/((seg>>4)&2) | (seg&1))
  %row_hi = and i32 (lshr i32 %seg32, 4), 2
  %row_lo = and i32 %seg32, 1
  %row = or i32 %row_hi, %row_lo
  ; col bits: (seg>>1)&0xF
  %col = and i32 (lshr i32 %seg32, 1), 15
  %row_sh = shl i32 %row, 4
  %idx.in.box = or i32 %row_sh, %col
  %idx64.in.box = zext i32 %idx.in.box to i64
  %box.base = shl i64 %j64, 6
  %sbox.idx = add i64 %box.base, %idx64.in.box
  %sbox.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX_2, i64 0, i64 %sbox.idx
  %sval8 = load i8, i8* %sbox.ptr, align 1
  %sval = zext i8 %sval8 to i32
  %s.acc.shl = shl i32 %s.acc, 4
  %s.acc.next = or i32 %s.acc.shl, %sval
  %s.j.next = add i32 %s.j, 1
  br label %s.cond

s.end:
  %S32 = phi i32 [ %s.acc, %s.cond ]

  ; P permutation
  br label %p.cond

p.cond:
  %p.k = phi i32 [ 0, %s.end ], [ %p.k.next, %p.body ]
  %p.acc = phi i32 [ 0, %s.end ], [ %p.acc.next, %p.body ]
  %p.cmp = icmp ult i32 %p.k, 32
  br i1 %p.cmp, label %p.body, label %p.end

p.body:
  %p.idx = zext i32 %p.k to i64
  %p.ptr = getelementptr inbounds [32 x i32], [32 x i32]* @P_1, i64 0, i64 %p.idx
  %p.val = load i32, i32* %p.ptr, align 4
  %p.sh = sub i32 32, %p.val
  %bit32.s = lshr i32 %S32, %p.sh
  %bit32 = and i32 %bit32.s, 1
  %p.acc.shl = shl i32 %p.acc, 1
  %p.acc.next = or i32 %p.acc.shl, %bit32
  %p.k.next = add i32 %p.k, 1
  br label %p.cond

p.end:
  %F32 = phi i32 [ %p.acc, %p.cond ]

  ; Feistel swap/update
  %R.next = xor i32 %L, %F32
  %L.next = %R
  br label %rounds.end

rounds.end:
  %round.i.next = add i32 %round.i, 1
  br label %rounds.cond

rounds.done:
  ; Combine R (as left) and L (as right) before FP
  %R64 = zext i32 %R to i64
  %L64 = zext i32 %L to i64
  %preFP.hi = shl i64 %R64, 32
  %preFP = or i64 %preFP.hi, %L64

  ; ----- Final Permutation (FP) -----
  br label %fp.cond

fp.cond:
  %fp.i = phi i32 [ 0, %rounds.done ], [ %fp.i.next, %fp.body ]
  %fp.acc = phi i64 [ 0, %rounds.done ], [ %fp.acc.next, %fp.body ]
  %fp.cmp = icmp ult i32 %fp.i, 64
  br i1 %fp.cmp, label %fp.body, label %fp.end

fp.body:
  %fp.idx = zext i32 %fp.i to i64
  %fp.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @FP_0, i64 0, i64 %fp.idx
  %fp.val.i32 = load i32, i32* %fp.ptr, align 4
  %fp.val = zext i32 %fp.val.i32 to i64
  %fp.sh = sub i64 64, %fp.val
  %fp.bit.s = lshr i64 %preFP, %fp.sh
  %fp.bit = and i64 %fp.bit.s, 1
  %fp.acc.shl = shl i64 %fp.acc, 1
  %fp.acc.next = or i64 %fp.acc.shl, %fp.bit
  %fp.i.next = add i32 %fp.i, 1
  br label %fp.cond

fp.end:
  %result = phi i64 [ %fp.acc, %fp.cond ]
  ret i64 %result
}