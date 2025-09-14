; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt ; Address: 0x11A9
; Intent: AES-128 single-block encryption with on-the-fly key expansion (confidence=0.99). Evidence: sbox and rcon usage; 176-byte key schedule; 10 rounds with MixColumns in rounds 1–9.
; Preconditions: out, in, key each point to at least 16 bytes.
; Postconditions: Writes 16-byte ciphertext to out.

; Only the necessary external declarations:
@rcon_0 = external dso_local global [256 x i8], align 16
@sbox_1 = external dso_local global [256 x i8], align 16

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %rk = alloca [176 x i8], align 16

  ; state <- in[0..15]
  br label %in_copy.loop

in_copy.loop:                                     ; preds = %in_copy.loop, %entry
  %i.in = phi i32 [ 0, %entry ], [ %i.in.next, %in_copy.loop ]
  %i.in.cmp = icmp sgt i32 %i.in, 15
  br i1 %i.in.cmp, label %key_copy.entry, label %in_copy.body

in_copy.body:                                     ; preds = %in_copy.loop
  %i.in.z = zext i32 %i.in to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %i.in.z
  %in.val = load i8, i8* %in.ptr, align 1
  %st.gep = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.in.z
  store i8 %in.val, i8* %st.gep, align 1
  %i.in.next = add nsw i32 %i.in, 1
  br label %in_copy.loop

key_copy.entry:                                   ; preds = %in_copy.loop
  br label %key_copy.loop

key_copy.loop:                                    ; preds = %key_copy.loop, %key_copy.entry
  %i.k = phi i32 [ 0, %key_copy.entry ], [ %i.k.next, %key_copy.loop ]
  %i.k.cmp = icmp sgt i32 %i.k, 15
  br i1 %i.k.cmp, label %expand.entry, label %key_copy.body

key_copy.body:                                    ; preds = %key_copy.loop
  %i.k.z = zext i32 %i.k to i64
  %key.ptr = getelementptr inbounds i8, i8* %key, i64 %i.k.z
  %key.val = load i8, i8* %key.ptr, align 1
  %rk0.gep = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.k.z
  store i8 %key.val, i8* %rk0.gep, align 1
  %i.k.next = add nsw i32 %i.k, 1
  br label %key_copy.loop

expand.entry:                                     ; preds = %key_copy.loop
  br label %expand.loop

expand.loop:                                      ; preds = %expand.next, %expand.entry
  %i.exp = phi i32 [ 16, %expand.entry ], [ %i.exp.next, %expand.next ]
  %rc.idx = phi i32 [ 0, %expand.entry ], [ %rc.idx.next, %expand.next ]
  %i.exp.cmp = icmp sgt i32 %i.exp, 175
  br i1 %i.exp.cmp, label %ark0.entry, label %expand.body

expand.body:                                      ; preds = %expand.loop
  ; load previous word W[i-1..4]
  %i.m4 = add nsw i32 %i.exp, -4
  %i.m3 = add nsw i32 %i.exp, -3
  %i.m2 = add nsw i32 %i.exp, -2
  %i.m1 = add nsw i32 %i.exp, -1
  %i.m4.z = zext i32 %i.m4 to i64
  %i.m3.z = zext i32 %i.m3 to i64
  %i.m2.z = zext i32 %i.m2 to i64
  %i.m1.z = zext i32 %i.m1 to i64
  %g.m4 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m4.z
  %g.m3 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m3.z
  %g.m2 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m2.z
  %g.m1 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m1.z
  %b0 = load i8, i8* %g.m4, align 1
  %b1 = load i8, i8* %g.m3, align 1
  %b2 = load i8, i8* %g.m2, align 1
  %b3 = load i8, i8* %g.m1, align 1

  ; condition: (i & 15) == 0
  %i.and = and i32 %i.exp, 15
  %i.and.zero = icmp eq i32 %i.and, 0
  br i1 %i.and.zero, label %do_core, label %no_core

