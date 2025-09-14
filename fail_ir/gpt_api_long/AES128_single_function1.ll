; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt  ; Address: 0x11A9
; Intent: AES-128 block encryption with key expansion (confidence=0.95). Evidence: sbox/rcon lookups; 10 rounds with MixColumns and ShiftRows
; Preconditions: out, in, key each point to at least 16 bytes; sbox_1 and rcon_0 are valid lookup tables (at least 256 bytes each).
; Postconditions: Writes the 16-byte ciphertext of AES-128(in, key) to out.

@rcon_0 = external constant [256 x i8]
@sbox_1 = external constant [256 x i8]

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 1
  %rk = alloca [176 x i8], align 1

  ; state[i] = in[i]
  br label %copy_in.loop

copy_in.loop:                                         ; preds = %copy_in.loop, %entry
  %i.in = phi i32 [ 0, %entry ], [ %i.in.next, %copy_in.loop ]
  %i.in.cmp = icmp sle i32 %i.in, 15
  br i1 %i.in.cmp, label %copy_in.body, label %copy_key.entry

copy_in.body:                                         ; preds = %copy_in.loop
  %i.in.z = zext i32 %i.in to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %i.in.z
  %in.val = load i8, i8* %in.ptr, align 1
  %st.gep = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.in.z
  store i8 %in.val, i8* %st.gep, align 1
  %i.in.next = add nsw i32 %i.in, 1
  br label %copy_in.loop

copy_key.entry:                                       ; preds = %copy_in.loop
  br label %copy_key.loop

copy_key.loop:                                        ; preds = %copy_key.loop, %copy_key.entry
  %i.key = phi i32 [ 0, %copy_key.entry ], [ %i.key.next, %copy_key.loop ]
  %i.key.cmp = icmp sle i32 %i.key, 15
  br i1 %i.key.cmp, label %copy_key.body, label %expand.entry

copy_key.body:                                        ; preds = %copy_key.loop
  %i.key.z = zext i32 %i.key to i64
  %key.ptr = getelementptr inbounds i8, i8* %key, i64 %i.key.z
  %key.val = load i8, i8* %key.ptr, align 1
  %rk.gep0 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.key.z
  store i8 %key.val, i8* %rk.gep0, align 1
  %i.key.next = add nsw i32 %i.key, 1
  br label %copy_key.loop

expand.entry:                                         ; preds = %copy_key.loop
  %i.exp.init = add nsw i32 16, 0
  %rc.init = add nsw i32 0, 0
  br label %expand.loop

expand.loop:                                          ; preds = %expand.next, %expand.entry
  %i.exp = phi i32 [ %i.exp.init, %expand.entry ], [ %i.exp.next, %expand.next ]
  %rc = phi i32 [ %rc.init, %expand.entry ], [ %rc.next, %expand.next ]
  %cmp.exp = icmp sle i32 %i.exp, 175
  br i1 %cmp.exp, label %expand.body, label %ark0.entry

expand.body:                                          ; preds = %expand.loop
  ; load previous word bytes
  %i.m4 = add nsw i32 %i.exp, -4
  %i.m3 = add nsw i32 %i.exp, -3
  %i.m2 = add nsw i32 %i.exp, -2
  %i.m1 = add nsw i32 %i.exp, -1
  %i.m4.z = zext i32 %i.m4 to i64
  %i.m3.z = zext i32 %i.m3 to i64
  %i.m2.z = zext i32 %i.m2 to i64
  %i.m1.z = zext i32 %i.m1 to i64
  %p.m4 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m4.z
  %p.m3 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m3.z
  %p.m2 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m2.z
  %p.m1 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m1.z
  %t0.in = load i8, i8* %p.m4, align 1
  %t1.in = load i8, i8* %p.m3, align 1
  %t2.in = load i8, i8* %p.m2, align 1
  %t3.in = load i8, i8* %p.m1, align 1
  %i.and = and i32 %i.exp, 15
  %is.subword = icmp eq i32 %i.and, 0
  br i1 %is.subword, label %subword, label %nosubword

