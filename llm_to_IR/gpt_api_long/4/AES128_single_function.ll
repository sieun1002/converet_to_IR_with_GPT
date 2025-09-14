; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt  ; Address: 0x11A9
; Intent: AES-128 block encryption (ECB) with on-the-fly key expansion (confidence=0.95). Evidence: S-box and Rcon tables; 10 rounds with MixColumns and ShiftRows
; Preconditions: out, in, key each point to at least 16 bytes; @sbox_1 is a 256-byte S-box; @rcon_0 provides Rcon sequence (>=10 entries)
; Postconditions: Writes 16-byte ciphertext to out

@sbox_1 = external constant [256 x i8]
@rcon_0 = external constant [256 x i8]

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %ks = alloca [176 x i8], align 16
  ; state <- in
  br label %copy_in.loop

copy_in.loop:                                      ; preds = %copy_in.loop, %entry
  %i.ci = phi i32 [ 0, %entry ], [ %i.ci.next, %copy_in.loop ]
  %i.ci.cmp = icmp sle i32 %i.ci, 15
  br i1 %i.ci.cmp, label %copy_in.body, label %copy_key.pre

copy_in.body:                                      ; preds = %copy_in.loop
  %i.ci.z = zext i32 %i.ci to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %i.ci.z
  %in.b = load i8, i8* %in.ptr, align 1
  %st.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.ci.z
  store i8 %in.b, i8* %st.ptr, align 1
  %i.ci.next = add nsw i32 %i.ci, 1
  br label %copy_in.loop

copy_key.pre:                                      ; preds = %copy_in.loop
  br label %copy_key.loop

copy_key.loop:                                     ; preds = %copy_key.loop, %copy_key.pre
  %i.ck = phi i32 [ 0, %copy_key.pre ], [ %i.ck.next, %copy_key.loop ]
  %i.ck.cmp = icmp sle i32 %i.ck, 15
  br i1 %i.ck.cmp, label %copy_key.body, label %kexp.init

copy_key.body:                                     ; preds = %copy_key.loop
  %i.ck.z = zext i32 %i.ck to i64
  %key.ptr = getelementptr inbounds i8, i8* %key, i64 %i.ck.z
  %key.b = load i8, i8* %key.ptr, align 1
  %ks.ptr0 = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %i.ck.z
  store i8 %key.b, i8* %ks.ptr0, align 1
  %i.ck.next = add nsw i32 %i.ck, 1
  br label %copy_key.loop

kexp.init:                                         ; preds = %copy_key.loop
  %i.ke.start = add i32 16, 0
  br label %kexp.loop

kexp.loop:                                         ; preds = %kexp.next, %kexp.init
  %i.ke = phi i32 [ %i.ke.start, %kexp.init ], [ %i.ke.next, %kexp.next ]
  %rcon.idx = phi i32 [ 0, %kexp.init ], [ %rcon.idx.next, %kexp.next ]
  %i.ke.cmp = icmp sle i32 %i.ke, 175
  br i1 %i.ke.cmp, label %kexp.body, label %ark0.init

kexp.body:                                         ; preds = %kexp.loop
  ; load t0..t3 = ks[i-4..i-1]
  %im4 = sub nsw i32 %i.ke, 4
  %im3 = sub nsw i32 %i.ke, 3
  %im2 = sub nsw i32 %i.ke, 2
  %im1 = sub nsw i32 %i.ke, 1
  %im4.z = zext i32 %im4 to i64
  %im3.z = zext i32 %im3 to i64
  %im2.z = zext i32 %im2 to i64
  %im1.z = zext i32 %im1 to i64
  %t0.p = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im4.z
  %t1.p = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im3.z
  %t2.p = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im2.z
  %t3.p = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im1.z
  %t0 = load i8, i8* %t0.p, align 1
  %t1 = load i8, i8* %t1.p, align 1
  %t2 = load i8, i8* %t2.p, align 1
  %t3 = load i8, i8* %t3.p, align 1
  ; condition i % 16 == 0
  %i.and = and i32 %i.ke, 15
  %is.rot = icmp eq i32 %i.and, 0
  br i1 %is.rot, label %kexp.subrot, label %kexp.norot

