; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt  ; Address: 0x11A9
; Intent: AES-128 block encryption (confidence=0.98). Evidence: S-box and Rcon tables; 10-round structure with ShiftRows/MixColumns
; Preconditions: out, in, key each reference at least 16 bytes
; Postconditions: out[0..15] contains AES-128 encryption of in under key

@__stack_chk_guard = external global i64
@sbox_1 = external global [256 x i8]
@rcon_0 = external global [256 x i8]

declare void @__stack_chk_fail()

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %state = alloca [16 x i8], align 16
  %ks = alloca [176 x i8], align 16

  ; state[i] = in[i]
  br label %copy_in.loop

copy_in.loop:
  %ci.i = phi i64 [ 0, %entry ], [ %ci.i.next, %copy_in.body ]
  %ci.cmp = icmp sle i64 %ci.i, 15
  br i1 %ci.cmp, label %copy_in.body, label %copy_key.pre

copy_in.body:
  %in.gep = getelementptr inbounds i8, i8* %in, i64 %ci.i
  %in.b = load i8, i8* %in.gep, align 1
  %st.gep = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ci.i
  store i8 %in.b, i8* %st.gep, align 1
  %ci.i.next = add nuw nsw i64 %ci.i, 1
  br label %copy_in.loop

copy_key.pre:
  br label %copy_key.loop

; ks[i] = key[i] for i=0..15
copy_key.loop:
  %ck.i = phi i64 [ 0, %copy_key.pre ], [ %ck.i.next, %copy_key.body ]
  %ck.cmp = icmp sle i64 %ck.i, 15
  br i1 %ck.cmp, label %copy_key.body, label %expand.init

copy_key.body:
  %key.gep = getelementptr inbounds i8, i8* %key, i64 %ck.i
  %key.b = load i8, i8* %key.gep, align 1
  %ks.gep = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %ck.i
  store i8 %key.b, i8* %ks.gep, align 1
  %ck.i.next = add nuw nsw i64 %ck.i, 1
  br label %copy_key.loop

expand.init:
  br label %expand.loop

; AES-128 key expansion to 176 bytes
expand.loop:
  %i = phi i64 [ 16, %expand.init ], [ %i.next, %expand.endstore ]
  %rc = phi i64 [ 0, %expand.init ], [ %rc.next, %expand.endstore ]
  %exp.cond = icmp sle i64 %i, 175
  br i1 %exp.cond, label %expand.body, label %ark0.init

expand.body:
  ; load previous 4 bytes
  %im4 = add nsw i64 %i, -4
  %im3 = add nsw i64 %i, -3
  %im2 = add nsw i64 %i, -2
  %im1 = add nsw i64 %i, -1
  %t0p = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im4
  %t1p = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im3
  %t2p = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im2
  %t3p = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im1
  %t0b = load i8, i8* %t0p, align 1
  %t1b = load i8, i8* %t1p, align 1
  %t2b = load i8, i8* %t2p, align 1
  %t3b = load i8, i8* %t3p, align 1
  ; if (i & 0x0f) == 0
  %i.and = and i64 %i, 15
  %need.core = icmp eq i64 %i.and, 0
  br i1 %need.core, label %coreword, label %nocore

coreword:
  ; RotWord: (t1,t2,t3,t0)
  ; SubWord using sbox
  %t0r = %t1b
  %t1r = %t2b
  %t2r = %t3b
  %t3r = %t0b
  ; sbox indices as i64
  %t0r.z = zext i8 %t0r to i64
  %t1r.z = zext i8 %t1r to i64
  %t2r.z = zext i8 %t2r to i64
  %t3r.z = zext i8 %t3r to i64
  %sbox.t0p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t0r.z
  %sbox.t1p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t1r.z
  %sbox.t2p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t2r.z
  %sbox.t3p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t3r.z
  %t0s = load i8, i8* %sbox.t0p, align 1
  %t1s = load i8, i8* %sbox.t1p, align 1
  %t2s = load i8, i8* %sbox.t2p, align 1
  %t3s = load i8, i8* %sbox.t3p, align 1
  ; t0 ^= rcon[rc++]
  %rcon.p = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 %rc
  %rcon.b = load i8, i8* %rcon.p, align 1
  %t0s.x = xor i8 %t0s, %rcon.b
  %rc.next.core = add nuw nsw i64 %rc, 1
  br label %aftercore

