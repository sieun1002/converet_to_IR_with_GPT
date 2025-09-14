; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt ; Address: 0x11A9
; Intent: AES-128 single-block encrypt (ECB) (confidence=0.95). Evidence: S-box and Rcon usage; 10 rounds with MixColumns except final.
; Preconditions: out, in, key point to at least 16 bytes (non-overlapping or safely overlapping).
; Postconditions: Writes 16-byte ciphertext to out.

@rcon_0 = external dso_local global [256 x i8], align 16
@sbox_1 = external dso_local global [256 x i8], align 16

define dso_local void @aes128_encrypt(i8* nocapture %out, i8* nocapture readonly %in, i8* nocapture readonly %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %rk = alloca [176 x i8], align 16

  ; state <- in[0..15]
  br label %copy_in

copy_in:                                             ; preds = %copy_in, %entry
  %i.in = phi i32 [ 0, %entry ], [ %inc.in, %copy_in ]
  %in.gep = getelementptr inbounds i8, i8* %in, i32 %i.in
  %in.b = load i8, i8* %in.gep, align 1
  %st.gep = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %i.in
  store i8 %in.b, i8* %st.gep, align 1
  %inc.in = add nuw nsw i32 %i.in, 1
  %cond.in = icmp sle i32 %i.in, 14
  br i1 %cond.in, label %copy_in, label %copy_in.tail

copy_in.tail:                                        ; preds = %copy_in
  ; copy last element i=15 already covered by loop condition sle 14? We handled via loop stepping to 15? Instead, finish explicitly:
  %in15 = getelementptr inbounds i8, i8* %in, i32 15
  %b15 = load i8, i8* %in15, align 1
  %st15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 15
  store i8 %b15, i8* %st15, align 1

  ; rk[0..15] <- key[0..15]
  br label %copy_key

copy_key:                                            ; preds = %copy_key, %copy_in.tail
  %i.k = phi i32 [ 0, %copy_in.tail ], [ %inc.k, %copy_key ]
  %key.gep = getelementptr inbounds i8, i8* %key, i32 %i.k
  %key.b = load i8, i8* %key.gep, align 1
  %rk.gep = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 %i.k
  store i8 %key.b, i8* %rk.gep, align 1
  %inc.k = add nuw nsw i32 %i.k, 1
  %cond.k = icmp sle i32 %i.k, 14
  br i1 %cond.k, label %copy_key, label %copy_key.tail

copy_key.tail:                                       ; preds = %copy_key
  %key15 = getelementptr inbounds i8, i8* %key, i32 15
  %kb15 = load i8, i8* %key15, align 1
  %rk15 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 15
  store i8 %kb15, i8* %rk15, align 1

  ; Key expansion
  br label %kexp.loop

kexp.loop:                                           ; preds = %kexp.loop, %copy_key.tail
  %i = phi i32 [ 16, %copy_key.tail ], [ %i.next, %kexp.loop ]
  %rcon_idx = phi i32 [ 0, %copy_key.tail ], [ %rcon_idx.next, %kexp.loop ]

  ; load previous word bytes t0..t3 = rk[i-4..i-1]
  %im4 = add nsw i32 %i, -4
  %im3 = add nsw i32 %i, -3
  %im2 = add nsw i32 %i, -2
  %im1 = add nsw i32 %i, -1
  %p0 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 %im4
  %p1 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 %im3
  %p2 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 %im2
  %p3 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 %im1
  %t0b = load i8, i8* %p0, align 1
  %t1b = load i8, i8* %p1, align 1
  %t2b = load i8, i8* %p2, align 1
  %t3b = load i8, i8* %p3, align 1

  ; if ((i & 15) == 0) do RotWord/SubWord and Rcon
  %iand = and i32 %i, 15
  %isblock = icmp eq i32 %iand, 0
  br i1 %isblock, label %subword, label %no_subword

subword:                                             ; preds = %kexp.loop
  ; rot left: (t1,t2,t3,t0)
  %rot0 = %t1b
  %rot1 = %t2b
  %rot2 = %t3b
  %rot3 = %t0b
  ; SubWord via sbox
  %rot0.z = zext i8 %rot0 to i32
  %s0p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i32 0, i32 %rot0.z
  %s0 = load i8, i8* %s0p, align 1
  %rot1.z = zext i8 %rot1 to i32
  %s1p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i32 0, i32 %rot1.z
  %s1 = load i8, i8* %s1p, align 1
  %rot2.z = zext i8 %rot2 to i32
  %s2p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i32 0, i32 %rot2.z
  %s2 = load i8, i8* %s2p, align 1
  %rot3.z = zext i8 %rot3 to i32
  %s3p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i32 0, i32 %rot3.z
  %s3 = load i8, i8* %s3p, align 1
  ; Rcon
  %rcp = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i32 0, i32 %rcon_idx
  %rc = load i8, i8* %rcp, align 1
  %s0.i = xor i8 %s0, %rc
  br label %after_sub

no_subword:                                          ; preds = %kexp.loop
  br label %after_sub

after_sub:                                           ; preds = %no_subword, %subword
  %tt0 = phi i8 [ %t0b, %no_subword ], [ %s0.i, %subword ]
  %tt1 = phi i8 [ %t1b, %no_subword ], [ %s1, %subword ]
  %tt2 = phi i8 [ %t2b, %no_subword ], [ %s2, %subword ]
  %tt3 = phi i8 [ %t3b, %no_subword ], [ %s3, %subword ]
  %rcon_idx.next = phi i32 [ %rcon_idx, %no_subword ], [ (add i32 %rcon_idx, 1), %subword ]

  ; Generate 4 bytes: rk[i+k] = rk[i-16+k] ^ tt{k}
  %im16 = add nsw i32 %i, -16
  %q0 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 %im16
  %q1 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 (add nsw i32 %im16, 1)
  %q2 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 (add nsw i32 %im16, 2)
  %q3 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 (add nsw i32 %im16, 3)
  %w0 = load i8, i8* %q0, align 1
  %w1 = load i8, i8* %q1, align 1
  %w2 = load i8, i8* %q2, align 1
  %w3 = load i8, i8* %q3, align 1

  %r0 = xor i8 %w0, %tt0
  %r1 = xor i8 %w1, %tt1
  %r2 = xor i8 %w2, %tt2
  %r3 = xor i8 %w3, %tt3

  %d0 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 %i
  store i8 %r0, i8* %d0, align 1
  %i1 = add nuw nsw i32 %i, 1
  %d1 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 %i1
  store i8 %r1, i8* %d1, align 1
  %i2 = add nuw nsw i32 %i, 2
  %d2 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 %i2
  store i8 %r2, i8* %d2, align 1
  %i3 = add nuw nsw i32 %i, 3
  %d3 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 %i3
  store i8 %r3, i8* %d3, align 1

  %i.next = add nuw nsw i32 %i, 4
  %cont.kexp = icmp sle i32 %i.next, 175
  br i1 %cont.kexp, label %kexp.loop, label %kexp.done

kexp.done:                                           ; preds = %after_sub
  ; Initial AddRoundKey (round 0)
  br label %ark0

ark0:                                                ; preds = %ark0, %kexp.done
  %i0 = phi i32 [ 0, %kexp.done ], [ %i0.next, %ark0 ]
  %stp0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %i0
  %sb0 = load i8, i8* %stp0, align 1
  %rkp0 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 %i0
  %kb0 = load i8, i8* %rkp0, align 1
  %xb0 = xor i8 %sb0, %kb0
  store i8 %xb0, i8* %stp0, align 1
  %i0.next = add nuw nsw i32 %i0, 1
  %cond0 = icmp sle i32 %i0, 14
  br i1 %cond0, label %ark0, label %rounds.init

rounds.init:                                         ; preds = %ark0
  ; write last byte i=15
  %stp15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 15
  %sb15 = load i8, i8* %stp15, align 1
  %rkp15 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 15
  %kb15.0 = load i8, i8* %rkp15, align 1
  %xb15 = xor i8 %sb15, %kb15.0
  store i8 %xb15, i8* %stp15, align 1

  br label %round.loop

round.loop:                                          ; preds = %arkN, %rounds.init
  %round = phi i32 [ 1, %rounds.init ], [ %round.next, %arkN ]
  ; SubBytes
  br label %subbytes

subbytes:                                            ; preds = %subbytes, %round.loop
  %is = phi i32 [ 0, %round.loop ], [ %is.next, %subbytes ]
  %sp = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %is
  %sv = load i8, i8* %sp, align 1
  %sv.z = zext i8 %sv to i32
  %sb.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i32 0, i32 %sv.z
  %sv.sb = load i8, i8* %sb.ptr, align 1
  store i8 %sv.sb, i8* %sp, align 1
  %is.next = add nuw nsw i32 %is, 1
  %cond.sb = icmp sle i32 %is, 14
  br i1 %cond.sb, label %subbytes, label %subbytes.tail

subbytes.tail:                                       ; preds = %subbytes
  %sp15.t = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 15
  %sv15 = load i8, i8* %sp15.t, align 1
  %sv15.z = zext i8 %sv15 to i32
  %sb15.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i32 0, i32 %sv15.z
  %sv15.sb = load i8, i8* %sb15.ptr, align 1
  store i8 %sv15.sb, i8* %sp15.t, align 1

  ; ShiftRows
  ; Load all 16
  %s0p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 0
  %s4p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 4
  %s8p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 8
  %s12p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 12
  %s1p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 1
  %s5p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 5
  %s9p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 9
  %s13p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 13
  %s2p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 2
  %s6p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 6
  %s10p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 10
  %s14p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 14
  %s3p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 3
  %s7p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 7
  %s11p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 11
  %s15p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 15

  %s0 = load i8, i8* %s0p, align 1
  %s4 = load i8, i8* %s4p, align 1
  %s8 = load i8, i8* %s8p, align 1
  %s12 = load i8, i8* %s12p, align 1
  %s1 = load i8, i8* %s1p, align 1
  %s5 = load i8, i8* %s5p, align 1
  %s9 = load i8, i8* %s9p, align 1
  %s13 = load i8, i8* %s13p, align 1
  %s2 = load i8, i8* %s2p, align 1
  %s6 = load i8, i8* %s6p, align 1
  %s10 = load i8, i8* %s10p, align 1
  %s14 = load i8, i8* %s14p, align 1
  %s3 = load i8, i8* %s3p, align 1
  %s7 = load i8, i8* %s7p, align 1
  %s11 = load i8, i8* %s11p, align 1
  %s15 = load i8, i8* %s15p, align 1

  ; Row 0: 0,4,8,12 unchanged
  store i8 %s0, i8* %s0p, align 1
  store i8 %s4, i8* %s4p, align 1
  store i8 %s8, i8* %s8p, align 1
  store i8 %s12, i8* %s12p, align 1
  ; Row 1 shift left by 1: 1,5,9,13 -> 5,9,13,1
  store i8 %s5, i8* %s1p, align 1
  store i8 %s9, i8* %s5p, align 1
  store i8 %s13, i8* %s9p, align 1
  store i8 %s1, i8* %s13p, align 1
  ; Row 2 shift left by 2: 2,6,10,14 -> 10,14,2,6
  store i8 %s10, i8* %s2p, align 1
  store i8 %s14, i8* %s6p, align 1
  store i8 %s2, i8* %s10p, align 1
  store i8 %s6, i8* %s14p, align 1
  ; Row 3 shift left by 3: 3,7,11,15 -> 15,3,7,11
  store i8 %s15, i8* %s3p, align 1
  store i8 %s3, i8* %s7p, align 1
  store i8 %s7, i8* %s11p, align 1
  store i8 %s11, i8* %s15p, align 1

  ; MixColumns on 4 columns
  br label %mixcol

mixcol:                                              ; preds = %mixcol, %subbytes.tail
  %c = phi i32 [ 0, %subbytes.tail ], [ %c.next, %mixcol ]
  %base = mul nuw nsw i32 %c, 4
  %b0i = add nuw nsw i32 %base, 0
  %b1i = add nuw nsw i32 %base, 1
  %b2i = add nuw nsw i32 %base, 2
  %b3i = add nuw nsw i32 %base, 3
  %b0p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %b0i
  %b1p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %b1i
  %b2p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %b2i
  %b3p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %b3i
  %a0 = load i8, i8* %b0p, align 1
  %a1 = load i8, i8* %b1p, align 1
  %a2 = load i8, i8* %b2p, align 1
  %a3 = load i8, i8* %b3p, align 1
  %a0z = zext i8 %a0 to i32
  %a1z = zext i8 %a1 to i32
  %a2z = zext i8 %a2 to i32
  %a3z = zext i8 %a3 to i32
  %tmp01 = xor i32 %a0z, %a1z
  %tmp23 = xor i32 %a2z, %a3z
  %tmp = xor i32 %tmp01, %tmp23

  ; new a0 = a0 ^ xtime(a0^a1) ^ tmp
  %t01 = %tmp01
  %carry0 = lshr i32 %t01, 7
  %carry0.and = and i32 %carry0, 1
  %t01sh = shl i32 %t01, 1
  %t01sh.mask = and i32 %t01sh, 255
  %c0.mul = mul nuw nsw i32 %carry0.and, 27
  %xt0 = xor i32 %t01sh.mask, %c0.mul
  %n0 = xor i32 %a0z, %xt0
  %n0f = xor i32 %n0, %tmp
  %n0b = trunc i32 %n0f to i8
  store i8 %n0b, i8* %b0p, align 1

  ; new a1 = a1 ^ xtime(a1^a2) ^ tmp
  %t12 = xor i32 %a1z, %a2z
  %carry1 = lshr i32 %t12, 7
  %carry1.and = and i32 %carry1, 1
  %t12sh = shl i32 %t12, 1
  %t12sh.mask = and i32 %t12sh, 255
  %c1.mul = mul nuw nsw i32 %carry1.and, 27
  %xt1 = xor i32 %t12sh.mask, %c1.mul
  %n1 = xor i32 %a1z, %xt1
  %n1f = xor i32 %n1, %tmp
  %n1b = trunc i32 %n1f to i8
  store i8 %n1b, i8* %b1p, align 1

  ; new a2 = a2 ^ xtime(a2^a3) ^ tmp
  %t23b = xor i32 %a2z, %a3z
  %carry2 = lshr i32 %t23b, 7
  %carry2.and = and i32 %carry2, 1
  %t23sh = shl i32 %t23b, 1
  %t23sh.mask = and i32 %t23sh, 255
  %c2.mul = mul nuw nsw i32 %carry2.and, 27
  %xt2 = xor i32 %t23sh.mask, %c2.mul
  %n2 = xor i32 %a2z, %xt2
  %n2f = xor i32 %n2, %tmp
  %n2b = trunc i32 %n2f to i8
  store i8 %n2b, i8* %b2p, align 1

  ; new a3 = a3 ^ xtime(a3^a0) ^ tmp
  %t30 = xor i32 %a3z, %a0z
  %carry3 = lshr i32 %t30, 7
  %carry3.and = and i32 %carry3, 1
  %t30sh = shl i32 %t30, 1
  %t30sh.mask = and i32 %t30sh, 255
  %c3.mul = mul nuw nsw i32 %carry3.and, 27
  %xt3 = xor i32 %t30sh.mask, %c3.mul
  %n3 = xor i32 %a3z, %xt3
  %n3f = xor i32 %n3, %tmp
  %n3b = trunc i32 %n3f to i8
  store i8 %n3b, i8* %b3p, align 1

  %c.next = add nuw nsw i32 %c, 1
  %cont.mc = icmp sle i32 %c, 2
  br i1 %cont.mc, label %mixcol, label %arkN

arkN:                                                ; preds = %mixcol
  ; AddRoundKey for round %round
  %rkoff = shl nuw nsw i32 %round, 4
  br label %arkN.loop

arkN.loop:                                           ; preds = %arkN.loop, %arkN
  %j = phi i32 [ 0, %arkN ], [ %j.next, %arkN.loop ]
  %spN = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %j
  %sbN = load i8, i8* %spN, align 1
  %joff = add nuw nsw i32 %j, %rkoff
  %rkpN = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 %joff
  %kbN = load i8, i8* %rkpN, align 1
  %xbN = xor i8 %sbN, %kbN
  store i8 %xbN, i8* %spN, align 1
  %j.next = add nuw nsw i32 %j, 1
  %cont.arkN = icmp sle i32 %j, 14
  br i1 %cont.arkN, label %arkN.loop, label %round.next.chk

round.next.chk:                                      ; preds = %arkN.loop
  ; last byte
  %spN15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 15
  %sbN15 = load i8, i8* %spN15, align 1
  %j15off = add nuw nsw i32 15, %rkoff
  %rkpN15 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 %j15off
  %kbN15 = load i8, i8* %rkpN15, align 1
  %xbN15 = xor i8 %sbN15, %kbN15
  store i8 %xbN15, i8* %spN15, align 1

  %round.next = add nuw nsw i32 %round, 1
  %cont.rounds = icmp sle i32 %round, 9
  br i1 %cont.rounds, label %round.loop, label %final.round

final.round:                                         ; preds = %round.next.chk
  ; Final round: SubBytes, ShiftRows, AddRoundKey with offset 160
  ; SubBytes
  br label %subbytesF

subbytesF:                                           ; preds = %subbytesF, %final.round
  %fi = phi i32 [ 0, %final.round ], [ %fi.next, %subbytesF ]
  %fsp = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %fi
  %fsv = load i8, i8* %fsp, align 1
  %fsv.z = zext i8 %fsv to i32
  %fsb.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i32 0, i32 %fsv.z
  %fsv.sb = load i8, i8* %fsb.ptr, align 1
  store i8 %fsv.sb, i8* %fsp, align 1
  %fi.next = add nuw nsw i32 %fi, 1
  %cont.fsb = icmp sle i32 %fi, 14
  br i1 %cont.fsb, label %subbytesF, label %subbytesF.tail

subbytesF.tail:                                      ; preds = %subbytesF
  %fsp15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 15
  %fsv15 = load i8, i8* %fsp15, align 1
  %fsv15.z = zext i8 %fsv15 to i32
  %fsb15.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i32 0, i32 %fsv15.z
  %fsv15.sb = load i8, i8* %fsb15.ptr, align 1
  store i8 %fsv15.sb, i8* %fsp15, align 1

  ; ShiftRows (same as above)
  %fs0 = load i8, i8* %s0p, align 1
  %fs4 = load i8, i8* %s4p, align 1
  %fs8 = load i8, i8* %s8p, align 1
  %fs12 = load i8, i8* %s12p, align 1
  %fs1 = load i8, i8* %s1p, align 1
  %fs5 = load i8, i8* %s5p, align 1
  %fs9 = load i8, i8* %s9p, align 1
  %fs13 = load i8, i8* %s13p, align 1
  %fs2 = load i8, i8* %s2p, align 1
  %fs6 = load i8, i8* %s6p, align 1
  %fs10 = load i8, i8* %s10p, align 1
  %fs14 = load i8, i8* %s14p, align 1
  %fs3 = load i8, i8* %s3p, align 1
  %fs7 = load i8, i8* %s7p, align 1
  %fs11 = load i8, i8* %s11p, align 1
  %fs15 = load i8, i8* %s15p, align 1

  store i8 %fs0, i8* %s0p, align 1
  store i8 %fs4, i8* %s4p, align 1
  store i8 %fs8, i8* %s8p, align 1
  store i8 %fs12, i8* %s12p, align 1
  store i8 %fs5, i8* %s1p, align 1
  store i8 %fs9, i8* %s5p, align 1
  store i8 %fs13, i8* %s9p, align 1
  store i8 %fs1, i8* %s13p, align 1
  store i8 %fs10, i8* %s2p, align 1
  store i8 %fs14, i8* %s6p, align 1
  store i8 %fs2, i8* %s10p, align 1
  store i8 %fs6, i8* %s14p, align 1
  store i8 %fs15, i8* %s3p, align 1
  store i8 %fs3, i8* %s7p, align 1
  store i8 %fs7, i8* %s11p, align 1
  store i8 %fs11, i8* %s15p, align 1

  ; AddRoundKey with offset 160 (10*16)
  br label %arkF

arkF:                                                ; preds = %arkF, %subbytesF.tail
  %jf = phi i32 [ 0, %subbytesF.tail ], [ %jf.next, %arkF ]
  %spF = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %jf
  %sbF = load i8, i8* %spF, align 1
  %jfo = add nuw nsw i32 %jf, 160
  %rkpF = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i32 0, i32 %jfo
  %kbF = load i8, i8* %rkpF, align 1
  %xbF = xor i8 %sbF, %kbF
  store i8 %xbF, i8* %spF, align 1
  %jf.next = add nuw nsw i32 %jf, 1
  %cont.arf = icmp sle i32 %jf, 14
  br i1 %cont.arf, label %arkF, label %store.out

store.out:                                           ; preds = %arkF
  ; last byte
  %spF15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 15
  %sbF15 = load i8, i8* %spF15, align 1
  %out15 = getelementptr inbounds i8, i8* %out, i32 15
  store i8 %sbF15, i8* %out15, align 1

  ; store bytes 0..14
  br label %store.loop

store.loop:                                          ; preds = %store.loop, %store.out
  %so = phi i32 [ 0, %store.out ], [ %so.next, %store.loop ]
  %spS = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %so
  %sbS = load i8, i8* %spS, align 1
  %op = getelementptr inbounds i8, i8* %out, i32 %so
  store i8 %sbS, i8* %op, align 1
  %so.next = add nuw nsw i32 %so, 1
  %cont.store = icmp sle i32 %so, 14
  br i1 %cont.store, label %store.loop, label %ret

ret:                                                  ; preds = %store.loop
  ret void
}