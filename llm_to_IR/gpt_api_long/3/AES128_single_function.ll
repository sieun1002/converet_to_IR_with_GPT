; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt  ; Address: 0x11A9
; Intent: AES-128 ECB encrypt one 16-byte block with 16-byte key (confidence=0.95). Evidence: S-box and Rcon tables; key expansion and 9 main rounds + final round transformations
; Preconditions: %out, %in, %key each point to at least 16 bytes; @sbox_1 and @rcon_0 provide standard AES tables
; Postconditions: Writes 16-byte ciphertext to %out

@sbox_1 = external global [256 x i8], align 16
@rcon_0 = external global [256 x i8], align 16

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %sched = alloca [176 x i8], align 16

  ; state <- input
  br label %copy_in.loop

copy_in.loop:                                     ; preds = %copy_in.loop, %entry
  %i.in = phi i32 [ 0, %entry ], [ %inc.in, %copy_in.loop ]
  %cmp.in = icmp sgt i32 %i.in, 15
  br i1 %cmp.in, label %copy_key.pre, label %copy_in.body

copy_in.body:                                     ; preds = %copy_in.loop
  %i.in.z = zext i32 %i.in to i64
  %inp.ptr = getelementptr inbounds i8, i8* %in, i64 %i.in.z
  %b.in = load i8, i8* %inp.ptr, align 1
  %st.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.in.z
  store i8 %b.in, i8* %st.ptr, align 1
  %inc.in = add i32 %i.in, 1
  br label %copy_in.loop

copy_key.pre:                                     ; preds = %copy_in.loop
  br label %copy_key.loop

copy_key.loop:                                    ; preds = %copy_key.loop, %copy_key.pre
  %i.k = phi i32 [ 0, %copy_key.pre ], [ %inc.k, %copy_key.loop ]
  %cmp.k = icmp sgt i32 %i.k, 15
  br i1 %cmp.k, label %expand.init, label %copy_key.body

copy_key.body:                                    ; preds = %copy_key.loop
  %i.k.z = zext i32 %i.k to i64
  %key.ptr = getelementptr inbounds i8, i8* %key, i64 %i.k.z
  %b.k = load i8, i8* %key.ptr, align 1
  %sch.ptr0 = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %i.k.z
  store i8 %b.k, i8* %sch.ptr0, align 1
  %inc.k = add i32 %i.k, 1
  br label %copy_key.loop

expand.init:                                      ; preds = %copy_key.loop
  %idx0 = add i32 0, 16
  %rconi0 = add i32 0, 0
  br label %expand.loop

expand.loop:                                      ; preds = %expand.next, %expand.init
  %idx = phi i32 [ %idx0, %expand.init ], [ %idx.next, %expand.next ]
  %rconi = phi i32 [ %rconi0, %expand.init ], [ %rconi.next, %expand.next ]
  %cmp.expand = icmp sgt i32 %idx, 175
  br i1 %cmp.expand, label %ark0.init, label %expand.body

expand.body:                                      ; preds = %expand.loop
  ; load prev 4 bytes
  %i_m4 = add i32 %idx, -4
  %i_m3 = add i32 %idx, -3
  %i_m2 = add i32 %idx, -2
  %i_m1 = add i32 %idx, -1
  %i_m4.z = zext i32 %i_m4 to i64
  %i_m3.z = zext i32 %i_m3 to i64
  %i_m2.z = zext i32 %i_m2 to i64
  %i_m1.z = zext i32 %i_m1 to i64
  %p_m4 = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %i_m4.z
  %p_m3 = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %i_m3.z
  %p_m2 = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %i_m2.z
  %p_m1 = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %i_m1.z
  %t0.in = load i8, i8* %p_m4, align 1
  %t1.in = load i8, i8* %p_m3, align 1
  %t2.in = load i8, i8* %p_m2, align 1
  %t3.in = load i8, i8* %p_m1, align 1
  ; if (idx % 16 == 0) rotword+subword+rcon
  %and = and i32 %idx, 15
  %is0 = icmp eq i32 %and, 0
  br i1 %is0, label %subword, label %no_subword

