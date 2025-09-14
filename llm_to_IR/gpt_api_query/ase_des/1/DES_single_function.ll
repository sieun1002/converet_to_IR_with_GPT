; ModuleID = 'des.ll'
target triple = "x86_64-pc-linux-gnu"

@PC1_7   = external constant [56 x i32], align 4
@SHIFTS_6 = external constant [16 x i32], align 4
@PC2_5   = external constant [48 x i32], align 4
@IP_4    = external constant [64 x i32], align 4
@E_3     = external constant [48 x i32], align 4
@SBOX_2  = external constant [512 x i8], align 1
@P_1     = external constant [32 x i32], align 4
@FP_0    = external constant [64 x i32], align 4

define i64 @des_encrypt(i64 %block, i64 %key) {
entry:
  br label %pc1.loop

pc1.loop:                                             ; build 56-bit key after PC-1
  %pc1.i = phi i32 [ 0, %entry ], [ %pc1.next, %pc1.body ]
  %kd.acc = phi i64 [ 0, %entry ], [ %kd.next, %pc1.body ]
  %pc1.cmp = icmp sle i32 %pc1.i, 55
  br i1 %pc1.cmp, label %pc1.body, label %pc1.exit

pc1.body:
  %pc1.idx = sext i32 %pc1.i to i64
  %pc1.ptr = getelementptr inbounds [56 x i32], [56 x i32]* @PC1_7, i64 0, i64 %pc1.idx
  %pc1.pos = load i32, i32* %pc1.ptr, align 4
  %pc1.pos64 = zext i32 %pc1.pos to i64
  %pc1.shift = sub i64 64, %pc1.pos64
  %pc1.shr = lshr i64 %key, %pc1.shift
  %pc1.bit = and i64 %pc1.shr, 1
  %pc1.shl = shl i64 %kd.acc, 1
  %kd.next = or i64 %pc1.shl, %pc1.bit
  %pc1.next = add i32 %pc1.i, 1
  br label %pc1.loop

pc1.exit:
  %c64 = lshr i64 %kd.acc, 28
  %c64masked = and i64 %c64, 268435455
  %C.init = trunc i64 %c64masked to i32
  %d64masked = and i64 %kd.acc, 268435455
  %D.init = trunc i64 %d64masked to i32

  %keys = alloca [16 x i64], align 8
  br label %ks.loop

ks.loop:                                              ; generate 16 round keys
  %ks.i = phi i32 [ 0, %pc1.exit ], [ %ks.next, %pc2.exit ]
  %C.cur = phi i32 [ %C.init, %pc1.exit ], [ %C.next, %pc2.exit ]
  %D.cur = phi i32 [ %D.init, %pc1.exit ], [ %D.next, %pc2.exit ]
  %ks.cmp = icmp sle i32 %ks.i, 15
  br i1 %ks.cmp, label %ks.body, label %ks.exit

ks.body:
  %ks.idx = sext i32 %ks.i to i64
  %sh.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS_6, i64 0, i64 %ks.idx
  %sh = load i32, i32* %sh.ptr, align 4

  %Cshl = shl i32 %C.cur, %sh
  %Cshr.shift = sub i32 28, %sh
  %Cshr = lshr i32 %C.cur, %Cshr.shift
  %Crot = or i32 %Cshl, %Cshr
  %C.next = and i32 %Crot, 268435455

  %Dshl = shl i32 %D.cur, %sh
  %Dshr.shift = sub i32 28, %sh
  %Dshr = lshr i32 %D.cur, %Dshr.shift
  %Drot = or i32 %Dshl, %Dshr
  %D.next = and i32 %Drot, 268435455

  %Cext = zext i32 %C.next to i64
  %Cext.shl = shl i64 %Cext, 28
  %Dext = zext i32 %D.next to i64
  %CD = or i64 %Cext.shl, %Dext

  br label %pc2.loop

pc2.loop:                                             ; apply PC-2 to make 48-bit subkey
  %pc2.i = phi i32 [ 0, %ks.body ], [ %pc2.next, %pc2.body ]
  %pc2.acc = phi i64 [ 0, %ks.body ], [ %pc2.acc.next, %pc2.body ]
  %pc2.cmp = icmp sle i32 %pc2.i, 47
  br i1 %pc2.cmp, label %pc2.body, label %pc2.exit

pc2.body:
  %pc2.idx = sext i32 %pc2.i to i64
  %pc2.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @PC2_5, i64 0, i64 %pc2.idx
  %pc2.pos = load i32, i32* %pc2.ptr, align 4
  %pc2.pos64 = zext i32 %pc2.pos to i64
  %pc2.shift = sub i64 56, %pc2.pos64
  %pc2.shrv = lshr i64 %CD, %pc2.shift
  %pc2.bit = and i64 %pc2.shrv, 1
  %pc2.shl = shl i64 %pc2.acc, 1
  %pc2.acc.next = or i64 %pc2.shl, %pc2.bit
  %pc2.next = add i32 %pc2.i, 1
  br label %pc2.loop

pc2.exit:
  %key.slot = getelementptr inbounds [16 x i64], [16 x i64]* %keys, i64 0, i64 %ks.idx
  store i64 %pc2.acc, i64* %key.slot, align 8
  %ks.next = add i32 %ks.i, 1
  br label %ks.loop

ks.exit:
  br label %ip.loop

ip.loop:                                              ; initial permutation on block
  %ip.i = phi i32 [ 0, %ks.exit ], [ %ip.next, %ip.body ]
  %ip.acc = phi i64 [ 0, %ks.exit ], [ %ip.acc.next, %ip.body ]
  %ip.cmp = icmp sle i32 %ip.i, 63
  br i1 %ip.cmp, label %ip.body, label %ip.exit

ip.body:
  %ip.idx = sext i32 %ip.i to i64
  %ip.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @IP_4, i64 0, i64 %ip.idx
  %ip.pos = load i32, i32* %ip.ptr, align 4
  %ip.pos64 = zext i32 %ip.pos to i64
  %ip.shift = sub i64 64, %ip.pos64
  %ip.shrv = lshr i64 %block, %ip.shift
  %ip.bit = and i64 %ip.shrv, 1
  %ip.shl = shl i64 %ip.acc, 1
  %ip.acc.next = or i64 %ip.shl, %ip.bit
  %ip.next = add i32 %ip.i, 1
  br label %ip.loop

ip.exit:
  %L0.pre = lshr i64 %ip.acc, 32
  %L0 = trunc i64 %L0.pre to i32
  %R0 = trunc i64 %ip.acc to i32
  br label %rounds.loop

rounds.loop:                                          ; 16 Feistel rounds
  %r.i = phi i32 [ 0, %ip.exit ], [ %r.next, %after.round ]
  %L.cur = phi i32 [ %L0, %ip.exit ], [ %L.next, %after.round ]
  %R.cur = phi i32 [ %R0, %ip.exit ], [ %R.next, %after.round ]
  %r.cmp = icmp sle i32 %r.i, 15
  br i1 %r.cmp, label %round.body, label %rounds.exit

round.body:
  br label %E.loop

E.loop:                                               ; expansion E
  %E.i = phi i32 [ 0, %round.body ], [ %E.next, %E.body ]
  %E.acc = phi i64 [ 0, %round.body ], [ %E.acc.next, %E.body ]
  %E.cmp = icmp sle i32 %E.i, 47
  br i1 %E.cmp, label %E.body, label %E.exit

E.body:
  %E.idx = sext i32 %E.i to i64
  %E.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @E_3, i64 0, i64 %E.idx
  %E.pos = load i32, i32* %E.ptr, align 4
  %E.shift = sub i32 32, %E.pos
  %R.shifted = lshr i32 %R.cur, %E.shift
  %R.bit64 = zext i32 %R.shifted to i64
  %E.bit = and i64 %R.bit64, 1
  %E.shl = shl i64 %E.acc, 1
  %E.acc.next = or i64 %E.shl, %E.bit
  %E.next = add i32 %E.i, 1
  br label %E.loop

E.exit:
  %key.idx = sext i32 %r.i to i64
  %rk.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %keys, i64 0, i64 %key.idx
  %rk = load i64, i64* %rk.ptr, align 8
  %A = xor i64 %E.acc, %rk

  br label %S.loop

S.loop:                                               ; S-box substitution
  %S.i = phi i32 [ 0, %E.exit ], [ %S.next, %S.body ]
  %S.acc = phi i32 [ 0, %E.exit ], [ %S.acc.next, %S.body ]
  %S.cmp = icmp sle i32 %S.i, 7
  br i1 %S.cmp, label %S.body, label %S.exit

S.body:
  %six = mul i32 %S.i, 6
  %shamt = sub i32 42, %six
  %shamt64 = zext i32 %shamt to i64
  %A.shifted = lshr i64 %A, %shamt64
  %A.tr = trunc i64 %A.shifted to i32
  %x6 = and i32 %A.tr, 63

  %t1 = lshr i32 %x6, 4
  %t1a = and i32 %t1, 2
  %t2 = and i32 %x6, 1
  %row = or i32 %t1a, %t2

  %colpre = lshr i32 %x6, 1
  %col = and i32 %colpre, 15

  %row16 = shl i32 %row, 4
  %sidx.inner = add i32 %row16, %col
  %base = mul i32 %S.i, 64
  %sidx = add i32 %base, %sidx.inner
  %sidx64 = sext i32 %sidx to i64
  %s.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX_2, i64 0, i64 %sidx64
  %sval8 = load i8, i8* %s.ptr, align 1
  %svali32 = zext i8 %sval8 to i32

  %S.shl = shl i32 %S.acc, 4
  %S.acc.next = or i32 %S.shl, %svali32
  %S.next = add i32 %S.i, 1
  br label %S.loop

S.exit:
  br label %P.loop

P.loop:                                               ; P permutation
  %P.i = phi i32 [ 0, %S.exit ], [ %P.next, %P.body ]
  %P.acc = phi i32 [ 0, %S.exit ], [ %P.acc.next, %P.body ]
  %P.cmp = icmp sle i32 %P.i, 31
  br i1 %P.cmp, label %P.body, label %P.exit

P.body:
  %P.idx = sext i32 %P.i to i64
  %P.ptr = getelementptr inbounds [32 x i32], [32 x i32]* @P_1, i64 0, i64 %P.idx
  %P.pos = load i32, i32* %P.ptr, align 4
  %P.shift = sub i32 32, %P.pos
  %S.shifted = lshr i32 %S.acc, %P.shift
  %P.bit = and i32 %S.shifted, 1
  %P.shl = shl i32 %P.acc, 1
  %P.acc.next = or i32 %P.shl, %P.bit
  %P.next = add i32 %P.i, 1
  br label %P.loop

P.exit:
  %L.next = %R.cur
  %R.next = xor i32 %P.acc, %L.cur
  %r.next = add i32 %r.i, 1
  br label %after.round

after.round:
  br label %rounds.loop

rounds.exit:
  %Rext = zext i32 %R.cur to i64
  %Rext.shl = shl i64 %Rext, 32
  %Lext = zext i32 %L.cur to i64
  %preout = or i64 %Rext.shl, %Lext
  br label %fp.loop

fp.loop:                                              ; final permutation
  %fp.i = phi i32 [ 0, %rounds.exit ], [ %fp.next, %fp.body ]
  %fp.acc = phi i64 [ 0, %rounds.exit ], [ %fp.acc.next, %fp.body ]
  %fp.cmp = icmp sle i32 %fp.i, 63
  br i1 %fp.cmp, label %fp.body, label %fp.exit

fp.body:
  %fp.idx = sext i32 %fp.i to i64
  %FP.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @FP_0, i64 0, i64 %fp.idx
  %FP.pos = load i32, i32* %FP.ptr, align 4
  %FP.pos64 = zext i32 %FP.pos to i64
  %FP.shift = sub i64 64, %FP.pos64
  %pre.shr = lshr i64 %preout, %FP.shift
  %fp.bit = and i64 %pre.shr, 1
  %fp.shl = shl i64 %fp.acc, 1
  %fp.acc.next = or i64 %fp.shl, %fp.bit
  %fp.next = add i32 %fp.i, 1
  br label %fp.loop

fp.exit:
  ret i64 %fp.acc
}