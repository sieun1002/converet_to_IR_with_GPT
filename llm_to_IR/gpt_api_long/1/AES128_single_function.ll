; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt  ; Address: 0x11A9
; Intent: AES-128 block encryption (confidence=0.98). Evidence: S-box and Rcon table lookups; 10-round key expansion and round structure
; Preconditions: out, in, key each point to at least 16 bytes; @sbox_1 is a 256-byte AES S-box; @rcon_0 provides AES Rcon starting at 0x01
; Postconditions: Writes 16-byte ciphertext to out

@sbox_1 = external dso_local global [256 x i8], align 16
@rcon_0 = external dso_local global [256 x i8], align 16

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %w = alloca [176 x i8], align 16

  br label %copy_in

copy_in:                                              ; copy plaintext into state
  %i.in = phi i32 [ 0, %entry ], [ %i.in.next, %copy_in.body ]
  %cmp.in = icmp sle i32 %i.in, 15
  br i1 %cmp.in, label %copy_in.body, label %copy_key

copy_in.body:
  %i.in.z = sext i32 %i.in to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %i.in.z
  %in.b = load i8, i8* %in.ptr, align 1
  %sptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.in.z
  store i8 %in.b, i8* %sptr, align 1
  %i.in.next = add nsw i32 %i.in, 1
  br label %copy_in

copy_key:                                             ; copy key into first 16 bytes of key schedule
  %i.key = phi i32 [ 0, %copy_in ], [ %i.key.next, %copy_key.body ]
  %cmp.key = icmp sle i32 %i.key, 15
  br i1 %cmp.key, label %copy_key.body, label %expand_init

copy_key.body:
  %i.key.z = sext i32 %i.key to i64
  %k.ptr = getelementptr inbounds i8, i8* %key, i64 %i.key.z
  %k.b = load i8, i8* %k.ptr, align 1
  %w.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.key.z
  store i8 %k.b, i8* %w.ptr, align 1
  %i.key.next = add nsw i32 %i.key, 1
  br label %copy_key

expand_init:
  br label %expand

expand:                                               ; AES-128 key expansion generate w[16..175]
  %i.exp = phi i32 [ 16, %expand_init ], [ %i.exp.next, %expand.end ]
  %rcidx = phi i32 [ 0, %expand_init ], [ %rcidx.next, %expand.end ]
  %cmp.exp = icmp sle i32 %i.exp, 175
  br i1 %cmp.exp, label %expand.body, label %addroundkey0

expand.body:
  ; load previous word (t0..t3)
  %i.m4 = add nsw i32 %i.exp, -4
  %i.m3 = add nsw i32 %i.exp, -3
  %i.m2 = add nsw i32 %i.exp, -2
  %i.m1 = add nsw i32 %i.exp, -1
  %i.m4.z = sext i32 %i.m4 to i64
  %i.m3.z = sext i32 %i.m3 to i64
  %i.m2.z = sext i32 %i.m2 to i64
  %i.m1.z = sext i32 %i.m1 to i64
  %w.m4.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.m4.z
  %w.m3.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.m3.z
  %w.m2.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.m2.z
  %w.m1.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.m1.z
  %t0.init = load i8, i8* %w.m4.ptr, align 1
  %t1.init = load i8, i8* %w.m3.ptr, align 1
  %t2.init = load i8, i8* %w.m2.ptr, align 1
  %t3.init = load i8, i8* %w.m1.ptr, align 1
  ; if (i % 16 == 0) { RotWord, SubWord, XOR Rcon }
  %and = and i32 %i.exp, 15
  %cond = icmp eq i32 %and, 0
  br i1 %cond, label %subword, label %no_subword

subword:
  ; rotate left (t1,t2,t3,t0)
  %rt0 = %t1.init
  %rt1 = %t2.init
  %rt2 = %t3.init
  %rt3 = %t0.init
  ; SubWord using S-box
  %rt0.z = zext i8 %rt0 to i64
  %rt1.z = zext i8 %rt1 to i64
  %rt2.z = zext i8 %rt2 to i64
  %rt3.z = zext i8 %rt3 to i64
  %sbox.rt0.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt0.z
  %sbox.rt1.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt1.z
  %sbox.rt2.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt2.z
  %sbox.rt3.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt3.z
  %sw0 = load i8, i8* %sbox.rt0.ptr, align 1
  %sw1 = load i8, i8* %sbox.rt1.ptr, align 1
  %sw2 = load i8, i8* %sbox.rt2.ptr, align 1
  %sw3 = load i8, i8* %sbox.rt3.ptr, align 1
  ; XOR Rcon on first byte; rcon index uses current rcidx then increments
  %rcidx.z = sext i32 %rcidx to i64
  %rcon.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 %rcidx.z
  %rconb = load i8, i8* %rcon.ptr, align 1
  %sw0.x = xor i8 %sw0, %rconb
  %rcidx.inc = add nsw i32 %rcidx, 1
  br label %after_subword

