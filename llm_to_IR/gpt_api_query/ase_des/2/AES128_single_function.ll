; ModuleID = 'aes128_encrypt.ll'
source_filename = "aes128_encrypt"

@ sbox_1 = external dso_local constant [256 x i8], align 16
@ rcon_0 = external dso_local constant [256 x i8], align 16

define dso_local void @aes128_encrypt(i8* nocapture %out, i8* nocapture readonly %in, i8* nocapture readonly %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %rk = alloca [176 x i8], align 16
  %i = alloca i32, align 4
  %rc = alloca i32, align 4
  %j = alloca i32, align 4
  %r = alloca i32, align 4
  %tmp = alloca [16 x i8], align 16

  ; state <- in
  store i32 0, i32* %j, align 4
  br label %copy_in.loop

copy_in.loop:
  %jv = load i32, i32* %j, align 4
  %j.cmp = icmp sle i32 %jv, 15
  br i1 %j.cmp, label %copy_in.body, label %copy_in.done

copy_in.body:
  %jv.z = zext i32 %jv to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %jv.z
  %in.b = load i8, i8* %in.ptr, align 1
  %st.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %jv.z
  store i8 %in.b, i8* %st.ptr, align 1
  %j.next = add i32 %jv, 1
  store i32 %j.next, i32* %j, align 4
  br label %copy_in.loop

copy_in.done:
  ; rk[0..15] <- key
  store i32 0, i32* %j, align 4
  br label %copy_key.loop

copy_key.loop:
  %jk = load i32, i32* %j, align 4
  %jk.cmp = icmp sle i32 %jk, 15
  br i1 %jk.cmp, label %copy_key.body, label %copy_key.done

copy_key.body:
  %jk.z = zext i32 %jk to i64
  %key.ptr = getelementptr inbounds i8, i8* %key, i64 %jk.z
  %k.b = load i8, i8* %key.ptr, align 1
  %rk.ptr0 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %jk.z
  store i8 %k.b, i8* %rk.ptr0, align 1
  %jk.next = add i32 %jk, 1
  store i32 %jk.next, i32* %j, align 4
  br label %copy_key.loop

copy_key.done:
  ; key expansion
  store i32 16, i32* %i, align 4
  store i32 0, i32* %rc, align 4
  br label %ke.loop

ke.loop:
  %iv = load i32, i32* %i, align 4
  %ke.cmp = icmp sle i32 %iv, 175
  br i1 %ke.cmp, label %ke.body, label %ke.done

ke.body:
  %iv.z = zext i32 %iv to i64
  %im4 = sub i32 %iv, 4
  %im3 = sub i32 %iv, 3
  %im2 = sub i32 %iv, 2
  %im1 = sub i32 %iv, 1
  %im4.z = zext i32 %im4 to i64
  %im3.z = zext i32 %im3 to i64
  %im2.z = zext i32 %im2 to i64
  %im1.z = zext i32 %im1 to i64
  %t0p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %im4.z
  %t1p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %im3.z
  %t2p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %im2.z
  %t3p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %im1.z
  %t0 = load i8, i8* %t0p, align 1
  %t1 = load i8, i8* %t1p, align 1
  %t2 = load i8, i8* %t2p, align 1
  %t3 = load i8, i8* %t3p, align 1

  %mod = and i32 %iv, 15
  %is_block = icmp eq i32 %mod, 0
  br i1 %is_block, label %ke.rot_sub, label %ke.noround

ke.rot_sub:
  ; rotate left by 1
  %tmp_t0 = phi i8 [ %t0, %ke.body ]
  %tmp_t1 = phi i8 [ %t1, %ke.body ]
  %tmp_t2 = phi i8 [ %t2, %ke.body ]
  %tmp_t3 = phi i8 [ %t3, %ke.body ]
  ; t0<-t1; t1<-t2; t2<-t3; t3<-t0
  %rt0 = %tmp_t1
  %rt1 = %tmp_t2
  %rt2 = %tmp_t3
  %rt3 = %tmp_t0
  ; SubWord via S-box
  ; t0
  %rt0.z = zext i8 %rt0 to i64
  %sbox.t0.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt0.z
  %rt0.s = load i8, i8* %sbox.t0.p, align 1
  ; t1
  %rt1.z = zext i8 %rt1 to i64
  %sbox.t1.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt1.z
  %rt1.s = load i8, i8* %sbox.t1.p, align 1
  ; t2
  %rt2.z = zext i8 %rt2 to i64
  %sbox.t2.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt2.z
  %rt2.s = load i8, i8* %sbox.t2.p, align 1
  ; t3
  %rt3.z = zext i8 %rt3 to i64
  %sbox.t3.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt3.z
  %rt3.s = load i8, i8* %sbox.t3.p, align 1
  ; Rcon
  %rcv = load i32, i32* %rc, align 4
  %rcv.z = zext i32 %rcv to i64
  %rcon.p = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 %rcv.z
  %rcon.b = load i8, i8* %rcon.p, align 1
  %rt0.rc = xor i8 %rt0.s, %rcon.b
  %rc.next = add i32 %rcv, 1
  store i32 %rc.next, i32* %rc, align 4
  br label %ke.merge

ke.noround:
  br label %ke.merge

ke.merge:
  %t0.sel = phi i8 [ %rt0.rc, %ke.rot_sub ], [ %t0, %ke.noround ]
  %t1.sel = phi i8 [ %rt1.s,  %ke.rot_sub ], [ %t1, %ke.noround ]
  %t2.sel = phi i8 [ %rt2.s,  %ke.rot_sub ], [ %t2, %ke.noround ]
  %t3.sel = phi i8 [ %rt3.s,  %ke.rot_sub ], [ %t3, %ke.noround ]

  ; rk[i..i+3] = rk[i-16..i-13] ^ t[0..3]
  %im16 = sub i32 %iv, 16
  %im15 = add i32 %im16, 1
  %im14 = add i32 %im16, 2
  %im13 = add i32 %im16, 3
  %im16.z = zext i32 %im16 to i64
  %im15.z = zext i32 %im15 to i64
  %im14.z = zext i32 %im14 to i64
  %im13.z = zext i32 %im13 to i64
  %w0.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %im16.z
  %w1.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %im15.z
  %w2.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %im14.z
  %w3.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %im13.z
  %w0 = load i8, i8* %w0.p, align 1
  %w1 = load i8, i8* %w1.p, align 1
  %w2 = load i8, i8* %w2.p, align 1
  %w3 = load i8, i8* %w3.p, align 1

  %o0 = xor i8 %w0, %t0.sel
  %o1 = xor i8 %w1, %t1.sel
  %o2 = xor i8 %w2, %t2.sel
  %o3 = xor i8 %w3, %t3.sel

  %i0.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %iv.z
  %i1.idx = add i32 %iv, 1
  %i2.idx = add i32 %iv, 2
  %i3.idx = add i32 %iv, 3
  %i1.z = zext i32 %i1.idx to i64
  %i2.z = zext i32 %i2.idx to i64
  %i3.z = zext i32 %i3.idx to i64
  %i1.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i1.z
  %i2.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i2.z
  %i3.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i3.z

  store i8 %o0, i8* %i0.p, align 1
  store i8 %o1, i8* %i1.p, align 1
  store i8 %o2, i8* %i2.p, align 1
  store i8 %o3, i8* %i3.p, align 1

  %iv.next = add i32 %iv, 4
  store i32 %iv.next, i32* %i, align 4
  br label %ke.loop

ke.done:
  ; initial AddRoundKey rk[0..15]
  store i32 0, i32* %j, align 4
  br label %ark0.loop

ark0.loop:
  %j0 = load i32, i32* %j, align 4
  %j0.cmp = icmp sle i32 %j0, 15
  br i1 %j0.cmp, label %ark0.body, label %ark0.done

ark0.body:
  %j0.z = zext i32 %j0 to i64
  %st.j.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %j0.z
  %st.j = load i8, i8* %st.j.p, align 1
  %rk.j.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %j0.z
  %rk.j = load i8, i8* %rk.j.p, align 1
  %xor0 = xor i8 %st.j, %rk.j
  store i8 %xor0, i8* %st.j.p, align 1
  %j0.n = add i32 %j0, 1
  store i32 %j0.n, i32* %j, align 4
  br label %ark0.loop

ark0.done:
  ; rounds 1..9
  store i32 1, i32* %r, align 4
  br label %rounds.loop

rounds.loop:
  %rv = load i32, i32* %r, align 4
  %r.cmp = icmp sle i32 %rv, 9
  br i1 %r.cmp, label %round.body, label %rounds.done

round.body:
  ; SubBytes
  store i32 0, i32* %j, align 4
  br label %sub.loop

sub.loop:
  %sj = load i32, i32* %j, align 4
  %sj.cmp = icmp sle i32 %sj, 15
  br i1 %sj.cmp, label %sub.body, label %sub.done

sub.body:
  %sj.z = zext i32 %sj to i64
  %st.p = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %sj.z
  %b0 = load i8, i8* %st.p, align 1
  %b0.z = zext i8 %b0 to i64
  %sbox.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %b0.z
  %sb = load i8, i8* %sbox.p, align 1
  store i8 %sb, i8* %st.p, align 1
  %sj.n = add i32 %sj, 1
  store i32 %sj.n, i32* %j, align 4
  br label %sub.loop

sub.done:
  ; ShiftRows -> tmp
  ; row 0
  %s0  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 0), align 1
  %s4  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 4), align 1
  %s8  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 8), align 1
  %s12 = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 12), align 1
  ; row 1
  %s1  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 1), align 1
  %s5  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 5), align 1
  %s9  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 9), align 1
  %s13 = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 13), align 1
  ; row 2
  %s2  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 2), align 1
  %s6  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 6), align 1
  %s10 = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 10), align 1
  %s14 = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 14), align 1
  ; row 3
  %s3  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 3), align 1
  %s7  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 7), align 1
  %s11 = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 11), align 1
  %s15 = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 15), align 1

  ; tmp after shift
  store i8 %s0,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 0), align 1
  store i8 %s5,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 1), align 1
  store i8 %s10, i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 2), align 1
  store i8 %s15, i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 3), align 1
  store i8 %s4,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 4), align 1
  store i8 %s9,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 5), align 1
  store i8 %s14, i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 6), align 1
  store i8 %s3,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 7), align 1
  store i8 %s8,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 8), align 1
  store i8 %s13, i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 9), align 1
  store i8 %s2,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 10), align 1
  store i8 %s7,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 11), align 1
  store i8 %s12, i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 12), align 1
  store i8 %s1,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 13), align 1
  store i8 %s6,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 14), align 1
  store i8 %s11, i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 15), align 1

  ; state = tmp
  store i32 0, i32* %j, align 4
  br label %tmpcpy.loop