do_core:                                          ; preds = %expand.body
  ; RotWord: [b1,b2,b3,b0]
  %rb0 = zext i8 %b1 to i32
  %rb1 = zext i8 %b2 to i32
  %rb2 = zext i8 %b3 to i32
  %rb3 = zext i8 %b0 to i32
  ; SubWord via sbox
  %sb0.idx = zext i8 %b1 to i64
  %sb0.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %sb0.idx
  %sb0 = load i8, i8* %sb0.ptr, align 1
  %sb1.idx = zext i8 %b2 to i64
  %sb1.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %sb1.idx
  %sb1 = load i8, i8* %sb1.ptr, align 1
  %sb2.idx = zext i8 %b3 to i64
  %sb2.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %sb2.idx
  %sb2 = load i8, i8* %sb2.ptr, align 1
  %sb3.idx = zext i8 %b0 to i64
  %sb3.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %sb3.idx
  %sb3 = load i8, i8* %sb3.ptr, align 1
  ; rcon
  %rc.next = add nuw nsw i32 %rc.idx, 1
  %rc.next.z = zext i32 %rc.next to i64
  %rc.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 %rc.next.z
  %rc.byte = load i8, i8* %rc.ptr, align 1
  %t0.core = xor i8 %sb0, %rc.byte
  %t1.core = %sb1
  %t2.core = %sb2
  %t3.core = %sb3
  br label %after_core

no_core:                                          ; preds = %expand.body
  %t0.nc = %b0
  %t1.nc = %b1
  %t2.nc = %b2
  %t3.nc = %b3
  br label %after_core

after_core:                                       ; preds = %no_core, %do_core
  %t0 = phi i8 [ %t0.core, %do_core ], [ %t0.nc, %no_core ]
  %t1 = phi i8 [ %t1.core, %do_core ], [ %t1.nc, %no_core ]
  %t2 = phi i8 [ %t2.core, %do_core ], [ %t2.nc, %no_core ]
  %t3 = phi i8 [ %t3.core, %do_core ], [ %t3.nc, %no_core ]
  %rc.idx.next = phi i32 [ %rc.next, %do_core ], [ %rc.idx, %no_core ]

  ; W[i..i+3] = W[i-16..i-13] ^ temp
  %i.m16 = add nsw i32 %i.exp, -16
  %i.m15 = add nsw i32 %i.exp, -15
  %i.m14 = add nsw i32 %i.exp, -14
  %i.m13 = add nsw i32 %i.exp, -13
  %i.m16.z = zext i32 %i.m16 to i64
  %i.m15.z = zext i32 %i.m15 to i64
  %i.m14.z = zext i32 %i.m14 to i64
  %i.m13.z = zext i32 %i.m13 to i64
  %g.m16 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m16.z
  %g.m15 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m15.z
  %g.m14 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m14.z
  %g.m13 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m13.z
  %w.m16 = load i8, i8* %g.m16, align 1
  %w.m15 = load i8, i8* %g.m15, align 1
  %w.m14 = load i8, i8* %g.m14, align 1
  %w.m13 = load i8, i8* %g.m13, align 1

  %wi = xor i8 %w.m16, %t0
  %wi1 = xor i8 %w.m15, %t1
  %wi2 = xor i8 %w.m14, %t2
  %wi3 = xor i8 %w.m13, %t3

  %i.exp.z = zext i32 %i.exp to i64
  %i.ep1 = add nuw nsw i32 %i.exp, 1
  %i.ep2 = add nuw nsw i32 %i.exp, 2
  %i.ep3 = add nuw nsw i32 %i.exp, 3
  %i.ep1.z = zext i32 %i.ep1 to i64
  %i.ep2.z = zext i32 %i.ep2 to i64
  %i.ep3.z = zext i32 %i.ep3 to i64
  %g.i = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.exp.z
  %g.i1 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.ep1.z
  %g.i2 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.ep2.z
  %g.i3 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.ep3.z
  store i8 %wi, i8* %g.i, align 1
  store i8 %wi1, i8* %g.i1, align 1
  store i8 %wi2, i8* %g.i2, align 1
  store i8 %wi3, i8* %g.i3, align 1

expand.next:                                      ; preds = %after_core
  %i.exp.next = add nuw nsw i32 %i.exp, 4
  %rc.idx.next2 = %rc.idx.next
  br label %expand.loop