subword:                                          ; preds = %expand.body
  ; rotate
  %rt0 = phi i8 [ %t1.in, %expand.body ]
  %rt1 = phi i8 [ %t2.in, %expand.body ]
  %rt2 = phi i8 [ %t3.in, %expand.body ]
  %rt3 = phi i8 [ %t0.in, %expand.body ]
  ; subbytes via sbox
  %rt0.z = zext i8 %rt0 to i64
  %sb0.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt0.z
  %sb0 = load i8, i8* %sb0.p, align 1
  %rt1.z = zext i8 %rt1 to i64
  %sb1.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt1.z
  %sb1 = load i8, i8* %sb1.p, align 1
  %rt2.z = zext i8 %rt2 to i64
  %sb2.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt2.z
  %sb2 = load i8, i8* %sb2.p, align 1
  %rt3.z = zext i8 %rt3 to i64
  %sb3.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt3.z
  %sb3 = load i8, i8* %sb3.p, align 1
  ; rcon
  %rconi.next1 = add i32 %rconi, 1
  %rconi.next1.z = zext i32 %rconi.next1 to i64
  %rcon.p = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 %rconi.next1.z
  %rcon.v = load i8, i8* %rcon.p, align 1
  %t0.s = xor i8 %sb0, %rcon.v
  br label %after_sub

no_subword:                                       ; preds = %expand.body
  br label %after_sub

after_sub:                                        ; preds = %no_subword, %subword
  %t0.sel = phi i8 [ %t0.s, %subword ], [ %t0.in, %no_subword ]
  %t1.sel = phi i8 [ %sb1, %subword ], [ %t1.in, %no_subword ]
  %t2.sel = phi i8 [ %sb2, %subword ], [ %t2.in, %no_subword ]
  %t3.sel = phi i8 [ %sb3, %subword ], [ %t3.in, %no_subword ]
  %rconi.out = phi i32 [ %rconi.next1, %subword ], [ %rconi, %no_subword ]

  ; write 4 bytes: sched[idx + j] = sched[idx-16 + j] ^ t[j]
  %base16 = add i32 %idx, -16

  ; j=0
  %b16_0.z = zext i32 %base16 to i64
  %p16_0 = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %b16_0.z
  %v16_0 = load i8, i8* %p16_0, align 1
  %out0 = xor i8 %v16_0, %t0.sel
  %idx0.z = zext i32 %idx to i64
  %p_out0 = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %idx0.z
  store i8 %out0, i8* %p_out0, align 1

  ; j=1
  %idx1 = add i32 %idx, 1
  %base16_1 = add i32 %base16, 1
  %b16_1.z = zext i32 %base16_1 to i64
  %p16_1 = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %b16_1.z
  %v16_1 = load i8, i8* %p16_1, align 1
  %out1 = xor i8 %v16_1, %t1.sel
  %idx1.z = zext i32 %idx1 to i64
  %p_out1 = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %idx1.z
  store i8 %out1, i8* %p_out1, align 1

  ; j=2
  %idx2 = add i32 %idx, 2
  %base16_2 = add i32 %base16, 2
  %b16_2.z = zext i32 %base16_2 to i64
  %p16_2 = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %b16_2.z
  %v16_2 = load i8, i8* %p16_2, align 1
  %out2 = xor i8 %v16_2, %t2.sel
  %idx2.z = zext i32 %idx2 to i64
  %p_out2 = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %idx2.z
  store i8 %out2, i8* %p_out2, align 1

  ; j=3
  %idx3 = add i32 %idx, 3
  %base16_3 = add i32 %base16, 3
  %b16_3.z = zext i32 %base16_3 to i64
  %p16_3 = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %b16_3.z
  %v16_3 = load i8, i8* %p16_3, align 1
  %out3 = xor i8 %v16_3, %t3.sel
  %idx3.z = zext i32 %idx3 to i64
  %p_out3 = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %idx3.z
  store i8 %out3, i8* %p_out3, align 1

  br label %expand.next