no_subword:
  br label %after_subword

after_subword:
  %t0.sel = phi i8 [ %sw0.x, %subword ], [ %t0.init, %no_subword ]
  %t1.sel = phi i8 [ %sw1,   %subword ], [ %t1.init, %no_subword ]
  %t2.sel = phi i8 [ %sw2,   %subword ], [ %t2.init, %no_subword ]
  %t3.sel = phi i8 [ %sw3,   %subword ], [ %t3.init, %no_subword ]
  %rcidx.new = phi i32 [ %rcidx.inc, %subword ], [ %rcidx, %no_subword ]

  ; compute w[i..i+3] = w[i-16..i-13] XOR t*
  %i.m16 = add nsw i32 %i.exp, -16
  %i.m15 = add nsw i32 %i.exp, -15
  %i.m14 = add nsw i32 %i.exp, -14
  %i.m13 = add nsw i32 %i.exp, -13
  %i.m16.z = sext i32 %i.m16 to i64
  %i.m15.z = sext i32 %i.m15 to i64
  %i.m14.z = sext i32 %i.m14 to i64
  %i.m13.z = sext i32 %i.m13 to i64
  %w.m16.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.m16.z
  %w.m15.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.m15.z
  %w.m14.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.m14.z
  %w.m13.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.m13.z
  %w.m16.b = load i8, i8* %w.m16.ptr, align 1
  %w.m15.b = load i8, i8* %w.m15.ptr, align 1
  %w.m14.b = load i8, i8* %w.m14.ptr, align 1
  %w.m13.b = load i8, i8* %w.m13.ptr, align 1
  %o0 = xor i8 %w.m16.b, %t0.sel
  %o1 = xor i8 %w.m15.b, %t1.sel
  %o2 = xor i8 %w.m14.b, %t2.sel
  %o3 = xor i8 %w.m13.b, %t3.sel
  %i.exp.z = sext i32 %i.exp to i64
  %i.exp.p1 = add nsw i32 %i.exp, 1
  %i.exp.p2 = add nsw i32 %i.exp, 2
  %i.exp.p3 = add nsw i32 %i.exp, 3
  %i.exp.p1.z = sext i32 %i.exp.p1 to i64
  %i.exp.p2.z = sext i32 %i.exp.p2 to i64
  %i.exp.p3.z = sext i32 %i.exp.p3 to i64
  %w.i.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.exp.z
  %w.i1.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.exp.p1.z
  %w.i2.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.exp.p2.z
  %w.i3.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.exp.p3.z
  store i8 %o0, i8* %w.i.ptr, align 1
  store i8 %o1, i8* %w.i1.ptr, align 1
  store i8 %o2, i8* %w.i2.ptr, align 1
  store i8 %o3, i8* %w.i3.ptr, align 1
  br label %expand.end

expand.end:
  %i.exp.next = add nsw i32 %i.exp, 4
  %rcidx.next = phi i32 [ %rcidx.new, %after_subword ]
  br label %expand

addroundkey0:                                         ; initial AddRoundKey with round 0 key
  br label %ark0.loop

ark0.loop:
  %i.ark0 = phi i32 [ 0, %addroundkey0 ], [ %i.ark0.next, %ark0.body ]
  %cmp.ark0 = icmp sle i32 %i.ark0, 15
  br i1 %cmp.ark0, label %ark0.body, label %rounds.init

ark0.body:
  %i.ark0.z = sext i32 %i.ark0 to i64
  %s.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.ark0.z
  %s.b = load i8, i8* %s.ptr, align 1
  %wk.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.ark0.z
  %wk.b = load i8, i8* %wk.ptr, align 1
  %s.x = xor i8 %s.b, %wk.b
  store i8 %s.x, i8* %s.ptr, align 1
  %i.ark0.next = add nsw i32 %i.ark0, 1
  br label %ark0.loop

rounds.init:
  br label %rounds

rounds:                                               ; rounds 1..9
  %r = phi i32 [ 1, %rounds.init ], [ %r.next, %rounds.end ]
  %cmp.r = icmp sle i32 %r, 9
  br i1 %cmp.r, label %round.body, label %final_subbytes

