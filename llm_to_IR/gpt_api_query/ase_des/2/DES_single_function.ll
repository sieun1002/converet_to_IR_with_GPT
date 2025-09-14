; LLVM IR (LLVM 14) for: des_encrypt(uint64 plaintext, uint64 key)
; External tables are declared but not defined here. Link against the module that defines them.

@__stack_chk_guard = external global i64

@PC1_7  = external constant [0 x i32]
@SHIFTS_6 = external constant [0 x i32]
@PC2_5  = external constant [0 x i32]
@IP_4   = external constant [0 x i32]
@E_3    = external constant [0 x i32]
@SBOX_2 = external constant [0 x i8]
@P_1    = external constant [0 x i32]
@FP_0   = external constant [0 x i32]

declare void @__stack_chk_fail() noreturn

define i64 @des_encrypt(i64 %plaintext, i64 %key) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard, align 8

  ; Generate 56-bit key permutation (PC1)
  br label %pc1.loop

pc1.loop:                                           ; i in [0..55]
  %i.pc1 = phi i32 [ 0, %entry ], [ %i.pc1.next, %pc1.inc ]
  %acc.pc1 = phi i64 [ 0, %entry ], [ %acc.pc1.next, %pc1.inc ]
  %cmp.pc1 = icmp ule i32 %i.pc1, 55
  br i1 %cmp.pc1, label %pc1.body, label %pc1.end

pc1.body:
  %idx.pc1 = zext i32 %i.pc1 to i64
  %ptr.pc1 = getelementptr inbounds [0 x i32], [0 x i32]* @PC1_7, i64 0, i64 %idx.pc1
  %val.pc1 = load i32, i32* %ptr.pc1, align 4
  %sub.pc1 = sub i32 64, %val.pc1
  %shamt.pc1 = zext i32 %sub.pc1 to i64
  %shr.pc1 = lshr i64 %key, %shamt.pc1
  %bit.pc1 = and i64 %shr.pc1, 1
  %shlacc.pc1 = shl i64 %acc.pc1, 1
  %acc.pc1.next = or i64 %shlacc.pc1, %bit.pc1
  br label %pc1.inc

pc1.inc:
  %i.pc1.next = add i32 %i.pc1, 1
  br label %pc1.loop

pc1.end:
  ; Split into C and D 28-bit halves
  %c0.shift = lshr i64 %acc.pc1, 28
  %c0.trunc = trunc i64 %c0.shift to i32
  %C = and i32 %c0.trunc, 268435455          ; 0x0FFFFFFF
  %D.trunc = trunc i64 %acc.pc1 to i32
  %D = and i32 %D.trunc, 268435455

  ; Allocate round keys
  %keys = alloca [16 x i64], align 8

  ; Generate 16 round keys
  br label %rk.loop

rk.loop:                                            ; r in [0..15]
  %r = phi i32 [ 0, %pc1.end ], [ %r.next, %rk.after.store ]
  %C.phi = phi i32 [ %C, %pc1.end ], [ %C.next, %rk.after.store ]
  %D.phi = phi i32 [ %D, %pc1.end ], [ %D.next, %rk.after.store ]
  %rk.cont = icmp ule i32 %r, 15
  br i1 %rk.cont, label %rk.body, label %rk.end

rk.body:
  ; shift = SHIFTS_6[r]
  %r.idx = zext i32 %r to i64
  %ptr.sh = getelementptr inbounds [0 x i32], [0 x i32]* @SHIFTS_6, i64 0, i64 %r.idx
  %shift = load i32, i32* %ptr.sh, align 4
  ; Rotate C and D by 'shift' within 28 bits
  %shz = and i32 %shift, 31
  %shinv = sub i32 28, %shz
  %C.shl = shl i32 %C.phi, %shz
  %C.lshr = lshr i32 %C.phi, %shinv
  %C.rot = or i32 %C.shl, %C.lshr
  %C.next = and i32 %C.rot, 268435455

  %D.shl = shl i32 %D.phi, %shz
  %D.lshr = lshr i32 %D.phi, %shinv
  %D.rot = or i32 %D.shl, %D.lshr
  %D.next = and i32 %D.rot, 268435455

  ; Combine into 56-bit value
  %C64 = zext i32 %C.next to i64
  %D64 = zext i32 %D.next to i64
  %C64.shl28 = shl i64 %C64, 28
  %CD56 = or i64 %C64.shl28, %D64

  ; Apply PC2 to build 48-bit subkey
  br label %pc2.loop

pc2.loop:                                           ; j in [0..47]
  %j = phi i32 [ 0, %rk.body ], [ %j.next, %pc2.inc ]
  %acc.pc2 = phi i64 [ 0, %rk.body ], [ %acc.pc2.next, %pc2.inc ]
  %pc2.cont = icmp ule i32 %j, 47
  br i1 %pc2.cont, label %pc2.body, label %pc2.end