nocore:
  br label %aftercore

aftercore:
  %t0.sel = phi i8 [ %t0s.x, %coreword ], [ %t0b, %nocore ]
  %t1.sel = phi i8 [ %t1s, %coreword ],   [ %t1b, %nocore ]
  %t2.sel = phi i8 [ %t2s, %coreword ],   [ %t2b, %nocore ]
  %t3.sel = phi i8 [ %t3s, %coreword ],   [ %t3b, %nocore ]
  %rc.cur = phi i64 [ %rc.next.core, %coreword ], [ %rc, %nocore ]

  ; w[i + k] = w[i-16 + k] ^ t[k]
  %im16 = add nsw i64 %i, -16
  ; k=0
  %w0.prev.p = getelementptr inbounds [176 x i8], [176 x i8]* @llvm.memcpy.p0i8.p0i8.i64, i64 0, i64 0 ; dummy to keep types consistent
  %w0.prev = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im16
  %w0.prev.b = load i8, i8* %w0.prev, align 1
  %w0.new = xor i8 %w0.prev.b, %t0.sel
  %wi.p = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %i
  store i8 %w0.new, i8* %wi.p, align 1
  ; k=1
  %i1 = add nuw nsw i64 %i, 1
  %im15 = add nsw i64 %im16, 1
  %w1.prev = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im15
  %w1.prev.b = load i8, i8* %w1.prev, align 1
  %w1.new = xor i8 %w1.prev.b, %t1.sel
  %wi1.p = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %i1
  store i8 %w1.new, i8* %wi1.p, align 1
  ; k=2
  %i2 = add nuw nsw i64 %i, 2
  %im14 = add nsw i64 %im16, 2
  %w2.prev = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im14
  %w2.prev.b = load i8, i8* %w2.prev, align 1
  %w2.new = xor i8 %w2.prev.b, %t2.sel
  %wi2.p = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %i2
  store i8 %w2.new, i8* %wi2.p, align 1
  ; k=3
  %i3 = add nuw nsw i64 %i, 3
  %im13 = add nsw i64 %im16, 3
  %w3.prev = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im13
  %w3.prev.b = load i8, i8* %w3.prev, align 1
  %w3.new = xor i8 %w3.prev.b, %t3.sel
  %wi3.p = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %i3
  store i8 %w3.new, i8* %wi3.p, align 1

expand.endstore:
  %i.next = add nuw nsw i64 %i, 4
  %rc.next = %rc.cur
  br label %expand.loop

ark0.init:
  br label %ark0.loop

; Initial AddRoundKey with round 0
ark0.loop:
  %a0.i = phi i64 [ 0, %ark0.init ], [ %a0.i.next, %ark0.body ]
  %a0.cmp = icmp sle i64 %a0.i, 15
  br i1 %a0.cmp, label %ark0.body, label %rounds.init

ark0.body:
  %st.p.a0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %a0.i
  %st.b.a0 = load i8, i8* %st.p.a0, align 1
  %ks.p.a0 = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %a0.i
  %ks.b.a0 = load i8, i8* %ks.p.a0, align 1
  %xor.a0 = xor i8 %st.b.a0, %ks.b.a0
  store i8 %xor.a0, i8* %st.p.a0, align 1
  %a0.i.next = add nuw nsw i64 %a0.i, 1
  br label %ark0.loop

rounds.init:
  br label %rounds.loop

; Rounds 1..9
rounds.loop:
  %r = phi i64 [ 1, %rounds.init ], [ %r.next, %ark.loop.end ]
  %r.cond = icmp sle i64 %r, 9
  br i1 %r.cond, label %subbytes.loop, label %final.sub

; SubBytes
subbytes.loop:
  %sb.i = phi i64 [ 0, %rounds.loop ], [ %sb.i.next, %subbytes.body ]
  %sb.cond = icmp sle i64 %sb.i, 15
  br i1 %sb.cond, label %subbytes.body, label %shiftrows