round.body:
  ; SubBytes
  br label %sb.loop

sb.loop:
  %i.sb = phi i32 [ 0, %round.body ], [ %i.sb.next, %sb.body ]
  %cmp.sb = icmp sle i32 %i.sb, 15
  br i1 %cmp.sb, label %sb.body, label %shiftrows

sb.body:
  %i.sb.z = sext i32 %i.sb to i64
  %s.sb.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.sb.z
  %s.sb.b = load i8, i8* %s.sb.ptr, align 1
  %s.idx = zext i8 %s.sb.b to i64
  %sbox.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %s.idx
  %s.sb.sub = load i8, i8* %sbox.ptr, align 1
  store i8 %s.sb.sub, i8* %s.sb.ptr, align 1
  %i.sb.next = add nsw i32 %i.sb, 1
  br label %sb.loop

shiftrows:
  ; load all state bytes
  %b0.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %b1.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %b2.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %b3.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %b4.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 4
  %b5.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %b6.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %b7.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %b8.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 8
  %b9.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %b10.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %b11.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %b12.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 12
  %b13.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %b14.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %b15.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %b0 = load i8, i8* %b0.ptr, align 1
  %b1 = load i8, i8* %b1.ptr, align 1
  %b2 = load i8, i8* %b2.ptr, align 1
  %b3 = load i8, i8* %b3.ptr, align 1
  %b4 = load i8, i8* %b4.ptr, align 1
  %b5 = load i8, i8* %b5.ptr, align 1
  %b6 = load i8, i8* %b6.ptr, align 1
  %b7 = load i8, i8* %b7.ptr, align 1
  %b8 = load i8, i8* %b8.ptr, align 1
  %b9 = load i8, i8* %b9.ptr, align 1
  %b10 = load i8, i8* %b10.ptr, align 1
  %b11 = load i8, i8* %b11.ptr, align 1
  %b12 = load i8, i8* %b12.ptr, align 1
  %b13 = load i8, i8* %b13.ptr, align 1
  %b14 = load i8, i8* %b14.ptr, align 1
  %b15 = load i8, i8* %b15.ptr, align 1
  ; ShiftRows (column-major state layout)
  ; Row 0 unchanged
  store i8 %b0,  i8* %b0.ptr,  align 1
  store i8 %b4,  i8* %b4.ptr,  align 1
  store i8 %b8,  i8* %b8.ptr,  align 1
  store i8 %b12, i8* %b12.ptr, align 1
  ; Row 1 rotate left by 1
  store i8 %b5,  i8* %b1.ptr,  align 1
  store i8 %b9,  i8* %b5.ptr,  align 1
  store i8 %b13, i8* %b9.ptr,  align 1
  store i8 %b1,  i8* %b13.ptr, align 1
  ; Row 2 rotate left by 2
  store i8 %b10, i8* %b2.ptr,  align 1
  store i8 %b14, i8* %b6.ptr,  align 1
  store i8 %b2,  i8* %b10.ptr, align 1
  store i8 %b6,  i8* %b14.ptr, align 1
  ; Row 3 rotate left by 3
  store i8 %b15, i8* %b3.ptr,  align 1
  store i8 %b3,  i8* %b7.ptr,  align 1
  store i8 %b7,  i8* %b11.ptr, align 1
  store i8 %b11, i8* %b15.ptr, align 1

  ; MixColumns
  br label %mc.cols

mc.cols:
  %col = phi i32 [ 0, %shiftrows ], [ %col.next, %mc.cols.end ]
  %cmp.col = icmp sle i32 %col, 3
  br i1 %cmp.col, label %mc.body, label %ark.round