kexp.subrot:                                       ; preds = %kexp.body
  ; rotate left (t0,t1,t2,t3) = (t1,t2,t3,t0)
  %rt0 = %t1
  %rt1 = %t2
  %rt2 = %t3
  %rt3 = %t0
  ; SubWord via sbox
  %rt0.z = zext i8 %rt0 to i64
  %rt0.s.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt0.z
  %rt0.s = load i8, i8* %rt0.s.p, align 1
  %rt1.z = zext i8 %rt1 to i64
  %rt1.s.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt1.z
  %rt1.s = load i8, i8* %rt1.s.p, align 1
  %rt2.z = zext i8 %rt2 to i64
  %rt2.s.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt2.z
  %rt2.s = load i8, i8* %rt2.s.p, align 1
  %rt3.z = zext i8 %rt3 to i64
  %rt3.s.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt3.z
  %rt3.s = load i8, i8* %rt3.s.p, align 1
  ; rcon
  %rcon.idx.next = add i32 %rcon.idx, 1
  %rcon.idx.z = zext i32 %rcon.idx.next to i64
  %rcon.p = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 %rcon.idx.z
  %rcon.b = load i8, i8* %rcon.p, align 1
  %t0r = xor i8 %rt0.s, %rcon.b
  br label %kexp.merge

kexp.norot:                                        ; preds = %kexp.body
  br label %kexp.merge

kexp.merge:                                        ; preds = %kexp.norot, %kexp.subrot
  %rcon.idx.phi = phi i32 [ %rcon.idx.next, %kexp.subrot ], [ %rcon.idx, %kexp.norot ]
  %t0.m = phi i8 [ %t0r, %kexp.subrot ], [ %t0, %kexp.norot ]
  %t1.m = phi i8 [ %rt1.s, %kexp.subrot ], [ %t1, %kexp.norot ]
  %t2.m = phi i8 [ %rt2.s, %kexp.subrot ], [ %t2, %kexp.norot ]
  %t3.m = phi i8 [ %rt3.s, %kexp.subrot ], [ %t3, %kexp.norot ]
  ; new 4 bytes: ks[i+j] = ks[i-16+j] ^ t{j}
  %im16 = sub nsw i32 %i.ke, 16
  %im16.z = zext i32 %im16 to i64
  %i.z = zext i32 %i.ke to i64
  ; byte 0
  %p.prev0 = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im16.z
  %prev0 = load i8, i8* %p.prev0, align 1
  %new0 = xor i8 %prev0, %t0.m
  %p.dst0 = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %i.z
  store i8 %new0, i8* %p.dst0, align 1
  ; byte 1
  %i1 = add nsw i32 %i.ke, 1
  %im161 = add nsw i32 %im16, 1
  %i1.z = zext i32 %i1 to i64
  %im161.z = zext i32 %im161 to i64
  %p.prev1 = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im161.z
  %prev1 = load i8, i8* %p.prev1, align 1
  %new1 = xor i8 %prev1, %t1.m
  %p.dst1 = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %i1.z
  store i8 %new1, i8* %p.dst1, align 1
  ; byte 2
  %i2 = add nsw i32 %i.ke, 2
  %im162 = add nsw i32 %im16, 2
  %i2.z = zext i32 %i2 to i64
  %im162.z = zext i32 %im162 to i64
  %p.prev2 = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im162.z
  %prev2 = load i8, i8* %p.prev2, align 1
  %new2 = xor i8 %prev2, %t2.m
  %p.dst2 = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %i2.z
  store i8 %new2, i8* %p.dst2, align 1
  ; byte 3
  %i3 = add nsw i32 %i.ke, 3
  %im163 = add nsw i32 %im16, 3
  %i3.z = zext i32 %i3 to i64
  %im163.z = zext i32 %im163 to i64
  %p.prev3 = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %im163.z
  %prev3 = load i8, i8* %p.prev3, align 1
  %new3 = xor i8 %prev3, %t3.m
  %p.dst3 = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %i3.z
  store i8 %new3, i8* %p.dst3, align 1
  br label %kexp.next

kexp.next:                                         ; preds = %kexp.merge
  %i.ke.next = add nsw i32 %i.ke, 4
  br label %kexp.loop, !llvm.loop !0

ark0.init:                                         ; preds = %kexp.loop
  br label %ark0.loop

ark0.loop:                                         ; preds = %ark0.loop, %ark0.init
  %i.ark0 = phi i32 [ 0, %ark0.init ], [ %i.ark0.next, %ark0.loop ]
  %i.ark0.cmp = icmp sle i32 %i.ark0, 15
  br i1 %i.ark0.cmp, label %ark0.body, label %rounds.init

ark0.body:                                         ; preds = %ark0.loop
  %i.ark0.z = zext i32 %i.ark0 to i64
  %st.p0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.ark0.z
  %st.b0 = load i8, i8* %st.p0, align 1
  %ks.p0 = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %i.ark0.z
  %ks.b0 = load i8, i8* %ks.p0, align 1
  %x0 = xor i8 %st.b0, %ks.b0
  store i8 %x0, i8* %st.p0, align 1
  %i.ark0.next = add nsw i32 %i.ark0, 1
  br label %ark0.loop