subword:                                              ; preds = %expand.body
  ; RotWord
  %t0.r = %t1.in
  %t1.r = %t2.in
  %t2.r = %t3.in
  %t3.r = %t0.in
  ; SubWord via sbox
  %t0.r.z = zext i8 %t0.r to i64
  %t1.r.z = zext i8 %t1.r to i64
  %t2.r.z = zext i8 %t2.r to i64
  %t3.r.z = zext i8 %t3.r to i64
  %sbox.t0.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t0.r.z
  %sbox.t1.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t1.r.z
  %sbox.t2.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t2.r.z
  %sbox.t3.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %t3.r.z
  %t0.s = load i8, i8* %sbox.t0.ptr, align 1
  %t1.s = load i8, i8* %sbox.t1.ptr, align 1
  %t2.s = load i8, i8* %sbox.t2.ptr, align 1
  %t3.s = load i8, i8* %sbox.t3.ptr, align 1
  ; Rcon
  %rc.z = zext i32 %rc to i64
  %rcon.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 %rc.z
  %rcon.val = load i8, i8* %rcon.ptr, align 1
  %t0.rc = xor i8 %t0.s, %rcon.val
  %rc.next = add nsw i32 %rc, 1
  br label %after.sub

nosubword:                                            ; preds = %expand.body
  %t0.ns = %t0.in
  %t1.ns = %t1.in
  %t2.ns = %t2.in
  %t3.ns = %t3.in
  %rc.pass = %rc
  br label %after.sub

after.sub:                                            ; preds = %nosubword, %subword
  %t0 = phi i8 [ %t0.rc, %subword ], [ %t0.ns, %nosubword ]
  %t1 = phi i8 [ %t1.s, %subword ], [ %t1.ns, %nosubword ]
  %t2 = phi i8 [ %t2.s, %subword ], [ %t2.ns, %nosubword ]
  %t3 = phi i8 [ %t3.s, %subword ], [ %t3.ns, %nosubword ]
  %rc.cur = phi i32 [ %rc.next, %subword ], [ %rc.pass, %nosubword ]

  ; rk[i..i+3] = rk[i-16..i-13] ^ {t0..t3}
  %i.m16 = add nsw i32 %i.exp, -16
  %i.m15 = add nsw i32 %i.exp, -15
  %i.m14 = add nsw i32 %i.exp, -14
  %i.m13 = add nsw i32 %i.exp, -13
  %i.m16.z = zext i32 %i.m16 to i64
  %i.m15.z = zext i32 %i.m15 to i64
  %i.m14.z = zext i32 %i.m14 to i64
  %i.m13.z = zext i32 %i.m13 to i64
  %p.m16 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m16.z
  %p.m15 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m15.z
  %p.m14 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m14.z
  %p.m13 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m13.z
  %b.m16 = load i8, i8* %p.m16, align 1
  %b.m15 = load i8, i8* %p.m15, align 1
  %b.m14 = load i8, i8* %p.m14, align 1
  %b.m13 = load i8, i8* %p.m13, align 1

  %i.exp.z = zext i32 %i.exp to i64
  %p.i   = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.exp.z
  %i.p1 = add nsw i32 %i.exp, 1
  %i.p2 = add nsw i32 %i.exp, 2
  %i.p3 = add nsw i32 %i.exp, 3
  %i.p1.z = zext i32 %i.p1 to i64
  %i.p2.z = zext i32 %i.p2 to i64
  %i.p3.z = zext i32 %i.p3 to i64
  %p.i1 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.p1.z
  %p.i2 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.p2.z
  %p.i3 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.p3.z

  %v0 = xor i8 %b.m16, %t0
  %v1 = xor i8 %b.m15, %t1
  %v2 = xor i8 %b.m14, %t2
  %v3 = xor i8 %b.m13, %t3
  store i8 %v0, i8* %p.i, align 1
  store i8 %v1, i8* %p.i1, align 1
  store i8 %v2, i8* %p.i2, align 1
  store i8 %v3, i8* %p.i3, align 1

  br label %expand.next

expand.next:                                          ; preds = %after.sub
  %i.exp.next = add nsw i32 %i.exp, 4
  br label %expand.loop

ark0.entry:                                           ; preds = %expand.loop
  ; initial AddRoundKey: state ^= rk[0..15]
  br label %ark0.loop

ark0.loop:                                            ; preds = %ark0.loop, %ark0.entry
  %i.ark0 = phi i32 [ 0, %ark0.entry ], [ %i.ark0.next, %ark0.loop ]
  %i.ark0.c = icmp sle i32 %i.ark0, 15
  br i1 %i.ark0.c, label %ark0.body, label %rounds.entry

