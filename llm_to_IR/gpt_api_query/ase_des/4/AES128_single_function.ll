; ModuleID = 'aes128_encrypt.ll'
source_filename = "aes128_encrypt.ll"
target triple = "x86_64-unknown-linux-gnu"

@rcon_0 = external dso_local constant [256 x i8], align 16
@sbox_1 = external dso_local constant [256 x i8], align 16

define dso_local void @aes128_encrypt(i8* nocapture %out, i8* nocapture readonly %in, i8* nocapture readonly %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %rk = alloca [176 x i8], align 16

  ; state[i] = in[i]
  br label %copy_in.loop

copy_in.loop:                                     ; preds = %copy_in.loop, %entry
  %ci.i = phi i32 [ 0, %entry ], [ %ci.i.next, %copy_in.loop ]
  %ci.i64 = zext i32 %ci.i to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %ci.i64
  %in.val = load i8, i8* %in.ptr, align 1
  %state.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ci.i64
  store i8 %in.val, i8* %state.ptr, align 1
  %ci.i.next = add nuw nsw i32 %ci.i, 1
  %ci.cond = icmp sle i32 %ci.i.next, 15
  br i1 %ci.cond, label %copy_in.loop, label %copy_key.loop

; rk[i] = key[i] for i in 0..15
copy_key.loop:                                   ; preds = %copy_in.loop, %copy_key.loop
  %ck.i = phi i32 [ 0, %copy_in.loop ], [ %ck.i.next, %copy_key.loop ]
  %ck.i64 = zext i32 %ck.i to i64
  %key.ptr = getelementptr inbounds i8, i8* %key, i64 %ck.i64
  %key.val = load i8, i8* %key.ptr, align 1
  %rk.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %ck.i64
  store i8 %key.val, i8* %rk.ptr, align 1
  %ck.i.next = add nuw nsw i32 %ck.i, 1
  %ck.cond = icmp sle i32 %ck.i.next, 15
  br i1 %ck.cond, label %copy_key.loop, label %kexp.init

kexp.init:                                        ; preds = %copy_key.loop
  %i = phi i32 [ 16, %copy_key.loop ]
  %rci = phi i32 [ 0, %copy_key.loop ]
  br label %kexp.loop

; Key expansion generates 176 bytes in rk[]
kexp.loop:                                       ; preds = %kexp.loop, %kexp.init
  %i.cur = phi i32 [ %i, %kexp.init ], [ %i.next4, %kexp.loop ]
  %rcon.idx = phi i32 [ %rci, %kexp.init ], [ %rcon.idx.next, %kexp.loop ]

  ; temp = rk[i-4 .. i-1]
  %i.sub4 = add nsw i32 %i.cur, -4
  %i.sub3 = add nsw i32 %i.cur, -3
  %i.sub2 = add nsw i32 %i.cur, -2
  %i.sub1 = add nsw i32 %i.cur, -1
  %i.sub4.i64 = sext i32 %i.sub4 to i64
  %i.sub3.i64 = sext i32 %i.sub3 to i64
  %i.sub2.i64 = sext i32 %i.sub2 to i64
  %i.sub1.i64 = sext i32 %i.sub1 to i64
  %t0.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.sub4.i64
  %t1.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.sub3.i64
  %t2.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.sub2.i64
  %t3.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.sub1.i64
  %t0 = load i8, i8* %t0.ptr, align 1
  %t1 = load i8, i8* %t1.ptr, align 1
  %t2 = load i8, i8* %t2.ptr, align 1
  %t3 = load i8, i8* %t3.ptr, align 1

  ; if (i % 16 == 0) { RotWord, SubWord via sbox, XOR with Rcon[rcon_idx], rcon_idx++ }
  %i.mod16 = and i32 %i.cur, 15
  %i.mod16.eq0 = icmp eq i32 %i.mod16, 0
  br i1 %i.mod16.eq0, label %kexp.rotword, label %kexp.norot

kexp.rotword:                                    ; preds = %kexp.loop
  ; rotate left by 1 byte: (t1,t2,t3,t0)
  %rw0 = call fastcc i8 @sbox_lookup(i8 %t1)
  %rw1 = call fastcc i8 @sbox_lookup(i8 %t2)
  %rw2 = call fastcc i8 @sbox_lookup(i8 %t3)
  %rw3 = call fastcc i8 @sbox_lookup(i8 %t0)
  ; rcon
  %rci.i64 = zext i32 %rcon.idx to i64
  %rcon.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @rcon_0, i64 0, i64 %rci.i64
  %rcon.val = load i8, i8* %rcon.ptr, align 1
  %rw0.r = xor i8 %rw0, %rcon.val
  %t0.sel = %rw0.r
  %t1.sel = %rw1
  %t2.sel = %rw2
  %t3.sel = %rw3
  %rcon.idx.next = add nuw nsw i32 %rcon.idx, 1
  br label %kexp.write

kexp.norot:                                      ; preds = %kexp.loop
  %t0.sel.n = %t0
  %t1.sel.n = %t1
  %t2.sel.n = %t2
  %t3.sel.n = %t3
  %rcon.idx.next.n = %rcon.idx
  br label %kexp.write

kexp.write:                                      ; preds = %kexp.norot, %kexp.rotword
  %t0w = phi i8 [ %t0.sel, %kexp.rotword ], [ %t0.sel.n, %kexp.norot ]
  %t1w = phi i8 [ %t1.sel, %kexp.rotword ], [ %t1.sel.n, %kexp.norot ]
  %t2w = phi i8 [ %t2.sel, %kexp.rotword ], [ %t2.sel.n, %kexp.norot ]
  %t3w = phi i8 [ %t3.sel, %kexp.rotword ], [ %t3.sel.n, %kexp.norot ]
  %rcon.idx.next = phi i32 [ %rcon.idx.next, %kexp.rotword ], [ %rcon.idx.next.n, %kexp.norot ]

  ; rk[i + j] = rk[i + j - 16] ^ t[j]
  %i.sub16 = add nsw i32 %i.cur, -16
  %i.sub16.i64 = sext i32 %i.sub16 to i64
  %base.prev = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %i.sub16.i64
  %base.cur = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 (sext (i32 %i.cur) to i64)

  ; j = 0
  %prev0 = load i8, i8* %base.prev, align 1
  %new0 = xor i8 %prev0, %t0w
  store i8 %new0, i8* %base.cur, align 1

  ; j = 1
  %prev1.ptr = getelementptr inbounds i8, i8* %base.prev, i64 1
  %cur1.ptr = getelementptr inbounds i8, i8* %base.cur, i64 1
  %prev1 = load i8, i8* %prev1.ptr, align 1
  %new1 = xor i8 %prev1, %t1w
  store i8 %new1, i8* %cur1.ptr, align 1

  ; j = 2
  %prev2.ptr = getelementptr inbounds i8, i8* %base.prev, i64 2
  %cur2.ptr = getelementptr inbounds i8, i8* %base.cur, i64 2
  %prev2 = load i8, i8* %prev2.ptr, align 1
  %new2 = xor i8 %prev2, %t2w
  store i8 %new2, i8* %cur2.ptr, align 1

  ; j = 3
  %prev3.ptr = getelementptr inbounds i8, i8* %base.prev, i64 3
  %cur3.ptr = getelementptr inbounds i8, i8* %base.cur, i64 3
  %prev3 = load i8, i8* %prev3.ptr, align 1
  %new3 = xor i8 %prev3, %t3w
  store i8 %new3, i8* %cur3.ptr, align 1

  %i.next4 = add nuw nsw i32 %i.cur, 4
  %kexp.cond = icmp sle i32 %i.next4, 175
  br i1 %kexp.cond, label %kexp.loop, label %ark0

; Initial AddRoundKey
ark0:                                             ; preds = %kexp.write
  br label %ark0.loop

ark0.loop:                                        ; preds = %ark0.loop, %ark0
  %ar0.i = phi i32 [ 0, %ark0 ], [ %ar0.i.next, %ark0.loop ]
  %ar0.i64 = zext i32 %ar0.i to i64
  %s.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ar0.i64
  %s.v = load i8, i8* %s.ptr, align 1
  %rk0.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %ar0.i64
  %rk0.v = load i8, i8* %rk0.ptr, align 1
  %sx = xor i8 %s.v, %rk0.v
  store i8 %sx, i8* %s.ptr, align 1
  %ar0.i.next = add nuw nsw i32 %ar0.i, 1
  %ar0.cond = icmp sle i32 %ar0.i.next, 15
  br i1 %ar0.cond, label %ark0.loop, label %rounds.init

; round = 1..9
rounds.init:                                      ; preds = %ark0.loop
  br label %rounds.loop

rounds.loop:                                      ; preds = %mix.addkey, %rounds.init
  %round = phi i32 [ 1, %rounds.init ], [ %round.next, %mix.addkey ]
  ; SubBytes
  br label %sub.loop

sub.loop:                                         ; preds = %sub.loop, %rounds.loop
  %si = phi i32 [ 0, %rounds.loop ], [ %si.next, %sub.loop ]
  %si.i64 = zext i32 %si to i64
  %sp = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %si.i64
  %sv = load i8, i8* %sp, align 1
  %sb = call fastcc i8 @sbox_lookup(i8 %sv)
  store i8 %sb, i8* %sp, align 1
  %si.next = add nuw nsw i32 %si, 1
  %sub.cond = icmp sle i32 %si.next, 15
  br i1 %sub.cond, label %sub.loop, label %shiftrows

; ShiftRows
shiftrows:                                        ; preds = %sub.loop
  ; Row 1: [1,5,9,13] rotate left by 1
  %p1  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %p5  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %p9  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %p13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %v1  = load i8, i8* %p1, align 1
  %v5  = load i8, i8* %p5, align 1
  %v9  = load i8, i8* %p9, align 1
  %v13 = load i8, i8* %p13, align 1
  store i8 %v5,  i8* %p1,  align 1
  store i8 %v9,  i8* %p5,  align 1
  store i8 %v13, i8* %p9,  align 1
  store i8 %v1,  i8* %p13, align 1

  ; Row 2: [2,6,10,14] rotate left by 2 (swap 2<->10, 6<->14)
  %p2  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %p6  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %p10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %p14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %v2  = load i8, i8* %p2, align 1
  %v6  = load i8, i8* %p6, align 1
  %v10 = load i8, i8* %p10, align 1
  %v14 = load i8, i8* %p14, align 1
  store i8 %v10, i8* %p2,  align 1
  store i8 %v14, i8* %p6,  align 1
  store i8 %v2,  i8* %p10, align 1
  store i8 %v6,  i8* %p14, align 1

  ; Row 3: [3,7,11,15] rotate left by 3 (right by 1)
  %p3  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %p7  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %p11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %p15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %v3  = load i8, i8* %p3, align 1
  %v7  = load i8, i8* %p7, align 1
  %v11 = load i8, i8* %p11, align 1
  %v15 = load i8, i8* %p15, align 1
  store i8 %v11, i8* %p15, align 1
  store i8 %v7,  i8* %p11, align 1
  store i8 %v3,  i8* %p7,  align 1
  store i8 %v15, i8* %p3,  align 1

  ; MixColumns
  br label %mix.loop

mix.loop:                                         ; preds = %mix.loop, %shiftrows
  %mc = phi i32 [ 0, %shiftrows ], [ %mc.next, %mix.loop ]

  %base = mul nuw nsw i32 %mc, 4
  %b0.i64 = zext i32 %base to i64
  %b1.i64 = add nuw nsw i64 %b0.i64, 1
  %b2.i64 = add nuw nsw i64 %b0.i64, 2
  %b3.i64 = add nuw nsw i64 %b0.i64, 3

  %sp0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b0.i64
  %sp1 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b1.i64
  %sp2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b2.i64
  %sp3 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %b3.i64

  %a0 = load i8, i8* %sp0, align 1
  %a1 = load i8, i8* %sp1, align 1
  %a2 = load i8, i8* %sp2, align 1
  %a3 = load i8, i8* %sp3, align 1

  %t01 = xor i8 %a0, %a1
  %t23 = xor i8 %a2, %a3
  %t = xor i8 %t01, %t23

  ; new0 = a0 ^ t ^ xtime(a0 ^ a1)
  %x01 = xor i8 %a0, %a1
  %xt01 = call fastcc i8 @xtime(i8 %x01)
  %n0t = xor i8 %a0, %t
  %n0  = xor i8 %n0t, %xt01
  store i8 %n0, i8* %sp0, align 1

  ; new1 = a1 ^ t ^ xtime(a1 ^ a2)
  %x12 = xor i8 %a1, %a2
  %xt12 = call fastcc i8 @xtime(i8 %x12)
  %n1t = xor i8 %a1, %t
  %n1  = xor i8 %n1t, %xt12
  store i8 %n1, i8* %sp1, align 1

  ; new2 = a2 ^ t ^ xtime(a2 ^ a3)
  %x23 = xor i8 %a2, %a3
  %xt23 = call fastcc i8 @xtime(i8 %x23)
  %n2t = xor i8 %a2, %t
  %n2  = xor i8 %n2t, %xt23
  store i8 %n2, i8* %sp2, align 1

  ; new3 = a3 ^ t ^ xtime(a3 ^ a0)
  %x30 = xor i8 %a3, %a0
  %xt30 = call fastcc i8 @xtime(i8 %x30)
  %n3t = xor i8 %a3, %t
  %n3  = xor i8 %n3t, %xt30
  store i8 %n3, i8* %sp3, align 1

  %mc.next = add nuw nsw i32 %mc, 1
  %mix.cond = icmp sle i32 %mc.next, 3
  br i1 %mix.cond, label %mix.loop, label %mix.addkey

; AddRoundKey with round key offset = round * 16
mix.addkey:                                       ; preds = %mix.loop
  %rk.off = shl nuw nsw i32 %round, 4
  br label %ark.loop

ark.loop:                                         ; preds = %ark.loop, %mix.addkey
  %ai = phi i32 [ 0, %mix.addkey ], [ %ai.next, %ark.loop ]
  %ai.i64 = zext i32 %ai to i64
  %sp.i = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %ai.i64
  %sv.i = load i8, i8* %sp.i, align 1
  %rk.idx = add nuw nsw i32 %rk.off, %ai
  %rk.idx.i64 = zext i32 %rk.idx to i64
  %rk.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %rk.idx.i64
  %rk.v = load i8, i8* %rk.p, align 1
  %sv.x = xor i8 %sv.i, %rk.v
  store i8 %sv.x, i8* %sp.i, align 1
  %ai.next = add nuw nsw i32 %ai, 1
  %ark.cond = icmp sle i32 %ai.next, 15
  br i1 %ark.cond, label %ark.loop, label %rounds.next

rounds.next:                                      ; preds = %ark.loop
  %round.next = add nuw nsw i32 %round, 1
  %rounds.cond = icmp sle i32 %round.next, 9
  br i1 %rounds.cond, label %rounds.loop, label %final.sub

; Final round: SubBytes
final.sub:                                        ; preds = %rounds.next
  br label %fsub.loop

fsub.loop:                                        ; preds = %fsub.loop, %final.sub
  %fsi = phi i32 [ 0, %final.sub ], [ %fsi.next, %fsub.loop ]
  %fsi.i64 = zext i32 %fsi to i64
  %fsp = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fsi.i64
  %fsv = load i8, i8* %fsp, align 1
  %fsb = call fastcc i8 @sbox_lookup(i8 %fsv)
  store i8 %fsb, i8* %fsp, align 1
  %fsi.next = add nuw nsw i32 %fsi, 1
  %fsub.cond = icmp sle i32 %fsi.next, 15
  br i1 %fsub.cond, label %fsub.loop, label %final.shift

; Final round: ShiftRows (same as before)
final.shift:                                      ; preds = %fsub.loop
  ; Row 1
  %fp1  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 1
  %fp5  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 5
  %fp9  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 9
  %fp13 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 13
  %fv1  = load i8, i8* %fp1,  align 1
  %fv5  = load i8, i8* %fp5,  align 1
  %fv9  = load i8, i8* %fp9,  align 1
  %fv13 = load i8, i8* %fp13, align 1
  store i8 %fv5,  i8* %fp1,  align 1
  store i8 %fv9,  i8* %fp5,  align 1
  store i8 %fv13, i8* %fp9,  align 1
  store i8 %fv1,  i8* %fp13, align 1

  ; Row 2
  %fp2  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 2
  %fp6  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 6
  %fp10 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 10
  %fp14 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 14
  %fv2  = load i8, i8* %fp2,  align 1
  %fv6  = load i8, i8* %fp6,  align 1
  %fv10 = load i8, i8* %fp10, align 1
  %fv14 = load i8, i8* %fp14, align 1
  store i8 %fv10, i8* %fp2,  align 1
  store i8 %fv14, i8* %fp6,  align 1
  store i8 %fv2,  i8* %fp10, align 1
  store i8 %fv6,  i8* %fp14, align 1

  ; Row 3
  %fp3  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 3
  %fp7  = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 7
  %fp11 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 11
  %fp15 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 15
  %fv3  = load i8, i8* %fp3,  align 1
  %fv7  = load i8, i8* %fp7,  align 1
  %fv11 = load i8, i8* %fp11, align 1
  %fv15 = load i8, i8* %fp15, align 1
  store i8 %fv11, i8* %fp15, align 1
  store i8 %fv7,  i8* %fp11, align 1
  store i8 %fv3,  i8* %fp7,  align 1
  store i8 %fv15, i8* %fp3,  align 1

  ; Final AddRoundKey with offset 160
  br label %final.ark.loop

final.ark.loop:                                   ; preds = %final.ark.loop, %final.shift
  %fai = phi i32 [ 0, %final.shift ], [ %fai.next, %final.ark.loop ]
  %fai.i64 = zext i32 %fai to i64
  %fsp.i = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %fai.i64
  %fsv.i = load i8, i8* %fsp.i, align 1
  %frk.idx = add nuw nsw i32 %fai, 160
  %frk.idx.i64 = zext i32 %frk.idx to i64
  %frk.p = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %frk.idx.i64
  %frk.v = load i8, i8* %frk.p, align 1
  %fsv.x = xor i8 %fsv.i, %frk.v
  store i8 %fsv.x, i8* %fsp.i, align 1
  %fai.next = add nuw nsw i32 %fai, 1
  %fark.cond = icmp sle i32 %fai.next, 15
  br i1 %fark.cond, label %final.ark.loop, label %store_out

; store state to out
store_out:                                        ; preds = %final.ark.loop
  br label %store_out.loop

store_out.loop:                                   ; preds = %store_out.loop, %store_out
  %so.i = phi i32 [ 0, %store_out ], [ %so.i.next, %store_out.loop ]
  %so.i64 = zext i32 %so.i to i64
  %sp.s = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %so.i64
  %sv.s = load i8, i8* %sp.s, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %so.i64
  store i8 %sv.s, i8* %out.ptr, align 1
  %so.i.next = add nuw nsw i32 %so.i, 1
  %so.cond = icmp sle i32 %so.i.next, 15
  br i1 %so.cond, label %store_out.loop, label %ret

ret:                                              ; preds = %store_out.loop
  ret void
}

; xtime: multiply by 0x02 in GF(2^8)
define internal fastcc i8 @xtime(i8 %x) unnamed_addr {
entry:
  %shl = shl i8 %x, 1
  %msb = and i8 %x, -128
  %hasmsb = icmp ne i8 %msb, 0
  %mask = select i1 %hasmsb, i8 27, i8 0
  %res = xor i8 %shl, %mask
  ret i8 %res
}

; S-box lookup
define internal fastcc i8 @sbox_lookup(i8 %b) unnamed_addr {
entry:
  %idx = zext i8 %b to i64
  %ptr = getelementptr inbounds [256 x i8], [256 x i8]* @sbox_1, i64 0, i64 %idx
  %val = load i8, i8* %ptr, align 1
  ret i8 %val
}