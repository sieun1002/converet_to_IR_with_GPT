; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt ; Address: 0x11A9
; Intent: AES-128 single-block encrypt (ECB-like) (confidence=0.98). Evidence: S-box and Rcon lookups; 176-byte key schedule and 10 rounds.
; Preconditions: out, in, key are non-null pointers to at least 16 bytes; key is 16 bytes (AES-128).
; Postconditions: Writes 16-byte ciphertext to out.

; Only the necessary external declarations:

@sbox_1 = external constant [256 x i8]
@rcon_0 = external constant [256 x i8]

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local void @aes128_encrypt(i8* nocapture %out, i8* nocapture readonly %in, i8* nocapture readonly %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %rk = alloca [176 x i8], align 16

  ; state[i] = in[i]
  br label %copy_in.loop

copy_in.loop:                                      ; preds = %copy_in.loop, %entry
  %i.in = phi i32 [ 0, %entry ], [ %i.in.next, %copy_in.loop ]
  %i.in.zext = zext i32 %i.in to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %i.in.zext
  %in.val = load i8, i8* %in.ptr, align 1
  %st.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.in.zext
  store i8 %in.val, i8* %st.ptr, align 1
  %i.in.next = add nuw nsw i32 %i.in, 1
  %in.done = icmp ult i32 %i.in.next, 16
  br i1 %in.done, label %copy_in.loop, label %copy_key.pre

copy_key.pre:                                      ; preds = %copy_in.loop
  br label %copy_key.loop

; rk[0..15] = key[0..15]
copy_key.loop:                                     ; preds = %copy_key.loop, %copy_key.pre
  %i.k = phi i32 [ 0, %copy_key.pre ], [ %i.k.next, %copy_key.loop ]
  %i.k.zext = zext i32 %i.k to i64
  %key.ptr = getelementptr inbounds i8, i8* %key, i64 %i.k.zext
  %key.val = load i8, i8* %key.ptr, align 1
  %rk.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.k.zext
  store i8 %key.val, i8* %rk.ptr, align 1
  %i.k.next = add nuw nsw i32 %i.k, 1
  %key.done = icmp ult i32 %i.k.next, 16
  br i1 %key.done, label %copy_key.loop, label %expand.init

; Key expansion
expand.init:                                       ; preds = %copy_key.loop
  br label %expand.loop

expand.loop:                                       ; preds = %expand.next, %expand.init
  %i = phi i32 [ 16, %expand.init ], [ %i.next, %expand.next ]
  %rci = phi i32 [ 0, %expand.init ], [ %rci.next, %expand.next ]

  ; load temp = rk[i-4..i-1]
  %i.m4 = add nsw i32 %i, -4
  %i.m3 = add nsw i32 %i, -3
  %i.m2 = add nsw i32 %i, -2
  %i.m1 = add nsw i32 %i, -1
  %i.m4.z = zext i32 %i.m4 to i64
  %i.m3.z = zext i32 %i.m3 to i64
  %i.m2.z = zext i32 %i.m2 to i64
  %i.m1.z = zext i32 %i.m1 to i64
  %t0p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m4.z
  %t1p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m3.z
  %t2p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m2.z
  %t3p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m1.z
  %t0 = load i8, i8* %t0p, align 1
  %t1 = load i8, i8* %t1p, align 1
  %t2 = load i8, i8* %t2p, align 1
  %t3 = load i8, i8* %t3p, align 1

  ; if (i % 16 == 0) { RotWord; SubWord; t0 ^= Rcon[rci]; rci++ }
  %i.low4 = and i32 %i, 15
  %cond = icmp eq i32 %i.low4, 0
  br i1 %cond, label %cond.true, label %cond.false

cond.true:                                         ; preds = %expand.loop
  ; rotate (t0,t1,t2,t3) = (t1,t2,t3,t0)
  %rt0 = %t1
  %rt1 = %t2
  %rt2 = %t3
  %rt3 = %t0
  ; SubWord via sbox
  %rt0.z = zext i8 %rt0 to i64
  %rt1.z = zext i8 %rt1 to i64
  %rt2.z = zext i8 %rt2 to i64
  %rt3.z = zext i8 %rt3 to i64
  %sb0p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt0.z
  %sb1p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt1.z
  %sb2p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt2.z
  %sb3p = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %rt3.z
  %sw0 = load i8, i8* %sb0p, align 1
  %sw1 = load i8, i8* %sb1p, align 1
  %sw2 = load i8, i8* %sb2p, align 1
  %sw3 = load i8, i8* %sb3p, align 1
  ; t0 ^= Rcon[rci]
  %rci.z = zext i32 %rci to i64
  %rcp = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 %rci.z
  %rcv = load i8, i8* %rcp, align 1
  %t0.rc = xor i8 %sw0, %rcv
  br label %cond.join

cond.false:                                        ; preds = %expand.loop
  br label %cond.join

cond.join:                                         ; preds = %cond.false, %cond.true
  %t0.sel = phi i8 [ %t0.rc, %cond.true ], [ %t0, %cond.false ]
  %t1.sel = phi i8 [ %sw1, %cond.true ], [ %t1, %cond.false ]
  %t2.sel = phi i8 [ %sw2, %cond.true ], [ %t2, %cond.false ]
  %t3.sel = phi i8 [ %sw3, %cond.true ], [ %t3, %cond.false ]
  %rci.next = phi i32 [ %rci.inc, %cond.true ], [ %rci, %cond.false ]
  %rci.inc = add nuw nsw i32 %rci, 1

  ; write rk[i..i+3] = rk[i-16..i-13] ^ (t0..t3)
  %i.m16 = add nsw i32 %i, -16
  %i.m15 = add nsw i32 %i, -15
  %i.m14 = add nsw i32 %i, -14
  %i.m13 = add nsw i32 %i, -13
  %i.m16.z = zext i32 %i.m16 to i64
  %i.m15.z = zext i32 %i.m15 to i64
  %i.m14.z = zext i32 %i.m14 to i64
  %i.m13.z = zext i32 %i.m13 to i64
  %w0p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m16.z
  %w1p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m15.z
  %w2p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m14.z
  %w3p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.m13.z
  %w0v = load i8, i8* %w0p, align 1
  %w1v = load i8, i8* %w1p, align 1
  %w2v = load i8, i8* %w2p, align 1
  %w3v = load i8, i8* %w3p, align 1
  %o0 = xor i8 %w0v, %t0.sel
  %o1 = xor i8 %w1v, %t1.sel
  %o2 = xor i8 %w2v, %t2.sel
  %o3 = xor i8 %w3v, %t3.sel
  %i.z = zext i32 %i to i64
  %i1 = add nuw nsw i32 %i, 1
  %i2 = add nuw nsw i32 %i, 2
  %i3 = add nuw nsw i32 %i, 3
  %i1.z = zext i32 %i1 to i64
  %i2.z = zext i32 %i2 to i64
  %i3.z = zext i32 %i3 to i64
  %op0 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.z
  %op1 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i1.z
  %op2 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i2.z
  %op3 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i3.z
  store i8 %o0, i8* %op0, align 1
  store i8 %o1, i8* %op1, align 1
  store i8 %o2, i8* %op2, align 1
  store i8 %o3, i8* %op3, align 1

  %i.next = add nuw nsw i32 %i, 4
  %done.expand = icmp ule i32 %i.next, 175
  br i1 %done.expand, label %expand.next, label %post.expand

expand.next:                                       ; preds = %cond.join
  br label %expand.loop

post.expand:                                       ; preds = %cond.join
  ; Initial AddRoundKey: state ^= rk[0..15]
  br label %ark0.loop

ark0.loop:                                         ; preds = %ark0.loop, %post.expand
  %i0 = phi i32 [ 0, %post.expand ], [ %i0.next, %ark0.loop ]
  %i0.z = zext i32 %i0 to i64
  %sp = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i0.z
  %sv = load i8, i8* %sp, align 1
  %rkp = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i0.z
  %rkv = load i8, i8* %rkp, align 1
  %xv = xor i8 %sv, %rkv
  store i8 %xv, i8* %sp, align 1
  %i0.next = add nuw nsw i32 %i0, 1
  %ark0.cont = icmp ult i32 %i0.next, 16
  br i1 %ark0.cont, label %ark0.loop, label %rounds.init

; Rounds 1..9
rounds.init:                                       ; preds = %ark0.loop
  br label %rounds.loop

rounds.loop:                                       ; preds = %ark.add, %rounds.init
  %round = phi i32 [ 1, %rounds.init ], [ %round.next, %ark.add ]
  ; SubBytes
  br label %sub.loop

sub.loop:                                          ; preds = %sub.loop, %rounds.loop
  %isub = phi i32 [ 0, %rounds.loop ], [ %isub.next, %sub.loop ]
  %isub.z = zext i32 %isub to i64
  %sp.sub = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %isub.z
  %sv.sub = load i8, i8* %sp.sub, align 1
  %sv.idx = zext i8 %sv.sub to i64
  %sb.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %sv.idx
  %sb.val = load i8, i8* %sb.ptr, align 1
  store i8 %sb.val, i8* %sp.sub, align 1
  %isub.next = add nuw nsw i32 %isub, 1
  %sub.cont = icmp ult i32 %isub.next, 16
  br i1 %sub.cont, label %sub.loop, label %shiftrows

; ShiftRows
shiftrows:                                         ; preds = %sub.loop
  ; load all state bytes
  %p0  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %p1  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %p2  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %p3  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %p4  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 4
  %p5  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %p6  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %p7  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %p8  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 8
  %p9  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %p10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %p11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %p12 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 12
  %p13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %p14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %p15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %v0  = load i8, i8* %p0,  align 1
  %v1  = load i8, i8* %p1,  align 1
  %v2  = load i8, i8* %p2,  align 1
  %v3  = load i8, i8* %p3,  align 1
  %v4  = load i8, i8* %p4,  align 1
  %v5  = load i8, i8* %p5,  align 1
  %v6  = load i8, i8* %p6,  align 1
  %v7  = load i8, i8* %p7,  align 1
  %v8  = load i8, i8* %p8,  align 1
  %v9  = load i8, i8* %p9,  align 1
  %v10 = load i8, i8* %p10, align 1
  %v11 = load i8, i8* %p11, align 1
  %v12 = load i8, i8* %p12, align 1
  %v13 = load i8, i8* %p13, align 1
  %v14 = load i8, i8* %p14, align 1
  %v15 = load i8, i8* %p15, align 1
  ; row0 unchanged
  store i8 %v0,  i8* %p0,  align 1
  store i8 %v4,  i8* %p4,  align 1
  store i8 %v8,  i8* %p8,  align 1
  store i8 %v12, i8* %p12, align 1
  ; row1 rotate left by 1: [1,5,9,13] -> [5,9,13,1]
  store i8 %v5,  i8* %p1,  align 1
  store i8 %v9,  i8* %p5,  align 1
  store i8 %v13, i8* %p9,  align 1
  store i8 %v1,  i8* %p13, align 1
  ; row2 rotate left by 2: [2,6,10,14] -> [10,14,2,6]
  store i8 %v10, i8* %p2,  align 1
  store i8 %v14, i8* %p6,  align 1
  store i8 %v2,  i8* %p10, align 1
  store i8 %v6,  i8* %p14, align 1
  ; row3 rotate left by 3: [3,7,11,15] -> [15,3,7,11]
  store i8 %v15, i8* %p3,  align 1
  store i8 %v3,  i8* %p7,  align 1
  store i8 %v7,  i8* %p11, align 1
  store i8 %v11, i8* %p15, align 1

  ; MixColumns
  br label %mix.col.loop

mix.col.loop:                                      ; preds = %mix.col.loop, %shiftrows
  %c = phi i32 [ 0, %shiftrows ], [ %c.next, %mix.col.loop ]
  %c4 = shl nuw nsw i32 %c, 2
  %c4.z = zext i32 %c4 to i64
  %c4p0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %c4.z
  %c4p1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 (add (i64 %c4.z), i64 1)
  %c4p2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 (add (i64 %c4.z), i64 2)
  %c4p3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 (add (i64 %c4.z), i64 3)
  %a = load i8, i8* %c4p0, align 1
  %b = load i8, i8* %c4p1, align 1
  %d = load i8, i8* %c4p3, align 1
  %cval = load i8, i8* %c4p2, align 1
  %ab = xor i8 %a, %b
  %cd = xor i8 %cval, %d
  %abcd1 = xor i8 %ab, %cd      ; a^b^c^d

  ; a' = a ^ xtime(a^b) ^ (a^b^c^d)
  %ab.z = zext i8 %ab to i32
  %xtab.s = shl i32 %ab.z, 1
  %ab.hi = lshr i8 %ab, 7
  %ab.hi.z = zext i8 %ab.hi to i32
  %ab.mul27 = mul nuw nsw i32 %ab.hi.z, 27
  %xtab.x = xor i32 %xtab.s, %ab.mul27
  %xtab = trunc i32 %xtab.x to i8
  %a.tmp = xor i8 %a, %xtab
  %a.new = xor i8 %a.tmp, %abcd1

  ; b' = b ^ xtime(b^c) ^ sum
  %bc = xor i8 %b, %cval
  %bc.z = zext i8 %bc to i32
  %xtbc.s = shl i32 %bc.z, 1
  %bc.hi = lshr i8 %bc, 7
  %bc.hi.z = zext i8 %bc.hi to i32
  %bc.mul27 = mul nuw nsw i32 %bc.hi.z, 27
  %xtbc.x = xor i32 %xtbc.s, %bc.mul27
  %xtbc = trunc i32 %xtbc.x to i8
  %b.tmp = xor i8 %b, %xtbc
  %b.new = xor i8 %b.tmp, %abcd1

  ; c' = c ^ xtime(c^d) ^ sum
  %cd2 = xor i8 %cval, %d
  %cd2.z = zext i8 %cd2 to i32
  %xtcd.s = shl i32 %cd2.z, 1
  %cd2.hi = lshr i8 %cd2, 7
  %cd2.hi.z = zext i8 %cd2.hi to i32
  %cd2.mul27 = mul nuw nsw i32 %cd2.hi.z, 27
  %xtcd.x = xor i32 %xtcd.s, %cd2.mul27
  %xtcd = trunc i32 %xtcd.x to i8
  %c.tmp = xor i8 %cval, %xtcd
  %c.new = xor i8 %c.tmp, %abcd1

  ; d' = d ^ xtime(d^a) ^ sum
  %da = xor i8 %d, %a
  %da.z = zext i8 %da to i32
  %xtda.s = shl i32 %da.z, 1
  %da.hi = lshr i8 %da, 7
  %da.hi.z = zext i8 %da.hi to i32
  %da.mul27 = mul nuw nsw i32 %da.hi.z, 27
  %xtda.x = xor i32 %xtda.s, %da.mul27
  %xtda = trunc i32 %xtda.x to i8
  %d.tmp = xor i8 %d, %xtda
  %d.new = xor i8 %d.tmp, %abcd1

  store i8 %a.new, i8* %c4p0, align 1
  store i8 %b.new, i8* %c4p1, align 1
  store i8 %c.new, i8* %c4p2, align 1
  store i8 %d.new, i8* %c4p3, align 1

  %c.next = add nuw nsw i32 %c, 1
  %mix.cont = icmp ult i32 %c.next, 4
  br i1 %mix.cont, label %mix.col.loop, label %ark.add

; AddRoundKey for round r
ark.add:                                           ; preds = %mix.col.loop
  %rkofs = mul nuw nsw i32 %round, 16
  br label %ark.loop

ark.loop:                                          ; preds = %ark.loop, %ark.add
  %ia = phi i32 [ 0, %ark.add ], [ %ia.next, %ark.loop ]
  %ia.z = zext i32 %ia to i64
  %sp.a = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ia.z
  %sv.a = load i8, i8* %sp.a, align 1
  %rk.idx = add nuw nsw i32 %rkofs, %ia
  %rk.idx.z = zext i32 %rk.idx to i64
  %rkp.a = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %rk.idx.z
  %rkv.a = load i8, i8* %rkp.a, align 1
  %xv.a = xor i8 %sv.a, %rkv.a
  store i8 %xv.a, i8* %sp.a, align 1
  %ia.next = add nuw nsw i32 %ia, 1
  %ark.cont = icmp ult i32 %ia.next, 16
  br i1 %ark.cont, label %ark.loop, label %rounds.next

rounds.next:                                       ; preds = %ark.loop
  %round.next = add nuw nsw i32 %round, 1
  %rounds.done = icmp ule i32 %round.next, 9
  br i1 %rounds.done, label %rounds.loop, label %final.round

; Final round (round 10): SubBytes, ShiftRows, AddRoundKey
final.round:                                       ; preds = %rounds.next
  ; SubBytes
  br label %subf.loop

subf.loop:                                         ; preds = %subf.loop, %final.round
  %if = phi i32 [ 0, %final.round ], [ %if.next, %subf.loop ]
  %if.z = zext i32 %if to i64
  %spf = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %if.z
  %svf = load i8, i8* %spf, align 1
  %svf.idx = zext i8 %svf to i64
  %sbf.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %svf.idx
  %sbf.val = load i8, i8* %sbf.ptr, align 1
  store i8 %sbf.val, i8* %spf, align 1
  %if.next = add nuw nsw i32 %if, 1
  %subf.cont = icmp ult i32 %if.next, 16
  br i1 %subf.cont, label %subf.loop, label %shiftf

shiftf:                                            ; preds = %subf.loop
  ; load all
  %q0  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %q1  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %q2  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %q3  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %q4  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 4
  %q5  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %q6  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %q7  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %q8  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 8
  %q9  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %q10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %q11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %q12 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 12
  %q13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %q14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %q15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %w0  = load i8, i8* %q0,  align 1
  %w1  = load i8, i8* %q1,  align 1
  %w2  = load i8, i8* %q2,  align 1
  %w3  = load i8, i8* %q3,  align 1
  %w4  = load i8, i8* %q4,  align 1
  %w5  = load i8, i8* %q5,  align 1
  %w6  = load i8, i8* %q6,  align 1
  %w7  = load i8, i8* %q7,  align 1
  %w8  = load i8, i8* %q8,  align 1
  %w9  = load i8, i8* %q9,  align 1
  %w10 = load i8, i8* %q10, align 1
  %w11 = load i8, i8* %q11, align 1
  %w12 = load i8, i8* %q12, align 1
  %w13 = load i8, i8* %q13, align 1
  %w14 = load i8, i8* %q14, align 1
  %w15 = load i8, i8* %q15, align 1
  ; row0 unchanged
  store i8 %w0,  i8* %q0,  align 1
  store i8 %w4,  i8* %q4,  align 1
  store i8 %w8,  i8* %q8,  align 1
  store i8 %w12, i8* %q12, align 1
  ; row1 rotate left by 1
  store i8 %w5,  i8* %q1,  align 1
  store i8 %w9,  i8* %q5,  align 1
  store i8 %w13, i8* %q9,  align 1
  store i8 %w1,  i8* %q13, align 1
  ; row2 rotate left by 2
  store i8 %w10, i8* %q2,  align 1
  store i8 %w14, i8* %q6,  align 1
  store i8 %w2,  i8* %q10, align 1
  store i8 %w6,  i8* %q14, align 1
  ; row3 rotate left by 3
  store i8 %w15, i8* %q3,  align 1
  store i8 %w3,  i8* %q7,  align 1
  store i8 %w7,  i8* %q11, align 1
  store i8 %w11, i8* %q15, align 1

  ; AddRoundKey round 10 offset = 160
  br label %arkf.loop

arkf.loop:                                         ; preds = %arkf.loop, %shiftf
  %if2 = phi i32 [ 0, %shiftf ], [ %if2.next, %arkf.loop ]
  %if2.z = zext i32 %if2 to i64
  %spf2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %if2.z
  %svf2 = load i8, i8* %spf2, align 1
  %rkf.idx = add nuw nsw i32 %if2, 160
  %rkf.idx.z = zext i32 %rkf.idx to i64
  %rkfp = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %rkf.idx.z
  %rkfv = load i8, i8* %rkfp, align 1
  %xvf = xor i8 %svf2, %rkfv
  store i8 %xvf, i8* %spf2, align 1
  %if2.next = add nuw nsw i32 %if2, 1
  %arkf.cont = icmp ult i32 %if2.next, 16
  br i1 %arkf.cont, label %arkf.loop, label %write.out

; write out
write.out:                                         ; preds = %arkf.loop
  br label %write.loop

write.loop:                                        ; preds = %write.loop, %write.out
  %iw = phi i32 [ 0, %write.out ], [ %iw.next, %write.loop ]
  %iw.z = zext i32 %iw to i64
  %spw = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %iw.z
  %svw = load i8, i8* %spw, align 1
  %outp = getelementptr inbounds i8, i8* %out, i64 %iw.z
  store i8 %svw, i8* %outp, align 1
  %iw.next = add nuw nsw i32 %iw, 1
  %write.cont = icmp ult i32 %iw.next, 16
  br i1 %write.cont, label %write.loop, label %ret

ret:                                              ; preds = %write.loop
  ret void
}