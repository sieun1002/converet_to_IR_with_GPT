; ModuleID = 'des_encrypt.ll'
target triple = "x86_64-unknown-linux-gnu"

@__stack_chk_guard = external global i64
declare void @__stack_chk_fail() noreturn

@PC1_7   = external constant [64 x i32]
@SHIFTS_6 = external constant [16 x i32]
@PC2_5   = external constant [64 x i32]
@IP_4    = external constant [64 x i32]
@E_3     = external constant [64 x i32]
@SBOX_2  = external constant [512 x i8]
@P_1     = external constant [32 x i32]
@FP_0    = external constant [64 x i32]

define i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %g0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %g0, i64* %canary.slot, align 8

  ; Build 56-bit key using PC1
  br label %pc1.loop

pc1.loop:                                            ; i in [0..55]
  %pc1.i = phi i32 [ 0, %entry ], [ %pc1.i.next, %pc1.body ]
  %pc1.acc = phi i64 [ 0, %entry ], [ %pc1.acc.next, %pc1.body ]
  %pc1.cmp = icmp sle i32 %pc1.i, 55
  br i1 %pc1.cmp, label %pc1.body, label %pc1.end

pc1.body:
  %pc1.idx64 = zext i32 %pc1.i to i64
  %pc1.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @PC1_7, i64 0, i64 %pc1.idx64
  %pc1.val = load i32, i32* %pc1.ptr, align 4
  %pc1.val64 = zext i32 %pc1.val to i64
  %pc1.sh = sub i64 64, %pc1.val64
  %key.shift = lshr i64 %key, %pc1.sh
  %pc1.bit = and i64 %key.shift, 1
  %pc1.acc.shl = shl i64 %pc1.acc, 1
  %pc1.acc.next = or i64 %pc1.acc.shl, %pc1.bit
  %pc1.i.next = add i32 %pc1.i, 1
  br label %pc1.loop

pc1.end:
  ; Split into C and D (28-bit halves)
  %pc1.final = phi i64 [ %pc1.acc, %pc1.loop ]
  %C0.shift = lshr i64 %pc1.final, 28
  %C0 = and i64 %C0.shift, 268435455
  %D0 = and i64 %pc1.final, 268435455
  %C0.i32 = trunc i64 %C0 to i32
  %D0.i32 = trunc i64 %D0 to i32

  ; Subkeys array
  %subkeys = alloca [16 x i64], align 16

  br label %sk.outer

sk.outer:                                            ; round in [0..15]
  %r.i = phi i32 [ 0, %pc1.end ], [ %r.i.next, %sk.outer.end ]
  %C.cur = phi i32 [ %C0.i32, %pc1.end ], [ %C.next, %sk.outer.end ]
  %D.cur = phi i32 [ %D0.i32, %pc1.end ], [ %D.next, %sk.outer.end ]
  %r.cmp = icmp sle i32 %r.i, 15
  br i1 %r.cmp, label %sk.body, label %sk.done

sk.body:
  ; load shift count
  %r.idx64 = zext i32 %r.i to i64
  %sh.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS_6, i64 0, i64 %r.idx64
  %sh = load i32, i32* %sh.ptr, align 4
  %sh.mask = and i32 %sh, 31
  ; rotate C and D (28-bit)
  %C.shl = shl i32 %C.cur, %sh.mask
  %C.invsh = sub i32 28, %sh.mask
  %C.shr = lshr i32 %C.cur, %C.invsh
  %C.rot.or = or i32 %C.shl, %C.shr
  %C.masked = and i32 %C.rot.or, 268435455
  %D.shl = shl i32 %D.cur, %sh.mask
  %D.invsh = sub i32 28, %sh.mask
  %D.shr = lshr i32 %D.cur, %D.invsh
  %D.rot.or = or i32 %D.shl, %D.shr
  %D.masked = and i32 %D.rot.or, 268435455

  ; combine to 56-bit CD
  %C.z = zext i32 %C.masked to i64
  %D.z = zext i32 %D.masked to i64
  %C.shl28 = shl i64 %C.z, 28
  %CD56 = or i64 %C.shl28, %D.z

  ; apply PC2 to build 48-bit subkey
  br label %pc2.loop

pc2.loop:                                            ; j in [0..47]
  %pc2.j = phi i32 [ 0, %sk.body ], [ %pc2.j.next, %pc2.body ]
  %pc2.acc = phi i64 [ 0, %sk.body ], [ %pc2.acc.next, %pc2.body ]
  %pc2.cmp = icmp sle i32 %pc2.j, 47
  br i1 %pc2.cmp, label %pc2.body, label %pc2.end