tmpcpy.loop:
  %tj = load i32, i32* %j, align 4
  %tj.cmp = icmp sle i32 %tj, 15
  br i1 %tj.cmp, label %tmpcpy.body, label %tmpcpy.done

tmpcpy.body:
  %tj.z = zext i32 %tj to i64
  %tmp.p = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 %tj.z
  %v = load i8, i8* %tmp.p, align 1
  %st.p2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %tj.z
  store i8 %v, i8* %st.p2, align 1
  %tj.n = add i32 %tj, 1
  store i32 %tj.n, i32* %j, align 4
  br label %tmpcpy.loop

tmpcpy.done:
  ; MixColumns for 4 columns
  ; column loop index c = 0..3
  store i32 0, i32* %j, align 4
  br label %mc.loop

mc.loop:
  %cj = load i32, i32* %j, align 4
  %cj.cmp = icmp sle i32 %cj, 3
  br i1 %cj.cmp, label %mc.body, label %mc.done

mc.body:
  %base = shl i32 %cj, 2
  %b0i = zext i32 %base to i64
  %b1i = zext i32 (add i32 %base, 1) to i64
  %b2i = zext i32 (add i32 %base, 2) to i64
  %b3i = zext i32 (add i32 %base, 3) to i64

  %p0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b0i
  %p1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b1i
  %p2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b2i
  %p3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b3i

  %a0 = load i8, i8* %p0, align 1
  %a1 = load i8, i8* %p1, align 1
  %a2 = load i8, i8* %p2, align 1
  %a3 = load i8, i8* %p3, align 1

  %t01 = xor i8 %a0, %a1
  %t23 = xor i8 %a2, %a3
  %t = xor i8 %t01, %t23

  ; xtime(a0 ^ a1)
  %x01 = %t01
  %x01shl = shl i8 %x01, 1
  %x01hb = lshr i8 %x01, 7
  %x01mul = mul i8 %x01hb, 27
  %x01xt = xor i8 %x01shl, %x01mul
  %n0 = xor i8 %x01xt, %t
  %new0 = xor i8 %a0, %n0
  store i8 %new0, i8* %p0, align 1

  ; xtime(a1 ^ a2)
  %x12 = xor i8 %a1, %a2
  %x12shl = shl i8 %x12, 1
  %x12hb = lshr i8 %x12, 7
  %x12mul = mul i8 %x12hb, 27
  %x12xt = xor i8 %x12shl, %x12mul
  %n1 = xor i8 %x12xt, %t
  %new1 = xor i8 %a1, %n1
  store i8 %new1, i8* %p1, align 1

  ; xtime(a2 ^ a3)
  %x23 = %t23
  %x23shl = shl i8 %x23, 1
  %x23hb = lshr i8 %x23, 7
  %x23mul = mul i8 %x23hb, 27
  %x23xt = xor i8 %x23shl, %x23mul
  %n2 = xor i8 %x23xt, %t
  %new2 = xor i8 %a2, %n2
  store i8 %new2, i8* %p2, align 1

  ; xtime(a3 ^ a0)
  %x30 = xor i8 %a3, %a0
  %x30shl = shl i8 %x30, 1
  %x30hb = lshr i8 %x30, 7
  %x30mul = mul i8 %x30hb, 27
  %x30xt = xor i8 %x30shl, %x30mul
  %n3 = xor i8 %x30xt, %t
  %new3 = xor i8 %a3, %n3
  store i8 %new3, i8* %p3, align 1

  %cj.n = add i32 %cj, 1
  store i32 %cj.n, i32* %j, align 4
  br label %mc.loop

