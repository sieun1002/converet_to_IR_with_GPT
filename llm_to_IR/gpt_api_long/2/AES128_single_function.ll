; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt  ; Address: 0x11A9
; Intent: AES-128 block encryption (confidence=0.95). Evidence: sbox/rcon usage; AES round structure
; Preconditions: out,in,key each reference at least 16 bytes
; Postconditions: out holds AES-128 encryption of the input block under the given 16-byte key

@rcon_0 = external constant [256 x i8]
@sbox_1 = external constant [256 x i8]

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 1
  %w = alloca [176 x i8], align 1
  %tmp = alloca [16 x i8], align 1

  br label %copy_in.hdr

copy_in.hdr:                                       ; copy 16 bytes from input to state
  %ci.i = phi i32 [ 0, entry ], [ %ci.i.next, %copy_in.body ]
  %ci.cmp = icmp sle i32 %ci.i, 15
  br i1 %ci.cmp, label %copy_in.body, label %copy_key.hdr

copy_in.body:
  %ci.idx64 = zext i32 %ci.i to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %ci.idx64
  %in.val = load i8, i8* %in.ptr, align 1
  %state.elem = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ci.idx64
  store i8 %in.val, i8* %state.elem, align 1
  %ci.i.next = add i32 %ci.i, 1
  br label %copy_in.hdr

copy_key.hdr:                                      ; copy 16 bytes of key to w[0..15]
  %ck.i = phi i32 [ 0, %copy_in.hdr ], [ %ck.i.next, %copy_key.body ]
  %ck.cmp = icmp sle i32 %ck.i, 15
  br i1 %ck.cmp, label %copy_key.body, label %kexp.init

copy_key.body:
  %ck.idx64 = zext i32 %ck.i to i64
  %key.ptr = getelementptr inbounds i8, i8* %key, i64 %ck.idx64
  %key.val = load i8, i8* %key.ptr, align 1
  %w.dest = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %ck.idx64
  store i8 %key.val, i8* %w.dest, align 1
  %ck.i.next = add i32 %ck.i, 1
  br label %copy_key.hdr

kexp.init:
  br label %kexp.hdr

kexp.hdr:                                          ; AES-128 key expansion to 176 bytes
  %i = phi i32 [ 16, %kexp.init ], [ %i.next, %kexp.join ]
  %rc = phi i32 [ 0, %kexp.init ], [ %rc.next, %kexp.join ]
  %i.cmp = icmp sle i32 %i, 175
  br i1 %i.cmp, label %kexp.body, label %ark0.hdr

kexp.body:
  %i_m4 = sub i32 %i, 4
  %i_m3 = sub i32 %i, 3
  %i_m2 = sub i32 %i, 2
  %i_m1 = sub i32 %i, 1
  %i_m4_64 = zext i32 %i_m4 to i64
  %i_m3_64 = zext i32 %i_m3 to i64
  %i_m2_64 = zext i32 %i_m2 to i64
  %i_m1_64 = zext i32 %i_m1 to i64
  %w.i_m4.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i_m4_64
  %w.i_m3.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i_m3_64
  %w.i_m2.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i_m2_64
  %w.i_m1.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i_m1_64
  %t0.raw = load i8, i8* %w.i_m4.ptr, align 1
  %t1.raw = load i8, i8* %w.i_m3.ptr, align 1
  %t2.raw = load i8, i8* %w.i_m2.ptr, align 1
  %t3.raw = load i8, i8* %w.i_m1.ptr, align 1
  %modmask = and i32 %i, 15
  %atblock = icmp eq i32 %modmask, 0
  br i1 %atblock, label %kexp.special, label %kexp.nospec