pc2.body:
  %pc2.j64 = zext i32 %pc2.j to i64
  %pc2.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @PC2_5, i64 0, i64 %pc2.j64
  %pc2.v = load i32, i32* %pc2.ptr, align 4
  %pc2.v64 = zext i32 %pc2.v to i64
  %pc2.sh = sub i64 56, %pc2.v64
  %cd.shift = lshr i64 %CD56, %pc2.sh
  %pc2.bit = and i64 %cd.shift, 1
  %pc2.acc.shl = shl i64 %pc2.acc, 1
  %pc2.acc.next = or i64 %pc2.acc.shl, %pc2.bit
  %pc2.j.next = add i32 %pc2.j, 1
  br label %pc2.loop

pc2.end:
  %subkey = phi i64 [ %pc2.acc, %pc2.loop ]
  ; store subkey
  %sk.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %r.idx64
  store i64 %subkey, i64* %sk.ptr, align 8

  ; update halves
  %C.next = %C.masked
  %D.next = %D.masked
  %r.i.next = add i32 %r.i, 1
  br label %sk.outer

sk.outer.end:                                        ; not used

sk.done:
  ; Initial Permutation on input block
  br label %ip.loop

ip.loop:                                             ; k in [0..63]
  %ip.k = phi i32 [ 0, %sk.done ], [ %ip.k.next, %ip.body ]
  %ip.acc = phi i64 [ 0, %sk.done ], [ %ip.acc.next, %ip.body ]
  %ip.cmp = icmp sle i32 %ip.k, 63
  br i1 %ip.cmp, label %ip.body, label %ip.end

ip.body:
  %ip.k64 = zext i32 %ip.k to i64
  %ip.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @IP_4, i64 0, i64 %ip.k64
  %ip.v = load i32, i32* %ip.ptr, align 4
  %ip.v64 = zext i32 %ip.v to i64
  %ip.sh = sub i64 64, %ip.v64
  %blk.shift = lshr i64 %block, %ip.sh
  %ip.bit = and i64 %blk.shift, 1
  %ip.acc.shl = shl i64 %ip.acc, 1
  %ip.acc.next = or i64 %ip.acc.shl, %ip.bit
  %ip.k.next = add i32 %ip.k, 1
  br label %ip.loop

ip.end:
  %ip.final = phi i64 [ %ip.acc, %ip.loop ]
  %L0.shift = lshr i64 %ip.final, 32
  %L0 = trunc i64 %L0.shift to i32
  %R0 = trunc i64 %ip.final to i32

  ; 16 Feistel rounds
  br label %round.loop

round.loop:                                          ; r in [0..15]
  %r2.i = phi i32 [ 0, %ip.end ], [ %r2.i.next, %round.end ]
  %L.cur = phi i32 [ %L0, %ip.end ], [ %L.next, %round.end ]
  %R.cur = phi i32 [ %R0, %ip.end ], [ %R.next, %round.end ]
  %r2.cmp = icmp sle i32 %r2.i, 15
  br i1 %r2.cmp, label %round.body, label %round.done

round.body:
  ; E expansion (32 -> 48)
  br label %e.loop

e.loop:                                              ; j in [0..47]
  %e.j = phi i32 [ 0, %round.body ], [ %e.j.next, %e.body ]
  %e.acc = phi i64 [ 0, %round.body ], [ %e.acc.next, %e.body ]
  %e.cmp = icmp sle i32 %e.j, 47
  br i1 %e.cmp, label %e.body, label %e.end

e.body:
  %e.j64 = zext i32 %e.j to i64
  %e.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @E_3, i64 0, i64 %e.j64
  %e.v = load i32, i32* %e.ptr, align 4
  %e.sh = sub i32 32, %e.v
  %R.z = zext i32 %R.cur to i64
  %R.shift = lshr i64 %R.z, (zext i32 %e.sh to i64)
  %e.bit = and i64 %R.shift, 1
  %e.acc.shl = shl i64 %e.acc, 1
  %e.acc.next = or i64 %e.acc.shl, %e.bit
  %e.j.next = add i32 %e.j, 1
  br label %e.loop

e.end:
  %E48 = phi i64 [ %e.acc, %e.loop ]
  ; XOR with subkey
  %r2.idx64 = zext i32 %r2.i to i64
  %sk.r.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %r2.idx64
  %sk.r = load i64, i64* %sk.r.ptr, align 8
  %A0 = xor i64 %E48, %sk.r

  ; S-box substitution -> 32-bit
  br label %s.loop

s.loop:                                              ; b in [0..7]
  %s.b = phi i32 [ 0, %e.end ], [ %s.b.next, %s.body ]
  %s.acc = phi i32 [ 0, %e.end ], [ %s.acc.next, %s.body ]
  %s.cmp = icmp sle i32 %s.b, 7
  br i1 %s.cmp, label %s.body, label %s.end