expand.next:                                      ; preds = %after_sub
  %idx.next = add i32 %idx, 4
  %rconi.next = add i32 %rconi.out, 0
  br label %expand.loop

ark0.init:                                        ; preds = %expand.loop
  br label %ark0.loop

; initial AddRoundKey with round key 0
ark0.loop:                                        ; preds = %ark0.loop, %ark0.init
  %i0 = phi i32 [ 0, %ark0.init ], [ %i0.inc, %ark0.loop ]
  %cmp0 = icmp sgt i32 %i0, 15
  br i1 %cmp0, label %rounds.init, label %ark0.body

ark0.body:                                        ; preds = %ark0.loop
  %i0.z = zext i32 %i0 to i64
  %st.p0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i0.z
  %st.b0 = load i8, i8* %st.p0, align 1
  %sk.p0 = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %i0.z
  %rk.b0 = load i8, i8* %sk.p0, align 1
  %x0 = xor i8 %st.b0, %rk.b0
  store i8 %x0, i8* %st.p0, align 1
  %i0.inc = add i32 %i0, 1
  br label %ark0.loop

rounds.init:                                      ; preds = %ark0.loop
  br label %rounds.loop

; 9 main rounds
rounds.loop:                                      ; preds = %rounds.next, %rounds.init
  %r = phi i32 [ 1, %rounds.init ], [ %r.next, %rounds.next ]
  %cmp.r = icmp sgt i32 %r, 9
  br i1 %cmp.r, label %final_subshift, label %round.body

; SubBytes
round.body:                                       ; preds = %rounds.loop
  br label %subbytes.loop

subbytes.loop:                                    ; preds = %subbytes.loop, %round.body
  %i.sb = phi i32 [ 0, %round.body ], [ %i.sb.inc, %subbytes.loop ]
  %cmp.sb = icmp sgt i32 %i.sb, 15
  br i1 %cmp.sb, label %shiftrows, label %subbytes.body

subbytes.body:                                    ; preds = %subbytes.loop
  %i.sb.z = zext i32 %i.sb to i64
  %p.sb = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.sb.z
  %v.sb = load i8, i8* %p.sb, align 1
  %v.sb.z = zext i8 %v.sb to i64
  %p.sbox = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %v.sb.z
  %v.sub = load i8, i8* %p.sbox, align 1
  store i8 %v.sub, i8* %p.sb, align 1
  %i.sb.inc = add i32 %i.sb, 1
  br label %subbytes.loop