mc.body:
  %base = shl i32 %col, 2
  %b0i = sext i32 %base to i64
  %b1i32 = add nsw i32 %base, 1
  %b2i32 = add nsw i32 %base, 2
  %b3i32 = add nsw i32 %base, 3
  %b1i = sext i32 %b1i32 to i64
  %b2i = sext i32 %b2i32 to i64
  %b3i = sext i32 %b3i32 to i64
  %p0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b0i
  %p1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b1i
  %p2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b2i
  %p3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b3i
  %s0 = load i8, i8* %p0, align 1
  %s1 = load i8, i8* %p1, align 1
  %s2 = load i8, i8* %p2, align 1
  %s3 = load i8, i8* %p3, align 1
  %t01 = xor i8 %s0, %s1
  %t23 = xor i8 %s2, %s3
  %t = xor i8 %t01, %t23

  ; xtime(s0 ^ s1)
  %u01 = xor i8 %s0, %s1
  %u01.z = zext i8 %u01 to i32
  %u01.shl = shl i32 %u01.z, 1
  %u01.and = and i32 %u01.shl, 255
  %u01.msb = lshr i32 %u01.z, 7
  %u01.mask = select i1 (icmp ne i32 %u01.msb, 0), i32 27, i32 0
  %u01.xt = xor i32 %u01.and, %u01.mask
  %u01.xt.t = trunc i32 %u01.xt to i8

  ; xtime(s1 ^ s2)
  %u12 = xor i8 %s1, %s2
  %u12.z = zext i8 %u12 to i32
  %u12.shl = shl i32 %u12.z, 1
  %u12.and = and i32 %u12.shl, 255
  %u12.msb = lshr i32 %u12.z, 7
  %u12.mask = select i1 (icmp ne i32 %u12.msb, 0), i32 27, i32 0
  %u12.xt = xor i32 %u12.and, %u12.mask
  %u12.xt.t = trunc i32 %u12.xt to i8

  ; xtime(s2 ^ s3)
  %u23 = xor i8 %s2, %s3
  %u23.z = zext i8 %u23 to i32
  %u23.shl = shl i32 %u23.z, 1
  %u23.and = and i32 %u23.shl, 255
  %u23.msb = lshr i32 %u23.z, 7
  %u23.mask = select i1 (icmp ne i32 %u23.msb, 0), i32 27, i32 0
  %u23.xt = xor i32 %u23.and, %u23.mask
  %u23.xt.t = trunc i32 %u23.xt to i8

  ; xtime(s3 ^ s0)
  %u30 = xor i8 %s3, %s0
  %u30.z = zext i8 %u30 to i32
  %u30.shl = shl i32 %u30.z, 1
  %u30.and = and i32 %u30.shl, 255
  %u30.msb = lshr i32 %u30.z, 7
  %u30.mask = select i1 (icmp ne i32 %u30.msb, 0), i32 27, i32 0
  %u30.xt = xor i32 %u30.and, %u30.mask
  %u30.xt.t = trunc i32 %u30.xt to i8

  ; compute new column
  %t.z = zext i8 %t to i8
  %n0.t = xor i8 %s0, %t
  %n0 = xor i8 %n0.t, %u01.xt.t
  %n1.t = xor i8 %s1, %t
  %n1 = xor i8 %n1.t, %u12.xt.t
  %n2.t = xor i8 %s2, %t
  %n2 = xor i8 %n2.t, %u23.xt.t
  %n3.t = xor i8 %s3, %t
  %n3 = xor i8 %n3.t, %u30.xt.t

  store i8 %n0, i8* %p0, align 1
  store i8 %n1, i8* %p1, align 1
  store i8 %n2, i8* %p2, align 1
  store i8 %n3, i8* %p3, align 1

  br label %mc.cols.end

mc.cols.end:
  %col.next = add nsw i32 %col, 1
  br label %mc.cols

ark.round:
  ; AddRoundKey with round r
  %rk.off = shl i32 %r, 4
  br label %ark.loop

ark.loop:
  %i.ark = phi i32 [ 0, %ark.round ], [ %i.ark.next, %ark.body ]
  %cmp.ark = icmp sle i32 %i.ark, 15
  br i1 %cmp.ark, label %ark.body, label %rounds.end

ark.body:
  %i.ark.z = sext i32 %i.ark to i64
  %s.r.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.ark.z
  %s.r.b = load i8, i8* %s.r.ptr, align 1
  %rk.idx = add nsw i32 %rk.off, %i.ark
  %rk.idx.z = sext i32 %rk.idx to i64
  %wk.r.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %rk.idx.z
  %wk.r.b = load i8, i8* %wk.r.ptr, align 1
  %s.r.x = xor i8 %s.r.b, %wk.r.b
  store i8 %s.r.x, i8* %s.r.ptr, align 1
  %i.ark.next = add nsw i32 %i.ark, 1
  br label %ark.loop

rounds.end:
  %r.next = add nsw i32 %r, 1
  br label %rounds

final_subbytes:
  ; final round: SubBytes
  br label %fsb.loop

fsb.loop:
  %i.fsb = phi i32 [ 0, %final_subbytes ], [ %i.fsb.next, %fsb.body ]
  %cmp.fsb = icmp sle i32 %i.fsb, 15
  br i1 %cmp.fsb, label %fsb.body, label %final_shiftrows