rounds.init:                                       ; preds = %ark0.loop
  br label %rounds.loop

rounds.loop:                                       ; preds = %ark.addkey, %rounds.init
  %round = phi i32 [ 1, %rounds.init ], [ %round.next, %ark.addkey ]
  %round.cmp = icmp sle i32 %round, 9
  br i1 %round.cmp, label %subbytes, label %final.init

subbytes:                                          ; preds = %rounds.loop
  br label %sb.loop

sb.loop:                                           ; preds = %sb.loop, %subbytes
  %i.sb = phi i32 [ 0, %subbytes ], [ %i.sb.next, %sb.loop ]
  %i.sb.cmp = icmp sle i32 %i.sb, 15
  br i1 %i.sb.cmp, label %sb.body, label %shiftrows

sb.body:                                           ; preds = %sb.loop
  %i.sb.z = zext i32 %i.sb to i64
  %p.s = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.sb.z
  %v.s = load i8, i8* %p.s, align 1
  %v.s.z = zext i8 %v.s to i64
  %p.sbx = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %v.s.z
  %v.sbx = load i8, i8* %p.sbx, align 1
  store i8 %v.sbx, i8* %p.s, align 1
  %i.sb.next = add nsw i32 %i.sb, 1
  br label %sb.loop

shiftrows:                                         ; preds = %sb.loop
  ; Row 1 rotate left by 1: indices 1,5,9,13
  %p1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %p5 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %p9 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %p13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %v1 = load i8, i8* %p1, align 1
  %v5 = load i8, i8* %p5, align 1
  %v9 = load i8, i8* %p9, align 1
  %v13 = load i8, i8* %p13, align 1
  store i8 %v5, i8* %p1, align 1
  store i8 %v9, i8* %p5, align 1
  store i8 %v13, i8* %p9, align 1
  store i8 %v1, i8* %p13, align 1
  ; Row 2 rotate left by 2: indices 2,6,10,14 (swap 2<->10, 6<->14)
  %p2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %p6 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %p10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %p14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %v2 = load i8, i8* %p2, align 1
  %v6 = load i8, i8* %p6, align 1
  %v10 = load i8, i8* %p10, align 1
  %v14 = load i8, i8* %p14, align 1
  store i8 %v10, i8* %p2, align 1
  store i8 %v14, i8* %p6, align 1
  store i8 %v2, i8* %p10, align 1
  store i8 %v6, i8* %p14, align 1
  ; Row 3 rotate left by 3: indices 3,7,11,15
  %p3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %p7 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %p11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %p15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %v3 = load i8, i8* %p3, align 1
  %v7 = load i8, i8* %p7, align 1
  %v11 = load i8, i8* %p11, align 1
  %v15 = load i8, i8* %p15, align 1
  store i8 %v15, i8* %p3, align 1
  store i8 %v3, i8* %p7, align 1
  store i8 %v7, i8* %p11, align 1
  store i8 %v11, i8* %p15, align 1
  br label %mixcols.init

mixcols.init:                                      ; preds = %shiftrows
  br label %mc.loop

mc.loop:                                           ; preds = %mc.loop, %mixcols.init
  %c = phi i32 [ 0, %mixcols.init ], [ %c.next, %mc.loop ]
  %c.cmp = icmp sle i32 %c, 3
  br i1 %c.cmp, label %mc.body, label %ark.init