kexp.special:                                      ; RotWord, SubWord, Rcon
  ; rotate left
  %t0.rot = select i1 true, i8 %t1.raw, i8 0
  %t1.rot = select i1 true, i8 %t2.raw, i8 0
  %t2.rot = select i1 true, i8 %t3.raw, i8 0
  %t3.rot = select i1 true, i8 %t0.raw, i8 0
  ; SubWord using sbox
  %t0.idx = zext i8 %t0.rot to i64
  %t0.sb.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t0.idx
  %t0.sb = load i8, i8* %t0.sb.ptr, align 1
  %t1.idx = zext i8 %t1.rot to i64
  %t1.sb.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t1.idx
  %t1.sb = load i8, i8* %t1.sb.ptr, align 1
  %t2.idx = zext i8 %t2.rot to i64
  %t2.sb.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t2.idx
  %t2.sb = load i8, i8* %t2.sb.ptr, align 1
  %t3.idx = zext i8 %t3.rot to i64
  %t3.sb.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t3.idx
  %t3.sb = load i8, i8* %t3.sb.ptr, align 1
  ; Rcon
  %rc64 = zext i32 %rc to i64
  %rc.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 %rc64
  %rc.byte = load i8, i8* %rc.ptr, align 1
  %t0.rcon = xor i8 %t0.sb, %rc.byte
  %rc.inc = add i32 %rc, 1
  br label %kexp.join

kexp.nospec:
  br label %kexp.join

kexp.join:
  %t0.final = phi i8 [ %t0.rcon, %kexp.special ], [ %t0.raw, %kexp.nospec ]
  %t1.final = phi i8 [ %t1.sb, %kexp.special ], [ %t1.raw, %kexp.nospec ]
  %t2.final = phi i8 [ %t2.sb, %kexp.special ], [ %t2.raw, %kexp.nospec ]
  %t3.final = phi i8 [ %t3.sb, %kexp.special ], [ %t3.raw, %kexp.nospec ]
  %rc.next = phi i32 [ %rc.inc, %kexp.special ], [ %rc, %kexp.nospec ]

  %i_m16 = sub i32 %i, 16
  %i_m15 = add i32 %i_m16, 1
  %i_m14 = add i32 %i_m16, 2
  %i_m13 = add i32 %i_m16, 3

  %i64 = zext i32 %i to i64
  %i1 = add i32 %i, 1
  %i2 = add i32 %i, 2
  %i3 = add i32 %i, 3
  %i1_64 = zext i32 %i1 to i64
  %i2_64 = zext i32 %i2 to i64
  %i3_64 = zext i32 %i3 to i64

  %i_m16_64 = zext i32 %i_m16 to i64
  %i_m15_64 = zext i32 %i_m15 to i64
  %i_m14_64 = zext i32 %i_m14 to i64
  %i_m13_64 = zext i32 %i_m13 to i64

  %w.im16.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i_m16_64
  %w.im15.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i_m15_64
  %w.im14.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i_m14_64
  %w.im13.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i_m13_64
  %w.im16 = load i8, i8* %w.im16.ptr, align 1
  %w.im15 = load i8, i8* %w.im15.ptr, align 1
  %w.im14 = load i8, i8* %w.im14.ptr, align 1
  %w.im13 = load i8, i8* %w.im13.ptr, align 1

  %w.i.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i64
  %w.i1.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i1_64
  %w.i2.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i2_64
  %w.i3.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i3_64

  %w.i.val = xor i8 %w.im16, %t0.final
  %w.i1.val = xor i8 %w.im15, %t1.final
  %w.i2.val = xor i8 %w.im14, %t2.final
  %w.i3.val = xor i8 %w.im13, %t3.final

  store i8 %w.i.val, i8* %w.i.ptr, align 1
  store i8 %w.i1.val, i8* %w.i1.ptr, align 1
  store i8 %w.i2.val, i8* %w.i2.ptr, align 1
  store i8 %w.i3.val, i8* %w.i3.ptr, align 1

  %i.next = add i32 %i, 4
  br label %kexp.hdr

ark0.hdr:                                          ; initial AddRoundKey with w[0..15]
  %ark0.i = phi i32 [ 0, %kexp.hdr ], [ %ark0.i.next, %ark0.body ]
  %ark0.cmp = icmp sle i32 %ark0.i, 15
  br i1 %ark0.cmp, label %ark0.body, label %rounds.init