fsb.body:
  %i.fsb.z = sext i32 %i.fsb to i64
  %s.fsb.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.fsb.z
  %s.fsb.b = load i8, i8* %s.fsb.ptr, align 1
  %s.fsb.idx = zext i8 %s.fsb.b to i64
  %sbox.f.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %s.fsb.idx
  %s.fsb.sub = load i8, i8* %sbox.f.ptr, align 1
  store i8 %s.fsb.sub, i8* %s.fsb.ptr, align 1
  %i.fsb.next = add nsw i32 %i.fsb, 1
  br label %fsb.loop

final_shiftrows:
  ; load all state bytes
  %fb0.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %fb1.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %fb2.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %fb3.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %fb4.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 4
  %fb5.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %fb6.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %fb7.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %fb8.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 8
  %fb9.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %fb10.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %fb11.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %fb12.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 12
  %fb13.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %fb14.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %fb15.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %fb0 = load i8, i8* %fb0.ptr, align 1
  %fb1 = load i8, i8* %fb1.ptr, align 1
  %fb2 = load i8, i8* %fb2.ptr, align 1
  %fb3 = load i8, i8* %fb3.ptr, align 1
  %fb4 = load i8, i8* %fb4.ptr, align 1
  %fb5 = load i8, i8* %fb5.ptr, align 1
  %fb6 = load i8, i8* %fb6.ptr, align 1
  %fb7 = load i8, i8* %fb7.ptr, align 1
  %fb8 = load i8, i8* %fb8.ptr, align 1
  %fb9 = load i8, i8* %fb9.ptr, align 1
  %fb10 = load i8, i8* %fb10.ptr, align 1
  %fb11 = load i8, i8* %fb11.ptr, align 1
  %fb12 = load i8, i8* %fb12.ptr, align 1
  %fb13 = load i8, i8* %fb13.ptr, align 1
  %fb14 = load i8, i8* %fb14.ptr, align 1
  %fb15 = load i8, i8* %fb15.ptr, align 1
  ; ShiftRows
  store i8 %fb0,  i8* %fb0.ptr,  align 1
  store i8 %fb4,  i8* %fb4.ptr,  align 1
  store i8 %fb8,  i8* %fb8.ptr,  align 1
  store i8 %fb12, i8* %fb12.ptr, align 1
  store i8 %fb5,  i8* %fb1.ptr,  align 1
  store i8 %fb9,  i8* %fb5.ptr,  align 1
  store i8 %fb13, i8* %fb9.ptr,  align 1
  store i8 %fb1,  i8* %fb13.ptr, align 1
  store i8 %fb10, i8* %fb2.ptr,  align 1
  store i8 %fb14, i8* %fb6.ptr,  align 1
  store i8 %fb2,  i8* %fb10.ptr, align 1
  store i8 %fb6,  i8* %fb14.ptr, align 1
  store i8 %fb15, i8* %fb3.ptr,  align 1
  store i8 %fb3,  i8* %fb7.ptr,  align 1
  store i8 %fb7,  i8* %fb11.ptr, align 1
  store i8 %fb11, i8* %fb15.ptr, align 1

  ; final AddRoundKey with round 10 (offset 160)
  br label %fark.loop

fark.loop:
  %i.fark = phi i32 [ 0, %final_shiftrows ], [ %i.fark.next, %fark.body ]
  %cmp.fark = icmp sle i32 %i.fark, 15
  br i1 %cmp.fark, label %fark.body, label %store_out

fark.body:
  %i.fark.z = sext i32 %i.fark to i64
  %s.f.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.fark.z
  %s.f.b = load i8, i8* %s.f.ptr, align 1
  %rk10.idx = add nsw i32 160, %i.fark
  %rk10.idx.z = sext i32 %rk10.idx to i64
  %wk10.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %rk10.idx.z
  %wk10.b = load i8, i8* %wk10.ptr, align 1
  %s.f.x = xor i8 %s.f.b, %wk10.b
  store i8 %s.f.x, i8* %s.f.ptr, align 1
  %i.fark.next = add nsw i32 %i.fark, 1
  br label %fark.loop

store_out:
  br label %copy_out

copy_out:
  %i.out = phi i32 [ 0, %store_out ], [ %i.out.next, %copy_out.body ]
  %cmp.out = icmp sle i32 %i.out, 15
  br i1 %cmp.out, label %copy_out.body, label %ret

copy_out.body:
  %i.out.z = sext i32 %i.out to i64
  %s.out.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.out.z
  %s.out.b = load i8, i8* %s.out.ptr, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %i.out.z
  store i8 %s.out.b, i8* %out.ptr, align 1
  %i.out.next = add nsw i32 %i.out, 1
  br label %copy_out

ret:
  ret void
}