ark0.body:                                            ; preds = %ark0.loop
  %i.ark0.z = zext i32 %i.ark0 to i64
  %st.p0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.ark0.z
  %st.b0 = load i8, i8* %st.p0, align 1
  %rk.p0 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.ark0.z
  %rk.b0 = load i8, i8* %rk.p0, align 1
  %x0 = xor i8 %st.b0, %rk.b0
  store i8 %x0, i8* %st.p0, align 1
  %i.ark0.next = add nsw i32 %i.ark0, 1
  br label %ark0.loop

rounds.entry:                                         ; preds = %ark0.loop
  %round.init = add nsw i32 1, 0
  br label %round.loop

round.loop:                                           ; preds = %ark.add.next, %rounds.entry
  %round = phi i32 [ %round.init, %rounds.entry ], [ %round.next, %ark.add.next ]
  %round.cmp = icmp sle i32 %round, 9
  br i1 %round.cmp, label %round.body, label %final.entry

round.body:                                           ; preds = %round.loop
  ; SubBytes
  br label %sub.loop

sub.loop:                                             ; preds = %sub.next, %round.body
  %i.sub = phi i32 [ 0, %round.body ], [ %i.sub.next, %sub.next ]
  %i.sub.c = icmp sle i32 %i.sub, 15
  br i1 %i.sub.c, label %sub.body, label %shift.entry

sub.body:                                             ; preds = %sub.loop
  %i.sub.z = zext i32 %i.sub to i64
  %st.ps = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.sub.z
  %sb.in = load i8, i8* %st.ps, align 1
  %sb.idx = zext i8 %sb.in to i64
  %sb.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %sb.idx
  %sb.val = load i8, i8* %sb.ptr, align 1
  store i8 %sb.val, i8* %st.ps, align 1
  %i.sub.next = add nsw i32 %i.sub, 1
  br label %sub.loop

shift.entry:                                          ; preds = %sub.loop
  ; ShiftRows
  ; Row 3: rotate right by 1 (3,7,11,15)
  %p3  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %p7  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %p11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %p15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %v15 = load i8, i8* %p15, align 1
  %v11 = load i8, i8* %p11, align 1
  %v7 = load i8, i8* %p7, align 1
  %v3 = load i8, i8* %p3, align 1
  store i8 %v11, i8* %p15, align 1
  store i8 %v7,  i8* %p11, align 1
  store i8 %v3,  i8* %p7,  align 1
  store i8 %v15, i8* %p3,  align 1
  ; Row 2: swap (2 <-> 10), (6 <-> 14)
  %p2  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %p6  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %p10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %p14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %v14 = load i8, i8* %p14, align 1
  %v6  = load i8, i8* %p6,  align 1
  store i8 %v6,  i8* %p14, align 1
  store i8 %v14, i8* %p6,  align 1
  %v10 = load i8, i8* %p10, align 1
  %v2  = load i8, i8* %p2,  align 1
  store i8 %v2,  i8* %p10, align 1
  store i8 %v10, i8* %p2,  align 1
  ; Row 1: rotate left by 1 (1,5,9,13)
  %p1  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %p5  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %p9  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %p13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %v13 = load i8, i8* %p13, align 1
  %v1  = load i8, i8* %p1,  align 1
  store i8 %v1,  i8* %p13, align 1
  %v5  = load i8, i8* %p5,  align 1
  store i8 %v5,  i8* %p1,  align 1
  %v9  = load i8, i8* %p9,  align 1
  store i8 %v9,  i8* %p5,  align 1
  store i8 %v13, i8* %p9,  align 1

  ; MixColumns
  br label %mc.loop

mc.loop:                                              ; preds = %mc.next, %shift.entry
  %col = phi i32 [ 0, %shift.entry ], [ %col.next, %mc.next ]
  %col.c = icmp sle i32 %col, 3
  br i1 %col.c, label %mc.body, label %ark.entry