mc.body:                                           ; preds = %mc.loop
  %c4 = shl i32 %c, 2
  %idx0 = add nsw i32 %c4, 0
  %idx1 = add nsw i32 %c4, 1
  %idx2 = add nsw i32 %c4, 2
  %idx3 = add nsw i32 %c4, 3
  %idx0.z = zext i32 %idx0 to i64
  %idx1.z = zext i32 %idx1 to i64
  %idx2.z = zext i32 %idx2 to i64
  %idx3.z = zext i32 %idx3 to i64
  %p0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %idx0.z
  %p1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %idx1.z
  %p2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %idx2.z
  %p3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %idx3.z
  %x0 = load i8, i8* %p0, align 1
  %x1 = load i8, i8* %p1, align 1
  %x2 = load i8, i8* %p2, align 1
  %x3 = load i8, i8* %p3, align 1
  %t01 = xor i8 %x0, %x1
  %t23 = xor i8 %x2, %x3
  %t = xor i8 %t01, %t23
  ; y0 = x0 ^ xtime(x0^x1) ^ t
  %ab01 = xor i8 %x0, %x1
  %ab01.z = zext i8 %ab01 to i32
  %ab01.shl = shl i32 %ab01.z, 1
  %ab01.shl.m = and i32 %ab01.shl, 255
  %ab01.hi = lshr i32 %ab01.z, 7
  %ab01.hi.mul = mul i32 %ab01.hi, 27
  %ab01.xt = xor i32 %ab01.shl.m, %ab01.hi.mul
  %ab01.xt.tr = trunc i32 %ab01.xt to i8
  %y0.t = xor i8 %x0, %ab01.xt.tr
  %y0 = xor i8 %y0.t, %t
  store i8 %y0, i8* %p0, align 1
  ; y1 = x1 ^ xtime(x1^x2) ^ t
  %ab12 = xor i8 %x1, %x2
  %ab12.z = zext i8 %ab12 to i32
  %ab12.shl = shl i32 %ab12.z, 1
  %ab12.shl.m = and i32 %ab12.shl, 255
  %ab12.hi = lshr i32 %ab12.z, 7
  %ab12.hi.mul = mul i32 %ab12.hi, 27
  %ab12.xt = xor i32 %ab12.shl.m, %ab12.hi.mul
  %ab12.xt.tr = trunc i32 %ab12.xt to i8
  %y1.t = xor i8 %x1, %ab12.xt.tr
  %y1 = xor i8 %y1.t, %t
  store i8 %y1, i8* %p1, align 1
  ; y2 = x2 ^ xtime(x2^x3) ^ t
  %ab23 = xor i8 %x2, %x3
  %ab23.z = zext i8 %ab23 to i32
  %ab23.shl = shl i32 %ab23.z, 1
  %ab23.shl.m = and i32 %ab23.shl, 255
  %ab23.hi = lshr i32 %ab23.z, 7
  %ab23.hi.mul = mul i32 %ab23.hi, 27
  %ab23.xt = xor i32 %ab23.shl.m, %ab23.hi.mul
  %ab23.xt.tr = trunc i32 %ab23.xt to i8
  %y2.t = xor i8 %x2, %ab23.xt.tr
  %y2 = xor i8 %y2.t, %t
  store i8 %y2, i8* %p2, align 1
  ; y3 = x3 ^ xtime(x3^x0) ^ t
  %ab30 = xor i8 %x3, %x0
  %ab30.z = zext i8 %ab30 to i32
  %ab30.shl = shl i32 %ab30.z, 1
  %ab30.shl.m = and i32 %ab30.shl, 255
  %ab30.hi = lshr i32 %ab30.z, 7
  %ab30.hi.mul = mul i32 %ab30.hi, 27
  %ab30.xt = xor i32 %ab30.shl.m, %ab30.hi.mul
  %ab30.xt.tr = trunc i32 %ab30.xt to i8
  %y3.t = xor i8 %x3, %ab30.xt.tr
  %y3 = xor i8 %y3.t, %t
  store i8 %y3, i8* %p3, align 1
  %c.next = add nsw i32 %c, 1
  br label %mc.loop

ark.init:                                          ; preds = %mc.loop
  br label %ark.loop

ark.loop:                                          ; preds = %ark.loop, %ark.init
  %i.ark = phi i32 [ 0, %ark.init ], [ %i.ark.next, %ark.loop ]
  %i.ark.cmp = icmp sle i32 %i.ark, 15
  br i1 %i.ark.cmp, label %ark.body, label %ark.addkey

ark.body:                                          ; preds = %ark.loop
  %i.ark.z = zext i32 %i.ark to i64
  %st.pa = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.ark.z
  %st.ba = load i8, i8* %st.pa, align 1
  %off.base = shl i32 %round, 4
  %off.i = add nsw i32 %off.base, %i.ark
  %off.i.z = zext i32 %off.i to i64
  %ks.pa = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %off.i.z
  %ks.ba = load i8, i8* %ks.pa, align 1
  %xrk = xor i8 %st.ba, %ks.ba
  store i8 %xrk, i8* %st.pa, align 1
  %i.ark.next = add nsw i32 %i.ark, 1
  br label %ark.loop

ark.addkey:                                        ; preds = %ark.loop
  %round.next = add nsw i32 %round, 1
  br label %rounds.loop, !llvm.loop !1

final.init:                                        ; preds = %rounds.loop
  ; Final round: SubBytes, ShiftRows, AddRoundKey with round=10
  br label %fsb.loop

