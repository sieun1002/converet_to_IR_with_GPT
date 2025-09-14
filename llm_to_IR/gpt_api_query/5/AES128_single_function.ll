; target triple for Linux x86_64
target triple = "x86_64-unknown-linux-gnu"

@sbox_1 = external dso_local global [256 x i8], align 16
@rcon_0 = external dso_local global [256 x i8], align 16

; xtime in GF(2^8) with AES polynomial (0x1b)
define internal fastcc i8 @xtime(i8 %x) {
entry:
  %x32 = zext i8 %x to i32
  %shl = shl i32 %x32, 1
  %msb = and i32 %x32, 128
  %msbbool = icmp ne i32 %msb, 0
  %mask = select i1 %msbbool, i32 27, i32 0
  %val = xor i32 %shl, %mask
  %res = and i32 %val, 255
  %ret = trunc i32 %res to i8
  ret i8 %ret
}

define dso_local void @aes128_encrypt(i8* nocapture %out, i8* nocapture readonly %in, i8* nocapture readonly %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %w = alloca [176 x i8], align 16

  ; copy input to state
  br label %Lcopy_in
Lcopy_in:
  %i_in = phi i32 [ 0, %entry ], [ %i_in.next, %Lcopy_in.body ]
  %cmp_in = icmp sle i32 %i_in, 15
  br i1 %cmp_in, label %Lcopy_in.body, label %Lcopy_in.end
Lcopy_in.body:
  %in.ptr = getelementptr inbounds i8, i8* %in, i32 %i_in
  %b.in = load i8, i8* %in.ptr, align 1
  %st.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %i_in
  store i8 %b.in, i8* %st.ptr, align 1
  %i_in.next = add nsw i32 %i_in, 1
  br label %Lcopy_in
Lcopy_in.end:

  ; copy key (16 bytes) into expanded key buffer w
  br label %Lcopy_key
Lcopy_key:
  %i_key = phi i32 [ 0, %Lcopy_in.end ], [ %i_key.next, %Lcopy_key.body ]
  %cmp_key = icmp sle i32 %i_key, 15
  br i1 %cmp_key, label %Lcopy_key.body, label %Lcopy_key.end
Lcopy_key.body:
  %k.ptr = getelementptr inbounds i8, i8* %key, i32 %i_key
  %b.key = load i8, i8* %k.ptr, align 1
  %w.k.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %i_key
  store i8 %b.key, i8* %w.k.ptr, align 1
  %i_key.next = add nsw i32 %i_key, 1
  br label %Lcopy_key
Lcopy_key.end:

  ; key expansion
  br label %Lkexp
Lkexp:
  %i = phi i32 [ 16, %Lcopy_key.end ], [ %i.next, %Lkexp.end ]
  %rc = phi i32 [ 0, %Lcopy_key.end ], [ %rc.next, %Lkexp.end ]
  %cmp_i = icmp sle i32 %i, 175
  br i1 %cmp_i, label %Lkexp.body, label %Lkexp.done

Lkexp.body:
  ; load temp = w[i-4..i-1]
  %im4 = add nsw i32 %i, -4
  %im3 = add nsw i32 %i, -3
  %im2 = add nsw i32 %i, -2
  %im1 = add nsw i32 %i, -1
  %t0.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %im4
  %t1.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %im3
  %t2.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %im2
  %t3.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %im1
  %t0 = load i8, i8* %t0.ptr, align 1
  %t1 = load i8, i8* %t1.ptr, align 1
  %t2 = load i8, i8* %t2.ptr, align 1
  %t3 = load i8, i8* %t3.ptr, align 1

  ; if ((i & 0x0f) == 0) rotate, subbytes and rcon
  %i.and = and i32 %i, 15
  %i.zero = icmp eq i32 %i.and, 0
  br i1 %i.zero, label %Lkexp.special, label %Lkexp.nospecial

Lkexp.special:
  ; RotWord: (t0,t1,t2,t3) -> (t1,t2,t3,t0)
  %rt0 = %t1
  %rt1 = %t2
  %rt2 = %t3
  %rt3 = %t0
  ; SubWord with sbox
  ; sbox[rt0]
  %rt0.z = zext i8 %rt0 to i64
  %sbox.base0 = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt0.z
  %rt0.sb = load i8, i8* %sbox.base0, align 1
  ; sbox[rt1]
  %rt1.z = zext i8 %rt1 to i64
  %sbox.base1 = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt1.z
  %rt1.sb = load i8, i8* %sbox.base1, align 1
  ; sbox[rt2]
  %rt2.z = zext i8 %rt2 to i64
  %sbox.base2 = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt2.z
  %rt2.sb = load i8, i8* %sbox.base2, align 1
  ; sbox[rt3]
  %rt3.z = zext i8 %rt3 to i64
  %sbox.base3 = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt3.z
  %rt3.sb = load i8, i8* %sbox.base3, align 1
  ; rcon[rc], then rc = rc + 1
  %rc.z = zext i32 %rc to i64
  %rcon.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 %rc.z
  %r = load i8, i8* %rcon.ptr, align 1
  %rt0.sb.i32 = zext i8 %rt0.sb to i32
  %r.i32 = zext i8 %r to i32
  %rt0.x = xor i32 %rt0.sb.i32, %r.i32
  %rt0.fin = trunc i32 %rt0.x to i8
  %rc.next.sp = add nuw nsw i32 %rc, 1
  br label %Lkexp.merge

Lkexp.nospecial:
  ; keep temp as-is
  br label %Lkexp.merge

Lkexp.merge:
  %rc.phi = phi i32 [ %rc.next.sp, %Lkexp.special ], [ %rc, %Lkexp.nospecial ]
  %t0.phi = phi i8 [ %rt0.fin, %Lkexp.special ], [ %t0, %Lkexp.nospecial ]
  %t1.phi = phi i8 [ %rt1.sb,  %Lkexp.special ], [ %t1, %Lkexp.nospecial ]
  %t2.phi = phi i8 [ %rt2.sb,  %Lkexp.special ], [ %t2, %Lkexp.nospecial ]
  %t3.phi = phi i8 [ %rt3.sb,  %Lkexp.special ], [ %t3, %Lkexp.nospecial ]

  ; w[i+j] = w[i-16+j] ^ t[j] for j=0..3
  %im16 = add nsw i32 %i, -16
  ; j=0
  %w_im16_0 = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %im16
  %w_i_0 = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %i
  %v_im16_0 = load i8, i8* %w_im16_0, align 1
  %v_im16_0.z = zext i8 %v_im16_0 to i32
  %t0.z2 = zext i8 %t0.phi to i32
  %x0 = xor i32 %v_im16_0.z, %t0.z2
  %x0.t = trunc i32 %x0 to i8
  store i8 %x0.t, i8* %w_i_0, align 1
  ; j=1
  %i1 = add nsw i32 %i, 1
  %im16p1 = add nsw i32 %im16, 1
  %w_im16_1 = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %im16p1
  %w_i_1 = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %i1
  %v_im16_1 = load i8, i8* %w_im16_1, align 1
  %v_im16_1.z = zext i8 %v_im16_1 to i32
  %t1.z2 = zext i8 %t1.phi to i32
  %x1 = xor i32 %v_im16_1.z, %t1.z2
  %x1.t = trunc i32 %x1 to i8
  store i8 %x1.t, i8* %w_i_1, align 1
  ; j=2
  %i2 = add nsw i32 %i, 2
  %im16p2 = add nsw i32 %im16, 2
  %w_im16_2 = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %im16p2
  %w_i_2 = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %i2
  %v_im16_2 = load i8, i8* %w_im16_2, align 1
  %v_im16_2.z = zext i8 %v_im16_2 to i32
  %t2.z2 = zext i8 %t2.phi to i32
  %x2 = xor i32 %v_im16_2.z, %t2.z2
  %x2.t = trunc i32 %x2 to i8
  store i8 %x2.t, i8* %w_i_2, align 1
  ; j=3
  %i3 = add nsw i32 %i, 3
  %im16p3 = add nsw i32 %im16, 3
  %w_im16_3 = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %im16p3
  %w_i_3 = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %i3
  %v_im16_3 = load i8, i8* %w_im16_3, align 1
  %v_im16_3.z = zext i8 %v_im16_3 to i32
  %t3.z2 = zext i8 %t3.phi to i32
  %x3 = xor i32 %v_im16_3.z, %t3.z2
  %x3.t = trunc i32 %x3 to i8
  store i8 %x3.t, i8* %w_i_3, align 1

  br label %Lkexp.end
Lkexp.end:
  %i.next = add nsw i32 %i, 4
  %rc.next = phi i32 [ %rc.phi, %Lkexp.merge ]
  br label %Lkexp
Lkexp.done:

  ; initial AddRoundKey: state ^= w[0..15]
  br label %Lark0
Lark0:
  %i0 = phi i32 [ 0, %Lkexp.done ], [ %i0.next, %Lark0.body ]
  %cmp0 = icmp sle i32 %i0, 15
  br i1 %cmp0, label %Lark0.body, label %Lark0.end
Lark0.body:
  %stp0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %i0
  %s0 = load i8, i8* %stp0, align 1
  %w0p = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %i0
  %k0 = load i8, i8* %w0p, align 1
  %s0.z = zext i8 %s0 to i32
  %k0.z = zext i8 %k0 to i32
  %sx = xor i32 %s0.z, %k0.z
  %sx.t = trunc i32 %sx to i8
  store i8 %sx.t, i8* %stp0, align 1
  %i0.next = add nsw i32 %i0, 1
  br label %Lark0
Lark0.end:

  ; rounds 1..9
  br label %Lrounds
Lrounds:
  %round = phi i32 [ 1, %Lark0.end ], [ %round.next, %Lrounds.end ]
  %cmpR = icmp sle i32 %round, 9
  br i1 %cmpR, label %Lround.body, label %Lrounds.done

; round body: SubBytes, ShiftRows, MixColumns, AddRoundKey
Lround.body:
  ; SubBytes
  br label %Lsb
Lsb:
  %is = phi i32 [ 0, %Lround.body ], [ %is.next, %Lsb.body ]
  %cmp_sb = icmp sle i32 %is, 15
  br i1 %cmp_sb, label %Lsb.body, label %Lsb.end
Lsb.body:
  %sp = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %is
  %sv = load i8, i8* %sp, align 1
  %sv.z = zext i8 %sv to i64
  %sbox.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %sv.z
  %sbv = load i8, i8* %sbox.ptr, align 1
  store i8 %sbv, i8* %sp, align 1
  %is.next = add nsw i32 %is, 1
  br label %Lsb
Lsb.end:

  ; ShiftRows
  ; Row 1: [1,5,9,13] <- left rotate by 1
  %s1p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 1
  %s5p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 5
  %s9p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 9
  %s13p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 13
  %t15 = load i8, i8* %s1p, align 1
  %v5 = load i8, i8* %s5p, align 1
  %v9 = load i8, i8* %s9p, align 1
  %v13 = load i8, i8* %s13p, align 1
  store i8 %v5, i8* %s1p, align 1
  store i8 %v9, i8* %s5p, align 1
  store i8 %v13, i8* %s9p, align 1
  store i8 %t15, i8* %s13p, align 1
  ; Row 2: [2,6,10,14] rotate left by 2
  %s2p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 2
  %s6p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 6
  %s10p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 10
  %s14p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 14
  %v2 = load i8, i8* %s2p, align 1
  %v6 = load i8, i8* %s6p, align 1
  %v10 = load i8, i8* %s10p, align 1
  %v14 = load i8, i8* %s14p, align 1
  store i8 %v10, i8* %s2p, align 1
  store i8 %v14, i8* %s6p, align 1
  store i8 %v2,  i8* %s10p, align 1
  store i8 %v6,  i8* %s14p, align 1
  ; Row 3: [3,7,11,15] rotate left by 3 (right by 1)
  %s3p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 3
  %s7p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 7
  %s11p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 11
  %s15p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 15
  %v3 = load i8, i8* %s3p, align 1
  %v7 = load i8, i8* %s7p, align 1
  %v11 = load i8, i8* %s11p, align 1
  %v15 = load i8, i8* %s15p, align 1
  store i8 %v15, i8* %s3p, align 1
  store i8 %v3,  i8* %s7p, align 1
  store i8 %v7,  i8* %s11p, align 1
  store i8 %v11, i8* %s15p, align 1

  ; MixColumns for columns j=0..3
  br label %Lmc
Lmc:
  %col = phi i32 [ 0, %Lsb.end ], [ %col.next, %Lmc.end ]
  %cmp_mc = icmp sle i32 %col, 3
  br i1 %cmp_mc, label %Lmc.body, label %Lmc.done

Lmc.body:
  %b = shl i32 %col, 2
  %p0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %b
  %bp1 = add nsw i32 %b, 1
  %p1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %bp1
  %bp2 = add nsw i32 %b, 2
  %p2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %bp2
  %bp3 = add nsw i32 %b, 3
  %p3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %bp3
  %a = load i8, i8* %p0, align 1
  %b1 = load i8, i8* %p1, align 1
  %c = load i8, i8* %p2, align 1
  %d = load i8, i8* %p3, align 1
  %ab = xor i8 %a, %b1
  %bc = xor i8 %b1, %c
  %cd = xor i8 %c, %d
  %da = xor i8 %d, %a
  %t = xor i8 %ab, %cd
  %t2 = xor i8 %t, %bc
  ; new a = a ^ xtime(a^b) ^ (a^b^c^d)
  %xtab = call fastcc i8 @xtime(i8 %ab)
  %na1 = xor i8 %a, %xtab
  %na = xor i8 %na1, %t
  ; new b = b ^ xtime(b^c) ^ t
  %xtbc = call fastcc i8 @xtime(i8 %bc)
  %nb1 = xor i8 %b1, %xtbc
  %nb = xor i8 %nb1, %t
  ; new c = c ^ xtime(c^d) ^ t
  %xtcd = call fastcc i8 @xtime(i8 %cd)
  %nc1 = xor i8 %c, %xtcd
  %nc = xor i8 %nc1, %t
  ; new d = d ^ xtime(d^a) ^ t
  %xtda = call fastcc i8 @xtime(i8 %da)
  %nd1 = xor i8 %d, %xtda
  %nd = xor i8 %nd1, %t
  store i8 %na, i8* %p0, align 1
  store i8 %nb, i8* %p1, align 1
  store i8 %nc, i8* %p2, align 1
  store i8 %nd, i8* %p3, align 1

  br label %Lmc.end
Lmc.end:
  %col.next = add nsw i32 %col, 1
  br label %Lmc
Lmc.done:

  ; AddRoundKey for this round
  %off = shl i32 %round, 4
  br label %Lark
Lark:
  %ia = phi i32 [ 0, %Lmc.done ], [ %ia.next, %Lark.body ]
  %cmp_ark = icmp sle i32 %ia, 15
  br i1 %cmp_ark, label %Lark.body, label %Lark.end
Lark.body:
  %spA = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %ia
  %svA = load i8, i8* %spA, align 1
  %idxA = add nsw i32 %off, %ia
  %wpA = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %idxA
  %kvA = load i8, i8* %wpA, align 1
  %svA.z = zext i8 %svA to i32
  %kvA.z = zext i8 %kvA to i32
  %xA = xor i32 %svA.z, %kvA.z
  %xA.t = trunc i32 %xA to i8
  store i8 %xA.t, i8* %spA, align 1
  %ia.next = add nsw i32 %ia, 1
  br label %Lark
Lark.end:
  br label %Lrounds.end

Lrounds.end:
  %round.next = add nsw i32 %round, 1
  br label %Lrounds
Lrounds.done:

  ; Final round: SubBytes, ShiftRows, AddRoundKey with offset 0xA0
  ; SubBytes
  br label %LsbF
LsbF:
  %isF = phi i32 [ 0, %Lrounds.done ], [ %isF.next, %LsbF.body ]
  %cmp_sbF = icmp sle i32 %isF, 15
  br i1 %cmp_sbF, label %LsbF.body, label %LsbF.end
LsbF.body:
  %spF = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %isF
  %svF = load i8, i8* %spF, align 1
  %svF.z = zext i8 %svF to i64
  %sbox.F = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %svF.z
  %sbvF = load i8, i8* %sbox.F, align 1
  store i8 %sbvF, i8* %spF, align 1
  %isF.next = add nsw i32 %isF, 1
  br label %LsbF
LsbF.end:

  ; ShiftRows (same as above)
  ; Row 1
  %Fs1p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 1
  %Fs5p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 5
  %Fs9p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 9
  %Fs13p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 13
  %Ft15 = load i8, i8* %Fs1p, align 1
  %Fv5 = load i8, i8* %Fs5p, align 1
  %Fv9 = load i8, i8* %Fs9p, align 1
  %Fv13 = load i8, i8* %Fs13p, align 1
  store i8 %Fv5, i8* %Fs1p, align 1
  store i8 %Fv9, i8* %Fs5p, align 1
  store i8 %Fv13, i8* %Fs9p, align 1
  store i8 %Ft15, i8* %Fs13p, align 1
  ; Row 2
  %Fs2p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 2
  %Fs6p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 6
  %Fs10p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 10
  %Fs14p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 14
  %Fv2 = load i8, i8* %Fs2p, align 1
  %Fv6 = load i8, i8* %Fs6p, align 1
  %Fv10 = load i8, i8* %Fs10p, align 1
  %Fv14 = load i8, i8* %Fs14p, align 1
  store i8 %Fv10, i8* %Fs2p, align 1
  store i8 %Fv14, i8* %Fs6p, align 1
  store i8 %Fv2,  i8* %Fs10p, align 1
  store i8 %Fv6,  i8* %Fs14p, align 1
  ; Row 3
  %Fs3p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 3
  %Fs7p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 7
  %Fs11p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 11
  %Fs15p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 15
  %Fv3 = load i8, i8* %Fs3p, align 1
  %Fv7 = load i8, i8* %Fs7p, align 1
  %Fv11 = load i8, i8* %Fs11p, align 1
  %Fv15 = load i8, i8* %Fs15p, align 1
  store i8 %Fv15, i8* %Fs3p, align 1
  store i8 %Fv3,  i8* %Fs7p, align 1
  store i8 %Fv7,  i8* %Fs11p, align 1
  store i8 %Fv11, i8* %Fs15p, align 1

  ; AddRoundKey with offset 0xA0 (160)
  br label %LarkF
LarkF:
  %iF = phi i32 [ 0, %LsbF.end ], [ %iF.next, %LarkF.body ]
  %cmpF = icmp sle i32 %iF, 15
  br i1 %cmpF, label %LarkF.body, label %LarkF.end
LarkF.body:
  %spF2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %iF
  %svF2 = load i8, i8* %spF2, align 1
  %idxF = add nsw i32 %iF, 160
  %wpF = getelementptr inbounds [176 x i8], [176 x i8]* %w, i32 0, i32 %idxF
  %kvF = load i8, i8* %wpF, align 1
  %svF2.z = zext i8 %svF2 to i32
  %kvF.z = zext i8 %kvF to i32
  %xF = xor i32 %svF2.z, %kvF.z
  %xF.t = trunc i32 %xF to i8
  store i8 %xF.t, i8* %spF2, align 1
  %iF.next = add nsw i32 %iF, 1
  br label %LarkF
LarkF.end:

  ; write out
  br label %Lcopy_out
Lcopy_out:
  %io = phi i32 [ 0, %LarkF.end ], [ %io.next, %Lcopy_out.body ]
  %cmp_out = icmp sle i32 %io, 15
  br i1 %cmp_out, label %Lcopy_out.body, label %Lcopy_out.end
Lcopy_out.body:
  %spO = getelementptr inbounds [16 x i8], [16 x i8]* %state, i32 0, i32 %io
  %bvO = load i8, i8* %spO, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i32 %io
  store i8 %bvO, i8* %out.ptr, align 1
  %io.next = add nsw i32 %io, 1
  br label %Lcopy_out
Lcopy_out.end:
  ret void
}