; ShiftRows
shiftrows:                                        ; preds = %subbytes.loop
  ; load all bytes a0..a15
  %a0.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %a1.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %a2.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %a3.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %a4.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 4
  %a5.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %a6.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %a7.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %a8.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 8
  %a9.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %a10.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %a11.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %a12.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 12
  %a13.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %a14.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %a15.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15

  %a0 = load i8, i8* %a0.p, align 1
  %a1 = load i8, i8* %a1.p, align 1
  %a2 = load i8, i8* %a2.p, align 1
  %a3 = load i8, i8* %a3.p, align 1
  %a4 = load i8, i8* %a4.p, align 1
  %a5 = load i8, i8* %a5.p, align 1
  %a6 = load i8, i8* %a6.p, align 1
  %a7 = load i8, i8* %a7.p, align 1
  %a8 = load i8, i8* %a8.p, align 1
  %a9 = load i8, i8* %a9.p, align 1
  %a10 = load i8, i8* %a10.p, align 1
  %a11 = load i8, i8* %a11.p, align 1
  %a12 = load i8, i8* %a12.p, align 1
  %a13 = load i8, i8* %a13.p, align 1
  %a14 = load i8, i8* %a14.p, align 1
  %a15 = load i8, i8* %a15.p, align 1

  ; row0 unchanged: [0,4,8,12]
  store i8 %a0,  i8* %a0.p,  align 1
  store i8 %a4,  i8* %a4.p,  align 1
  store i8 %a8,  i8* %a8.p,  align 1
  store i8 %a12, i8* %a12.p, align 1
  ; row1 rotate left by 1: [1,5,9,13] -> [5,9,13,1]
  store i8 %a5,  i8* %a1.p,  align 1
  store i8 %a9,  i8* %a5.p,  align 1
  store i8 %a13, i8* %a9.p,  align 1
  store i8 %a1,  i8* %a13.p, align 1
  ; row2 rotate left by 2: [2,6,10,14] -> [10,14,2,6]
  store i8 %a10, i8* %a2.p,  align 1
  store i8 %a14, i8* %a6.p,  align 1
  store i8 %a2,  i8* %a10.p, align 1
  store i8 %a6,  i8* %a14.p, align 1
  ; row3 rotate left by 3: [3,7,11,15] -> [15,3,7,11]
  store i8 %a15, i8* %a3.p,  align 1
  store i8 %a3,  i8* %a7.p,  align 1
  store i8 %a7,  i8* %a11.p, align 1
  store i8 %a11, i8* %a15.p, align 1

  br label %mixcols.init

mixcols.init:                                     ; preds = %shiftrows
  br label %mixcols.loop

mixcols.loop:                                     ; preds = %mixcols.next, %mixcols.init
  %c = phi i32 [ 0, %mixcols.init ], [ %c.next, %mixcols.next ]
  %cmp.c = icmp sgt i32 %c, 3
  br i1 %cmp.c, label %ark.loop, label %mixcols.body

mixcols.body:                                     ; preds = %mixcols.loop
  %base = mul i32 %c, 4
  %b0.i = zext i32 %base to i64
  %b1.i = zext i32 (add i32 %base, 1) to i64
  %b2.i = zext i32 (add i32 %base, 2) to i64
  %b3.i = zext i32 (add i32 %base, 3) to i64

  %p0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b0.i
  %p1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b1.i
  %p2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b2.i
  %p3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b3.i

  %va = load i8, i8* %p0, align 1
  %vb = load i8, i8* %p1, align 1
  %vc = load i8, i8* %p2, align 1
  %vd = load i8, i8* %p3, align 1

  %t.ab = xor i8 %va, %vb
  %t.cd = xor i8 %vc, %vd
  %t.all = xor i8 %t.ab, %t.cd

  ; s0 ^= xtime(a^b) ^ t
  %xt0.shl = shl i8 %t.ab, 1
  %xt0.msb = lshr i8 %t.ab, 7
  %xt0.msb1 = icmp ne i8 %xt0.msb, 0
  %xt0.mask = select i1 %xt0.msb1, i8 27, i8 0
  %xt0 = xor i8 %xt0.shl, %xt0.mask
  %m0 = xor i8 %xt0, %t.all
  %s0.old = %va
  %s0.new = xor i8 %s0.old, %m0
  store i8 %s0.new, i8* %p0, align 1

  ; s1 ^= xtime(b^c) ^ t
  %t.bc = xor i8 %vb, %vc
  %xt1.shl = shl i8 %t.bc, 1
  %xt1.msb = lshr i8 %t.bc, 7
  %xt1.msb1 = icmp ne i8 %xt1.msb, 0
  %xt1.mask = select i1 %xt1.msb1, i8 27, i8 0
  %xt1 = xor i8 %xt1.shl, %xt1.mask
  %m1 = xor i8 %xt1, %t.all
  %s1.old = %vb
  %s1.new = xor i8 %s1.old, %m1
  store i8 %s1.new, i8* %p1, align 1

  ; s2 ^= xtime(c^d) ^ t
  %t.cd2 = xor i8 %vc, %vd
  %xt2.shl = shl i8 %t.cd2, 1
  %xt2.msb = lshr i8 %t.cd2, 7
  %xt2.msb1 = icmp ne i8 %xt2.msb, 0
  %xt2.mask = select i1 %xt2.msb1, i8 27, i8 0
  %xt2 = xor i8 %xt2.shl, %xt2.mask
  %m2 = xor i8 %xt2, %t.all
  %s2.old = %vc
  %s2.new = xor i8 %s2.old, %m2
  store i8 %s2.new, i8* %p2, align 1

  ; s3 ^= xtime(d^a) ^ t
  %t.da = xor i8 %vd, %va
  %xt3.shl = shl i8 %t.da, 1
  %xt3.msb = lshr i8 %t.da, 7
  %xt3.msb1 = icmp ne i8 %xt3.msb, 0
  %xt3.mask = select i1 %xt3.msb1, i8 27, i8 0
  %xt3 = xor i8 %xt3.shl, %xt3.mask
  %m3 = xor i8 %xt3, %t.all
  %s3.old = %vd
  %s3.new = xor i8 %s3.old, %m3
  store i8 %s3.new, i8* %p3, align 1

  br label %mixcols.next

