; ModuleID = 'aes128_module'
source_filename = "aes128_encrypt.ll"
target triple = "x86_64-pc-linux-gnu"

@sbox_1 = external dso_local constant [256 x i8], align 1
@rcon_0 = external dso_local constant [256 x i8], align 1

define dso_local void @aes128_encrypt(i8* nocapture %out, i8* nocapture readonly %in, i8* nocapture readonly %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %rk = alloca [176 x i8], align 16

  ; state[i] = in[i], i=0..15
  br label %copy_in.loop

copy_in.loop:                                         ; preds = %copy_in.inc, %entry
  %ci.i = phi i32 [ 0, %entry ], [ %ci.i.next, %copy_in.inc ]
  %ci.c = icmp ult i32 %ci.i, 16
  br i1 %ci.c, label %copy_in.body, label %copy_in.end

copy_in.body:                                         ; preds = %copy_in.loop
  %ci.i.z = zext i32 %ci.i to i64
  %in.elem.ptr = getelementptr inbounds i8, i8* %in, i64 %ci.i.z
  %in.elem = load i8, i8* %in.elem.ptr, align 1
  %st.elem.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ci.i.z
  store i8 %in.elem, i8* %st.elem.ptr, align 1
  br label %copy_in.inc

copy_in.inc:                                          ; preds = %copy_in.body
  %ci.i.next = add i32 %ci.i, 1
  br label %copy_in.loop

copy_in.end:                                          ; preds = %copy_in.loop
  ; rk[i] = key[i], i=0..15
  br label %copy_key.loop

copy_key.loop:                                        ; preds = %copy_key.inc, %copy_in.end
  %ck.i = phi i32 [ 0, %copy_in.end ], [ %ck.i.next, %copy_key.inc ]
  %ck.c = icmp ult i32 %ck.i, 16
  br i1 %ck.c, label %copy_key.body, label %copy_key.end

copy_key.body:                                        ; preds = %copy_key.loop
  %ck.i.z = zext i32 %ck.i to i64
  %key.elem.ptr = getelementptr inbounds i8, i8* %key, i64 %ck.i.z
  %key.elem = load i8, i8* %key.elem.ptr, align 1
  %rk.elem.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %ck.i.z
  store i8 %key.elem, i8* %rk.elem.ptr, align 1
  br label %copy_key.inc

copy_key.inc:                                         ; preds = %copy_key.body
  %ck.i.next = add i32 %ck.i, 1
  br label %copy_key.loop

copy_key.end:                                         ; preds = %copy_key.loop
  ; Key expansion
  br label %kexp.loop

kexp.loop:                                            ; preds = %kexp.inc, %copy_key.end
  %ke.i = phi i32 [ 16, %copy_key.end ], [ %ke.i.next, %kexp.inc ]
  %ke.rc = phi i32 [ 0, %copy_key.end ], [ %ke.rc.next, %kexp.inc ]
  %ke.c = icmp sle i32 %ke.i, 175
  br i1 %ke.c, label %kexp.body, label %kexp.end

kexp.body:                                            ; preds = %kexp.loop
  ; load last word (t0..t3)
  %i.m4 = add i32 %ke.i, -4
  %i.m3 = add i32 %ke.i, -3
  %i.m2 = add i32 %ke.i, -2
  %i.m1 = add i32 %ke.i, -1
  %i.m4.z = zext i32 %i.m4 to i64
  %i.m3.z = zext i32 %i.m3 to i64
  %i.m2.z = zext i32 %i.m2 to i64
  %i.m1.z = zext i32 %i.m1 to i64
  %t0.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m4.z
  %t1.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m3.z
  %t2.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m2.z
  %t3.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m1.z
  %t0 = load i8, i8* %t0.ptr, align 1
  %t1 = load i8, i8* %t1.ptr, align 1
  %t2 = load i8, i8* %t2.ptr, align 1
  %t3 = load i8, i8* %t3.ptr, align 1

  ; if (i & 0xF) == 0 -> RotWord, SubWord, Rcon
  %i.and = and i32 %ke.i, 15
  %i.and.is0 = icmp eq i32 %i.and, 0
  br i1 %i.and.is0, label %kexp.rot, label %kexp.no.rot

kexp.rot:                                             ; preds = %kexp.body
  ; rotate left 1 byte
  %rt0 = mov.i8 %t1
  %rt1 = mov.i8 %t2
  %rt2 = mov.i8 %t3
  %rt3 = mov.i8 %t0
  ; SubWord via sbox
  %rt0.z = zext i8 %rt0 to i64
  %rt1.z = zext i8 %rt1 to i64
  %rt2.z = zext i8 %rt2 to i64
  %rt3.z = zext i8 %rt3 to i64
  %sb0.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt0.z
  %sb1.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt1.z
  %sb2.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt2.z
  %sb3.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt3.z
  %sw0 = load i8, i8* %sb0.ptr, align 1
  %sw1 = load i8, i8* %sb1.ptr, align 1
  %sw2 = load i8, i8* %sb2.ptr, align 1
  %sw3 = load i8, i8* %sb3.ptr, align 1
  ; Rcon
  %rc.z = zext i32 %ke.rc to i64
  %rcon.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 %rc.z
  %rcon.val = load i8, i8* %rcon.ptr, align 1
  %sw0.r = xor i8 %sw0, %rcon.val
  br label %kexp.merge

kexp.no.rot:                                          ; preds = %kexp.body
  br label %kexp.merge

kexp.merge:                                           ; preds = %kexp.no.rot, %kexp.rot
  %t0.sel = phi i8 [ %sw0.r, %kexp.rot ], [ %t0, %kexp.no.rot ]
  %t1.sel = phi i8 [ %sw1,   %kexp.rot ], [ %t1, %kexp.no.rot ]
  %t2.sel = phi i8 [ %sw2,   %kexp.rot ], [ %t2, %kexp.no.rot ]
  %t3.sel = phi i8 [ %sw3,   %kexp.rot ], [ %t3, %kexp.no.rot ]
  %ke.rc.next = phi i32 [ %ke.rc + 1, %kexp.rot ], [ %ke.rc, %kexp.no.rot ]

  ; rk[i + j] = rk[i - 16 + j] ^ t[j], j=0..3
  %i.m16 = add i32 %ke.i, -16
  %i.m15 = add i32 %ke.i, -15
  %i.m14 = add i32 %ke.i, -14
  %i.m13 = add i32 %ke.i, -13
  %i.z = zext i32 %ke.i to i64
  %i1 = add i32 %ke.i, 1
  %i2 = add i32 %ke.i, 2
  %i3 = add i32 %ke.i, 3
  %i.m16.z = zext i32 %i.m16 to i64
  %i.m15.z = zext i32 %i.m15 to i64
  %i.m14.z = zext i32 %i.m14 to i64
  %i.m13.z = zext i32 %i.m13 to i64
  %i1.z = zext i32 %i1 to i64
  %i2.z = zext i32 %i2 to i64
  %i3.z = zext i32 %i3 to i64

  %rk.im16.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m16.z
  %rk.im15.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m15.z
  %rk.im14.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m14.z
  %rk.im13.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m13.z

  %rk.i.ptr   = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.z
  %rk.i1.ptr  = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i1.z
  %rk.i2.ptr  = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i2.z
  %rk.i3.ptr  = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i3.z

  %rk.im16 = load i8, i8* %rk.im16.ptr, align 1
  %rk.im15 = load i8, i8* %rk.im15.ptr, align 1
  %rk.im14 = load i8, i8* %rk.im14.ptr, align 1
  %rk.im13 = load i8, i8* %rk.im13.ptr, align 1

  %rk.i.val  = xor i8 %rk.im16, %t0.sel
  %rk.i1.val = xor i8 %rk.im15, %t1.sel
  %rk.i2.val = xor i8 %rk.im14, %t2.sel
  %rk.i3.val = xor i8 %rk.im13, %t3.sel

  store i8 %rk.i.val,  i8* %rk.i.ptr,  align 1
  store i8 %rk.i1.val, i8* %rk.i1.ptr, align 1
  store i8 %rk.i2.val, i8* %rk.i2.ptr, align 1
  store i8 %rk.i3.val, i8* %rk.i3.ptr, align 1

  br label %kexp.inc

kexp.inc:                                             ; preds = %kexp.merge
  %ke.i.next = add i32 %ke.i, 4
  br label %kexp.loop

kexp.end:                                             ; preds = %kexp.loop
  ; Initial AddRoundKey state ^= rk[0..15]
  br label %ark0.loop

ark0.loop:                                            ; preds = %ark0.inc, %kexp.end
  %a0.i = phi i32 [ 0, %kexp.end ], [ %a0.i.next, %ark0.inc ]
  %a0.c = icmp ult i32 %a0.i, 16
  br i1 %a0.c, label %ark0.body, label %ark0.end

ark0.body:                                            ; preds = %ark0.loop
  %a0.i.z = zext i32 %a0.i to i64
  %st.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %a0.i.z
  %st.v = load i8, i8* %st.p, align 1
  %rk.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %a0.i.z
  %rk.v = load i8, i8* %rk.p, align 1
  %x = xor i8 %st.v, %rk.v
  store i8 %x, i8* %st.p, align 1
  br label %ark0.inc

ark0.inc:                                             ; preds = %ark0.body
  %a0.i.next = add i32 %a0.i, 1
  br label %ark0.loop

ark0.end:                                             ; preds = %ark0.loop
  ; Rounds 1..9
  br label %round.loop

round.loop:                                           ; preds = %round.inc, %ark0.end
  %r.i = phi i32 [ 1, %ark0.end ], [ %r.i.next, %round.inc ]
  %r.c = icmp sle i32 %r.i, 9
  br i1 %r.c, label %round.body, label %round.end

round.body:                                           ; preds = %round.loop
  ; SubBytes
  br label %sub.loop

sub.loop:                                             ; preds = %sub.inc, %round.body
  %sb.i = phi i32 [ 0, %round.body ], [ %sb.i.next, %sub.inc ]
  %sb.c = icmp ult i32 %sb.i, 16
  br i1 %sb.c, label %sub.body, label %sub.end

sub.body:                                             ; preds = %sub.loop
  %sb.i.z = zext i32 %sb.i to i64
  %sb.st.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %sb.i.z
  %sb.v = load i8, i8* %sb.st.p, align 1
  %sb.v.z = zext i8 %sb.v to i64
  %sb.sbox.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %sb.v.z
  %sb.sv = load i8, i8* %sb.sbox.p, align 1
  store i8 %sb.sv, i8* %sb.st.p, align 1
  br label %sub.inc

sub.inc:                                              ; preds = %sub.body
  %sb.i.next = add i32 %sb.i, 1
  br label %sub.loop

sub.end:                                              ; preds = %sub.loop
  ; ShiftRows: load state to temporaries
  %s0.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %s1.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %s2.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %s3.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %s4.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 4
  %s5.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %s6.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %s7.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %s8.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 8
  %s9.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %s10.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %s11.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %s12.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 12
  %s13.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %s14.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %s15.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15

  %s0  = load i8, i8* %s0.p,  align 1
  %s1  = load i8, i8* %s1.p,  align 1
  %s2  = load i8, i8* %s2.p,  align 1
  %s3  = load i8, i8* %s3.p,  align 1
  %s4  = load i8, i8* %s4.p,  align 1
  %s5  = load i8, i8* %s5.p,  align 1
  %s6  = load i8, i8* %s6.p,  align 1
  %s7  = load i8, i8* %s7.p,  align 1
  %s8  = load i8, i8* %s8.p,  align 1
  %s9  = load i8, i8* %s9.p,  align 1
  %s10 = load i8, i8* %s10.p, align 1
  %s11 = load i8, i8* %s11.p, align 1
  %s12 = load i8, i8* %s12.p, align 1
  %s13 = load i8, i8* %s13.p, align 1
  %s14 = load i8, i8* %s14.p, align 1
  %s15 = load i8, i8* %s15.p, align 1

  ; Row 1 shift left by 1: 1,5,9,13
  %t1 = mov.i8 %s1
  %ns1  = mov.i8 %s5
  %ns5  = mov.i8 %s9
  %ns9  = mov.i8 %s13
  %ns13 = mov.i8 %t1

  ; Row 2 shift left by 2: swap 2<->10, 6<->14
  %ns2  = mov.i8 %s10
  %ns10 = mov.i8 %s2
  %ns6  = mov.i8 %s14
  %ns14 = mov.i8 %s6

  ; Row 3 shift left by 3: 3,7,11,15
  %t3 = mov.i8 %s3
  %ns3  = mov.i8 %s15
  %ns15 = mov.i8 %s11
  %ns11 = mov.i8 %s7
  %ns7  = mov.i8 %t3

  ; Rows 0 and 4,8,12 unchanged
  %ns0  = mov.i8 %s0
  %ns4  = mov.i8 %s4
  %ns8  = mov.i8 %s8
  %ns12 = mov.i8 %s12

  ; MixColumns per column
  ; Column 0: indices 0,1,2,3
  %c0.t = xor i8 %ns0, %ns1
  %c0.t1 = xor i8 %c0.t, %ns2
  %c0.t2 = xor i8 %c0.t1, %ns3
  ; xtime(ns0 ^ ns1)
  %c0.x01 = shl i8 %c0.t, 1
  %c0.msb = lshr i8 %c0.t, 7
  %c0.red = mul i8 %c0.msb, 27
  %c0.xt = xor i8 %c0.x01, %c0.red
  %n0 = xor i8 %ns0, %c0.xt
  %n0f = xor i8 %n0, %c0.t2

  ; xtime(ns1 ^ ns2)
  %c0.t12 = xor i8 %ns1, %ns2
  %c0.x12 = shl i8 %c0.t12, 1
  %c0.msb12 = lshr i8 %c0.t12, 7
  %c0.red12 = mul i8 %c0.msb12, 27
  %c0.xt12 = xor i8 %c0.x12, %c0.red12
  %n1 = xor i8 %ns1, %c0.xt12
  %n1f = xor i8 %n1, %c0.t2

  ; xtime(ns2 ^ ns3)
  %c0.t23 = xor i8 %ns2, %ns3
  %c0.x23 = shl i8 %c0.t23, 1
  %c0.msb23 = lshr i8 %c0.t23, 7
  %c0.red23 = mul i8 %c0.msb23, 27
  %c0.xt23 = xor i8 %c0.x23, %c0.red23
  %n2 = xor i8 %ns2, %c0.xt23
  %n2f = xor i8 %n2, %c0.t2

  ; xtime(ns3 ^ ns0)
  %c0.t30 = xor i8 %ns3, %ns0
  %c0.x30 = shl i8 %c0.t30, 1
  %c0.msb30 = lshr i8 %c0.t30, 7
  %c0.red30 = mul i8 %c0.msb30, 27
  %c0.xt30 = xor i8 %c0.x30, %c0.red30
  %n3 = xor i8 %ns3, %c0.xt30
  %n3f = xor i8 %n3, %c0.t2

  ; Column 1: indices 4,5,6,7
  %c1.t = xor i8 %ns4, %ns5
  %c1.t1 = xor i8 %c1.t, %ns6
  %c1.t2 = xor i8 %c1.t1, %ns7

  %c1.t01 = xor i8 %ns4, %ns5
  %c1.x01 = shl i8 %c1.t01, 1
  %c1.msb = lshr i8 %c1.t01, 7
  %c1.red = mul i8 %c1.msb, 27
  %c1.xt = xor i8 %c1.x01, %c1.red
  %m4 = xor i8 %ns4, %c1.xt
  %m4f = xor i8 %m4, %c1.t2

  %c1.t12 = xor i8 %ns5, %ns6
  %c1.x12 = shl i8 %c1.t12, 1
  %c1.msb12 = lshr i8 %c1.t12, 7
  %c1.red12 = mul i8 %c1.msb12, 27
  %c1.xt12 = xor i8 %c1.x12, %c1.red12
  %m5 = xor i8 %ns5, %c1.xt12
  %m5f = xor i8 %m5, %c1.t2

  %c1.t23 = xor i8 %ns6, %ns7
  %c1.x23 = shl i8 %c1.t23, 1
  %c1.msb23 = lshr i8 %c1.t23, 7
  %c1.red23 = mul i8 %c1.msb23, 27
  %c1.xt23 = xor i8 %c1.x23, %c1.red23
  %m6 = xor i8 %ns6, %c1.xt23
  %m6f = xor i8 %m6, %c1.t2

  %c1.t30 = xor i8 %ns7, %ns4
  %c1.x30 = shl i8 %c1.t30, 1
  %c1.msb30 = lshr i8 %c1.t30, 7
  %c1.red30 = mul i8 %c1.msb30, 27
  %c1.xt30 = xor i8 %c1.x30, %c1.red30
  %m7 = xor i8 %ns7, %c1.xt30
  %m7f = xor i8 %m7, %c1.t2

  ; Column 2: indices 8,9,10,11
  %c2.t = xor i8 %ns8, %ns9
  %c2.t1 = xor i8 %c2.t, %ns10
  %c2.t2 = xor i8 %c2.t1, %ns11

  %c2.t01 = xor i8 %ns8, %ns9
  %c2.x01 = shl i8 %c2.t01, 1
  %c2.msb = lshr i8 %c2.t01, 7
  %c2.red = mul i8 %c2.msb, 27
  %c2.xt = xor i8 %c2.x01, %c2.red
  %m8 = xor i8 %ns8, %c2.xt
  %m8f = xor i8 %m8, %c2.t2

  %c2.t12 = xor i8 %ns9, %ns10
  %c2.x12 = shl i8 %c2.t12, 1
  %c2.msb12 = lshr i8 %c2.t12, 7
  %c2.red12 = mul i8 %c2.msb12, 27
  %c2.xt12 = xor i8 %c2.x12, %c2.red12
  %m9 = xor i8 %ns9, %c2.xt12
  %m9f = xor i8 %m9, %c2.t2

  %c2.t23 = xor i8 %ns10, %ns11
  %c2.x23 = shl i8 %c2.t23, 1
  %c2.msb23 = lshr i8 %c2.t23, 7
  %c2.red23 = mul i8 %c2.msb23, 27
  %c2.xt23 = xor i8 %c2.x23, %c2.red23
  %m10 = xor i8 %ns10, %c2.xt23
  %m10f = xor i8 %m10, %c2.t2

  %c2.t30 = xor i8 %ns11, %ns8
  %c2.x30 = shl i8 %c2.t30, 1
  %c2.msb30 = lshr i8 %c2.t30, 7
  %c2.red30 = mul i8 %c2.msb30, 27
  %c2.xt30 = xor i8 %c2.x30, %c2.red30
  %m11 = xor i8 %ns11, %c2.xt30
  %m11f = xor i8 %m11, %c2.t2

  ; Column 3: indices 12,13,14,15
  %c3.t = xor i8 %ns12, %ns13
  %c3.t1 = xor i8 %c3.t, %ns14
  %c3.t2 = xor i8 %c3.t1, %ns15

  %c3.t01 = xor i8 %ns12, %ns13
  %c3.x01 = shl i8 %c3.t01, 1
  %c3.msb = lshr i8 %c3.t01, 7
  %c3.red = mul i8 %c3.msb, 27
  %c3.xt = xor i8 %c3.x01, %c3.red
  %m12 = xor i8 %ns12, %c3.xt
  %m12f = xor i8 %m12, %c3.t2

  %c3.t12 = xor i8 %ns13, %ns14
  %c3.x12 = shl i8 %c3.t12, 1
  %c3.msb12 = lshr i8 %c3.t12, 7
  %c3.red12 = mul i8 %c3.msb12, 27
  %c3.xt12 = xor i8 %c3.x12, %c3.red12
  %m13 = xor i8 %ns13, %c3.xt12
  %m13f = xor i8 %m13, %c3.t2

  %c3.t23 = xor i8 %ns14, %ns15
  %c3.x23 = shl i8 %c3.t23, 1
  %c3.msb23 = lshr i8 %c3.t23, 7
  %c3.red23 = mul i8 %c3.msb23, 27
  %c3.xt23 = xor i8 %c3.x23, %c3.red23
  %m14 = xor i8 %ns14, %c3.xt23
  %m14f = xor i8 %m14, %c3.t2

  %c3.t30 = xor i8 %ns15, %ns12
  %c3.x30 = shl i8 %c3.t30, 1
  %c3.msb30 = lshr i8 %c3.t30, 7
  %c3.red30 = mul i8 %c3.msb30, 27
  %c3.xt30 = xor i8 %c3.x30, %c3.red30
  %m15 = xor i8 %ns15, %c3.xt30
  %m15f = xor i8 %m15, %c3.t2

  ; store mixed columns back to state
  store i8 %n0f,  i8* %s0.p,  align 1
  store i8 %n1f,  i8* %s1.p,  align 1
  store i8 %n2f,  i8* %s2.p,  align 1
  store i8 %n3f,  i8* %s3.p,  align 1
  store i8 %m4f,  i8* %s4.p,  align 1
  store i8 %m5f,  i8* %s5.p,  align 1
  store i8 %m6f,  i8* %s6.p,  align 1
  store i8 %m7f,  i8* %s7.p,  align 1
  store i8 %m8f,  i8* %s8.p,  align 1
  store i8 %m9f,  i8* %s9.p,  align 1
  store i8 %m10f, i8* %s10.p, align 1
  store i8 %m11f, i8* %s11.p, align 1
  store i8 %m12f, i8* %s12.p, align 1
  store i8 %m13f, i8* %s13.p, align 1
  store i8 %m14f, i8* %s14.p, align 1
  store i8 %m15f, i8* %s15.p, align 1

  ; AddRoundKey with offset r.i * 16
  br label %ark.loop

ark.loop:                                             ; preds = %ark.inc, %sub.end
  %ar.i = phi i32 [ 0, %sub.end ], [ %ar.i.next, %ark.inc ]
  %ar.c = icmp ult i32 %ar.i, 16
  br i1 %ar.c, label %ark.body, label %ark.end

ark.body:                                             ; preds = %ark.loop
  %ar.i.z = zext i32 %ar.i to i64
  %st.p.r = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ar.i.z
  %st.v.r = load i8, i8* %st.p.r, align 1
  %r.off = mul i32 %r.i, 16
  %rk.idx = add i32 %r.off, %ar.i
  %rk.idx.z = zext i32 %rk.idx to i64
  %rk.p.r = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %rk.idx.z
  %rk.v.r = load i8, i8* %rk.p.r, align 1
  %xr = xor i8 %st.v.r, %rk.v.r
  store i8 %xr, i8* %st.p.r, align 1
  br label %ark.inc

ark.inc:                                              ; preds = %ark.body
  %ar.i.next = add i32 %ar.i, 1
  br label %ark.loop

ark.end:                                              ; preds = %ark.loop
  br label %round.inc

round.inc:                                            ; preds = %ark.end
  %r.i.next = add i32 %r.i, 1
  br label %round.loop

round.end:                                            ; preds = %round.loop
  ; Final round: SubBytes, ShiftRows, AddRoundKey with offset 160
  ; SubBytes
  br label %fsub.loop

fsub.loop:                                            ; preds = %fsub.inc, %round.end
  %fs.i = phi i32 [ 0, %round.end ], [ %fs.i.next, %fsub.inc ]
  %fs.c = icmp ult i32 %fs.i, 16
  br i1 %fs.c, label %fsub.body, label %fsub.end

fsub.body:                                            ; preds = %fsub.loop
  %fs.i.z = zext i32 %fs.i to i64
  %fs.st.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fs.i.z
  %fs.v = load i8, i8* %fs.st.p, align 1
  %fs.v.z = zext i8 %fs.v to i64
  %fs.sbox.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %fs.v.z
  %fs.sv = load i8, i8* %fs.sbox.p, align 1
  store i8 %fs.sv, i8* %fs.st.p, align 1
  br label %fsub.inc

fsub.inc:                                             ; preds = %fsub.body
  %fs.i.next = add i32 %fs.i, 1
  br label %fsub.loop

fsub.end:                                             ; preds = %fsub.loop
  ; ShiftRows (same as before)
  %fs0.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %fs1.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %fs2.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %fs3.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %fs4.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 4
  %fs5.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %fs6.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %fs7.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %fs8.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 8
  %fs9.p  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %fs10.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %fs11.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %fs12.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 12
  %fs13.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %fs14.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %fs15.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15

  %fs0  = load i8, i8* %fs0.p,  align 1
  %fs1  = load i8, i8* %fs1.p,  align 1
  %fs2  = load i8, i8* %fs2.p,  align 1
  %fs3  = load i8, i8* %fs3.p,  align 1
  %fs4  = load i8, i8* %fs4.p,  align 1
  %fs5  = load i8, i8* %fs5.p,  align 1
  %fs6  = load i8, i8* %fs6.p,  align 1
  %fs7  = load i8, i8* %fs7.p,  align 1
  %fs8  = load i8, i8* %fs8.p,  align 1
  %fs9  = load i8, i8* %fs9.p,  align 1
  %fs10 = load i8, i8* %fs10.p, align 1
  %fs11 = load i8, i8* %fs11.p, align 1
  %fs12 = load i8, i8* %fs12.p, align 1
  %fs13 = load i8, i8* %fs13.p, align 1
  %fs14 = load i8, i8* %fs14.p, align 1
  %fs15 = load i8, i8* %fs15.p, align 1

  ; Row 1
  %ft1 = mov.i8 %fs1
  %fns1  = mov.i8 %fs5
  %fns5  = mov.i8 %fs9
  %fns9  = mov.i8 %fs13
  %fns13 = mov.i8 %ft1
  ; Row 2
  %fns2  = mov.i8 %fs10
  %fns10 = mov.i8 %fs2
  %fns6  = mov.i8 %fs14
  %fns14 = mov.i8 %fs6
  ; Row 3
  %ft3 = mov.i8 %fs3
  %fns3  = mov.i8 %fs15
  %fns15 = mov.i8 %fs11
  %fns11 = mov.i8 %fs7
  %fns7  = mov.i8 %ft3
  ; Rows 0/4/8/12
  %fns0  = mov.i8 %fs0
  %fns4  = mov.i8 %fs4
  %fns8  = mov.i8 %fs8
  %fns12 = mov.i8 %fs12

  store i8 %fns0,  i8* %fs0.p,  align 1
  store i8 %fns1,  i8* %fs1.p,  align 1
  store i8 %fns2,  i8* %fs2.p,  align 1
  store i8 %fns3,  i8* %fs3.p,  align 1
  store i8 %fns4,  i8* %fs4.p,  align 1
  store i8 %fns5,  i8* %fs5.p,  align 1
  store i8 %fns6,  i8* %fs6.p,  align 1
  store i8 %fns7,  i8* %fs7.p,  align 1
  store i8 %fns8,  i8* %fs8.p,  align 1
  store i8 %fns9,  i8* %fs9.p,  align 1
  store i8 %fns10, i8* %fs10.p, align 1
  store i8 %fns11, i8* %fs11.p, align 1
  store i8 %fns12, i8* %fs12.p, align 1
  store i8 %fns13, i8* %fs13.p, align 1
  store i8 %fns14, i8* %fs14.p, align 1
  store i8 %fns15, i8* %fs15.p, align 1

  ; AddRoundKey with offset 160 (10*16)
  br label %fark.loop

fark.loop:                                            ; preds = %fark.inc, %fsub.end
  %far.i = phi i32 [ 0, %fsub.end ], [ %far.i.next, %fark.inc ]
  %far.c = icmp ult i32 %far.i, 16
  br i1 %far.c, label %fark.body, label %fark.end

fark.body:                                            ; preds = %fark.loop
  %far.i.z = zext i32 %far.i to i64
  %fst.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %far.i.z
  %fst.v = load i8, i8* %fst.p, align 1
  %rk160.idx = add i32 %far.i, 160
  %rk160.idx.z = zext i32 %rk160.idx to i64
  %frk.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %rk160.idx.z
  %frk.v = load i8, i8* %frk.p, align 1
  %fx = xor i8 %fst.v, %frk.v
  store i8 %fx, i8* %fst.p, align 1
  br label %fark.inc

fark.inc:                                             ; preds = %fark.body
  %far.i.next = add i32 %far.i, 1
  br label %fark.loop

fark.end:                                             ; preds = %fark.loop
  ; store state to out
  br label %copy_out.loop

copy_out.loop:                                        ; preds = %copy_out.inc, %fark.end
  %co.i = phi i32 [ 0, %fark.end ], [ %co.i.next, %copy_out.inc ]
  %co.c = icmp ult i32 %co.i, 16
  br i1 %co.c, label %copy_out.body, label %copy_out.end

copy_out.body:                                        ; preds = %copy_out.loop
  %co.i.z = zext i32 %co.i to i64
  %co.st.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %co.i.z
  %co.v = load i8, i8* %co.st.p, align 1
  %out.p = getelementptr inbounds i8, i8* %out, i64 %co.i.z
  store i8 %co.v, i8* %out.p, align 1
  br label %copy_out.inc

copy_out.inc:                                         ; preds = %copy_out.body
  %co.i.next = add i32 %co.i, 1
  br label %copy_out.loop

copy_out.end:                                         ; preds = %copy_out.loop
  ret void
}

; Note: @sbox_1 and @rcon_0 are declared as external constants and must be provided by the linker.