ark0.body:
  %ark0.idx64 = zext i32 %ark0.i to i64
  %st.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ark0.idx64
  %st.b = load i8, i8* %st.ptr, align 1
  %rk.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %ark0.idx64
  %rk.b = load i8, i8* %rk.ptr, align 1
  %xor0 = xor i8 %st.b, %rk.b
  store i8 %xor0, i8* %st.ptr, align 1
  %ark0.i.next = add i32 %ark0.i, 1
  br label %ark0.hdr

rounds.init:
  br label %rounds.hdr

rounds.hdr:                                        ; rounds 1..9
  %r = phi i32 [ 1, %rounds.init ], [ %r.next, %ark.hdr ]
  %r.cmp = icmp sle i32 %r, 9
  br i1 %r.cmp, label %subbytes.hdr, label %finalsub.hdr

subbytes.hdr:
  %sb.i = phi i32 [ 0, %rounds.hdr ], [ %sb.i.next, %subbytes.body ]
  %sb.cmp = icmp sle i32 %sb.i, 15
  br i1 %sb.cmp, label %subbytes.body, label %shiftrows.hdr

subbytes.body:
  %sb.idx64 = zext i32 %sb.i to i64
  %sb.st.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %sb.idx64
  %sb.val = load i8, i8* %sb.st.ptr, align 1
  %sb.z = zext i8 %sb.val to i64
  %sb.s.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %sb.z
  %sb.sv = load i8, i8* %sb.s.ptr, align 1
  store i8 %sb.sv, i8* %sb.st.ptr, align 1
  %sb.i.next = add i32 %sb.i, 1
  br label %subbytes.hdr

shiftrows.hdr:                                     ; use tmp buffer for permuted state
  ; row 0
  %s0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %s4 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 4
  %s8 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 8
  %s12 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 12
  %v0 = load i8, i8* %s0, align 1
  %v4 = load i8, i8* %s4, align 1
  %v8 = load i8, i8* %s8, align 1
  %v12 = load i8, i8* %s12, align 1
  %t0p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 0
  %t4p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 4
  %t8p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 8
  %t12p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 12
  store i8 %v0, i8* %t0p, align 1
  store i8 %v4, i8* %t4p, align 1
  store i8 %v8, i8* %t8p, align 1
  store i8 %v12, i8* %t12p, align 1
  ; row 1 rotate left 1: 1,5,9,13 -> 5,9,13,1
  %s1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %s5 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %s9 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %s13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %v1 = load i8, i8* %s1, align 1
  %v5 = load i8, i8* %s5, align 1
  %v9 = load i8, i8* %s9, align 1
  %v13 = load i8, i8* %s13, align 1
  %t1p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 1
  %t5p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 5
  %t9p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 9
  %t13p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 13
  store i8 %v5, i8* %t1p, align 1
  store i8 %v9, i8* %t5p, align 1
  store i8 %v13, i8* %t9p, align 1
  store i8 %v1, i8* %t13p, align 1
  ; row 2 rotate left 2: 2,6,10,14 -> 10,14,2,6
  %s2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %s6 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %s10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %s14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %v2 = load i8, i8* %s2, align 1
  %v6 = load i8, i8* %s6, align 1
  %v10 = load i8, i8* %s10, align 1
  %v14 = load i8, i8* %s14, align 1
  %t2p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 2
  %t6p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 6
  %t10p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 10
  %t14p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 14
  store i8 %v10, i8* %t2p, align 1
  store i8 %v14, i8* %t6p, align 1
  store i8 %v2, i8* %t10p, align 1
  store i8 %v6, i8* %t14p, align 1
  ; row 3 rotate left 3: 3,7,11,15 -> 15,3,7,11
  %s3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %s7 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %s11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %s15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %v3 = load i8, i8* %s3, align 1
  %v7 = load i8, i8* %s7, align 1
  %v11 = load i8, i8* %s11, align 1
  %v15 = load i8, i8* %s15, align 1
  %t3p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 3
  %t7p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 7
  %t11p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 11
  %t15p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 15
  store i8 %v15, i8* %t3p, align 1
  store i8 %v3, i8* %t7p, align 1
  store i8 %v7, i8* %t11p, align 1
  store i8 %v11, i8* %t15p, align 1

  ; copy tmp back to state
  br label %copy_tmp_back.hdr