mixcols.next:                                     ; preds = %mixcols.body
  %c.next = add i32 %c, 1
  br label %mixcols.loop

; AddRoundKey for round r
ark.loop:                                         ; preds = %mixcols.loop
  br label %arkr.loop

arkr.loop:                                        ; preds = %arkr.loop, %ark.loop
  %i.rk = phi i32 [ 0, %ark.loop ], [ %i.rk.inc, %arkr.loop ]
  %cmp.rk = icmp sgt i32 %i.rk, 15
  br i1 %cmp.rk, label %rounds.next, label %arkr.body

arkr.body:                                        ; preds = %arkr.loop
  %i.rk.z = zext i32 %i.rk to i64
  %st.pr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.rk.z
  %st.br = load i8, i8* %st.pr, align 1
  %off.r = mul i32 %r, 16
  %rk.idx = add i32 %off.r, %i.rk
  %rk.idx.z = zext i32 %rk.idx to i64
  %rk.pr = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %rk.idx.z
  %rk.br = load i8, i8* %rk.pr, align 1
  %st.xr = xor i8 %st.br, %rk.br
  store i8 %st.xr, i8* %st.pr, align 1
  %i.rk.inc = add i32 %i.rk, 1
  br label %arkr.loop

rounds.next:                                      ; preds = %arkr.loop
  %r.next = add i32 %r, 1
  br label %rounds.loop

; final round: SubBytes, ShiftRows, AddRoundKey with round 10
final_subshift:                                   ; preds = %rounds.loop
  br label %final.sb.loop

final.sb.loop:                                    ; preds = %final.sb.loop, %final_subshift
  %i.fsb = phi i32 [ 0, %final_subshift ], [ %i.fsb.inc, %final.sb.loop ]
  %cmp.fsb = icmp sgt i32 %i.fsb, 15
  br i1 %cmp.fsb, label %final.shift, label %final.sb.body

final.sb.body:                                    ; preds = %final.sb.loop
  %i.fsb.z = zext i32 %i.fsb to i64
  %p.fsb = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.fsb.z
  %v.fsb = load i8, i8* %p.fsb, align 1
  %v.fsb.z = zext i8 %v.fsb to i64
  %p.sbox.f = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %v.fsb.z
  %v.sub.f = load i8, i8* %p.sbox.f, align 1
  store i8 %v.sub.f, i8* %p.fsb, align 1
  %i.fsb.inc = add i32 %i.fsb, 1
  br label %final.sb.loop