pc2.body:
  %j.idx = zext i32 %j to i64
  %ptr.pc2 = getelementptr inbounds [0 x i32], [0 x i32]* @PC2_5, i64 0, i64 %j.idx
  %val.pc2 = load i32, i32* %ptr.pc2, align 4
  %sub.pc2 = sub i32 56, %val.pc2
  %shamt.pc2 = zext i32 %sub.pc2 to i64
  %shr.pc2 = lshr i64 %CD56, %shamt.pc2
  %bit.pc2 = and i64 %shr.pc2, 1
  %acc.pc2.shl = shl i64 %acc.pc2, 1
  %acc.pc2.next = or i64 %acc.pc2.shl, %bit.pc2
  br label %pc2.inc

pc2.inc:
  %j.next = add i32 %j, 1
  br label %pc2.loop

pc2.end:
  ; Store round key
  %keys.ptr0 = getelementptr inbounds [16 x i64], [16 x i64]* %keys, i64 0, i64 %r.idx
  store i64 %acc.pc2, i64* %keys.ptr0, align 8
  br label %rk.after.store

rk.after.store:
  %r.next = add i32 %r, 1
  br label %rk.loop

rk.end:
  ; Initial Permutation on plaintext -> 64-bit
  br label %ip.loop

ip.loop:                                            ; k in [0..63]
  %k = phi i32 [ 0, %rk.end ], [ %k.next, %ip.inc ]
  %acc.ip = phi i64 [ 0, %rk.end ], [ %acc.ip.next, %ip.inc ]
  %ip.cont = icmp ule i32 %k, 63
  br i1 %ip.cont, label %ip.body, label %ip.end

ip.body:
  %k.idx = zext i32 %k to i64
  %ptr.ip = getelementptr inbounds [0 x i32], [0 x i32]* @IP_4, i64 0, i64 %k.idx
  %val.ip = load i32, i32* %ptr.ip, align 4
  %sub.ip = sub i32 64, %val.ip
  %shamt.ip = zext i32 %sub.ip to i64
  %shr.ip = lshr i64 %plaintext, %shamt.ip
  %bit.ip = and i64 %shr.ip, 1
  %acc.ip.shl = shl i64 %acc.ip, 1
  %acc.ip.next = or i64 %acc.ip.shl, %bit.ip
  br label %ip.inc

ip.inc:
  %k.next = add i32 %k, 1
  br label %ip.loop

ip.end:
  ; Split into L and R (32-bit)
  %L0.shift = lshr i64 %acc.ip, 32
  %L = trunc i64 %L0.shift to i32
  %R = trunc i64 %acc.ip to i32

  ; 16 Feistel rounds
  br label %round.loop

round.loop:                                         ; round in [0..15]
  %round = phi i32 [ 0, %ip.end ], [ %round.next, %round.end ]
  %L.phi = phi i32 [ %L, %ip.end ], [ %L.new, %round.end ]
  %R.phi = phi i32 [ %R, %ip.end ], [ %R.new, %round.end ]
  %round.cont = icmp ule i32 %round, 15
  br i1 %round.cont, label %round.body, label %rounds.done

round.body:
  ; Expansion E on R (32->48)
  br label %e.loop

e.loop:                                             ; e in [0..47]
  %e = phi i32 [ 0, %round.body ], [ %e.next, %e.inc ]
  %acc.e = phi i64 [ 0, %round.body ], [ %acc.e.next, %e.inc ]
  %e.cont = icmp ule i32 %e, 47
  br i1 %e.cont, label %e.body, label %e.end

e.body:
  %e.idx = zext i32 %e to i64
  %ptr.e = getelementptr inbounds [0 x i32], [0 x i32]* @E_3, i64 0, i64 %e.idx
  %val.e = load i32, i32* %ptr.e, align 4
  %sub.e = sub i32 32, %val.e
  %shamt.e = and i32 %sub.e, 31
  %shr.e32 = lshr i32 %R.phi, %shamt.e
  %bit.e32 = and i32 %shr.e32, 1
  %bit.e = zext i32 %bit.e32 to i64
  %acc.e.shl = shl i64 %acc.e, 1
  %acc.e.next = or i64 %acc.e.shl, %bit.e
  br label %e.inc

e.inc:
  %e.next = add i32 %e, 1
  br label %e.loop

e.end:
  ; XOR with round key
  %rk.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %keys, i64 0, i64 %r.idx
  %rk.load = load i64, i64* %rk.ptr, align 8
  %x48 = xor i64 %acc.e, %rk.load

  ; S-box substitution (48->32)
  br label %s.loop

s.loop:                                             ; s in [0..7]
  %s = phi i32 [ 0, %e.end ], [ %s.next, %s.inc ]
  %acc.s = phi i32 [ 0, %e.end ], [ %acc.s.next, %s.inc ]
  %s.cont = icmp ule i32 %s, 7
  br i1 %s.cont, label %s.body, label %s.end