copy_tmp_back.hdr:
  %ctb.i = phi i32 [ 0, %shiftrows.hdr ], [ %ctb.i.next, %copy_tmp_back.body ]
  %ctb.cmp = icmp sle i32 %ctb.i, 15
  br i1 %ctb.cmp, label %copy_tmp_back.body, label %mixcols.hdr

copy_tmp_back.body:
  %ctb.idx64 = zext i32 %ctb.i to i64
  %tmp.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 %ctb.idx64
  %tmp.val = load i8, i8* %tmp.ptr, align 1
  %stb.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ctb.idx64
  store i8 %tmp.val, i8* %stb.ptr, align 1
  %ctb.i.next = add i32 %ctb.i, 1
  br label %copy_tmp_back.hdr

mixcols.hdr:
  %mc.c = phi i32 [ 0, %copy_tmp_back.hdr ], [ %mc.c.next, %mixcols.body ]
  %mc.cmp = icmp sle i32 %mc.c, 3
  br i1 %mc.cmp, label %mixcols.body, label %ark.hdr

mixcols.body:
  %c4 = shl i32 %mc.c, 2
  %c0.idx = zext i32 %c4 to i64
  %c1.i32 = add i32 %c4, 1
  %c2.i32 = add i32 %c4, 2
  %c3.i32 = add i32 %c4, 3
  %c1.idx = zext i32 %c1.i32 to i64
  %c2.idx = zext i32 %c2.i32 to i64
  %c3.idx = zext i32 %c3.i32 to i64
  %p0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %c0.idx
  %p1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %c1.idx
  %p2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %c2.idx
  %p3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %c3.idx
  %a = load i8, i8* %p0, align 1
  %b = load i8, i8* %p1, align 1
  %c = load i8, i8* %p2, align 1
  %d = load i8, i8* %p3, align 1
  %t.ab = xor i8 %a, %b
  %t.cd = xor i8 %c, %d
  %t.abcd = xor i8 %t.ab, %t.cd

  ; m0 = xtime(a ^ b) ^ t
  %u0 = xor i8 %a, %b
  %u0_shl = shl i8 %u0, 1
  %u0_hi = lshr i8 %u0, 7
  %u0_hi_mask = and i8 %u0_hi, 1
  %u0_hi_mul = mul i8 %u0_hi_mask, 27
  %xt0 = xor i8 %u0_shl, %u0_hi_mul
  %m0 = xor i8 %xt0, %t.abcd
  %s0 = xor i8 %a, %m0
  store i8 %s0, i8* %p0, align 1

  ; m1 = xtime(b ^ c) ^ t
  %u1 = xor i8 %b, %c
  %u1_shl = shl i8 %u1, 1
  %u1_hi = lshr i8 %u1, 7
  %u1_hi_mask = and i8 %u1_hi, 1
  %u1_hi_mul = mul i8 %u1_hi_mask, 27
  %xt1 = xor i8 %u1_shl, %u1_hi_mul
  %m1 = xor i8 %xt1, %t.abcd
  %s1 = xor i8 %b, %m1
  store i8 %s1, i8* %p1, align 1

  ; m2 = xtime(c ^ d) ^ t
  %u2 = xor i8 %c, %d
  %u2_shl = shl i8 %u2, 1
  %u2_hi = lshr i8 %u2, 7
  %u2_hi_mask = and i8 %u2_hi, 1
  %u2_hi_mul = mul i8 %u2_hi_mask, 27
  %xt2 = xor i8 %u2_shl, %u2_hi_mul
  %m2 = xor i8 %xt2, %t.abcd
  %s2 = xor i8 %c, %m2
  store i8 %s2, i8* %p2, align 1

  ; m3 = xtime(d ^ a) ^ t
  %u3 = xor i8 %d, %a
  %u3_shl = shl i8 %u3, 1
  %u3_hi = lshr i8 %u3, 7
  %u3_hi_mask = and i8 %u3_hi, 1
  %u3_hi_mul = mul i8 %u3_hi_mask, 27
  %xt3 = xor i8 %u3_shl, %u3_hi_mul
  %m3 = xor i8 %xt3, %t.abcd
  %s3 = xor i8 %d, %m3
  store i8 %s3, i8* %p3, align 1

  %mc.c.next = add i32 %mc.c, 1
  br label %mixcols.hdr