mc.done:
  ; AddRoundKey for this round
  ; offset = rv * 16
  %rv.cur = load i32, i32* %r, align 4
  %ofs = shl i32 %rv.cur, 4
  store i32 0, i32* %j, align 4
  br label %ark.loop

ark.loop:
  %aj = load i32, i32* %j, align 4
  %aj.cmp = icmp sle i32 %aj, 15
  br i1 %aj.cmp, label %ark.body, label %ark.done

ark.body:
  %aj.z = zext i32 %aj to i64
  %st.p3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %aj.z
  %sb3 = load i8, i8* %st.p3, align 1

  %idx = add i32 %ofs, %aj
  %idx.z = zext i32 %idx to i64
  %rk.p3 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %idx.z
  %rk.b3 = load i8, i8* %rk.p3, align 1

  %x3 = xor i8 %sb3, %rk.b3
  store i8 %x3, i8* %st.p3, align 1

  %aj.n = add i32 %aj, 1
  store i32 %aj.n, i32* %j, align 4
  br label %ark.loop

ark.done:
  %rv.n = add i32 %rv.cur, 1
  store i32 %rv.n, i32* %r, align 4
  br label %rounds.loop

rounds.done:
  ; final round: SubBytes, ShiftRows, AddRoundKey at offset 160 (0xA0)
  ; SubBytes
  store i32 0, i32* %j, align 4
  br label %fsub.loop

