; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

@PC1_7 = external constant [56 x i32]
@SHIFTS_6 = external constant [16 x i32]
@PC2_5 = external constant [48 x i32]
@IP_4 = external constant [64 x i32]
@E_3 = external constant [48 x i32]
@SBOX_2 = external constant [512 x i8]
@P_1 = external constant [32 x i32]
@FP_0 = external constant [64 x i32]

define i64 @des_encrypt(i64 %msg, i64 %key) {
entry:
  %subkeys = alloca [16 x i64], align 8

  br label %pc1.loop

pc1.loop:                                            ; build 56-bit from PC1
  %pc1.i = phi i32 [ 0, %entry ], [ %pc1.i.next, %pc1.body ]
  %pc1.acc = phi i64 [ 0, %entry ], [ %pc1.acc.next, %pc1.body ]
  %pc1.cmp = icmp sle i32 %pc1.i, 55
  br i1 %pc1.cmp, label %pc1.body, label %pc1.end

pc1.body:
  %pc1.idx = sext i32 %pc1.i to i64
  %pc1.ptr = getelementptr inbounds [56 x i32], [56 x i32]* @PC1_7, i64 0, i64 %pc1.idx
  %pc1.val = load i32, i32* %pc1.ptr, align 4
  %pc1.val.z = zext i32 %pc1.val to i64
  %pc1.shift = sub i64 64, %pc1.val.z
  %pc1.key.sh = lshr i64 %key, %pc1.shift
  %pc1.bit = and i64 %pc1.key.sh, 1
  %pc1.acc.shl = shl i64 %pc1.acc, 1
  %pc1.acc.next = or i64 %pc1.acc.shl, %pc1.bit
  %pc1.i.next = add i32 %pc1.i, 1
  br label %pc1.loop

pc1.end:
  %pc1.acc.fin = phi i64 [ %pc1.acc, %pc1.loop ]
  %C64.tmp = lshr i64 %pc1.acc.fin, 28
  %C32.tmp = trunc i64 %C64.tmp to i32
  %C0 = and i32 %C32.tmp, 268435455
  %D32.tmp = trunc i64 %pc1.acc.fin to i32
  %D0 = and i32 %D32.tmp, 268435455
  br label %roundkeys.loop

roundkeys.loop:                                      ; 16 key-schedule rounds
  %rk.i = phi i32 [ 0, %pc1.end ], [ %rk.i.next, %pc2.end ]
  %C = phi i32 [ %C0, %pc1.end ], [ %C.next, %pc2.end ]
  %D = phi i32 [ %D0, %pc1.end ], [ %D.next, %pc2.end ]
  %rk.cmp = icmp sle i32 %rk.i, 15
  br i1 %rk.cmp, label %rk.body, label %roundkeys.end

rk.body:
  %sh.idx = sext i32 %rk.i to i64
  %sh.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS_6, i64 0, i64 %sh.idx
  %sh.val = load i32, i32* %sh.ptr, align 4

  ; rotate-left C by sh.val within 28 bits
  %C.shl = shl i32 %C, %sh.val
  %C.inv = sub i32 28, %sh.val
  %C.lshr = lshr i32 %C, %C.inv
  %C.or = or i32 %C.shl, %C.lshr
  %C.next = and i32 %C.or, 268435455

  ; rotate-left D by sh.val within 28 bits
  %D.shl = shl i32 %D, %sh.val
  %D.inv = sub i32 28, %sh.val
  %D.lshr = lshr i32 %D, %D.inv
  %D.or = or i32 %D.shl, %D.lshr
  %D.next = and i32 %D.or, 268435455

  ; combine to 56-bit CD
  %C.z = zext i32 %C.next to i64
  %D.z = zext i32 %D.next to i64
  %C.shift28 = shl i64 %C.z, 28
  %CD = or i64 %C.shift28, %D.z

  br label %pc2.loop

pc2.loop:                                            ; build 48-bit subkey from PC2
  %pc2.j = phi i32 [ 0, %rk.body ], [ %pc2.j.next, %pc2.body ]
  %pc2.acc = phi i64 [ 0, %rk.body ], [ %pc2.acc.next, %pc2.body ]
  %pc2.cmp = icmp sle i32 %pc2.j, 47
  br i1 %pc2.cmp, label %pc2.body, label %pc2.end

pc2.body:
  %pc2.idx = sext i32 %pc2.j to i64
  %pc2.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @PC2_5, i64 0, i64 %pc2.idx
  %pc2.val = load i32, i32* %pc2.ptr, align 4
  %pc2.val.z = zext i32 %pc2.val to i64
  %pc2.shift = sub i64 56, %pc2.val.z
  %pc2.sh = lshr i64 %CD, %pc2.shift
  %pc2.bit = and i64 %pc2.sh, 1
  %pc2.acc.shl = shl i64 %pc2.acc, 1
  %pc2.acc.next = or i64 %pc2.acc.shl, %pc2.bit
  %pc2.j.next = add i32 %pc2.j, 1
  br label %pc2.loop

pc2.end:
  %subkey = phi i64 [ %pc2.acc, %pc2.loop ]
  %rk.store.idx = sext i32 %rk.i to i64
  %rk.store.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %rk.store.idx
  store i64 %subkey, i64* %rk.store.ptr, align 8

  %rk.i.next = add i32 %rk.i, 1
  br label %roundkeys.loop

roundkeys.end:
  br label %ip.loop

ip.loop:                                             ; initial permutation IP
  %ip.i = phi i32 [ 0, %roundkeys.end ], [ %ip.i.next, %ip.body ]
  %ip.acc = phi i64 [ 0, %roundkeys.end ], [ %ip.acc.next, %ip.body ]
  %ip.cmp = icmp sle i32 %ip.i, 63
  br i1 %ip.cmp, label %ip.body, label %ip.end

ip.body:
  %ip.idx = sext i32 %ip.i to i64
  %ip.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @IP_4, i64 0, i64 %ip.idx
  %ip.val = load i32, i32* %ip.ptr, align 4
  %ip.val.z = zext i32 %ip.val to i64
  %ip.shift = sub i64 64, %ip.val.z
  %ip.msg.sh = lshr i64 %msg, %ip.shift
  %ip.bit = and i64 %ip.msg.sh, 1
  %ip.acc.shl = shl i64 %ip.acc, 1
  %ip.acc.next = or i64 %ip.acc.shl, %ip.bit
  %ip.i.next = add i32 %ip.i, 1
  br label %ip.loop

ip.end:
  %ip.acc.fin = phi i64 [ %ip.acc, %ip.loop ]
  %L64 = lshr i64 %ip.acc.fin, 32
  %L = trunc i64 %L64 to i32
  %R = trunc i64 %ip.acc.fin to i32
  br label %rounds.loop

rounds.loop:                                         ; 16 Feistel rounds
  %r.i = phi i32 [ 0, %ip.end ], [ %r.i.next, %round.end ]
  %L.cur = phi i32 [ %L, %ip.end ], [ %L.next, %round.end ]
  %R.cur = phi i32 [ %R, %ip.end ], [ %R.next, %round.end ]
  %r.cmp = icmp sle i32 %r.i, 15
  br i1 %r.cmp, label %round.body, label %rounds.end

round.body:
  ; E expansion
  br label %E.loop

E.loop:
  %E.i = phi i32 [ 0, %round.body ], [ %E.i.next, %E.body ]
  %E.acc = phi i64 [ 0, %round.body ], [ %E.acc.next, %E.body ]
  %E.cmp = icmp sle i32 %E.i, 47
  br i1 %E.cmp, label %E.body, label %E.end

E.body:
  %E.idx = sext i32 %E.i to i64
  %E.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @E_3, i64 0, i64 %E.idx
  %E.val = load i32, i32* %E.ptr, align 4
  %E.shift32 = sub i32 32, %E.val
  %R.z = zext i32 %R.cur to i64
  %E.shift64 = zext i32 %E.shift32 to i64
  %E.sh = lshr i64 %R.z, %E.shift64
  %E.bit = and i64 %E.sh, 1
  %E.acc.shl = shl i64 %E.acc, 1
  %E.acc.next = or i64 %E.acc.shl, %E.bit
  %E.i.next = add i32 %E.i, 1
  br label %E.loop

E.end:
  %E.out = phi i64 [ %E.acc, %E.loop ]
  ; XOR with subkey
  %sk.idx = sext i32 %r.i to i64
  %sk.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %sk.idx
  %sk.val = load i64, i64* %sk.ptr, align 8
  %X48 = xor i64 %E.out, %sk.val

  ; S-box compression
  br label %S.loop

S.loop:
  %S.i = phi i32 [ 0, %E.end ], [ %S.i.next, %S.body ]
  %S.acc = phi i32 [ 0, %E.end ], [ %S.acc.next, %S.body ]
  %S.cmp = icmp sle i32 %S.i, 7
  br i1 %S.cmp, label %S.body, label %S.end

S.body:
  %mul6 = mul i32 %S.i, 6
  %shift6.i32 = sub i32 42, %mul6
  %shift6 = zext i32 %shift6.i32 to i64
  %chunk.sh = lshr i64 %X48, %shift6
  %chunk = and i64 %chunk.sh, 63
  %chunk32 = trunc i64 %chunk to i32

  %row_hi = lshr i32 %chunk32, 4
  %row_hi2 = and i32 %row_hi, 2
  %row_lo = and i32 %chunk32, 1
  %row = or i32 %row_hi2, %row_lo

  %col_pre = lshr i32 %chunk32, 1
  %col = and i32 %col_pre, 15

  %row.shift = shl i32 %row, 4
  %sidx = add i32 %row.shift, %col

  %sbox.base = mul i32 %S.i, 64
  %sbox.off = add i32 %sbox.base, %sidx
  %sbox.off64 = zext i32 %sbox.off to i64
  %s.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX_2, i64 0, i64 %sbox.off64
  %s.byte = load i8, i8* %s.ptr, align 1
  %s.val = zext i8 %s.byte to i32

  %S.acc.shl = shl i32 %S.acc, 4
  %S.acc.next = or i32 %S.acc.shl, %s.val
  %S.i.next = add i32 %S.i, 1
  br label %S.loop

S.end:
  %S.out = phi i32 [ %S.acc, %S.loop ]

  ; P permutation
  br label %P.loop

P.loop:
  %P.i = phi i32 [ 0, %S.end ], [ %P.i.next, %P.body ]
  %P.acc = phi i32 [ 0, %S.end ], [ %P.acc.next, %P.body ]
  %P.cmp = icmp sle i32 %P.i, 31
  br i1 %P.cmp, label %P.body, label %P.end

P.body:
  %P.idx = sext i32 %P.i to i64
  %P.ptr = getelementptr inbounds [32 x i32], [32 x i32]* @P_1, i64 0, i64 %P.idx
  %P.val = load i32, i32* %P.ptr, align 4
  %P.shift = sub i32 32, %P.val
  %P.bit.pre = lshr i32 %S.out, %P.shift
  %P.bit = and i32 %P.bit.pre, 1
  %P.acc.shl = shl i32 %P.acc, 1
  %P.acc.next = or i32 %P.acc.shl, %P.bit
  %P.i.next = add i32 %P.i, 1
  br label %P.loop

P.end:
  %f = phi i32 [ %P.acc, %P.loop ]
  %L.next = %R.cur
  %xor = xor i32 %L.cur, %f
  %R.next = %xor
  br label %round.end

round.end:
  %r.i.next = add i32 %r.i, 1
  br label %rounds.loop

rounds.end:
  %L.fin = phi i32 [ %L.cur, %rounds.loop ]
  %R.fin = phi i32 [ %R.cur, %rounds.loop ]

  ; preoutput with final swap applied: R|L
  %R64.fin = zext i32 %R.fin to i64
  %L64.fin = zext i32 %L.fin to i64
  %R.shift32 = shl i64 %R64.fin, 32
  %preout = or i64 %R.shift32, %L64.fin

  br label %fp.loop

fp.loop:                                             ; final permutation FP
  %fp.i = phi i32 [ 0, %rounds.end ], [ %fp.i.next, %fp.body ]
  %fp.acc = phi i64 [ 0, %rounds.end ], [ %fp.acc.next, %fp.body ]
  %fp.cmp = icmp sle i32 %fp.i, 63
  br i1 %fp.cmp, label %fp.body, label %fp.end

fp.body:
  %fp.idx = sext i32 %fp.i to i64
  %fp.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @FP_0, i64 0, i64 %fp.idx
  %fp.val = load i32, i32* %fp.ptr, align 4
  %fp.val.z = zext i32 %fp.val to i64
  %fp.shift = sub i64 64, %fp.val.z
  %fp.pre.sh = lshr i64 %preout, %fp.shift
  %fp.bit = and i64 %fp.pre.sh, 1
  %fp.acc.shl = shl i64 %fp.acc, 1
  %fp.acc.next = or i64 %fp.acc.shl, %fp.bit
  %fp.i.next = add i32 %fp.i, 1
  br label %fp.loop

fp.end:
  %out = phi i64 [ %fp.acc, %fp.loop ]
  ret i64 %out
}