subbytes.body:
  %st.p.sb = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %sb.i
  %v.sb = load i8, i8* %st.p.sb, align 1
  %v.sb.z = zext i8 %v.sb to i64
  %sbox.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %v.sb.z
  %sbox.v = load i8, i8* %sbox.p, align 1
  store i8 %sbox.v, i8* %st.p.sb, align 1
  %sb.i.next = add nuw nsw i64 %sb.i, 1
  br label %subbytes.loop

; ShiftRows
shiftrows:
  ; load all 16 bytes
  %s0p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %s1p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %s2p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %s3p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %s4p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 4
  %s5p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %s6p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %s7p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %s8p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 8
  %s9p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %s10p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %s11p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %s12p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 12
  %s13p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %s14p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %s15p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %s0 = load i8, i8* %s0p, align 1
  %s1 = load i8, i8* %s1p, align 1
  %s2 = load i8, i8* %s2p, align 1
  %s3 = load i8, i8* %s3p, align 1
  %s4 = load i8, i8* %s4p, align 1
  %s5 = load i8, i8* %s5p, align 1
  %s6 = load i8, i8* %s6p, align 1
  %s7 = load i8, i8* %s7p, align 1
  %s8 = load i8, i8* %s8p, align 1
  %s9 = load i8, i8* %s9p, align 1
  %s10 = load i8, i8* %s10p, align 1
  %s11 = load i8, i8* %s11p, align 1
  %s12 = load i8, i8* %s12p, align 1
  %s13 = load i8, i8* %s13p, align 1
  %s14 = load i8, i8* %s14p, align 1
  %s15 = load i8, i8* %s15p, align 1
  ; row0 unchanged: 0,4,8,12
  store i8 %s0, i8* %s0p, align 1
  store i8 %s4, i8* %s4p, align 1
  store i8 %s8, i8* %s8p, align 1
  store i8 %s12, i8* %s12p, align 1
  ; row1 shift left 1: 1,5,9,13 -> 5,9,13,1
  store i8 %s5, i8* %s1p, align 1
  store i8 %s9, i8* %s5p, align 1
  store i8 %s13, i8* %s9p, align 1
  store i8 %s1, i8* %s13p, align 1
  ; row2 shift left 2: 2,6,10,14 -> 10,14,2,6
  store i8 %s10, i8* %s2p, align 1
  store i8 %s14, i8* %s6p, align 1
  store i8 %s2, i8* %s10p, align 1
  store i8 %s6, i8* %s14p, align 1
  ; row3 shift left 3: 3,7,11,15 -> 15,3,7,11
  store i8 %s7, i8* %s11p, align 1 ; preserve old s11 for other stores: we'll write s11 below
  store i8 %s15, i8* %s3p, align 1
  store i8 %s3, i8* %s15p, align 1
  store i8 %s11, i8* %s7p, align 1

  br label %mixcols.init

mixcols.init:
  br label %mixcols.loop

mixcols.loop:
  %mc.c = phi i64 [ 0, %mixcols.init ], [ %mc.c.next, %mixcols.body3 ]
  %mc.cond = icmp sle i64 %mc.c, 3
  br i1 %mc.cond, label %mixcols.body, label %ark.loop.init