ark.hdr:                                           ; AddRoundKey for round r
  %ark.i = phi i32 [ 0, %mixcols.hdr ], [ %ark.i.next, %ark.body ]
  %ark.cmp = icmp sle i32 %ark.i, 15
  br i1 %ark.cmp, label %ark.body, label %rounds.next

ark.body:
  %ark.idx64 = zext i32 %ark.i to i64
  %rk.off = mul i32 %r, 16
  %rk.idx = add i32 %rk.off, %ark.i
  %rk.idx64 = zext i32 %rk.idx to i64
  %st.ptr.r = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ark.idx64
  %st.b.r = load i8, i8* %st.ptr.r, align 1
  %rk.ptr.r = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %rk.idx64
  %rk.b.r = load i8, i8* %rk.ptr.r, align 1
  %xor.r = xor i8 %st.b.r, %rk.b.r
  store i8 %xor.r, i8* %st.ptr.r, align 1
  %ark.i.next = add i32 %ark.i, 1
  br label %ark.hdr

rounds.next:
  %r.next = add i32 %r, 1
  br label %rounds.hdr

finalsub.hdr:                                      ; final SubBytes
  %fsb.i = phi i32 [ 0, %rounds.hdr ], [ %fsb.i.next, %finalsub.body ]
  %fsb.cmp = icmp sle i32 %fsb.i, 15
  br i1 %fsb.cmp, label %finalsub.body, label %finalshift

finalsub.body:
  %fsb.idx64 = zext i32 %fsb.i to i64
  %fsb.st.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fsb.idx64
  %fsb.val = load i8, i8* %fsb.st.ptr, align 1
  %fsb.z = zext i8 %fsb.val to i64
  %fsb.s.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %fsb.z
  %fsb.sv = load i8, i8* %fsb.s.ptr, align 1
  store i8 %fsb.sv, i8* %fsb.st.ptr, align 1
  %fsb.i.next = add i32 %fsb.i, 1
  br label %finalsub.hdr