ark0.entry:                                       ; preds = %expand.loop
  ; AddRoundKey round 0
  br label %ark0.loop

ark0.loop:                                        ; preds = %ark0.loop, %ark0.entry
  %i0 = phi i32 [ 0, %ark0.entry ], [ %i0.next, %ark0.loop ]
  %i0.cmp = icmp sgt i32 %i0, 15
  br i1 %i0.cmp, label %rounds.entry, label %ark0.body

ark0.body:                                        ; preds = %ark0.loop
  %i0.z = zext i32 %i0 to i64
  %st.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i0.z
  %st.v = load i8, i8* %st.p, align 1
  %rk.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i0.z
  %rk.v = load i8, i8* %rk.p, align 1
  %x0 = xor i8 %st.v, %rk.v
  store i8 %x0, i8* %st.p, align 1
  %i0.next = add nsw i32 %i0, 1
  br label %ark0.loop

rounds.entry:                                     ; preds = %ark0.loop
  br label %round.loop

round.loop:                                       ; preds = %round.next, %rounds.entry
  %rnd = phi i32 [ 1, %rounds.entry ], [ %rnd.next, %round.next ]
  %rnd.cmp = icmp sgt i32 %rnd, 9
  br i1 %rnd.cmp, label %final.entry, label %round.body

round.body:                                       ; preds = %round.loop
  ; SubBytes
  br label %sub.loop

sub.loop:                                         ; preds = %sub.loop, %round.body
  %is = phi i32 [ 0, %round.body ], [ %is.next, %sub.loop ]
  %is.cmp = icmp sgt i32 %is, 15
  br i1 %is.cmp, label %shiftrows.entry, label %sub.body

sub.body:                                         ; preds = %sub.loop
  %is.z = zext i32 %is to i64
  %s.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %is.z
  %s.v = load i8, i8* %s.p, align 1
  %s.idx = zext i8 %s.v to i64
  %sbox.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %s.idx
  %s.sb = load i8, i8* %sbox.p, align 1
  store i8 %s.sb, i8* %s.p, align 1
  %is.next = add nsw i32 %is, 1
  br label %sub.loop

shiftrows.entry:                                  ; preds = %sub.loop
  ; Load state bytes
  %s0.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %s1.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %s2.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %s3.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %s4.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 4
  %s5.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %s6.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %s7.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %s8.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 8
  %s9.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %s10.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %s11.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %s12.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 12
  %s13.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %s14.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %s15.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15

  %s0v = load i8, i8* %s0.p, align 1
  %s1v = load i8, i8* %s1.p, align 1
  %s2v = load i8, i8* %s2.p, align 1
  %s3v = load i8, i8* %s3.p, align 1
  %s4v = load i8, i8* %s4.p, align 1
  %s5v = load i8, i8* %s5.p, align 1
  %s6v = load i8, i8* %s6.p, align 1
  %s7v = load i8, i8* %s7.p, align 1
  %s8v = load i8, i8* %s8.p, align 1
  %s9v = load i8, i8* %s9.p, align 1
  %s10v = load i8, i8* %s10.p, align 1
  %s11v = load i8, i8* %s11.p, align 1
  %s12v = load i8, i8* %s12.p, align 1
  %s13v = load i8, i8* %s13.p, align 1
  %s14v = load i8, i8* %s14.p, align 1
  %s15v = load i8, i8* %s15.p, align 1

  ; ShiftRows
  ; Row0 unchanged
  store i8 %s0v, i8* %s0.p, align 1
  store i8 %s4v, i8* %s4.p, align 1
  store i8 %s8v, i8* %s8.p, align 1
  store i8 %s12v, i8* %s12.p, align 1
  ; Row1 left by 1: [1,5,9,13] -> [5,9,13,1]
  store i8 %s5v, i8* %s1.p, align 1
  store i8 %s9v, i8* %s5.p, align 1
  store i8 %s13v, i8* %s9.p, align 1
  store i8 %s1v, i8* %s13.p, align 1
  ; Row2 left by 2: [2,6,10,14] -> [10,14,2,6]
  store i8 %s10v, i8* %s2.p, align 1
  store i8 %s14v, i8* %s6.p, align 1
  store i8 %s2v, i8* %s10.p, align 1
  store i8 %s6v, i8* %s14.p, align 1
  ; Row3 left by 3: [3,7,11,15] -> [15,3,7,11]
  store i8 %s15v, i8* %s3.p, align 1
  store i8 %s3v, i8* %s7.p, align 1
  store i8 %s7v, i8* %s11.p, align 1
  store i8 %s11v, i8* %s15.p, align 1

  ; MixColumns on 4 columns
  br label %mc.col0