mixcols.body:
  %c0 = %mc.c
  %c1 = add nuw nsw i64 %mc.c, 4
  %c2 = add nuw nsw i64 %mc.c, 8
  %c3 = add nuw nsw i64 %mc.c, 12
  %p0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %c0
  %p1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %c1
  %p2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %c2
  %p3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %c3
  %b0 = load i8, i8* %p0, align 1
  %b1 = load i8, i8* %p1, align 1
  %b2 = load i8, i8* %p2, align 1
  %b3 = load i8, i8* %p3, align 1
  %sum01 = xor i8 %b0, %b1
  %sum23 = xor i8 %b2, %b3
  %sum = xor i8 %sum01, %sum23

  ; xtime for (b0 ^ b1)
  %x01 = %sum01
  %x01_shl = shl i8 %x01, 1
  %x01_hi = lshr i8 %x01, 7
  %x01_hi.z = zext i8 %x01_hi to i64
  %rconmul01.p = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 0 ; dummy use to keep ssa ok
  %x01_sel = select i1 (icmp ne i8 %x01_hi, 0), i8 27, i8 0
  %xt01 = xor i8 %x01_shl, %x01_sel

  ; xtime for (b1 ^ b2)
  %x12 = xor i8 %b1, %b2
  %x12_shl = shl i8 %x12, 1
  %x12_hi = lshr i8 %x12, 7
  %x12_sel = select i1 (icmp ne i8 %x12_hi, 0), i8 27, i8 0
  %xt12 = xor i8 %x12_shl, %x12_sel

  ; xtime for (b2 ^ b3)
  %x23 = %sum23
  %x23_shl = shl i8 %x23, 1
  %x23_hi = lshr i8 %x23, 7
  %x23_sel = select i1 (icmp ne i8 %x23_hi, 0), i8 27, i8 0
  %xt23 = xor i8 %x23_shl, %x23_sel

  ; xtime for (b3 ^ b0)
  %x30 = xor i8 %b3, %b0
  %x30_shl = shl i8 %x30, 1
  %x30_hi = lshr i8 %x30, 7
  %x30_sel = select i1 (icmp ne i8 %x30_hi, 0), i8 27, i8 0
  %xt30 = xor i8 %x30_shl, %x30_sel

  ; out0 ^= xtime(b0^b1) ^ sum
  %t0a = xor i8 %xt01, %sum
  %o0 = xor i8 %b0, %t0a
  store i8 %o0, i8* %p0, align 1

  ; out1 ^= xtime(b1^b2) ^ sum
  %t1a = xor i8 %xt12, %sum
  %o1 = xor i8 %b1, %t1a
  store i8 %o1, i8* %p1, align 1

  ; out2 ^= xtime(b2^b3) ^ sum
  %t2a = xor i8 %xt23, %sum
  %o2 = xor i8 %b2, %t2a
  store i8 %o2, i8* %p2, align 1

  ; out3 ^= xtime(b3^b0) ^ sum
  %t3a = xor i8 %xt30, %sum
  %o3 = xor i8 %b3, %t3a
  store i8 %o3, i8* %p3, align 1

  br label %mixcols.body3

mixcols.body3:
  %mc.c.next = add nuw nsw i64 %mc.c, 1
  br label %mixcols.loop

; AddRoundKey for round r (offset = r*16)
ark.loop.init:
  br label %ark.loop

ark.loop:
  %ark.i = phi i64 [ 0, %ark.loop.init ], [ %ark.i.next, %ark.body ]
  %ark.cond = icmp sle i64 %ark.i, 15
  br i1 %ark.cond, label %ark.body, label %ark.loop.end

ark.body:
  %off = mul nuw nsw i64 %r, 16
  %kidx = add nuw nsw i64 %off, %ark.i
  %st.p.ark = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ark.i
  %st.b.ark = load i8, i8* %st.p.ark, align 1
  %ks.p.ark = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %kidx
  %ks.b.ark = load i8, i8* %ks.p.ark, align 1
  %ark.x = xor i8 %st.b.ark, %ks.b.ark
  store i8 %ark.x, i8* %st.p.ark, align 1
  %ark.i.next = add nuw nsw i64 %ark.i, 1
  br label %ark.loop

ark.loop.end:
  %r.next = add nuw nsw i64 %r, 1
  br label %rounds.loop

; Final round (round 10): SubBytes, ShiftRows, AddRoundKey(offset=160)
final.sub:
  br label %final.sub.loop

final.sub.loop:
  %fsb.i = phi i64 [ 0, %final.sub ], [ %fsb.i.next, %final.sub.body ]
  %fsb.cond = icmp sle i64 %fsb.i, 15
  br i1 %fsb.cond, label %final.sub.body, label %final.shift

final.sub.body:
  %st.p.fsb = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fsb.i
  %v.fsb = load i8, i8* %st.p.fsb, align 1
  %v.fsb.z = zext i8 %v.fsb to i64
  %sbox.fs.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %v.fsb.z
  %sbox.fs.v = load i8, i8* %sbox.fs.p, align 1
  store i8 %sbox.fs.v, i8* %st.p.fsb, align 1
  %fsb.i.next = add nuw nsw i64 %fsb.i, 1
  br label %final.sub.loop

