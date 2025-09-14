; ModuleID = 'aes128.ll'
source_filename = "aes128.ll"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@sbox_1 = external constant [256 x i8], align 16
@rcon_0 = external constant [256 x i8], align 16

define dso_local void @aes128_encrypt(i8* nocapture %out, i8* nocapture readonly %in, i8* nocapture readonly %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %rk = alloca [176 x i8], align 16

  ; copy input block into state[16]
  br label %in.loop

in.loop:                                          ; preds = %in.loop, %entry
  %i.in = phi i32 [ 0, %entry ], [ %i.in.next, %in.loop ]
  %i.in.i64 = zext i32 %i.in to i64
  %in.ptr.i = getelementptr inbounds i8, i8* %in, i64 %i.in.i64
  %in.val = load i8, i8* %in.ptr.i, align 1
  %state.gep = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.in.i64
  store i8 %in.val, i8* %state.gep, align 1
  %i.in.next = add nuw nsw i32 %i.in, 1
  %in.cond = icmp sle i32 %i.in.next, 15
  br i1 %in.cond, label %in.loop, label %copykey

copykey:                                          ; preds = %in.loop
  ; copy key[16] into rk[0..15]
  br label %key.loop

key.loop:                                         ; preds = %key.loop, %copykey
  %i.key = phi i32 [ 0, %copykey ], [ %i.key.next, %key.loop ]
  %i.key.i64 = zext i32 %i.key to i64
  %key.ptr.i = getelementptr inbounds i8, i8* %key, i64 %i.key.i64
  %key.val = load i8, i8* %key.ptr.i, align 1
  %rk.gep0 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.key.i64
  store i8 %key.val, i8* %rk.gep0, align 1
  %i.key.next = add nuw nsw i32 %i.key, 1
  %key.cond = icmp sle i32 %i.key.next, 15
  br i1 %key.cond, label %key.loop, label %expand.init

expand.init:                                      ; preds = %key.loop
  %i.exp.init = add nuw nsw i32 16, 0
  %rcon.idx.init = add nuw nsw i32 0, 0
  br label %expand.loop

; AES-128 key expansion: generate rk[16..175]
expand.loop:                                      ; preds = %expand.cont, %expand.init
  %i.exp = phi i32 [ %i.exp.init, %expand.init ], [ %i.exp.next4, %expand.cont ]
  %rcon.idx = phi i32 [ %rcon.idx.init, %expand.init ], [ %rcon.next, %expand.cont ]
  %cond.exp = icmp sle i32 %i.exp, 175
  br i1 %cond.exp, label %expand.body, label %addroundkey0

expand.body:                                      ; preds = %expand.loop
  ; load last 4 bytes: t0..t3 = rk[i-4..i-1]
  %i.m4 = add nsw i32 %i.exp, -4
  %i.m3 = add nsw i32 %i.exp, -3
  %i.m2 = add nsw i32 %i.exp, -2
  %i.m1 = add nsw i32 %i.exp, -1
  %i.m4.i64 = sext i32 %i.m4 to i64
  %i.m3.i64 = sext i32 %i.m3 to i64
  %i.m2.i64 = sext i32 %i.m2 to i64
  %i.m1.i64 = sext i32 %i.m1 to i64
  %t0.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m4.i64
  %t1.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m3.i64
  %t2.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m2.i64
  %t3.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m1.i64
  %t0 = load i8, i8* %t0.ptr, align 1
  %t1 = load i8, i8* %t1.ptr, align 1
  %t2 = load i8, i8* %t2.ptr, align 1
  %t3 = load i8, i8* %t3.ptr, align 1

  ; if (i % 16 == 0) { t = SubWord(RotWord(t)); t0 ^= rcon[rcon_idx]; rcon_idx++ }
  %i.and = and i32 %i.exp, 15
  %need.core = icmp eq i32 %i.and, 0
  br i1 %need.core, label %coreword, label %nocore

coreword:                                         ; preds = %expand.body
  ; rotate left 1 byte: (t1,t2,t3,t0)
  %rt0 = zext i8 %t1 to i32
  %rt1 = zext i8 %t2 to i32
  %rt2 = zext i8 %t3 to i32
  %rt3 = zext i8 %t0 to i32
  ; sbox each
  %s0.gep = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 (zext i32 %rt0 to i64)
  %s1.gep = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 (zext i32 %rt1 to i64)
  %s2.gep = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 (zext i32 %rt2 to i64)
  %s3.gep = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 (zext i32 %rt3 to i64)
  %s0 = load i8, i8* %s0.gep, align 1
  %s1 = load i8, i8* %s1.gep, align 1
  %s2 = load i8, i8* %s2.gep, align 1
  %s3 = load i8, i8* %s3.gep, align 1
  ; rcon
  %rci.i64 = zext i32 %rcon.idx to i64
  %rcon.gep = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 %rci.i64
  %rconval = load i8, i8* %rcon.gep, align 1
  %s0.rc = xor i8 %s0, %rconval
  %rcon.next = add nuw nsw i32 %rcon.idx, 1
  br label %aftercore

nocore:                                           ; preds = %expand.body
  %s0.rc.n = %t0
  %s1.n = %t1
  %s2.n = %t2
  %s3.n = %t3
  br label %aftercore

aftercore:                                        ; preds = %nocore, %coreword
  %tt0 = phi i8 [ %s0.rc, %coreword ], [ %s0.rc.n, %nocore ]
  %tt1 = phi i8 [ %s1, %coreword ],     [ %s1.n, %nocore ]
  %tt2 = phi i8 [ %s2, %coreword ],     [ %s2.n, %nocore ]
  %tt3 = phi i8 [ %s3, %coreword ],     [ %s3.n, %nocore ]
  %rcon.out = phi i32 [ %rcon.next, %coreword ], [ %rcon.idx, %nocore ]

  ; rk[i + j] = rk[i - 16 + j] ^ ttj
  %i.m16 = add nsw i32 %i.exp, -16
  %i.m16.i64 = sext i32 %i.m16 to i64
  %i.i64 = sext i32 %i.exp to i64
  %base.m16 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m16.i64
  %base.i = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.i64

  ; j = 0
  %src0 = load i8, i8* %base.m16, align 1
  %w0 = xor i8 %src0, %tt0
  store i8 %w0, i8* %base.i, align 1
  ; j = 1
  %base.m16.1 = getelementptr inbounds i8, i8* %base.m16, i64 1
  %base.i.1   = getelementptr inbounds i8, i8* %base.i,   i64 1
  %src1 = load i8, i8* %base.m16.1, align 1
  %w1 = xor i8 %src1, %tt1
  store i8 %w1, i8* %base.i.1, align 1
  ; j = 2
  %base.m16.2 = getelementptr inbounds i8, i8* %base.m16, i64 2
  %base.i.2   = getelementptr inbounds i8, i8* %base.i,   i64 2
  %src2 = load i8, i8* %base.m16.2, align 1
  %w2 = xor i8 %src2, %tt2
  store i8 %w2, i8* %base.i.2, align 1
  ; j = 3
  %base.m16.3 = getelementptr inbounds i8, i8* %base.m16, i64 3
  %base.i.3   = getelementptr inbounds i8, i8* %base.i,   i64 3
  %src3 = load i8, i8* %base.m16.3, align 1
  %w3 = xor i8 %src3, %tt3
  store i8 %w3, i8* %base.i.3, align 1

  %i.exp.next4 = add nsw i32 %i.exp, 4
  br label %expand.cont

expand.cont:                                      ; preds = %aftercore
  br label %expand.loop

; Initial AddRoundKey with rk[0..15]
addroundkey0:                                     ; preds = %expand.loop
  br label %ark0.loop

ark0.loop:                                        ; preds = %ark0.loop, %addroundkey0
  %i.ark0 = phi i32 [ 0, %addroundkey0 ], [ %i.ark0.next, %ark0.loop ]
  %i.ark0.i64 = zext i32 %i.ark0 to i64
  %state.p0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.ark0.i64
  %rk.p0 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.ark0.i64
  %sv0 = load i8, i8* %state.p0, align 1
  %kv0 = load i8, i8* %rk.p0, align 1
  %x0 = xor i8 %sv0, %kv0
  store i8 %x0, i8* %state.p0, align 1
  %i.ark0.next = add nuw nsw i32 %i.ark0, 1
  %ark0.cond = icmp sle i32 %i.ark0.next, 15
  br i1 %ark0.cond, label %ark0.loop, label %rounds.init

; 9 main rounds
rounds.init:                                      ; preds = %ark0.loop
  %round = add nuw nsw i32 1, 0
  br label %rounds.loop

rounds.loop:                                      ; preds = %addround.loop.end, %rounds.init
  %r = phi i32 [ %round, %rounds.init ], [ %r.next, %addround.loop.end ]
  %cont.rounds = icmp sle i32 %r, 9
  br i1 %cont.rounds, label %subbytes, label %final.sub

; SubBytes state[i] = sbox[state[i]]
subbytes:                                         ; preds = %rounds.loop
  br label %sb.loop

sb.loop:                                          ; preds = %sb.loop, %subbytes
  %i.sb = phi i32 [ 0, %subbytes ], [ %i.sb.next, %sb.loop ]
  %i.sb.i64 = zext i32 %i.sb to i64
  %sptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.sb.i64
  %sval = load i8, i8* %sptr, align 1
  %sidx = zext i8 %sval to i64
  %sbox.gep = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %sidx
  %sbox.val = load i8, i8* %sbox.gep, align 1
  store i8 %sbox.val, i8* %sptr, align 1
  %i.sb.next = add nuw nsw i32 %i.sb, 1
  %sb.cond = icmp sle i32 %i.sb.next, 15
  br i1 %sb.cond, label %sb.loop, label %shiftrows

; ShiftRows
shiftrows:                                        ; preds = %sb.loop
  ; Row 1 rotate left by 1: indices 1,5,9,13
  %p1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %p5 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %p9 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %p13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %v1 = load i8, i8* %p1, align 1
  %v5 = load i8, i8* %p5, align 1
  %v9 = load i8, i8* %p9, align 1
  %v13 = load i8, i8* %p13, align 1
  store i8 %v5,  i8* %p1,  align 1
  store i8 %v9,  i8* %p5,  align 1
  store i8 %v13, i8* %p9,  align 1
  store i8 %v1,  i8* %p13, align 1
  ; Row 2 rotate left by 2: swap 2<->10 and 6<->14
  %p2  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %p6  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %p10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %p14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %v2  = load i8, i8* %p2,  align 1
  %v10 = load i8, i8* %p10, align 1
  store i8 %v10, i8* %p2,  align 1
  store i8 %v2,  i8* %p10, align 1
  %v6  = load i8, i8* %p6,  align 1
  %v14 = load i8, i8* %p14, align 1
  store i8 %v14, i8* %p6,  align 1
  store i8 %v6,  i8* %p14, align 1
  ; Row 3 rotate left by 3: indices 3,7,11,15
  %p3  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %p7  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %p11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %p15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %v3  = load i8, i8* %p3,  align 1
  %v7  = load i8, i8* %p7,  align 1
  %v11 = load i8, i8* %p11, align 1
  %v15 = load i8, i8* %p15, align 1
  store i8 %v15, i8* %p3,  align 1
  store i8 %v11, i8* %p15, align 1
  store i8 %v7,  i8* %p11, align 1
  store i8 %v3,  i8* %p7,  align 1
  br label %mixcolumns

; MixColumns (optimized form)
mixcolumns:                                       ; preds = %shiftrows
  br label %mc.col.loop

mc.col.loop:                                      ; preds = %mc.col.loop, %mixcolumns
  %c = phi i32 [ 0, %mixcolumns ], [ %c.next, %mc.col.loop ]
  %c.mul4 = shl i32 %c, 2
  %c0.i64 = zext i32 %c.mul4 to i64
  %c1.i64 = add i64 %c0.i64, 1
  %c2.i64 = add i64 %c0.i64, 2
  %c3.i64 = add i64 %c0.i64, 3
  %sp.c0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %c0.i64
  %sp.c1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %c1.i64
  %sp.c2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %c2.i64
  %sp.c3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %c3.i64
  %a0 = load i8, i8* %sp.c0, align 1
  %a1 = load i8, i8* %sp.c1, align 1
  %a2 = load i8, i8* %sp.c2, align 1
  %a3 = load i8, i8* %sp.c3, align 1
  %sum01 = xor i8 %a0, %a1
  %sum23 = xor i8 %a2, %a3
  %sum = xor i8 %sum01, %sum23

  ; xtime(x) = (x << 1) ^ ( (x & 0x80) ? 0x1B : 0 )
  ; new a0
  %x01 = xor i8 %a0, %a1
  %x01_shl = shl i8 %x01, 1
  %x01_msb = and i8 %x01, -128
  %x01_msbnz = icmp ne i8 %x01_msb, 0
  %x01_corr = select i1 %x01_msbnz, i8 27, i8 0
  %x01_xt = xor i8 %x01_shl, %x01_corr
  %t0 = xor i8 %a0, %sum
  %na0 = xor i8 %t0, %x01_xt

  ; new a1
  %x12 = xor i8 %a1, %a2
  %x12_shl = shl i8 %x12, 1
  %x12_msb = and i8 %x12, -128
  %x12_msbnz = icmp ne i8 %x12_msb, 0
  %x12_corr = select i1 %x12_msbnz, i8 27, i8 0
  %x12_xt = xor i8 %x12_shl, %x12_corr
  %t1 = xor i8 %a1, %sum
  %na1 = xor i8 %t1, %x12_xt

  ; new a2
  %x23 = xor i8 %a2, %a3
  %x23_shl = shl i8 %x23, 1
  %x23_msb = and i8 %x23, -128
  %x23_msbnz = icmp ne i8 %x23_msb, 0
  %x23_corr = select i1 %x23_msbnz, i8 27, i8 0
  %x23_xt = xor i8 %x23_shl, %x23_corr
  %t2 = xor i8 %a2, %sum
  %na2 = xor i8 %t2, %x23_xt

  ; new a3
  %x30 = xor i8 %a3, %a0
  %x30_shl = shl i8 %x30, 1
  %x30_msb = and i8 %x30, -128
  %x30_msbnz = icmp ne i8 %x30_msb, 0
  %x30_corr = select i1 %x30_msbnz, i8 27, i8 0
  %x30_xt = xor i8 %x30_shl, %x30_corr
  %t3 = xor i8 %a3, %sum
  %na3 = xor i8 %t3, %x30_xt

  store i8 %na0, i8* %sp.c0, align 1
  store i8 %na1, i8* %sp.c1, align 1
  store i8 %na2, i8* %sp.c2, align 1
  store i8 %na3, i8* %sp.c3, align 1

  %c.next = add nuw nsw i32 %c, 1
  %mc.cont = icmp sle i32 %c.next, 3
  br i1 %mc.cont, label %mc.col.loop, label %addround

; AddRoundKey for round r: rk offset = r*16
addround:                                         ; preds = %mc.col.loop
  %rk.off = shl i32 %r, 4
  br label %addround.loop

addround.loop:                                    ; preds = %addround.loop, %addround
  %i.ar = phi i32 [ 0, %addround ], [ %i.ar.next, %addround.loop ]
  %i.ar.i64 = zext i32 %i.ar to i64
  %state.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.ar.i64
  %rk.idx = add nsw i32 %rk.off, %i.ar
  %rk.idx.i64 = sext i32 %rk.idx to i64
  %rk.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %rk.idx.i64
  %sv = load i8, i8* %state.p, align 1
  %kv = load i8, i8* %rk.p, align 1
  %x = xor i8 %sv, %kv
  store i8 %x, i8* %state.p, align 1
  %i.ar.next = add nuw nsw i32 %i.ar, 1
  %ar.cond = icmp sle i32 %i.ar.next, 15
  br i1 %ar.cond, label %addround.loop, label %addround.loop.end

addround.loop.end:                                ; preds = %addround.loop
  %r.next = add nuw nsw i32 %r, 1
  br label %rounds.loop

; Final round: SubBytes, ShiftRows, AddRoundKey with offset 160
final.sub:                                        ; preds = %rounds.loop
  br label %fsb.loop

fsb.loop:                                         ; preds = %fsb.loop, %final.sub
  %i.fsb = phi i32 [ 0, %final.sub ], [ %i.fsb.next, %fsb.loop ]
  %i.fsb.i64 = zext i32 %i.fsb to i64
  %fsptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.fsb.i64
  %fsval = load i8, i8* %fsptr, align 1
  %fsidx = zext i8 %fsval to i64
  %fsbox.gep = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %fsidx
  %fsbox.val = load i8, i8* %fsbox.gep, align 1
  store i8 %fsbox.val, i8* %fsptr, align 1
  %i.fsb.next = add nuw nsw i32 %i.fsb, 1
  %fsb.cond = icmp sle i32 %i.fsb.next, 15
  br i1 %fsb.cond, label %fsb.loop, label %final.sr

final.sr:                                         ; preds = %fsb.loop
  ; ShiftRows again
  %fp1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %fp5 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %fp9 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %fp13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %fv1 = load i8, i8* %fp1, align 1
  %fv5 = load i8, i8* %fp5, align 1
  %fv9 = load i8, i8* %fp9, align 1
  %fv13 = load i8, i8* %fp13, align 1
  store i8 %fv5,  i8* %fp1,  align 1
  store i8 %fv9,  i8* %fp5,  align 1
  store i8 %fv13, i8* %fp9,  align 1
  store i8 %fv1,  i8* %fp13, align 1

  %fp2  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %fp6  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %fp10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %fp14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %fv2  = load i8, i8* %fp2,  align 1
  %fv10 = load i8, i8* %fp10, align 1
  store i8 %fv10, i8* %fp2,  align 1
  store i8 %fv2,  i8* %fp10, align 1
  %fv6  = load i8, i8* %fp6,  align 1
  %fv14 = load i8, i8* %fp14, align 1
  store i8 %fv14, i8* %fp6,  align 1
  store i8 %fv6,  i8* %fp14, align 1

  %fp3  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %fp7  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %fp11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %fp15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %fv3  = load i8, i8* %fp3,  align 1
  %fv7  = load i8, i8* %fp7,  align 1
  %fv11 = load i8, i8* %fp11, align 1
  %fv15 = load i8, i8* %fp15, align 1
  store i8 %fv15, i8* %fp3,  align 1
  store i8 %fv11, i8* %fp15, align 1
  store i8 %fv7,  i8* %fp11, align 1
  store i8 %fv3,  i8* %fp7,  align 1

  ; AddRoundKey with offset 160 (0xA0)
  br label %final.ark.loop

final.ark.loop:                                   ; preds = %final.ark.loop, %final.sr
  %i.far = phi i32 [ 0, %final.sr ], [ %i.far.next, %final.ark.loop ]
  %i.far.i64 = zext i32 %i.far to i64
  %state.fp = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.far.i64
  %rk.final.idx = add nuw nsw i32 %i.far, 160
  %rk.final.idx.i64 = zext i32 %rk.final.idx to i64
  %rk.fp = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %rk.final.idx.i64
  %svf = load i8, i8* %state.fp, align 1
  %kvf = load i8, i8* %rk.fp, align 1
  %xf = xor i8 %svf, %kvf
  store i8 %xf, i8* %state.fp, align 1
  %i.far.next = add nuw nsw i32 %i.far, 1
  %final.ark.cond = icmp sle i32 %i.far.next, 15
  br i1 %final.ark.cond, label %final.ark.loop, label %store.out

; store state to out
store.out:                                        ; preds = %final.ark.loop
  br label %out.loop

out.loop:                                         ; preds = %out.loop, %store.out
  %i.out = phi i32 [ 0, %store.out ], [ %i.out.next, %out.loop ]
  %i.out.i64 = zext i32 %i.out to i64
  %sop = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.out.i64
  %oval = load i8, i8* %sop, align 1
  %outp = getelementptr inbounds i8, i8* %out, i64 %i.out.i64
  store i8 %oval, i8* %outp, align 1
  %i.out.next = add nuw nsw i32 %i.out, 1
  %out.cond = icmp sle i32 %i.out.next, 15
  br i1 %out.cond, label %out.loop, label %ret

ret:                                              ; preds = %out.loop
  ret void
}