mc.xtime:                                         ; helper block is not used (placeholder)

mc.col0:                                          ; preds = %shiftrows.entry
  ; load column 0: indices 0..3
  %c0_0 = load i8, i8* %s0.p, align 1
  %c0_1 = load i8, i8* %s1.p, align 1
  %c0_2 = load i8, i8* %s2.p, align 1
  %c0_3 = load i8, i8* %s3.p, align 1
  %t0.x1 = xor i8 %c0_0, %c0_1
  %t0.x2 = xor i8 %c0_2, %c0_3
  %t0.sum = xor i8 %t0.x1, %t0.x2
  ; a0'
  %v01 = xor i8 %c0_0, %c0_1
  %v01_shl = shl i8 %v01, 1
  %v01_msb = lshr i8 %v01, 7
  %v01_mul = mul i8 %v01_msb, 27
  %xt01 = xor i8 %v01_shl, %v01_mul
  %c0n0.t = xor i8 %c0_0, %xt01
  %c0n0 = xor i8 %c0n0.t, %t0.sum
  ; a1'
  %v12 = xor i8 %c0_1, %c0_2
  %v12_shl = shl i8 %v12, 1
  %v12_msb = lshr i8 %v12, 7
  %v12_mul = mul i8 %v12_msb, 27
  %xt12 = xor i8 %v12_shl, %v12_mul
  %c0n1.t = xor i8 %c0_1, %xt12
  %c0n1 = xor i8 %c0n1.t, %t0.sum
  ; a2'
  %v23 = xor i8 %c0_2, %c0_3
  %v23_shl = shl i8 %v23, 1
  %v23_msb = lshr i8 %v23, 7
  %v23_mul = mul i8 %v23_msb, 27
  %xt23 = xor i8 %v23_shl, %v23_mul
  %c0n2.t = xor i8 %c0_2, %xt23
  %c0n2 = xor i8 %c0n2.t, %t0.sum
  ; a3'
  %v30 = xor i8 %c0_3, %c0_0
  %v30_shl = shl i8 %v30, 1
  %v30_msb = lshr i8 %v30, 7
  %v30_mul = mul i8 %v30_msb, 27
  %xt30 = xor i8 %v30_shl, %v30_mul
  %c0n3.t = xor i8 %c0_3, %xt30
  %c0n3 = xor i8 %c0n3.t, %t0.sum
  store i8 %c0n0, i8* %s0.p, align 1
  store i8 %c0n1, i8* %s1.p, align 1
  store i8 %c0n2, i8* %s2.p, align 1
  store i8 %c0n3, i8* %s3.p, align 1
  br label %mc.col1