finalshift:                                        ; final ShiftRows using tmp
  ; row 0
  %fs0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %fs4 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 4
  %fs8 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 8
  %fs12 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 12
  %fv0 = load i8, i8* %fs0, align 1
  %fv4 = load i8, i8* %fs4, align 1
  %fv8 = load i8, i8* %fs8, align 1
  %fv12 = load i8, i8* %fs12, align 1
  %ft0p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 0
  %ft4p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 4
  %ft8p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 8
  %ft12p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 12
  store i8 %fv0, i8* %ft0p, align 1
  store i8 %fv4, i8* %ft4p, align 1
  store i8 %fv8, i8* %ft8p, align 1
  store i8 %fv12, i8* %ft12p, align 1
  ; row 1
  %fs1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %fs5 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %fs9 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %fs13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %fv1 = load i8, i8* %fs1, align 1
  %fv5 = load i8, i8* %fs5, align 1
  %fv9 = load i8, i8* %fs9, align 1
  %fv13 = load i8, i8* %fs13, align 1
  %ft1p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 1
  %ft5p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 5
  %ft9p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 9
  %ft13p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 13
  store i8 %fv5, i8* %ft1p, align 1
  store i8 %fv9, i8* %ft5p, align 1
  store i8 %fv13, i8* %ft9p, align 1
  store i8 %fv1, i8* %ft13p, align 1
  ; row 2
  %fs2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %fs6 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %fs10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %fs14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %fv2 = load i8, i8* %fs2, align 1
  %fv6 = load i8, i8* %fs6, align 1
  %fv10 = load i8, i8* %fs10, align 1
  %fv14 = load i8, i8* %fs14, align 1
  %ft2p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 2
  %ft6p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 6
  %ft10p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 10
  %ft14p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 14
  store i8 %fv10, i8* %ft2p, align 1
  store i8 %fv14, i8* %ft6p, align 1
  store i8 %fv2, i8* %ft10p, align 1
  store i8 %fv6, i8* %ft14p, align 1
  ; row 3
  %fs3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %fs7 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %fs11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %fs15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %fv3 = load i8, i8* %fs3, align 1
  %fv7 = load i8, i8* %fs7, align 1
  %fv11 = load i8, i8* %fs11, align 1
  %fv15 = load i8, i8* %fs15, align 1
  %ft3p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 3
  %ft7p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 7
  %ft11p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 11
  %ft15p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 15
  store i8 %fv15, i8* %ft3p, align 1
  store i8 %fv3, i8* %ft7p, align 1
  store i8 %fv7, i8* %ft11p, align 1
  store i8 %fv11, i8* %ft15p, align 1

  br label %finalcopy.hdr

finalcopy.hdr:
  %fc.i = phi i32 [ 0, %finalshift ], [ %fc.i.next, %finalcopy.body ]
  %fc.cmp = icmp sle i32 %fc.i, 15
  br i1 %fc.cmp, label %finalcopy.body, label %finalark.hdr

finalcopy.body:
  %fc.idx64 = zext i32 %fc.i to i64
  %ft.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 %fc.idx64
  %ft.val = load i8, i8* %ft.ptr, align 1
  %fs.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fc.idx64
  store i8 %ft.val, i8* %fs.ptr, align 1
  %fc.i.next = add i32 %fc.i, 1
  br label %finalcopy.hdr

finalark.hdr:                                      ; final AddRoundKey with offset 160 (0xA0)
  %fark.i = phi i32 [ 0, %finalcopy.hdr ], [ %fark.i.next, %finalark.body ]
  %fark.cmp = icmp sle i32 %fark.i, 15
  br i1 %fark.cmp, label %finalark.body, label %storeout.hdr

finalark.body:
  %fark.idx64 = zext i32 %fark.i to i64
  %lastoff = add i32 %fark.i, 160
  %lastoff64 = zext i32 %lastoff to i64
  %st.ptr.f = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fark.idx64
  %st.b.f = load i8, i8* %st.ptr.f, align 1
  %rk.ptr.f = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %lastoff64
  %rk.b.f = load i8, i8* %rk.ptr.f, align 1
  %xor.f = xor i8 %st.b.f, %rk.b.f
  store i8 %xor.f, i8* %st.ptr.f, align 1
  %fark.i.next = add i32 %fark.i, 1
  br label %finalark.hdr

storeout.hdr:                                      ; write state to out
  %so.i = phi i32 [ 0, %finalark.hdr ], [ %so.i.next, %storeout.body ]
  %so.cmp = icmp sle i32 %so.i, 15
  br i1 %so.cmp, label %storeout.body, label %ret

storeout.body:
  %so.idx64 = zext i32 %so.i to i64
  %so.st.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %so.idx64
  %so.val = load i8, i8* %so.st.ptr, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %so.idx64
  store i8 %so.val, i8* %out.ptr, align 1
  %so.i.next = add i32 %so.i, 1
  br label %storeout.hdr

ret:
  ret void
}