; ModuleID = 'des.ll'
source_filename = "des_encrypt"

@PC1_7  = external constant [56 x i32], align 4
@SHIFTS_6 = external constant [16 x i32], align 4
@PC2_5  = external constant [48 x i32], align 4
@IP_4   = external constant [64 x i32], align 4
@E_3    = external constant [48 x i32], align 4
@SBOX_2 = external constant [512 x i8], align 1
@P_1    = external constant [32 x i32], align 4
@FP_0   = external constant [64 x i32], align 4

define i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr nounwind {
entry:
  %subkeys = alloca [16 x i64], align 16

  ; PC1 permutation -> 56-bit key
  br label %pc1.header

pc1.header:
  %pc1.i = phi i32 [ 0, %entry ], [ %pc1.inext, %pc1.latch ]
  %pc1.acc = phi i64 [ 0, %entry ], [ %pc1.acc.next, %pc1.latch ]
  %pc1.cmp = icmp sle i32 %pc1.i, 55
  br i1 %pc1.cmp, label %pc1.body, label %pc1.exit

pc1.body:
  %pc1.i64 = sext i32 %pc1.i to i64
  %pc1.ptr = getelementptr inbounds [56 x i32], [56 x i32]* @PC1_7, i64 0, i64 %pc1.i64
  %pc1.val = load i32, i32* %pc1.ptr, align 4
  %pc1.val64 = zext i32 %pc1.val to i64
  %pc1.shift = sub i64 64, %pc1.val64
  %pc1.sh = lshr i64 %key, %pc1.shift
  %pc1.bit = and i64 %pc1.sh, 1
  %pc1.acc.shl = shl i64 %pc1.acc, 1
  %pc1.acc.next = or i64 %pc1.acc.shl, %pc1.bit
  %pc1.inext = add i32 %pc1.i, 1
  br label %pc1.latch

pc1.latch:
  br label %pc1.header

pc1.exit:
  ; split C and D (28-bit halves)
  %perm = phi i64 [ %pc1.acc, %pc1.header ]
  %perm.shr = lshr i64 %perm, 28
  %mask28 = and i64 %perm.shr, 268435455
  %C0 = trunc i64 %mask28 to i32
  %D0.i64 = and i64 %perm, 268435455
  %D0 = trunc i64 %D0.i64 to i32
  br label %round.header

; Generate 16 subkeys
round.header:
  %r.i = phi i32 [ 0, %pc1.exit ], [ %r.inext, %round.latch ]
  %C.phi = phi i32 [ %C0, %pc1.exit ], [ %C.next, %round.latch ]
  %D.phi = phi i32 [ %D0, %pc1.exit ], [ %D.next, %round.latch ]
  %round.cmp = icmp sle i32 %r.i, 15
  br i1 %round.cmp, label %round.body, label %round.exit

round.body:
  ; load shift
  %r.i64 = sext i32 %r.i to i64
  %sh.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS_6, i64 0, i64 %r.i64
  %sh.val = load i32, i32* %sh.ptr, align 4
  ; rotate C 28
  %sh.invC = sub i32 28, %sh.val
  %C.shl = shl i32 %C.phi, %sh.val
  %C.shr = lshr i32 %C.phi, %sh.invC
  %C.or = or i32 %C.shl, %C.shr
  %C.masked = and i32 %C.or, 268435455
  ; rotate D 28
  %sh.invD = sub i32 28, %sh.val
  %D.shl = shl i32 %D.phi, %sh.val
  %D.shr = lshr i32 %D.phi, %sh.invD
  %D.or = or i32 %D.shl, %D.shr
  %D.masked = and i32 %D.or, 268435455
  %C.next = %C.masked
  %D.next = %D.masked
  ; combine into 56-bit
  %C64 = zext i32 %C.next to i64
  %D64 = zext i32 %D.next to i64
  %C64.shl = shl i64 %C64, 28
  %CD = or i64 %C64.shl, %D64
  ; PC2 -> 48-bit subkey
  br label %pc2.header

pc2.header:
  %pc2.j = phi i32 [ 0, %round.body ], [ %pc2.jnext, %pc2.latch ]
  %pc2.acc = phi i64 [ 0, %round.body ], [ %pc2.acc.next, %pc2.latch ]
  %pc2.cmp = icmp sle i32 %pc2.j, 47
  br i1 %pc2.cmp, label %pc2.body, label %pc2.exit

pc2.body:
  %pc2.j64 = sext i32 %pc2.j to i64
  %pc2.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @PC2_5, i64 0, i64 %pc2.j64
  %pc2.val = load i32, i32* %pc2.ptr, align 4
  %pc2.val64 = zext i32 %pc2.val to i64
  %pc2.shift = sub i64 56, %pc2.val64
  %pc2.sh = lshr i64 %CD, %pc2.shift
  %pc2.bit = and i64 %pc2.sh, 1
  %pc2.acc.shl = shl i64 %pc2.acc, 1
  %pc2.acc.next = or i64 %pc2.acc.shl, %pc2.bit
  %pc2.jnext = add i32 %pc2.j, 1
  br label %pc2.latch

pc2.latch:
  br label %pc2.header

pc2.exit:
  %subkey = phi i64 [ %pc2.acc, %pc2.header ]
  %subkeys.base = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  %sub.ptr = getelementptr inbounds i64, i64* %subkeys.base, i64 %r.i64
  store i64 %subkey, i64* %sub.ptr, align 8
  %r.inext = add i32 %r.i, 1
  br label %round.latch

round.latch:
  br label %round.header

round.exit:
  ; Initial permutation IP
  br label %ip.header

ip.header:
  %ip.i = phi i32 [ 0, %round.exit ], [ %ip.inext, %ip.latch ]
  %ip.acc = phi i64 [ 0, %round.exit ], [ %ip.acc.next, %ip.latch ]
  %ip.cmp = icmp sle i32 %ip.i, 63
  br i1 %ip.cmp, label %ip.body, label %ip.exit

ip.body:
  %ip.i64 = sext i32 %ip.i to i64
  %ip.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @IP_4, i64 0, i64 %ip.i64
  %ip.val = load i32, i32* %ip.ptr, align 4
  %ip.val64 = zext i32 %ip.val to i64
  %ip.shift = sub i64 64, %ip.val64
  %ip.sh = lshr i64 %block, %ip.shift
  %ip.bit = and i64 %ip.sh, 1
  %ip.acc.shl = shl i64 %ip.acc, 1
  %ip.acc.next = or i64 %ip.acc.shl, %ip.bit
  %ip.inext = add i32 %ip.i, 1
  br label %ip.latch

ip.latch:
  br label %ip.header

ip.exit:
  %ip.res = phi i64 [ %ip.acc, %ip.header ]
  %L.init64 = lshr i64 %ip.res, 32
  %L.init32 = trunc i64 %L.init64 to i32
  %R.init32 = trunc i64 %ip.res to i32
  br label %enc.header

; 16 Feistel rounds
enc.header:
  %er.i = phi i32 [ 0, %ip.exit ], [ %er.inext, %enc.latch ]
  %L.phi = phi i32 [ %L.init32, %ip.exit ], [ %L.next, %enc.latch ]
  %R.phi = phi i32 [ %R.init32, %ip.exit ], [ %R.next, %enc.latch ]
  %enc.cmp = icmp sle i32 %er.i, 15
  br i1 %enc.cmp, label %enc.body, label %enc.exit

enc.body:
  ; E expansion from R
  br label %e.header

e.header:
  %e.j = phi i32 [ 0, %enc.body ], [ %e.jnext, %e.latch ]
  %e.acc = phi i64 [ 0, %enc.body ], [ %e.acc.next, %e.latch ]
  %e.cmp = icmp sle i32 %e.j, 47
  br i1 %e.cmp, label %e.body, label %e.exit

e.body:
  %e.j64 = sext i32 %e.j to i64
  %e.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @E_3, i64 0, i64 %e.j64
  %e.val = load i32, i32* %e.ptr, align 4
  %e.shift32 = sub i32 32, %e.val
  %R.sh = lshr i32 %R.phi, %e.shift32
  %R.bit32 = and i32 %R.sh, 1
  %R.bit64 = zext i32 %R.bit32 to i64
  %e.acc.shl = shl i64 %e.acc, 1
  %e.acc.next = or i64 %e.acc.shl, %R.bit64
  %e.jnext = add i32 %e.j, 1
  br label %e.latch

e.latch:
  br label %e.header

e.exit:
  %E.out = phi i64 [ %e.acc, %e.header ]
  ; XOR with subkey
  %er.i64 = sext i32 %er.i to i64
  %sub.ptr2.base = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  %sub.ptr2 = getelementptr inbounds i64, i64* %sub.ptr2.base, i64 %er.i64
  %k48 = load i64, i64* %sub.ptr2, align 8
  %x48 = xor i64 %E.out, %k48
  ; S-boxes
  br label %s.header

s.header:
  %s.i = phi i32 [ 0, %e.exit ], [ %s.inext, %s.latch ]
  %s.acc = phi i32 [ 0, %e.exit ], [ %s.acc.next, %s.latch ]
  %s.cmp = icmp sle i32 %s.i, 7
  br i1 %s.cmp, label %s.body, label %s.exit

s.body:
  %s.mul6 = mul i32 %s.i, 6
  %s.shift = sub i32 42, %s.mul6
  %s.shift64 = zext i32 %s.shift to i64
  %chunk = lshr i64 %x48, %s.shift64
  %chunk6 = and i64 %chunk, 63
  ; row = ((chunk >> 4) & 2) | (chunk & 1)
  %row.high = lshr i64 %chunk6, 4
  %row.bit1 = and i64 %row.high, 2
  %row.bit0 = and i64 %chunk6, 1
  %row.mix = or i64 %row.bit1, %row.bit0
  %row.i32 = trunc i64 %row.mix to i32
  ; col = (chunk >> 1) & 0xF
  %col.tmp = lshr i64 %chunk6, 1
  %col.and = and i64 %col.tmp, 15
  %col.i32 = trunc i64 %col.and to i32
  ; index = s*64 + row*16 + col
  %row16 = shl i32 %row.i32, 4
  %rowcol = add i32 %row16, %col.i32
  %s.mul64 = mul i32 %s.i, 64
  %s.idx = add i32 %s.mul64, %rowcol
  %s.idx64 = zext i32 %s.idx to i64
  %s.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX_2, i64 0, i64 %s.idx64
  %s.nib = load i8, i8* %s.ptr, align 1
  %s.nib32 = zext i8 %s.nib to i32
  %s.acc.shl = shl i32 %s.acc, 4
  %s.acc.next = or i32 %s.acc.shl, %s.nib32
  %s.inext = add i32 %s.i, 1
  br label %s.latch

s.latch:
  br label %s.header

s.exit:
  %s.out = phi i32 [ %s.acc, %s.header ]
  ; P permutation
  br label %p.header

p.header:
  %p.i = phi i32 [ 0, %s.exit ], [ %p.inext, %p.latch ]
  %p.acc = phi i32 [ 0, %s.exit ], [ %p.acc.next, %p.latch ]
  %p.cmp = icmp sle i32 %p.i, 31
  br i1 %p.cmp, label %p.body, label %p.exit

p.body:
  %p.i64 = sext i32 %p.i to i64
  %p.ptr = getelementptr inbounds [32 x i32], [32 x i32]* @P_1, i64 0, i64 %p.i64
  %p.val = load i32, i32* %p.ptr, align 4
  %p.shift = sub i32 32, %p.val
  %p.sh = lshr i32 %s.out, %p.shift
  %p.bit = and i32 %p.sh, 1
  %p.acc.shl = shl i32 %p.acc, 1
  %p.acc.next = or i32 %p.acc.shl, %p.bit
  %p.inext = add i32 %p.i, 1
  br label %p.latch

p.latch:
  br label %p.header

p.exit:
  %f.out = phi i32 [ %p.acc, %p.header ]
  %L.tmp = %R.phi
  %R.new = xor i32 %L.phi, %f.out
  %L.next = %L.tmp
  %R.next = %R.new
  %er.inext = add i32 %er.i, 1
  br label %enc.latch

enc.latch:
  br label %enc.header

enc.exit:
  ; preoutput = (R << 32) | L
  %R.final64 = zext i32 %R.phi to i64
  %L.final64 = zext i32 %L.phi to i64
  %pre.shl = shl i64 %R.final64, 32
  %pre = or i64 %pre.shl, %L.final64
  br label %fp.header

; Final permutation FP
fp.header:
  %fp.i = phi i32 [ 0, %enc.exit ], [ %fp.inext, %fp.latch ]
  %fp.acc = phi i64 [ 0, %enc.exit ], [ %fp.acc.next, %fp.latch ]
  %fp.cmp = icmp sle i32 %fp.i, 63
  br i1 %fp.cmp, label %fp.body, label %fp.exit

fp.body:
  %fp.i64 = sext i32 %fp.i to i64
  %fp.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @FP_0, i64 0, i64 %fp.i64
  %fp.val = load i32, i32* %fp.ptr, align 4
  %fp.val64 = zext i32 %fp.val to i64
  %fp.shift = sub i64 64, %fp.val64
  %fp.sh = lshr i64 %pre, %fp.shift
  %fp.bit = and i64 %fp.sh, 1
  %fp.acc.shl = shl i64 %fp.acc, 1
  %fp.acc.next = or i64 %fp.acc.shl, %fp.bit
  %fp.inext = add i32 %fp.i, 1
  br label %fp.latch

fp.latch:
  br label %fp.header

fp.exit:
  %res = phi i64 [ %fp.acc, %fp.header ]
  ret i64 %res
}