s.body:
  %b64 = zext i32 %s.b to i64
  %b.mul6 = mul nuw nsw i64 %b64, 6
  %sh.from42 = sub i64 42, %b.mul6
  %chunk.shift = lshr i64 %A0, %sh.from42
  %chunk6 = and i64 %chunk.shift, 63

  %topbit = and i64 %chunk6, 32
  %topbit.s = lshr i64 %topbit, 4                 ; -> 2 or 0
  %lowbit = and i64 %chunk6, 1
  %row64 = or i64 %topbit.s, %lowbit
  %row = trunc i64 %row64 to i32

  %col.shift = lshr i64 %chunk6, 1
  %col64 = and i64 %col.shift, 15
  %col = trunc i64 %col64 to i32

  %row.shl4 = shl i32 %row, 4
  %rowcol = or i32 %row.shl4, %col
  %rowcol64 = zext i32 %rowcol to i64

  %b.mul64 = mul nuw nsw i64 %b64, 64
  %s.idx = add i64 %b.mul64, %rowcol64
  %s.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX_2, i64 0, i64 %s.idx
  %s.val8 = load i8, i8* %s.ptr, align 1
  %s.val = zext i8 %s.val8 to i32

  %s.acc.shl = shl i32 %s.acc, 4
  %s.acc.next = or i32 %s.acc.shl, %s.val
  %s.b.next = add i32 %s.b, 1
  br label %s.loop

s.end:
  %S32 = phi i32 [ %s.acc, %s.loop ]

  ; P permutation -> f
  br label %p.loop

p.loop:                                              ; p in [0..31]
  %p.i = phi i32 [ 0, %s.end ], [ %p.i.next, %p.body ]
  %p.acc = phi i32 [ 0, %s.end ], [ %p.acc.next, %p.body ]
  %p.cmp = icmp sle i32 %p.i, 31
  br i1 %p.cmp, label %p.body, label %p.end

p.body:
  %p.i64 = zext i32 %p.i to i64
  %p.ptr = getelementptr inbounds [32 x i32], [32 x i32]* @P_1, i64 0, i64 %p.i64
  %p.v = load i32, i32* %p.ptr, align 4
  %p.sh = sub i32 32, %p.v
  %S32.z = zext i32 %S32 to i64
  %S.shift = lshr i64 %S32.z, (zext i32 %p.sh to i64)
  %p.bit64 = and i64 %S.shift, 1
  %p.bit = trunc i64 %p.bit64 to i32
  %p.acc.shl = shl i32 %p.acc, 1
  %p.acc.next = or i32 %p.acc.shl, %p.bit
  %p.i.next = add i32 %p.i, 1
  br label %p.loop

p.end:
  %f = phi i32 [ %p.acc, %p.loop ]

  ; Feistel combine and swap
  %R.save = %R.cur
  %L.xor.f = xor i32 %L.cur, %f
  %L.next = %R.save
  %R.next = %L.xor.f

  %r2.i.next = add i32 %r2.i, 1
  br label %round.loop

round.end:                                           ; not used

round.done:
  ; combine preoutput R||L
  %R.z2 = zext i32 %R.cur to i64
  %L.z2 = zext i32 %L.cur to i64
  %R.shl32 = shl i64 %R.z2, 32
  %preout = or i64 %R.shl32, %L.z2

  ; Final permutation
  br label %fp.loop

fp.loop:                                             ; k in [0..63]
  %fp.k = phi i32 [ 0, %round.done ], [ %fp.k.next, %fp.body ]
  %fp.acc = phi i64 [ 0, %round.done ], [ %fp.acc.next, %fp.body ]
  %fp.cmp = icmp sle i32 %fp.k, 63
  br i1 %fp.cmp, label %fp.body, label %fp.end

fp.body:
  %fp.k64 = zext i32 %fp.k to i64
  %fp.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @FP_0, i64 0, i64 %fp.k64
  %fp.v = load i32, i32* %fp.ptr, align 4
  %fp.v64 = zext i32 %fp.v to i64
  %fp.sh = sub i64 64, %fp.v64
  %pre.shift = lshr i64 %preout, %fp.sh
  %fp.bit = and i64 %pre.shift, 1
  %fp.acc.shl = shl i64 %fp.acc, 1
  %fp.acc.next = or i64 %fp.acc.shl, %fp.bit
  %fp.k.next = add i32 %fp.k, 1
  br label %fp.loop

fp.end:
  %cipher = phi i64 [ %fp.acc, %fp.loop ]

  ; stack canary check
  %g1 = load i64, i64* @__stack_chk_guard, align 8
  %g0.loaded = load i64, i64* %canary.slot, align 8
  %canary.ok = icmp eq i64 %g0.loaded, %g1
  br i1 %canary.ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i64 %cipher
}