mc.col1:                                          ; preds = %mc.col0
  ; column 1: indices 4..7
  %c1_0 = load i8, i8* %s4.p, align 1
  %c1_1 = load i8, i8* %s5.p, align 1
  %c1_2 = load i8, i8* %s6.p, align 1
  %c1_3 = load i8, i8* %s7.p, align 1
  %t1.x1 = xor i8 %c1_0, %c1_1
  %t1.x2 = xor i8 %c1_2, %c1_3
  %t1.sum = xor i8 %t1.x1, %t1.x2
  %u01 = xor i8 %c1_0, %c1_1
  %u01_shl = shl i8 %u01, 1
  %u01_msb = lshr i8 %u01, 7
  %u01_mul = mul i8 %u01_msb, 27
  %xtu01 = xor i8 %u01_shl, %u01_mul
  %c1n0.t = xor i8 %c1_0, %xtu01
  %c1n0 = xor i8 %c1n0.t, %t1.sum
  %u12 = xor i8 %c1_1, %c1_2
  %u12_shl = shl i8 %u12, 1
  %u12_msb = lshr i8 %u12, 7
  %u12_mul = mul i8 %u12_msb, 27
  %xtu12 = xor i8 %u12_shl, %u12_mul
  %c1n1.t = xor i8 %c1_1, %xtu12
  %c1n1 = xor i8 %c1n1.t, %t1.sum
  %u23 = xor i8 %c1_2, %c1_3
  %u23_shl = shl i8 %u23, 1
  %u23_msb = lshr i8 %u23, 7
  %u23_mul = mul i8 %u23_msb, 27
  %xtu23 = xor i8 %u23_shl, %u23_mul
  %c1n2.t = xor i8 %c1_2, %xtu23
  %c1n2 = xor i8 %c1n2.t, %t1.sum
  %u30 = xor i8 %c1_3, %c1_0
  %u30_shl = shl i8 %u30, 1
  %u30_msb = lshr i8 %u30, 7
  %u30_mul = mul i8 %u30_msb, 27
  %xtu30 = xor i8 %u30_shl, %u30_mul
  %c1n3.t = xor i8 %c1_3, %xtu30
  %c1n3 = xor i8 %c1n3.t, %t1.sum
  store i8 %c1n0, i8* %s4.p, align 1
  store i8 %c1n1, i8* %s5.p, align 1
  store i8 %c1n2, i8* %s6.p, align 1
  store i8 %c1n3, i8* %s7.p, align 1
  br label %mc.col2

mc.col2:                                          ; preds = %mc.col1
  ; column 2: indices 8..11
  %c2_0 = load i8, i8* %s8.p, align 1
  %c2_1 = load i8, i8* %s9.p, align 1
  %c2_2 = load i8, i8* %s10.p, align 1
  %c2_3 = load i8, i8* %s11.p, align 1
  %t2.x1 = xor i8 %c2_0, %c2_1
  %t2.x2 = xor i8 %c2_2, %c2_3
  %t2.sum = xor i8 %t2.x1, %t2.x2
  %w01 = xor i8 %c2_0, %c2_1
  %w01_shl = shl i8 %w01, 1
  %w01_msb = lshr i8 %w01, 7
  %w01_mul = mul i8 %w01_msb, 27
  %xtw01 = xor i8 %w01_shl, %w01_mul
  %c2n0.t = xor i8 %c2_0, %xtw01
  %c2n0 = xor i8 %c2n0.t, %t2.sum
  %w12 = xor i8 %c2_1, %c2_2
  %w12_shl = shl i8 %w12, 1
  %w12_msb = lshr i8 %w12, 7
  %w12_mul = mul i8 %w12_msb, 27
  %xtw12 = xor i8 %w12_shl, %w12_mul
  %c2n1.t = xor i8 %c2_1, %xtw12
  %c2n1 = xor i8 %c2n1.t, %t2.sum
  %w23 = xor i8 %c2_2, %c2_3
  %w23_shl = shl i8 %w23, 1
  %w23_msb = lshr i8 %w23, 7
  %w23_mul = mul i8 %w23_msb, 27
  %xtw23 = xor i8 %w23_shl, %w23_mul
  %c2n2.t = xor i8 %c2_2, %xtw23
  %c2n2 = xor i8 %c2n2.t, %t2.sum
  %w30 = xor i8 %c2_3, %c2_0
  %w30_shl = shl i8 %w30, 1
  %w30_msb = lshr i8 %w30, 7
  %w30_mul = mul i8 %w30_msb, 27
  %xtw30 = xor i8 %w30_shl, %w30_mul
  %c2n3.t = xor i8 %c2_3, %xtw30
  %c2n3 = xor i8 %c2n3.t, %t2.sum
  store i8 %c2n0, i8* %s8.p, align 1
  store i8 %c2n1, i8* %s9.p, align 1
  store i8 %c2n2, i8* %s10.p, align 1
  store i8 %c2n3, i8* %s11.p, align 1
  br label %mc.col3