fsb.loop:                                          ; preds = %fsb.loop, %final.init
  %i.fsb = phi i32 [ 0, %final.init ], [ %i.fsb.next, %fsb.loop ]
  %i.fsb.cmp = icmp sle i32 %i.fsb, 15
  br i1 %i.fsb.cmp, label %fsb.body, label %fshift

fsb.body:                                          ; preds = %fsb.loop
  %i.fsb.z = zext i32 %i.fsb to i64
  %p.fs = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.fsb.z
  %v.fs = load i8, i8* %p.fs, align 1
  %v.fs.z = zext i8 %v.fs to i64
  %p.fsbx = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %v.fs.z
  %v.fsbx = load i8, i8* %p.fsbx, align 1
  store i8 %v.fsbx, i8* %p.fs, align 1
  %i.fsb.next = add nsw i32 %i.fsb, 1
  br label %fsb.loop

fshift:                                            ; preds = %fsb.loop
  ; Row 1
  %fp1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %fp5 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %fp9 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %fp13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %fv1 = load i8, i8* %fp1, align 1
  %fv5 = load i8, i8* %fp5, align 1
  %fv9 = load i8, i8* %fp9, align 1
  %fv13 = load i8, i8* %fp13, align 1
  store i8 %fv5, i8* %fp1, align 1
  store i8 %fv9, i8* %fp5, align 1
  store i8 %fv13, i8* %fp9, align 1
  store i8 %fv1, i8* %fp13, align 1
  ; Row 2
  %fp2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %fp6 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %fp10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %fp14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %fv2 = load i8, i8* %fp2, align 1
  %fv6 = load i8, i8* %fp6, align 1
  %fv10 = load i8, i8* %fp10, align 1
  %fv14 = load i8, i8* %fp14, align 1
  store i8 %fv10, i8* %fp2, align 1
  store i8 %fv14, i8* %fp6, align 1
  store i8 %fv2, i8* %fp10, align 1
  store i8 %fv6, i8* %fp14, align 1
  ; Row 3
  %fp3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %fp7 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %fp11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %fp15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %fv3 = load i8, i8* %fp3, align 1
  %fv7 = load i8, i8* %fp7, align 1
  %fv11 = load i8, i8* %fp11, align 1
  %fv15 = load i8, i8* %fp15, align 1
  store i8 %fv15, i8* %fp3, align 1
  store i8 %fv3, i8* %fp7, align 1
  store i8 %fv7, i8* %fp11, align 1
  store i8 %fv11, i8* %fp15, align 1
  br label %fark.init

fark.init:                                         ; preds = %fshift
  br label %fark.loop

fark.loop:                                         ; preds = %fark.loop, %fark.init
  %i.fark = phi i32 [ 0, %fark.init ], [ %i.fark.next, %fark.loop ]
  %i.fark.cmp = icmp sle i32 %i.fark, 15
  br i1 %i.fark.cmp, label %fark.body, label %store.out

fark.body:                                         ; preds = %fark.loop
  %i.fark.z = zext i32 %i.fark to i64
  %p.fa = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.fark.z
  %v.fa = load i8, i8* %p.fa, align 1
  %offA = add nsw i32 %i.fark, 160
  %offA.z = zext i32 %offA to i64
  %p.ka = getelementptr inbounds [176 x i8], [176 x i8]* %ks, i64 0, i64 %offA.z
  %v.ka = load i8, i8* %p.ka, align 1
  %v.xa = xor i8 %v.fa, %v.ka
  store i8 %v.xa, i8* %p.fa, align 1
  %i.fark.next = add nsw i32 %i.fark, 1
  br label %fark.loop

store.out:                                         ; preds = %fark.loop
  br label %copy_out.loop

copy_out.loop:                                     ; preds = %copy_out.loop, %store.out
  %i.co = phi i32 [ 0, %store.out ], [ %i.co.next, %copy_out.loop ]
  %i.co.cmp = icmp sle i32 %i.co, 15
  br i1 %i.co.cmp, label %copy_out.body, label %ret

copy_out.body:                                     ; preds = %copy_out.loop
  %i.co.z = zext i32 %i.co to i64
  %st.po = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.co.z
  %b.o = load i8, i8* %st.po, align 1
  %out.p = getelementptr inbounds i8, i8* %out, i64 %i.co.z
  store i8 %b.o, i8* %out.p, align 1
  %i.co.next = add nsw i32 %i.co, 1
  br label %copy_out.loop

ret:                                              ; preds = %copy_out.loop
  ret void
}

!0 = distinct !{!0}
!1 = distinct !{!1}