fsub.loop:
  %fj = load i32, i32* %j, align 4
  %fj.cmp = icmp sle i32 %fj, 15
  br i1 %fj.cmp, label %fsub.body, label %fsub.done

fsub.body:
  %fj.z = zext i32 %fj to i64
  %fsp = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fj.z
  %fb = load i8, i8* %fsp, align 1
  %fb.z = zext i8 %fb to i64
  %fsbx.p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %fb.z
  %fsb = load i8, i8* %fsbx.p, align 1
  store i8 %fsb, i8* %fsp, align 1
  %fj.n = add i32 %fj, 1
  store i32 %fj.n, i32* %j, align 4
  br label %fsub.loop

fsub.done:
  ; ShiftRows into tmp
  ; reuse same as earlier
  %fs0  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 0), align 1
  %fs4  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 4), align 1
  %fs8  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 8), align 1
  %fs12 = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 12), align 1

  %fs1  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 1), align 1
  %fs5  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 5), align 1
  %fs9  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 9), align 1
  %fs13 = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 13), align 1

  %fs2  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 2), align 1
  %fs6  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 6), align 1
  %fs10 = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 10), align 1
  %fs14 = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 14), align 1

  %fs3  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 3), align 1
  %fs7  = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 7), align 1
  %fs11 = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 11), align 1
  %fs15 = load i8, i8* getelementptr([16 x i8], [16 x i8]* %state, i64 0, i64 15), align 1

  store i8 %fs0,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 0), align 1
  store i8 %fs5,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 1), align 1
  store i8 %fs10, i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 2), align 1
  store i8 %fs15, i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 3), align 1
  store i8 %fs4,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 4), align 1
  store i8 %fs9,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 5), align 1
  store i8 %fs14, i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 6), align 1
  store i8 %fs3,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 7), align 1
  store i8 %fs8,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 8), align 1
  store i8 %fs13, i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 9), align 1
  store i8 %fs2,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 10), align 1
  store i8 %fs7,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 11), align 1
  store i8 %fs12, i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 12), align 1
  store i8 %fs1,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 13), align 1
  store i8 %fs6,  i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 14), align 1
  store i8 %fs11, i8* getelementptr([16 x i8], [16 x i8]* %tmp, i64 0, i64 15), align 1

  ; state = tmp
  store i32 0, i32* %j, align 4
  br label %fscpy.loop