mc.body:                                              ; preds = %mc.loop
  %b = shl i32 %col, 2
  %b0.z = zext i32 %b to i64
  %b1.i = add nsw i32 %b, 1
  %b2.i = add nsw i32 %b, 2
  %b3.i = add nsw i32 %b, 3
  %b1.z = zext i32 %b1.i to i64
  %b2.z = zext i32 %b2.i to i64
  %b3.z = zext i32 %b3.i to i64
  %sp0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b0.z
  %sp1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b1.z
  %sp2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b2.z
  %sp3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b3.z
  %a0 = load i8, i8* %sp0, align 1
  %a1 = load i8, i8* %sp1, align 1
  %a2 = load i8, i8* %sp2, align 1
  %a3 = load i8, i8* %sp3, align 1
  %t.x = xor i8 %a0, %a1
  %t.y = xor i8 %a2, %a3
  %t = xor i8 %t.x, %t.y

  ; new0 = a0 ^ xtime(a0 ^ a1) ^ t
  %x01 = xor i8 %a0, %a1
  %n0 = call i8 @aes128_encrypt.xtime(i8 %x01)
  %n0t = xor i8 %n0, %t
  %new0 = xor i8 %a0, %n0t
  store i8 %new0, i8* %sp0, align 1

  ; new1 = a1 ^ xtime(a1 ^ a2) ^ t
  %x12 = xor i8 %a1, %a2
  %n1 = call i8 @aes128_encrypt.xtime(i8 %x12)
  %n1t = xor i8 %n1, %t
  %new1 = xor i8 %a1, %n1t
  store i8 %new1, i8* %sp1, align 1

  ; new2 = a2 ^ xtime(a2 ^ a3) ^ t
  %x23 = xor i8 %a2, %a3
  %n2 = call i8 @aes128_encrypt.xtime(i8 %x23)
  %n2t = xor i8 %n2, %t
  %new2 = xor i8 %a2, %n2t
  store i8 %new2, i8* %sp2, align 1

  ; new3 = a3 ^ xtime(a3 ^ a0) ^ t
  %x30 = xor i8 %a3, %a0
  %n3 = call i8 @aes128_encrypt.xtime(i8 %x30)
  %n3t = xor i8 %n3, %t
  %new3 = xor i8 %a3, %n3t
  store i8 %new3, i8* %sp3, align 1

  br label %mc.next

mc.next:                                              ; preds = %mc.body
  %col.next = add nsw i32 %col, 1
  br label %mc.loop

ark.entry:                                            ; preds = %mc.loop
  ; AddRoundKey for this round
  %rk.off = mul nsw i32 %round, 16
  br label %ark.loop

ark.loop:                                             ; preds = %ark.next, %ark.entry
  %i.ark = phi i32 [ 0, %ark.entry ], [ %i.ark.next, %ark.next ]
  %i.ark.c = icmp sle i32 %i.ark, 15
  br i1 %i.ark.c, label %ark.body, label %ark.add.next

ark.body:                                             ; preds = %ark.loop
  %i.ark.z = zext i32 %i.ark to i64
  %sp.ark = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.ark.z
  %sv = load i8, i8* %sp.ark, align 1
  %rk.idx = add nsw i32 %rk.off, %i.ark
  %rk.idx.z = zext i32 %rk.idx to i64
  %rk.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %rk.idx.z
  %rk.b = load i8, i8* %rk.p, align 1
  %sx = xor i8 %sv, %rk.b
  store i8 %sx, i8* %sp.ark, align 1
  %i.ark.next = add nsw i32 %i.ark, 1
  br label %ark.next

ark.next:                                             ; preds = %ark.body
  br label %ark.loop

ark.add.next:                                         ; preds = %ark.loop
  %round.next = add nsw i32 %round, 1
  br label %round.loop

final.entry:                                          ; preds = %round.loop
  ; Final SubBytes
  br label %fsub.loop

fsub.loop:                                            ; preds = %fsub.next, %final.entry
  %i.fsub = phi i32 [ 0, %final.entry ], [ %i.fsub.next, %fsub.next ]
  %i.fsub.c = icmp sle i32 %i.fsub, 15
  br i1 %i.fsub.c, label %fsub.body, label %fshift.entry

fsub.body:                                            ; preds = %fsub.loop
  %i.fsub.z = zext i32 %i.fsub to i64
  %st.pf = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.fsub.z
  %fb.in = load i8, i8* %st.pf, align 1
  %fb.idx = zext i8 %fb.in to i64
  %fb.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %fb.idx
  %fb.val = load i8, i8* %fb.ptr, align 1
  store i8 %fb.val, i8* %st.pf, align 1
  %i.fsub.next = add nsw i32 %i.fsub, 1
  br label %fsub.loop