s.body:
  ; shift = 42 - 6*s
  %s.mul4 = shl i32 %s, 2
  %tmp.sub = sub i32 %s, %s.mul4            ; s - 4s = -3s
  %tmp.mul2 = shl i32 %tmp.sub, 1           ; -6s
  %shift.s = add i32 %tmp.mul2, 42          ; 42 - 6s
  %shamt.s = zext i32 %shift.s to i64
  %grp = lshr i64 %x48, %shamt.s
  %grp6 = and i64 %grp, 63
  %grp6.i32 = trunc i64 %grp6 to i32
  ; row = ((grp >> 4) & 2) | (grp & 1)
  %row.hi = lshr i32 %grp6.i32, 4
  %row.hi2 = and i32 %row.hi, 2
  %row.lo = and i32 %grp6.i32, 1
  %row = or i32 %row.hi2, %row.lo
  ; col = (grp >> 1) & 0xF
  %col.shr = lshr i32 %grp6.i32, 1
  %col = and i32 %col.shr, 15
  ; idx = (row<<4) + col
  %row.shl4 = shl i32 %row, 4
  %idx.s = add i32 %row.shl4, %col
  ; table offset = (s << 6) + idx
  %s.off = shl i32 %s, 6
  %off.sum = add i32 %s.off, %idx.s
  %off.sum64 = zext i32 %off.sum to i64
  %ptr.sbox = getelementptr inbounds [0 x i8], [0 x i8]* @SBOX_2, i64 0, i64 %off.sum64
  %val.sbox.i8 = load i8, i8* %ptr.sbox, align 1
  %val.sbox = zext i8 %val.sbox.i8 to i32
  %acc.s.shl = shl i32 %acc.s, 4
  %acc.s.next = or i32 %acc.s.shl, %val.sbox
  br label %s.inc

s.inc:
  %s.next = add i32 %s, 1
  br label %s.loop

s.end:
  ; P permutation (32->32)
  br label %p.loop

p.loop:                                             ; p in [0..31]
  %p = phi i32 [ 0, %s.end ], [ %p.next, %p.inc ]
  %acc.p = phi i32 [ 0, %s.end ], [ %acc.p.next, %p.inc ]
  %p.cont = icmp ule i32 %p, 31
  br i1 %p.cont, label %p.body, label %p.end

p.body:
  %p.idx = zext i32 %p to i64
  %ptr.p = getelementptr inbounds [0 x i32], [0 x i32]* @P_1, i64 0, i64 %p.idx
  %val.p = load i32, i32* %ptr.p, align 4
  %sub.p = sub i32 32, %val.p
  %shamt.p = and i32 %sub.p, 31
  %shr.p = lshr i32 %acc.s, %shamt.p
  %bit.p = and i32 %shr.p, 1
  %acc.p.shl = shl i32 %acc.p, 1
  %acc.p.next = or i32 %acc.p.shl, %bit.p
  br label %p.inc

p.inc:
  %p.next = add i32 %p, 1
  br label %p.loop

p.end:
  ; Feistel swap and combine
  %L.new = %R.phi
  %R.new = xor i32 %L.phi, %acc.p
  br label %round.end

round.end:
  %round.next = add i32 %round, 1
  br label %round.loop

rounds.done:
  ; Preoutput: (R << 32) | L
  %R64 = zext i32 %R.phi to i64
  %L64 = zext i32 %L.phi to i64
  %R64.shl32 = shl i64 %R64, 32
  %preout = or i64 %R64.shl32, %L64

  ; Final Permutation (FP)
  br label %fp.loop

fp.loop:                                            ; f in [0..63]
  %f = phi i32 [ 0, %rounds.done ], [ %f.next, %fp.inc ]
  %acc.fp = phi i64 [ 0, %rounds.done ], [ %acc.fp.next, %fp.inc ]
  %fp.cont = icmp ule i32 %f, 63
  br i1 %fp.cont, label %fp.body, label %fp.end

fp.body:
  %f.idx = zext i32 %f to i64
  %ptr.fp = getelementptr inbounds [0 x i32], [0 x i32]* @FP_0, i64 0, i64 %f.idx
  %val.fp = load i32, i32* %ptr.fp, align 4
  %sub.fp = sub i32 64, %val.fp
  %shamt.fp = zext i32 %sub.fp to i64
  %shr.fp = lshr i64 %preout, %shamt.fp
  %bit.fp = and i64 %shr.fp, 1
  %acc.fp.shl = shl i64 %acc.fp, 1
  %acc.fp.next = or i64 %acc.fp.shl, %bit.fp
  br label %fp.inc

fp.inc:
  %f.next = add i32 %f, 1
  br label %fp.loop

fp.end:
  ; Stack canary check and return
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %guard, %guard2
  br i1 %ok, label %ret, label %stkfail

stkfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i64 %acc.fp
}