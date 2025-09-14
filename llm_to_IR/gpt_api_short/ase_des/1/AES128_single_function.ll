; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt ; Address: 0x000011A9
; Intent: AES-128 ECB single-block encrypt (confidence=0.90). Evidence: key expansion to 176 bytes, 9 full rounds + final round, S-box/rcon usage, ShiftRows/MixColumns/AddRoundKey patterns.
; Preconditions: in, out, key point to at least 16 valid bytes each; sbox_1 is a 256-byte S-box; rcon_0 contains AES round constants.
; Postconditions: out[0..15] contains AES-128 encryption of in[0..15] with key[0..15].

; Only the necessary external declarations:
@rcon_0 = external global [256 x i8]
@sbox_1 = external global [256 x i8]

define dso_local void @aes128_encrypt(i8* nocapture noundef %out, i8* nocapture noundef readonly %in, i8* nocapture noundef readonly %key) local_unnamed_addr {
entry:
  ; state[16], expanded key w[176]
  %state = alloca [16 x i8], align 16
  %w = alloca [176 x i8], align 16

  ; load input -> state
  br label %copy_in.loop

copy_in.loop:                                        ; i = 0..15
  %ci.i = phi i32 [ 0, %entry ], [ %ci.i.next, %copy_in.body ]
  %ci.cmp = icmp sle i32 %ci.i, 15
  br i1 %ci.cmp, label %copy_in.body, label %copy_key.entry

copy_in.body:
  %ci.i64 = sext i32 %ci.i to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %ci.i64
  %in.b = load i8, i8* %in.ptr, align 1
  %st.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ci.i64
  store i8 %in.b, i8* %st.ptr, align 1
  %ci.i.next = add nsw i32 %ci.i, 1
  br label %copy_in.loop

copy_key.entry:
  br label %copy_key.loop

copy_key.loop:                                       ; i = 0..15
  %ck.i = phi i32 [ 0, %copy_key.entry ], [ %ck.i.next, %copy_key.body ]
  %ck.cmp = icmp sle i32 %ck.i, 15
  br i1 %ck.cmp, label %copy_key.body, label %keyexp.entry

copy_key.body:
  %ck.i64 = sext i32 %ck.i to i64
  %key.ptr = getelementptr inbounds i8, i8* %key, i64 %ck.i64
  %key.b = load i8, i8* %key.ptr, align 1
  %w.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %ck.i64
  store i8 %key.b, i8* %w.ptr, align 1
  %ck.i.next = add nsw i32 %ck.i, 1
  br label %copy_key.loop

; Key expansion for AES-128: generate w[16..175]
keyexp.entry:
  br label %keyexp.loop

keyexp.loop:
  %ke.i = phi i32 [ 16, %keyexp.entry ], [ %ke.i.next, %keyexp.body ]
  %ke.rc = phi i32 [ 0, %keyexp.entry ], [ %ke.rc.next, %keyexp.body ]
  %ke.cont = icmp sle i32 %ke.i, 175
  br i1 %ke.cont, label %keyexp.body, label %addroundkey0.entry

keyexp.body:
  ; load temp = w[i-4..i-1]
  %i.m4 = add nsw i32 %ke.i, -4
  %i.m3 = add nsw i32 %ke.i, -3
  %i.m2 = add nsw i32 %ke.i, -2
  %i.m1 = add nsw i32 %ke.i, -1
  %i.m4.i64 = sext i32 %i.m4 to i64
  %i.m3.i64 = sext i32 %i.m3 to i64
  %i.m2.i64 = sext i32 %i.m2 to i64
  %i.m1.i64 = sext i32 %i.m1 to i64
  %w.m4.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.m4.i64
  %w.m3.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.m3.i64
  %w.m2.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.m2.i64
  %w.m1.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %i.m1.i64
  %t0 = load i8, i8* %w.m4.ptr, align 1
  %t1 = load i8, i8* %w.m3.ptr, align 1
  %t2 = load i8, i8* %w.m2.ptr, align 1
  %t3 = load i8, i8* %w.m1.ptr, align 1

  ; if ((i & 0x0f) == 0) apply RotWord/SubWord and Rcon
  %i.and = and i32 %ke.i, 15
  %i.isblock = icmp eq i32 %i.and, 0
  br i1 %i.isblock, label %ke.block, label %ke.noblock

ke.block:
  ; rotate
  ; t0,t1,t2,t3 = t1,t2,t3,t0
  %t0b = %t0
  %t0.rot = %t1
  %t1.rot = %t2
  %t2.rot = %t3
  %t3.rot = %t0b
  ; subbytes via sbox_1
  %t0.idx = zext i8 %t0.rot to i64
  %t1.idx = zext i8 %t1.rot to i64
  %t2.idx = zext i8 %t2.rot to i64
  %t3.idx = zext i8 %t3.rot to i64
  %sbox.t0.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t0.idx
  %sbox.t1.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t1.idx
  %sbox.t2.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t2.idx
  %sbox.t3.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t3.idx
  %t0.sb = load i8, i8* %sbox.t0.ptr, align 1
  %t1.sb = load i8, i8* %sbox.t1.ptr, align 1
  %t2.sb = load i8, i8* %sbox.t2.ptr, align 1
  %t3.sb = load i8, i8* %sbox.t3.ptr, align 1
  ; Rcon
  %rc.i64 = sext i32 %ke.rc to i64
  %rcon.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 %rc.i64
  %rcon.b = load i8, i8* %rcon.ptr, align 1
  %t0.sb.i32 = zext i8 %t0.sb to i32
  %rcon.i32 = zext i8 %rcon.b to i32
  %t0.rc.x = xor i32 %t0.sb.i32, %rcon.i32
  %t0.rc = trunc i32 %t0.rc.x to i8
  %ke.rc.inc = add nsw i32 %ke.rc, 1
  br label %ke.merge

ke.noblock:
  br label %ke.merge

ke.merge:
  %t0.final = phi i8 [ %t0.rc, %ke.block ], [ %t0, %ke.noblock ]
  %t1.final = phi i8 [ %t1.sb, %ke.block ], [ %t1, %ke.noblock ]
  %t2.final = phi i8 [ %t2.sb, %ke.block ], [ %t2, %ke.noblock ]
  %t3.final = phi i8 [ %t3.sb, %ke.block ], [ %t3, %ke.noblock ]
  %ke.rc.next = phi i32 [ %ke.rc.inc, %ke.block ], [ %ke.rc, %ke.noblock ]

  ; w[i..i+3] = w[i-16..i-13] ^ temp
  %i.m16 = add nsw i32 %ke.i, -16
  %w.i.m16.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 (sext i32 %i.m16 to i64)
  %w.i.m15.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 (sext i32 (add nsw i32 %ke.i, -15) to i64)
  %w.i.m14.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 (sext i32 (add nsw i32 %ke.i, -14) to i64)
  %w.i.m13.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 (sext i32 (add nsw i32 %ke.i, -13) to i64)
  %w.m16.b0 = load i8, i8* %w.i.m16.ptr, align 1
  %w.m15.b1 = load i8, i8* %w.i.m15.ptr, align 1
  %w.m14.b2 = load i8, i8* %w.i.m14.ptr, align 1
  %w.m13.b3 = load i8, i8* %w.i.m13.ptr, align 1
  %b0.x = xor i8 %w.m16.b0, %t0.final
  %b1.x = xor i8 %w.m15.b1, %t1.final
  %b2.x = xor i8 %w.m14.b2, %t2.final
  %b3.x = xor i8 %w.m13.b3, %t3.final
  %w.i.ptr   = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 (sext i32 %ke.i to i64)
  %w.i1.ptr  = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 (sext i32 (add nsw i32 %ke.i, 1) to i64)
  %w.i2.ptr  = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 (sext i32 (add nsw i32 %ke.i, 2) to i64)
  %w.i3.ptr  = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 (sext i32 (add nsw i32 %ke.i, 3) to i64)
  store i8 %b0.x, i8* %w.i.ptr, align 1
  store i8 %b1.x, i8* %w.i1.ptr, align 1
  store i8 %b2.x, i8* %w.i2.ptr, align 1
  store i8 %b3.x, i8* %w.i3.ptr, align 1
  %ke.i.next = add nsw i32 %ke.i, 4
  br label %keyexp.loop

; Initial AddRoundKey: state ^= w[0..15]
addroundkey0.entry:
  br label %ark0.loop

ark0.loop:
  %ark0.i = phi i32 [ 0, %addroundkey0.entry ], [ %ark0.i.next, %ark0.body ]
  %ark0.cmp = icmp sle i32 %ark0.i, 15
  br i1 %ark0.cmp, label %ark0.body, label %rounds.entry

ark0.body:
  %ark0.i64 = sext i32 %ark0.i to i64
  %s.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ark0.i64
  %s.b = load i8, i8* %s.ptr, align 1
  %w0.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %ark0.i64
  %w0.b = load i8, i8* %w0.ptr, align 1
  %sb.x = xor i8 %s.b, %w0.b
  store i8 %sb.x, i8* %s.ptr, align 1
  %ark0.i.next = add nsw i32 %ark0.i, 1
  br label %ark0.loop

; Rounds 1..9
rounds.entry:
  br label %rounds.loop

rounds.loop:
  %rnd = phi i32 [ 1, %rounds.entry ], [ %rnd.next, %after_ark ]
  %rnd.cmp = icmp sle i32 %rnd, 9
  br i1 %rnd.cmp, label %subbytes.entry, label %final.entry

; SubBytes
subbytes.entry:
  br label %sb.loop

sb.loop:
  %sb.i = phi i32 [ 0, %subbytes.entry ], [ %sb.i.next, %sb.body ]
  %sb.cmp = icmp sle i32 %sb.i, 15
  br i1 %sb.cmp, label %sb.body, label %shiftrows.entry

sb.body:
  %sb.i64 = sext i32 %sb.i to i64
  %sb.sp = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %sb.i64
  %sb.b = load i8, i8* %sb.sp, align 1
  %sb.idx = zext i8 %sb.b to i64
  %sbox.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %sb.idx
  %sb.s = load i8, i8* %sbox.ptr, align 1
  store i8 %sb.s, i8* %sb.sp, align 1
  %sb.i.next = add nsw i32 %sb.i, 1
  br label %sb.loop

; ShiftRows
shiftrows.entry:
  ; Row 1: indices 1,5,9,13 rotate left by 1
  %p1  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %p5  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %p9  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %p13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %b1  = load i8, i8* %p1, align 1
  %b5  = load i8, i8* %p5, align 1
  %b9  = load i8, i8* %p9, align 1
  %b13 = load i8, i8* %p13, align 1
  store i8 %b5,  i8* %p1,  align 1
  store i8 %b9,  i8* %p5,  align 1
  store i8 %b13, i8* %p9,  align 1
  store i8 %b1,  i8* %p13, align 1
  ; Row 2: indices 2,6,10,14 rotate by 2 (swap 2<->10 and 6<->14)
  %p2  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %p6  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %p10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %p14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %b2  = load i8, i8* %p2, align 1
  %b6  = load i8, i8* %p6, align 1
  %b10 = load i8, i8* %p10, align 1
  %b14 = load i8, i8* %p14, align 1
  store i8 %b10, i8* %p2,  align 1
  store i8 %b14, i8* %p6,  align 1
  store i8 %b2,  i8* %p10, align 1
  store i8 %b6,  i8* %p14, align 1
  ; Row 3: indices 3,7,11,15 rotate left by 3 (right by 1)
  %p3  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %p7  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %p11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %p15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %b3  = load i8, i8* %p3,  align 1
  %b7  = load i8, i8* %p7,  align 1
  %b11 = load i8, i8* %p11, align 1
  %b15 = load i8, i8* %p15, align 1
  store i8 %b15, i8* %p3,  align 1
  store i8 %b3,  i8* %p7,  align 1
  store i8 %b7,  i8* %p11, align 1
  store i8 %b11, i8* %p15, align 1
  br label %mixcolumns.entry

; MixColumns
mixcolumns.entry:
  br label %mc.col.loop

mc.col.loop:
  %col = phi i32 [ 0, %mixcolumns.entry ], [ %col.next, %mc.col.end ]
  %mc.cmp = icmp sle i32 %col, 3
  br i1 %mc.cmp, label %mc.col.body, label %ark.entry

mc.col.body:
  %base = shl i32 %col, 2
  %i0 = sext i32 %base to i64
  %i1 = sext i32 (add nsw i32 %base, 1) to i64
  %i2 = sext i32 (add nsw i32 %base, 2) to i64
  %i3 = sext i32 (add nsw i32 %base, 3) to i64
  %c0p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i0
  %c1p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i1
  %c2p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i2
  %c3p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i3
  %c0b = load i8, i8* %c0p, align 1
  %c1b = load i8, i8* %c1p, align 1
  %c2b = load i8, i8* %c2p, align 1
  %c3b = load i8, i8* %c3p, align 1
  %c0 = zext i8 %c0b to i32
  %c1 = zext i8 %c1b to i32
  %c2 = zext i8 %c2b to i32
  %c3 = zext i8 %c3b to i32
  %t.x1 = xor i32 %c0, %c1
  %t.x2 = xor i32 %t.x1, %c2
  %t = xor i32 %t.x2, %c3

  ; s0 ^= xtime(c0^c1) ^ t
  %x01 = xor i32 %c0, %c1
  %x01sh = shl i32 %x01, 1
  %x01sh.m = and i32 %x01sh, 255
  %x01carry = lshr i32 %x01, 7
  %x01mul = mul i32 %x01carry, 27
  %xt01 = xor i32 %x01sh.m, %x01mul
  %s0.x1 = xor i32 %c0, %xt01
  %s0.x2 = xor i32 %s0.x1, %t
  %s0 = trunc i32 %s0.x2 to i8
  store i8 %s0, i8* %c0p, align 1

  ; s1 ^= xtime(c1^c2) ^ t
  %x12 = xor i32 %c1, %c2
  %x12sh = shl i32 %x12, 1
  %x12sh.m = and i32 %x12sh, 255
  %x12carry = lshr i32 %x12, 7
  %x12mul = mul i32 %x12carry, 27
  %xt12 = xor i32 %x12sh.m, %x12mul
  %s1.x1 = xor i32 %c1, %xt12
  %s1.x2 = xor i32 %s1.x1, %t
  %s1 = trunc i32 %s1.x2 to i8
  store i8 %s1, i8* %c1p, align 1

  ; s2 ^= xtime(c2^c3) ^ t
  %x23 = xor i32 %c2, %c3
  %x23sh = shl i32 %x23, 1
  %x23sh.m = and i32 %x23sh, 255
  %x23carry = lshr i32 %x23, 7
  %x23mul = mul i32 %x23carry, 27
  %xt23 = xor i32 %x23sh.m, %x23mul
  %s2.x1 = xor i32 %c2, %xt23
  %s2.x2 = xor i32 %s2.x1, %t
  %s2 = trunc i32 %s2.x2 to i8
  store i8 %s2, i8* %c2p, align 1

  ; s3 ^= xtime(c3^c0) ^ t
  %x30 = xor i32 %c3, %c0
  %x30sh = shl i32 %x30, 1
  %x30sh.m = and i32 %x30sh, 255
  %x30carry = lshr i32 %x30, 7
  %x30mul = mul i32 %x30carry, 27
  %xt30 = xor i32 %x30sh.m, %x30mul
  %s3.x1 = xor i32 %c3, %xt30
  %s3.x2 = xor i32 %s3.x1, %t
  %s3 = trunc i32 %s3.x2 to i8
  store i8 %s3, i8* %c3p, align 1

  br label %mc.col.end

mc.col.end:
  %col.next = add nsw i32 %col, 1
  br label %mc.col.loop

; AddRoundKey for round rnd: state ^= w[rnd*16 .. rnd*16+15]
ark.entry:
  br label %ark.loop

ark.loop:
  %ark.i = phi i32 [ 0, %ark.entry ], [ %ark.i.next, %ark.body ]
  %ark.cmp = icmp sle i32 %ark.i, 15
  br i1 %ark.cmp, label %ark.body, label %after_ark

ark.body:
  %ark.i64 = sext i32 %ark.i to i64
  %sptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ark.i64
  %sb = load i8, i8* %sptr, align 1
  %rnd.shl = shl i32 %rnd, 4
  %w.idx = add nsw i32 %rnd.shl, %ark.i
  %w.idx64 = sext i32 %w.idx to i64
  %wptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %w.idx64
  %wb = load i8, i8* %wptr, align 1
  %xor = xor i8 %sb, %wb
  store i8 %xor, i8* %sptr, align 1
  %ark.i.next = add nsw i32 %ark.i, 1
  br label %ark.loop

after_ark:
  %rnd.next = add nsw i32 %rnd, 1
  br label %rounds.loop

; Final round: SubBytes, ShiftRows, AddRoundKey with round 10 (0xA0)
final.entry:
  ; SubBytes
  br label %final.sb.loop

final.sb.loop:
  %fsb.i = phi i32 [ 0, %final.entry ], [ %fsb.i.next, %final.sb.body ]
  %fsb.cmp = icmp sle i32 %fsb.i, 15
  br i1 %fsb.cmp, label %final.sb.body, label %final.sr.entry

final.sb.body:
  %fsb.i64 = sext i32 %fsb.i to i64
  %fsb.sp = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fsb.i64
  %fsb.b = load i8, i8* %fsb.sp, align 1
  %fsb.idx = zext i8 %fsb.b to i64
  %fsbox.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %fsb.idx
  %fsb.s = load i8, i8* %fsbox.ptr, align 1
  store i8 %fsb.s, i8* %fsb.sp, align 1
  %fsb.i.next = add nsw i32 %fsb.i, 1
  br label %final.sb.loop

final.sr.entry:
  ; ShiftRows same as before
  %fp1  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %fp5  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %fp9  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %fp13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %fb1  = load i8, i8* %fp1, align 1
  %fb5  = load i8, i8* %fp5, align 1
  %fb9  = load i8, i8* %fp9, align 1
  %fb13 = load i8, i8* %fp13, align 1
  store i8 %fb5,  i8* %fp1,  align 1
  store i8 %fb9,  i8* %fp5,  align 1
  store i8 %fb13, i8* %fp9,  align 1
  store i8 %fb1,  i8* %fp13, align 1
  %fp2  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %fp6  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %fp10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %fp14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %fb2  = load i8, i8* %fp2,  align 1
  %fb6  = load i8, i8* %fp6,  align 1
  %fb10 = load i8, i8* %fp10, align 1
  %fb14 = load i8, i8* %fp14, align 1
  store i8 %fb10, i8* %fp2,  align 1
  store i8 %fb14, i8* %fp6,  align 1
  store i8 %fb2,  i8* %fp10, align 1
  store i8 %fb6,  i8* %fp14, align 1
  %fp3  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %fp7  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %fp11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %fp15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %fb3  = load i8, i8* %fp3,  align 1
  %fb7  = load i8, i8* %fp7,  align 1
  %fb11 = load i8, i8* %fp11, align 1
  %fb15 = load i8, i8* %fp15, align 1
  store i8 %fb15, i8* %fp3,  align 1
  store i8 %fb3,  i8* %fp7,  align 1
  store i8 %fb7,  i8* %fp11, align 1
  store i8 %fb11, i8* %fp15, align 1
  br label %final.ark.entry

; Final AddRoundKey with round 10 (offset 160 = 0xA0)
final.ark.entry:
  br label %final.ark.loop

final.ark.loop:
  %fark.i = phi i32 [ 0, %final.ark.entry ], [ %fark.i.next, %final.ark.body ]
  %fark.cmp = icmp sle i32 %fark.i, 15
  br i1 %fark.cmp, label %final.ark.body, label %store_out.entry

final.ark.body:
  %fark.i64 = sext i32 %fark.i to i64
  %fsptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fark.i64
  %fsb = load i8, i8* %fsptr, align 1
  %off10 = add nsw i32 %fark.i, 160
  %off10.i64 = sext i32 %off10 to i64
  %w10.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i64 0, i64 %off10.i64
  %w10.b = load i8, i8* %w10.ptr, align 1
  %fxor = xor i8 %fsb, %w10.b
  store i8 %fxor, i8* %fsptr, align 1
  %fark.i.next = add nsw i32 %fark.i, 1
  br label %final.ark.loop

; store state -> out
store_out.entry:
  br label %store_out.loop

store_out.loop:
  %so.i = phi i32 [ 0, %store_out.entry ], [ %so.i.next, %store_out.body ]
  %so.cmp = icmp sle i32 %so.i, 15
  br i1 %so.cmp, label %store_out.body, label %ret

store_out.body:
  %so.i64 = sext i32 %so.i to i64
  %s.ptr2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %so.i64
  %sb2 = load i8, i8* %s.ptr2, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %so.i64
  store i8 %sb2, i8* %out.ptr, align 1
  %so.i.next = add nsw i32 %so.i, 1
  br label %store_out.loop

ret:
  ret void
}