final.shift:                                      ; preds = %final.sb.loop
  ; load all bytes again
  %f0.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %f1.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %f2.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %f3.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %f4.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 4
  %f5.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %f6.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %f7.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %f8.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 8
  %f9.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %f10.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %f11.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %f12.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 12
  %f13.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %f14.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %f15.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15

  %f0 = load i8, i8* %f0.p, align 1
  %f1 = load i8, i8* %f1.p, align 1
  %f2 = load i8, i8* %f2.p, align 1
  %f3 = load i8, i8* %f3.p, align 1
  %f4 = load i8, i8* %f4.p, align 1
  %f5 = load i8, i8* %f5.p, align 1
  %f6 = load i8, i8* %f6.p, align 1
  %f7 = load i8, i8* %f7.p, align 1
  %f8 = load i8, i8* %f8.p, align 1
  %f9 = load i8, i8* %f9.p, align 1
  %f10 = load i8, i8* %f10.p, align 1
  %f11 = load i8, i8* %f11.p, align 1
  %f12 = load i8, i8* %f12.p, align 1
  %f13 = load i8, i8* %f13.p, align 1
  %f14 = load i8, i8* %f14.p, align 1
  %f15 = load i8, i8* %f15.p, align 1

  store i8 %f0,  i8* %f0.p,  align 1
  store i8 %f4,  i8* %f4.p,  align 1
  store i8 %f8,  i8* %f8.p,  align 1
  store i8 %f12, i8* %f12.p, align 1

  store i8 %f5,  i8* %f1.p,  align 1
  store i8 %f9,  i8* %f5.p,  align 1
  store i8 %f13, i8* %f9.p,  align 1
  store i8 %f1,  i8* %f13.p, align 1

  store i8 %f10, i8* %f2.p,  align 1
  store i8 %f14, i8* %f6.p,  align 1
  store i8 %f2,  i8* %f10.p, align 1
  store i8 %f6,  i8* %f14.p, align 1

  store i8 %f15, i8* %f3.p,  align 1
  store i8 %f3,  i8* %f7.p,  align 1
  store i8 %f7,  i8* %f11.p, align 1
  store i8 %f11, i8* %f15.p, align 1

  br label %final.ark.loop

final.ark.loop:                                   ; preds = %final.ark.loop, %final.shift
  %i.fk = phi i32 [ 0, %final.shift ], [ %i.fk.inc, %final.ark.loop ]
  %cmp.fk = icmp sgt i32 %i.fk, 15
  br i1 %cmp.fk, label %store_out.init, label %final.ark.body

final.ark.body:                                   ; preds = %final.ark.loop
  %i.fk.z = zext i32 %i.fk to i64
  %st.pf = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.fk.z
  %st.bf = load i8, i8* %st.pf, align 1
  %rk10.idx = add i32 %i.fk, 160
  %rk10.idx.z = zext i32 %rk10.idx to i64
  %rk10.p = getelementptr inbounds [176 x i8], [176 x i8]* %sched, i64 0, i64 %rk10.idx.z
  %rk10.b = load i8, i8* %rk10.p, align 1
  %st.xf = xor i8 %st.bf, %rk10.b
  store i8 %st.xf, i8* %st.pf, align 1
  %i.fk.inc = add i32 %i.fk, 1
  br label %final.ark.loop

; store state -> out
store_out.init:                                   ; preds = %final.ark.loop
  br label %store_out.loop

store_out.loop:                                   ; preds = %store_out.loop, %store_out.init
  %i.out = phi i32 [ 0, %store_out.init ], [ %i.out.inc, %store_out.loop ]
  %cmp.out = icmp sgt i32 %i.out, 15
  br i1 %cmp.out, label %ret, label %store_out.body

store_out.body:                                   ; preds = %store_out.loop
  %i.out.z = zext i32 %i.out to i64
  %p.so = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.out.z
  %b.so = load i8, i8* %p.so, align 1
  %p.out = getelementptr inbounds i8, i8* %out, i64 %i.out.z
  store i8 %b.so, i8* %p.out, align 1
  %i.out.inc = add i32 %i.out, 1
  br label %store_out.loop

ret:                                              ; preds = %store_out.loop
  ret void
}