final.shift:
  ; reload pointers
  %fs0p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %fs1p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %fs2p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %fs3p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %fs4p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 4
  %fs5p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %fs6p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %fs7p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %fs8p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 8
  %fs9p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %fs10p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %fs11p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %fs12p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 12
  %fs13p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %fs14p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %fs15p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %fs0 = load i8, i8* %fs0p, align 1
  %fs1 = load i8, i8* %fs1p, align 1
  %fs2 = load i8, i8* %fs2p, align 1
  %fs3 = load i8, i8* %fs3p, align 1
  %fs4 = load i8, i8* %fs4p, align 1
  %fs5 = load i8, i8* %fs5p, align 1
  %fs6 = load i8, i8* %fs6p, align 1
  %fs7 = load i8, i8* %fs7p, align 1
  %fs8 = load i8, i8* %fs8p, align 1
  %fs9 = load i8, i8* %fs9p, align 1
  %fs10 = load i8, i8* %fs10p, align 1
  %fs11 = load i8, i8* %fs11p, align 1
  %fs12 = load i8, i8* %fs12p, align 1
  %fs13 = load i8, i8* %fs13p, align 1
  %fs14 = load i8, i8* %fs14p, align 1
  %fs15 = load i8, i8* %fs15p, align 1
  ; row0 unchanged
  store i8 %fs0, i8* %fs0p, align 1
  store i8 %fs4, i8* %fs4p, align 1
  store i8 %fs8, i8* %fs8p, align 1
  store i8 %fs12, i8* %fs12p, align 1
  ; row1 shift 1
  store i8 %fs5, i8* %fs1p, align 1
  store i8 %fs9, i8* %fs5p, align 1
  store i8 %fs13, i8* %fs9p, align 1
  store i8 %fs1, i8* %fs13p, align 1
  ; row2 shift 2
  store i8 %fs10, i8* %fs2p, align 1
  store i8 %fs14, i8* %fs6p, align 1
  store i8 %fs2, i8* %fs10p, align 1
  store i8 %fs6, i8* %fs14p, align 1
  ; row3 shift 3
  store i8 %fs15, i8* %fs3p, align 1
  store i8 %fs3, i8* %fs15p, align 1
  store i8 %fs11, i8* %fs7p, align 1
  store i8 %fs7, i8* %fs11p, align 1

  br label %final.ark.init

final.ark.init:
  br label %final.ark.loop

final.ark.loop:
  %fark.i = phi i64 [ 0, %final.ark.init ], [ %fark.i.next, %final.ark.body ]
  %fark.cond = icmp sle i64 %fark.i, 15
  br i1 %fark.cond, label %final.ark.body, label %store.out.init

final.ark.body:
  %off10 = mul nuw nsw i64 10, 16
  %fkidx = add nuw nsw i64 %off10, %fark.i
  %st.p.fark = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fark.i
  %st.b.fark = load i8, i8* %st.p.fark, align 1
  %ks.p.fark = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %fkidx
  %ks.b.fark = load i8, i8* %ks.p.fark, align 1
  %fark.x = xor i8 %st.b.fark, %ks.b.fark
  store i8 %fark.x, i8* %st.p.fark, align 1
  %fark.i.next = add nuw nsw i64 %fark.i, 1
  br label %final.ark.loop

; store state to out
store.out.init:
  br label %store.out.loop

store.out.loop:
  %so.i = phi i64 [ 0, %store.out.init ], [ %so.i.next, %store.out.body ]
  %so.cond = icmp sle i64 %so.i, 15
  br i1 %so.cond, label %store.out.body, label %epilogue

store.out.body:
  %st.p.so = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %so.i
  %v.so = load i8, i8* %st.p.so, align 1
  %out.p = getelementptr inbounds i8, i8* %out, i64 %so.i
  store i8 %v.so, i8* %out.p, align 1
  %so.i.next = add nuw nsw i64 %so.i, 1
  br label %store.out.loop

epilogue:
  %guard.end = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard, %guard.end
  br i1 %ok, label %ret, label %stack_fail

stack_fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret void
}