fscpy.loop:
  %fj2 = load i32, i32* %j, align 4
  %fj2.cmp = icmp sle i32 %fj2, 15
  br i1 %fj2.cmp, label %fscpy.body, label %fscpy.done

fscpy.body:
  %fj2.z = zext i32 %fj2 to i64
  %tp = getelementptr inbounds [16 x i8], [16 x i8]* %tmp, i64 0, i64 %fj2.z
  %vb = load i8, i8* %tp, align 1
  %sp = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fj2.z
  store i8 %vb, i8* %sp, align 1
  %fj2.n = add i32 %fj2, 1
  store i32 %fj2.n, i32* %j, align 4
  br label %fscpy.loop

fscpy.done:
  ; AddRoundKey offset 160
  store i32 0, i32* %j, align 4
  br label %finalark.loop

finalark.loop:
  %fj3 = load i32, i32* %j, align 4
  %fj3.cmp = icmp sle i32 %fj3, 15
  br i1 %fj3.cmp, label %finalark.body, label %finalark.done

finalark.body:
  %fj3.z = zext i32 %fj3 to i64
  %sp3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fj3.z
  %sb4 = load i8, i8* %sp3, align 1

  %idxf = add i32 %fj3, 160
  %idxf.z = zext i32 %idxf to i64
  %rpf = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %idxf.z
  %rbf = load i8, i8* %rpf, align 1

  %xf = xor i8 %sb4, %rbf
  store i8 %xf, i8* %sp3, align 1

  %fj3.n = add i32 %fj3, 1
  store i32 %fj3.n, i32* %j, align 4
  br label %finalark.loop

finalark.done:
  ; out <- state
  store i32 0, i32* %j, align 4
  br label %copy_out.loop

copy_out.loop:
  %jo = load i32, i32* %j, align 4
  %jo.cmp = icmp sle i32 %jo, 15
  br i1 %jo.cmp, label %copy_out.body, label %copy_out.done

copy_out.body:
  %jo.z = zext i32 %jo to i64
  %sp4 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %jo.z
  %ob = load i8, i8* %sp4, align 1
  %outp = getelementptr inbounds i8, i8* %out, i64 %jo.z
  store i8 %ob, i8* %outp, align 1
  %jo.n = add i32 %jo, 1
  store i32 %jo.n, i32* %j, align 4
  br label %copy_out.loop

copy_out.done:
  ret void
}