mc.col3:                                          ; preds = %mc.col2
  ; column 3: indices 12..15
  %c3_0 = load i8, i8* %s12.p, align 1
  %c3_1 = load i8, i8* %s13.p, align 1
  %c3_2 = load i8, i8* %s14.p, align 1
  %c3_3 = load i8, i8* %s15.p, align 1
  %t3.x1 = xor i8 %c3_0, %c3_1
  %t3.x2 = xor i8 %c3_2, %c3_3
  %t3.sum = xor i8 %t3.x1, %t3.x2
  %z01 = xor i8 %c3_0, %c3_1
  %z01_shl = shl i8 %z01, 1
  %z01_msb = lshr i8 %z01, 7
  %z01_mul = mul i8 %z01_msb, 27
  %xtz01 = xor i8 %z01_shl, %z01_mul
  %c3n0.t = xor i8 %c3_0, %xtz01
  %c3n0 = xor i8 %c3n0.t, %t3.sum
  %z12 = xor i8 %c3_1, %c3_2
  %z12_shl = shl i8 %z12, 1
  %z12_msb = lshr i8 %z12, 7
  %z12_mul = mul i8 %z12_msb, 27
  %xtz12 = xor i8 %z12_shl, %z12_mul
  %c3n1.t = xor i8 %c3_1, %xtz12
  %c3n1 = xor i8 %c3n1.t, %t3.sum
  %z23 = xor i8 %c3_2, %c3_3
  %z23_shl = shl i8 %z23, 1
  %z23_msb = lshr i8 %z23, 7
  %z23_mul = mul i8 %z23_msb, 27
  %xtz23 = xor i8 %z23_shl, %z23_mul
  %c3n2.t = xor i8 %c3_2, %xtz23
  %c3n2 = xor i8 %c3n2.t, %t3.sum
  %z30 = xor i8 %c3_3, %c3_0
  %z30_shl = shl i8 %z30, 1
  %z30_msb = lshr i8 %z30, 7
  %z30_mul = mul i8 %z30_msb, 27
  %xtz30 = xor i8 %z30_shl, %z30_mul
  %c3n3.t = xor i8 %c3_3, %xtz30
  %c3n3 = xor i8 %c3n3.t, %t3.sum
  store i8 %c3n0, i8* %s12.p, align 1
  store i8 %c3n1, i8* %s13.p, align 1
  store i8 %c3n2, i8* %s14.p, align 1
  store i8 %c3n3, i8* %s15.p, align 1

  ; AddRoundKey for this round
  br label %ark.loop

ark.loop:                                         ; preds = %ark.loop, %mc.col3
  %ia = phi i32 [ 0, %mc.col3 ], [ %ia.next, %ark.loop ]
  %ia.cmp = icmp sgt i32 %ia, 15
  br i1 %ia.cmp, label %round.next, label %ark.body

ark.body:                                         ; preds = %ark.loop
  %ia.z = zext i32 %ia to i64
  %st.pa = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ia.z
  %st.va = load i8, i8* %st.pa, align 1
  %rk.off = mul nuw nsw i32 %rnd, 16
  %rk.idx = add nuw nsw i32 %rk.off, %ia
  %rk.idx.z = zext i32 %rk.idx to i64
  %rk.pa = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %rk.idx.z
  %rk.va = load i8, i8* %rk.pa, align 1
  %xra = xor i8 %st.va, %rk.va
  store i8 %xra, i8* %st.pa, align 1
  %ia.next = add nsw i32 %ia, 1
  br label %ark.loop

round.next:                                       ; preds = %ark.loop
  %rnd.next = add nuw nsw i32 %rnd, 1
  br label %round.loop

final.entry:                                      ; preds = %round.loop
  ; Final round: SubBytes, ShiftRows, AddRoundKey with offset 160 (0xA0)
  br label %fsub.loop

fsub.loop:                                        ; preds = %fsub.loop, %final.entry
  %fi = phi i32 [ 0, %final.entry ], [ %fi.next, %fsub.loop ]
  %fi.cmp = icmp sgt i32 %fi, 15
  br i1 %fi.cmp, label %fshift.entry, label %fsub.body