fshift.entry:                                         ; preds = %fsub.loop
  ; Final ShiftRows (same as above)
  ; Row 3: rotate right by 1 (3,7,11,15)
  %fp3  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %fp7  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %fp11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %fp15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %fv15 = load i8, i8* %fp15, align 1
  %fv11 = load i8, i8* %fp11, align 1
  %fv7 = load i8, i8* %fp7, align 1
  %fv3 = load i8, i8* %fp3, align 1
  store i8 %fv11, i8* %fp15, align 1
  store i8 %fv7,  i8* %fp11, align 1
  store i8 %fv3,  i8* %fp7,  align 1
  store i8 %fv15, i8* %fp3,  align 1
  ; Row 2: swap (2 <-> 10), (6 <-> 14)
  %fp2  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %fp6  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %fp10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %fp14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %fv14 = load i8, i8* %fp14, align 1
  %fv6  = load i8, i8* %fp6,  align 1
  store i8 %fv6,  i8* %fp14, align 1
  store i8 %fv14, i8* %fp6,  align 1
  %fv10 = load i8, i8* %fp10, align 1
  %fv2  = load i8, i8* %fp2,  align 1
  store i8 %fv2,  i8* %fp10, align 1
  store i8 %fv10, i8* %fp2,  align 1
  ; Row 1: rotate left by 1 (1,5,9,13)
  %fp1  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %fp5  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %fp9  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %fp13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %fv13b = load i8, i8* %fp13, align 1
  %fv1  = load i8, i8* %fp1,  align 1
  store i8 %fv1,  i8* %fp13, align 1
  %fv5  = load i8, i8* %fp5,  align 1
  store i8 %fv5,  i8* %fp1,  align 1
  %fv9  = load i8, i8* %fp9,  align 1
  store i8 %fv9,  i8* %fp5,  align 1
  store i8 %fv13b, i8* %fp9,  align 1

  ; Final AddRoundKey with offset 160
  br label %fark.loop

fark.loop:                                            ; preds = %fark.next, %fshift.entry
  %i.fark = phi i32 [ 0, %fshift.entry ], [ %i.fark.next, %fark.next ]
  %i.fark.c = icmp sle i32 %i.fark, 15
  br i1 %i.fark.c, label %fark.body, label %store.entry

fark.body:                                            ; preds = %fark.loop
  %i.fark.z = zext i32 %i.fark to i64
  %sp.f = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.fark.z
  %svf = load i8, i8* %sp.f, align 1
  %rk.idxf = add nsw i32 160, %i.fark
  %rk.idxf.z = zext i32 %rk.idxf to i64
  %rk.pf = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %rk.idxf.z
  %rk.bf = load i8, i8* %rk.pf, align 1
  %sxf = xor i8 %svf, %rk.bf
  store i8 %sxf, i8* %sp.f, align 1
  %i.fark.next = add nsw i32 %i.fark, 1
  br label %fark.next

fark.next:                                            ; preds = %fark.body
  br label %fark.loop

store.entry:                                          ; preds = %fark.loop
  ; write out
  br label %store.loop

store.loop:                                           ; preds = %store.next, %store.entry
  %i.st = phi i32 [ 0, %store.entry ], [ %i.st.next, %store.next ]
  %i.st.c = icmp sle i32 %i.st, 15
  br i1 %i.st.c, label %store.body, label %ret

store.body:                                           ; preds = %store.loop
  %i.st.z = zext i32 %i.st to i64
  %sp.out = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.st.z
  %bv = load i8, i8* %sp.out, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %i.st.z
  store i8 %bv, i8* %out.ptr, align 1
  %i.st.next = add nsw i32 %i.st, 1
  br label %store.next

store.next:                                           ; preds = %store.body
  br label %store.loop

ret:                                                  ; preds = %store.loop
  ret void
}

; xtime helper: ((x<<1) ^ (0x1B if x&0x80 else 0)) & 0xFF
define internal i8 @aes128_encrypt.xtime(i8 %x) local_unnamed_addr {
entry:
  %xi = zext i8 %x to i32
  %x2 = shl i32 %xi, 1
  %x2m = and i32 %x2, 255
  %msb = and i32 %xi, 128
  %msb.nz = icmp ne i32 %msb, 0
  %x2c = xor i32 %x2m, 27
  %res = select i1 %msb.nz, i32 %x2c, i32 %x2m
  %tr = trunc i32 %res to i8
  ret i8 %tr
}