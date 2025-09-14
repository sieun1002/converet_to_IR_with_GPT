; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt ; Address: 0x11A9
; Intent: AES-128 single-block encrypt (ECB) (confidence=0.98). Evidence: key schedule with rcon/sbox, 9 rounds with MixColumns, final round without MixColumns
; Preconditions: out, in, key point to at least 16 bytes; sbox_1 is 256-byte S-box; rcon_0 provides round constants
; Postconditions: writes 16-byte ciphertext to out

@sbox_1 = external constant [256 x i8], align 16
@rcon_0 = external constant [256 x i8], align 16

define dso_local void @aes128_encrypt(i8* nocapture %out, i8* nocapture readonly %in, i8* nocapture readonly %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %rk = alloca [176 x i8], align 16

  ; state <- in[0..15]
  br label %copy_in.loop

copy_in.loop: ; i = 0..15
  %i.ci = phi i32 [ 0, %entry ], [ %i.ci.next, %copy_in.body ]
  %i.ci.ext = zext i32 %i.ci to i64
  %in.ptr.i = getelementptr inbounds i8, i8* %in, i64 %i.ci.ext
  %in.val.i = load i8, i8* %in.ptr.i, align 1
  %st.ptr.i = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.ci.ext
  store i8 %in.val.i, i8* %st.ptr.i, align 1
  br label %copy_in.body

copy_in.body:
  %i.ci.next = add nuw nsw i32 %i.ci, 1
  %ci.cond = icmp sle i32 %i.ci, 14
  br i1 %ci.cond, label %copy_in.loop, label %copy_key.loop

; rk[0..15] <- key[0..15]
copy_key.loop:
  %i.ck = phi i32 [ 0, %copy_in.body ], [ %i.ck.next, %copy_key.body ]
  %i.ck.ext = zext i32 %i.ck to i64
  %key.ptr.i = getelementptr inbounds i8, i8* %key, i64 %i.ck.ext
  %key.val.i = load i8, i8* %key.ptr.i, align 1
  %rk.ptr.i = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.ck.ext
  store i8 %key.val.i, i8* %rk.ptr.i, align 1
  br label %copy_key.body

copy_key.body:
  %i.ck.next = add nuw nsw i32 %i.ck, 1
  %ck.cond = icmp sle i32 %i.ck, 14
  br i1 %ck.cond, label %copy_key.loop, label %kexp.init

; Key expansion
kexp.init:
  %i.ke = phi i32 [ 16, %copy_key.body ], [ %i.ke.next, %kexp.step4 ]
  %rci = phi i32 [ 0, %copy_key.body ], [ %rci.next, %kexp.step4 ]
  br label %kexp.loop

kexp.loop:
  %i.ke.le = icmp sle i32 %i.ke, 175
  br i1 %i.ke.le, label %kexp.body, label %post_kexp

kexp.body:
  ; load previous 4 bytes
  %i.m4 = add nsw i32 %i.ke, -4
  %i.m3 = add nsw i32 %i.ke, -3
  %i.m2 = add nsw i32 %i.ke, -2
  %i.m1 = add nsw i32 %i.ke, -1
  %i.m4.z = zext i32 %i.m4 to i64
  %i.m3.z = zext i32 %i.m3 to i64
  %i.m2.z = zext i32 %i.m2 to i64
  %i.m1.z = zext i32 %i.m1 to i64
  %p4.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m4.z
  %p3.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m3.z
  %p2.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m2.z
  %p1.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m1.z
  %a0 = load i8, i8* %p4.ptr, align 1
  %a1 = load i8, i8* %p3.ptr, align 1
  %a2 = load i8, i8* %p2.ptr, align 1
  %a3 = load i8, i8* %p1.ptr, align 1
  ; if (i & 0x0f) == 0
  %i.and = and i32 %i.ke, 15
  %cond.subw = icmp eq i32 %i.and, 0
  br i1 %cond.subw, label %kexp.subw, label %kexp.gen

kexp.subw:
  ; RotWord
  %ra0 = select i1 true, i8 %a1, i8 %a1
  %ra1 = select i1 true, i8 %a2, i8 %a2
  %ra2 = select i1 true, i8 %a3, i8 %a3
  %ra3 = select i1 true, i8 %a0, i8 %a0
  ; SubWord via sbox
  %ra0.z = zext i8 %ra0 to i64
  %ra1.z = zext i8 %ra1 to i64
  %ra2.z = zext i8 %ra2 to i64
  %ra3.z = zext i8 %ra3 to i64
  %sbox.base = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 0
  %sb0.ptr = getelementptr inbounds i8, i8* %sbox.base, i64 %ra0.z
  %sb1.ptr = getelementptr inbounds i8, i8* %sbox.base, i64 %ra1.z
  %sb2.ptr = getelementptr inbounds i8, i8* %sbox.base, i64 %ra2.z
  %sb3.ptr = getelementptr inbounds i8, i8* %sbox.base, i64 %ra3.z
  %sb0 = load i8, i8* %sb0.ptr, align 1
  %sb1 = load i8, i8* %sb1.ptr, align 1
  %sb2 = load i8, i8* %sb2.ptr, align 1
  %sb3 = load i8, i8* %sb3.ptr, align 1
  ; XOR rcon into first byte, rcon index uses current rci then rci++
  %rci.z64 = zext i32 %rci to i64
  %rcon.base = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 0
  %rcon.ptr = getelementptr inbounds i8, i8* %rcon.base, i64 %rci.z64
  %rcon.val = load i8, i8* %rcon.ptr, align 1
  %sb0.x = xor i8 %sb0, %rcon.val
  %rci.next = add nuw nsw i32 %rci, 1
  br label %kexp.gen

kexp.gen:
  ; choose temp bytes (either original a* or substituted/rotated)
  %sel0 = phi i8 [ %sb0.x, %kexp.subw ], [ %a0, %kexp.body ]
  %sel1 = phi i8 [ %sb1,   %kexp.subw ], [ %a1, %kexp.body ]
  %sel2 = phi i8 [ %sb2,   %kexp.subw ], [ %a2, %kexp.body ]
  %sel3 = phi i8 [ %sb3,   %kexp.subw ], [ %a3, %kexp.body ]

  ; rk[i + j] = rk[i - 16 + j] XOR sel[j]
  %i.m16 = add nsw i32 %i.ke, -16
  %i.m15 = add nsw i32 %i.ke, -15
  %i.m14 = add nsw i32 %i.ke, -14
  %i.m13 = add nsw i32 %i.ke, -13
  %i.z = zext i32 %i.ke to i64
  %im16.z = zext i32 %i.m16 to i64
  %im15.z = zext i32 %i.m15 to i64
  %im14.z = zext i32 %i.m14 to i64
  %im13.z = zext i32 %i.m13 to i64

  %src0.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %im16.z
  %src1.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %im15.z
  %src2.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %im14.z
  %src3.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %im13.z
  %src0 = load i8, i8* %src0.ptr, align 1
  %src1 = load i8, i8* %src1.ptr, align 1
  %src2 = load i8, i8* %src2.ptr, align 1
  %src3 = load i8, i8* %src3.ptr, align 1
  %x0 = xor i8 %src0, %sel0
  %x1 = xor i8 %src1, %sel1
  %x2 = xor i8 %src2, %sel2
  %x3 = xor i8 %src3, %sel3

  %dst0.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.z
  store i8 %x0, i8* %dst0.ptr, align 1
  %i.p1 = add nuw nsw i32 %i.ke, 1
  %i.p1.z = zext i32 %i.p1 to i64
  %dst1.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.p1.z
  store i8 %x1, i8* %dst1.ptr, align 1
  %i.p2 = add nuw nsw i32 %i.ke, 2
  %i.p2.z = zext i32 %i.p2 to i64
  %dst2.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.p2.z
  store i8 %x2, i8* %dst2.ptr, align 1
  %i.p3 = add nuw nsw i32 %i.ke, 3
  %i.p3.z = zext i32 %i.p3 to i64
  %dst3.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.p3.z
  store i8 %x3, i8* %dst3.ptr, align 1

  br label %kexp.step4

kexp.step4:
  %i.ke.next = add nuw nsw i32 %i.ke, 4
  br label %kexp.loop

post_kexp:
  ; Initial AddRoundKey with rk[0..15]
  br label %ark0.loop

ark0.loop:
  %i0 = phi i32 [ 0, %post_kexp ], [ %i0.next, %ark0.body ]
  %i0.z = zext i32 %i0 to i64
  %st.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i0.z
  %st.v = load i8, i8* %st.p, align 1
  %rk0.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i0.z
  %rk0.v = load i8, i8* %rk0.p, align 1
  %st.x = xor i8 %st.v, %rk0.v
  store i8 %st.x, i8* %st.p, align 1
  br label %ark0.body

ark0.body:
  %i0.next = add nuw nsw i32 %i0, 1
  %ark0.cond = icmp sle i32 %i0, 14
  br i1 %ark0.cond, label %ark0.loop, label %rounds.init

; Rounds 1..9
rounds.init:
  %r = phi i32 [ 1, %ark0.body ], [ %r.next, %ark_end ]
  br label %rounds.loop

rounds.loop:
  %r.le = icmp sle i32 %r, 9
  br i1 %r.le, label %round_subbytes, label %final_round

; SubBytes
round_subbytes:
  br label %sb.loop

sb.loop:
  %is = phi i32 [ 0, %round_subbytes ], [ %is.next, %sb.body ]
  %is.z = zext i32 %is to i64
  %p.si = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %is.z
  %v.si = load i8, i8* %p.si, align 1
  %v.si.z = zext i8 %v.si to i64
  %sb.base.r = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 0
  %sb.ptr.r = getelementptr inbounds i8, i8* %sb.base.r, i64 %v.si.z
  %sb.val.r = load i8, i8* %sb.ptr.r, align 1
  store i8 %sb.val.r, i8* %p.si, align 1
  br label %sb.body

sb.body:
  %is.next = add nuw nsw i32 %is, 1
  %sb.cond = icmp sle i32 %is, 14
  br i1 %sb.cond, label %sb.loop, label %shiftrows

; ShiftRows (as in assembly)
shiftrows:
  ; Row 1: [1,5,9,13] left by 1
  %p1  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %p5  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %p9  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %p13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %v1  = load i8, i8* %p1, align 1
  %v5  = load i8, i8* %p5, align 1
  %v9  = load i8, i8* %p9, align 1
  %v13 = load i8, i8* %p13, align 1
  store i8 %v5,  i8* %p1, align 1
  store i8 %v9,  i8* %p5, align 1
  store i8 %v13, i8* %p9, align 1
  store i8 %v1,  i8* %p13, align 1
  ; Row 2: [2,6,10,14] left by 2 (swap pairs)
  %p2  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %p6  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %p10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %p14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %v2  = load i8, i8* %p2, align 1
  %v10 = load i8, i8* %p10, align 1
  store i8 %v10, i8* %p2, align 1
  store i8 %v2,  i8* %p10, align 1
  %v6  = load i8, i8* %p6, align 1
  %v14 = load i8, i8* %p14, align 1
  store i8 %v14, i8* %p6, align 1
  store i8 %v6,  i8* %p14, align 1
  ; Row 3: [3,7,11,15] left by 1 (as per disassembly)
  %p3  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %p7  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %p11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %p15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %v3  = load i8, i8* %p3, align 1
  %v7  = load i8, i8* %p7, align 1
  %v11 = load i8, i8* %p11, align 1
  %v15 = load i8, i8* %p15, align 1
  store i8 %v7,  i8* %p3, align 1
  store i8 %v11, i8* %p7, align 1
  store i8 %v15, i8* %p11, align 1
  store i8 %v3,  i8* %p15, align 1
  br label %mixcols.init

; MixColumns for 4 columns
mixcols.init:
  %c = phi i32 [ 0, %shiftrows ], [ %c.next, %mixcols.endcol ]
  br label %mixcols.loop

mixcols.loop:
  %c.le = icmp sle i32 %c, 3
  br i1 %c.le, label %mixcols.body, label %ark_round

mixcols.body:
  %base = mul nuw nsw i32 %c, 4
  %b0i = zext i32 %base to i64
  %b1i = zext i32 (add i32 %base, 1) to i64
  %b2i = zext i32 (add i32 %base, 2) to i64
  %b3i = zext i32 (add i32 %base, 3) to i64
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
  %t   = xor i8 %t01, %t23

  ; new s0 = s0 ^ xtime(s0^s1) ^ t
  %x01 = and i8 %t01, -1
  %xt01 = shl i8 %x01, 1
  %c01 = lshr i8 %x01, 7
  %c01.w = mul i8 %c01, 27
  %xt01r = xor i8 %xt01, %c01.w
  %n0.t = xor i8 %s0, %xt01r
  %n0 = xor i8 %n0.t, %t
  store i8 %n0, i8* %p0, align 1

  ; new s1 = s1 ^ xtime(s1^s2) ^ t
  %x12 = xor i8 %s1, %s2
  %xt12 = shl i8 %x12, 1
  %c12 = lshr i8 %x12, 7
  %c12.w = mul i8 %c12, 27
  %xt12r = xor i8 %xt12, %c12.w
  %n1.t = xor i8 %s1, %xt12r
  %n1 = xor i8 %n1.t, %t
  store i8 %n1, i8* %p1, align 1

  ; new s2 = s2 ^ xtime(s2^s3) ^ t
  %x23 = xor i8 %s2, %s3
  %xt23 = shl i8 %x23, 1
  %c23 = lshr i8 %x23, 7
  %c23.w = mul i8 %c23, 27
  %xt23r = xor i8 %xt23, %c23.w
  %n2.t = xor i8 %s2, %xt23r
  %n2 = xor i8 %n2.t, %t
  store i8 %n2, i8* %p2, align 1

  ; new s3 = s3 ^ xtime(s3^s0) ^ t
  %x30 = xor i8 %s3, %s0
  %xt30 = shl i8 %x30, 1
  %c30 = lshr i8 %x30, 7
  %c30.w = mul i8 %c30, 27
  %xt30r = xor i8 %xt30, %c30.w
  %n3.t = xor i8 %s3, %xt30r
  %n3 = xor i8 %n3.t, %t
  store i8 %n3, i8* %p3, align 1

  br label %mixcols.endcol

mixcols.endcol:
  %c.next = add nuw nsw i32 %c, 1
  br label %mixcols.loop

; AddRoundKey for round r
ark_round:
  %off = shl i32 %r, 4
  br label %arkr.loop

arkr.loop:
  %j = phi i32 [ 0, %ark_round ], [ %j.next, %arkr.body ]
  %j.z = zext i32 %j to i64
  %st.p.r = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %j.z
  %st.v.r = load i8, i8* %st.p.r, align 1
  %idx.rk = add nuw nsw i32 %off, %j
  %idx.rk.z = zext i32 %idx.rk to i64
  %rk.p.r = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %idx.rk.z
  %rk.v.r = load i8, i8* %rk.p.r, align 1
  %st.x.r = xor i8 %st.v.r, %rk.v.r
  store i8 %st.x.r, i8* %st.p.r, align 1
  br label %arkr.body

arkr.body:
  %j.next = add nuw nsw i32 %j, 1
  %arkr.cond = icmp sle i32 %j, 14
  br i1 %arkr.cond, label %arkr.loop, label %ark_end

ark_end:
  %r.next = add nuw nsw i32 %r, 1
  br label %rounds.loop

; Final round: SubBytes, ShiftRows, AddRoundKey with offset 160
final_round:
  ; SubBytes
  br label %fsb.loop

fsb.loop:
  %k = phi i32 [ 0, %final_round ], [ %k.next, %fsb.body ]
  %k.z = zext i32 %k to i64
  %p.k = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %k.z
  %v.k = load i8, i8* %p.k, align 1
  %v.k.z = zext i8 %v.k to i64
  %sb.base.f = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 0
  %sb.ptr.f = getelementptr inbounds i8, i8* %sb.base.f, i64 %v.k.z
  %sb.val.f = load i8, i8* %sb.ptr.f, align 1
  store i8 %sb.val.f, i8* %p.k, align 1
  br label %fsb.body

fsb.body:
  %k.next = add nuw nsw i32 %k, 1
  %fsb.cond = icmp sle i32 %k, 14
  br i1 %fsb.cond, label %fsb.loop, label %fshift

fshift:
  ; Row 1
  %fp1  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %fp5  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %fp9  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %fp13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %fv1  = load i8, i8* %fp1, align 1
  %fv5  = load i8, i8* %fp5, align 1
  %fv9  = load i8, i8* %fp9, align 1
  %fv13 = load i8, i8* %fp13, align 1
  store i8 %fv5,  i8* %fp1, align 1
  store i8 %fv9,  i8* %fp5, align 1
  store i8 %fv13, i8* %fp9, align 1
  store i8 %fv1,  i8* %fp13, align 1
  ; Row 2
  %fp2  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %fp6  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %fp10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %fp14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %fv2  = load i8, i8* %fp2, align 1
  %fv10 = load i8, i8* %fp10, align 1
  store i8 %fv10, i8* %fp2, align 1
  store i8 %fv2,  i8* %fp10, align 1
  %fv6  = load i8, i8* %fp6, align 1
  %fv14 = load i8, i8* %fp14, align 1
  store i8 %fv14, i8* %fp6, align 1
  store i8 %fv6,  i8* %fp14, align 1
  ; Row 3
  %fp3  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %fp7  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %fp11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %fp15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %fv3  = load i8, i8* %fp3, align 1
  %fv7  = load i8, i8* %fp7, align 1
  %fv11 = load i8, i8* %fp11, align 1
  %fv15 = load i8, i8* %fp15, align 1
  store i8 %fv7,  i8* %fp3, align 1
  store i8 %fv11, i8* %fp7, align 1
  store i8 %fv15, i8* %fp11, align 1
  store i8 %fv3,  i8* %fp15, align 1
  br label %final_ark

final_ark:
  ; offset 0xA0 = 160
  br label %fark.loop

fark.loop:
  %m = phi i32 [ 0, %final_ark ], [ %m.next, %fark.body ]
  %m.z = zext i32 %m to i64
  %st.p.f = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %m.z
  %st.v.f = load i8, i8* %st.p.f, align 1
  %idx.f = add nuw nsw i32 %m, 160
  %idx.f.z = zext i32 %idx.f to i64
  %rk.p.f = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %idx.f.z
  %rk.v.f = load i8, i8* %rk.p.f, align 1
  %st.x.f = xor i8 %st.v.f, %rk.v.f
  store i8 %st.x.f, i8* %st.p.f, align 1
  br label %fark.body

fark.body:
  %m.next = add nuw nsw i32 %m, 1
  %fark.cond = icmp sle i32 %m, 14
  br i1 %fark.cond, label %fark.loop, label %write_out

; Write state to out
write_out:
  br label %wo.loop

wo.loop:
  %w = phi i32 [ 0, %write_out ], [ %w.next, %wo.body ]
  %w.z = zext i32 %w to i64
  %st.p.w = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %w.z
  %v.w = load i8, i8* %st.p.w, align 1
  %out.p.w = getelementptr inbounds i8, i8* %out, i64 %w.z
  store i8 %v.w, i8* %out.p.w, align 1
  br label %wo.body

wo.body:
  %w.next = add nuw nsw i32 %w, 1
  %wo.cond = icmp sle i32 %w, 14
  br i1 %wo.cond, label %wo.loop, label %done

done:
  ret void
}