fsub.body:                                        ; preds = %fsub.loop
  %fi.z = zext i32 %fi to i64
  %fsp = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fi.z
  %fsv = load i8, i8* %fsp, align 1
  %fsidx = zext i8 %fsv to i64
  %fsbp = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %fsidx
  %fsb = load i8, i8* %fsbp, align 1
  store i8 %fsb, i8* %fsp, align 1
  %fi.next = add nsw i32 %fi, 1
  br label %fsub.loop

fshift.entry:                                     ; preds = %fsub.loop
  ; Load current state bytes
  %fs0v = load i8, i8* %s0.p, align 1
  %fs1v = load i8, i8* %s1.p, align 1
  %fs2v = load i8, i8* %s2.p, align 1
  %fs3v = load i8, i8* %s3.p, align 1
  %fs4v = load i8, i8* %s4.p, align 1
  %fs5v = load i8, i8* %s5.p, align 1
  %fs6v = load i8, i8* %s6.p, align 1
  %fs7v = load i8, i8* %s7.p, align 1
  %fs8v = load i8, i8* %s8.p, align 1
  %fs9v = load i8, i8* %s9.p, align 1
  %fs10v = load i8, i8* %s10.p, align 1
  %fs11v = load i8, i8* %s11.p, align 1
  %fs12v = load i8, i8* %s12.p, align 1
  %fs13v = load i8, i8* %s13.p, align 1
  %fs14v = load i8, i8* %s14.p, align 1
  %fs15v = load i8, i8* %s15.p, align 1

  ; ShiftRows
  store i8 %fs0v, i8* %s0.p, align 1
  store i8 %fs4v, i8* %s4.p, align 1
  store i8 %fs8v, i8* %s8.p, align 1
  store i8 %fs12v, i8* %s12.p, align 1

  store i8 %fs5v, i8* %s1.p, align 1
  store i8 %fs9v, i8* %s5.p, align 1
  store i8 %fs13v, i8* %s9.p, align 1
  store i8 %fs1v, i8* %s13.p, align 1

  store i8 %fs10v, i8* %s2.p, align 1
  store i8 %fs14v, i8* %s6.p, align 1
  store i8 %fs2v, i8* %s10.p, align 1
  store i8 %fs6v, i8* %s14.p, align 1

  store i8 %fs15v, i8* %s3.p, align 1
  store i8 %fs3v, i8* %s7.p, align 1
  store i8 %fs7v, i8* %s11.p, align 1
  store i8 %fs11v, i8* %s15.p, align 1

  ; Add last round key at offset 160
  br label %fark.loop

fark.loop:                                        ; preds = %fark.loop, %fshift.entry
  %fo = phi i32 [ 0, %fshift.entry ], [ %fo.next, %fark.loop ]
  %fo.cmp = icmp sgt i32 %fo, 15
  br i1 %fo.cmp, label %store.out, label %fark.body

fark.body:                                        ; preds = %fark.loop
  %fo.z = zext i32 %fo to i64
  %fsp2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fo.z
  %fsv2 = load i8, i8* %fsp2, align 1
  %rk.idx2 = add nuw nsw i32 %fo, 160
  %rk.idx2.z = zext i32 %rk.idx2 to i64
  %rk.fp = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %rk.idx2.z
  %rk.fv = load i8, i8* %rk.fp, align 1
  %xr = xor i8 %fsv2, %rk.fv
  store i8 %xr, i8* %fsp2, align 1
  %fo.next = add nsw i32 %fo, 1
  br label %fark.loop

store.out:                                        ; preds = %fark.loop
  br label %out.loop

out.loop:                                         ; preds = %out.loop, %store.out
  %io = phi i32 [ 0, %store.out ], [ %io.next, %out.loop ]
  %io.cmp = icmp sgt i32 %io, 15
  br i1 %io.cmp, label %ret, label %out.body

out.body:                                         ; preds = %out.loop
  %io.z = zext i32 %io to i64
  %st.op = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %io.z
  %st.ov = load i8, i8* %st.op, align 1
  %out.p = getelementptr inbounds i8, i8* %out, i64 %io.z
  store i8 %st.ov, i8* %out.p, align 1
  %io.next = add nsw i32 %io, 1
  br label %out.loop

ret:                                              ; preds = %out.loop
  ret void
}