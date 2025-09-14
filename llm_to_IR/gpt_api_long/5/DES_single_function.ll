; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt  ; Address: 0x1189
; Intent: DES block encryption (single 64-bit block with 64-bit key) (confidence=0.95). Evidence: PC1/PC2/IP/FP/E/SBOX/P tables and 16-round Feistel structure
; Preconditions: Tables PC1_7, SHIFTS_6, PC2_5, IP_4, E_3, SBOX_2, P_1, FP_0 are provided and properly populated
; Postconditions: Returns the 64-bit ciphertext of the input block under the given key

@PC1_7 = external global i32
@SHIFTS_6 = external global i32
@PC2_5 = external global i32
@IP_4 = external global i32
@E_3 = external global i32
@SBOX_2 = external global i8
@P_1 = external global i32
@FP_0 = external global i32

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 8
  ; Build 56-bit key from PC1
  br label %pc1.loop

pc1.loop:                                            ; preds = %pc1.loop, %entry
  %pc1.i = phi i32 [ 0, %entry ], [ %pc1.i.next, %pc1.loop ]
  %pc1.acc = phi i64 [ 0, %entry ], [ %pc1.acc.next, %pc1.loop ]
  %pc1.cmp = icmp sle i32 %pc1.i, 55
  br i1 %pc1.cmp, label %pc1.body, label %pc1.done

pc1.body:                                            ; preds = %pc1.loop
  %pc1.idx64 = zext i32 %pc1.i to i64
  %pc1.ptr = getelementptr inbounds i32, i32* @PC1_7, i64 %pc1.idx64
  %pc1.pos = load i32, i32* %pc1.ptr, align 4
  %pc1.sh = sub i32 64, %pc1.pos
  %pc1.sh64 = zext i32 %pc1.sh to i64
  %pc1.ks = lshr i64 %key, %pc1.sh64
  %pc1.bit = and i64 %pc1.ks, 1
  %pc1.acc.shl = shl i64 %pc1.acc, 1
  %pc1.acc.next = or i64 %pc1.acc.shl, %pc1.bit
  %pc1.i.next = add i32 %pc1.i, 1
  br label %pc1.loop

pc1.done:                                            ; preds = %pc1.loop
  %c.tmp64 = lshr i64 %pc1.acc, 28
  %c.tmp32 = trunc i64 %c.tmp64 to i32
  %C0 = and i32 %c.tmp32, 268435455
  %d.tmp32 = trunc i64 %pc1.acc to i32
  %D0 = and i32 %d.tmp32, 268435455
  ; Generate 16 subkeys
  br label %rk.loop

rk.loop:                                             ; preds = %rk.loop, %pc1.done
  %rk.i = phi i32 [ 0, %pc1.done ], [ %rk.i.next, %rk.loop ]
  %C.phi = phi i32 [ %C0, %pc1.done ], [ %C.next, %rk.loop ]
  %D.phi = phi i32 [ %D0, %pc1.done ], [ %D.next, %rk.loop ]
  %rk.cmp = icmp sle i32 %rk.i, 15
  br i1 %rk.cmp, label %rk.body, label %rk.done

rk.body:                                             ; preds = %rk.loop
  ; rotation amount
  %sh.idx64 = zext i32 %rk.i to i64
  %sh.ptr = getelementptr inbounds i32, i32* @SHIFTS_6, i64 %sh.idx64
  %sh.val = load i32, i32* %sh.ptr, align 4
  ; rotate C (28-bit)
  %c.l = shl i32 %C.phi, %sh.val
  %c.rshamt = sub i32 28, %sh.val
  %c.r = lshr i32 %C.phi, %c.rshamt
  %c.rot = or i32 %c.l, %c.r
  %C.next = and i32 %c.rot, 268435455
  ; rotate D (28-bit)
  %d.l = shl i32 %D.phi, %sh.val
  %d.rshamt = sub i32 28, %sh.val
  %d.r = lshr i32 %D.phi, %d.rshamt
  %d.rot = or i32 %d.l, %d.r
  %D.next = and i32 %d.rot, 268435455
  ; combine into 56-bit
  %C64 = zext i32 %C.next to i64
  %C64.sh = shl i64 %C64, 28
  %D64 = zext i32 %D.next to i64
  %CD56 = or i64 %C64.sh, %D64
  ; PC2 -> 48-bit subkey
  br label %pc2.loop

pc2.loop:                                            ; preds = %pc2.loop, %rk.body
  %pc2.i = phi i32 [ 0, %rk.body ], [ %pc2.i.next, %pc2.loop ]
  %pc2.acc = phi i64 [ 0, %rk.body ], [ %pc2.acc.next, %pc2.loop ]
  %pc2.cmp = icmp sle i32 %pc2.i, 47
  br i1 %pc2.cmp, label %pc2.body, label %pc2.done

pc2.body:                                            ; preds = %pc2.loop
  %pc2.idx64 = zext i32 %pc2.i to i64
  %pc2.ptr = getelementptr inbounds i32, i32* @PC2_5, i64 %pc2.idx64
  %pc2.pos = load i32, i32* %pc2.ptr, align 4
  %pc2.sh = sub i32 56, %pc2.pos
  %pc2.sh64 = zext i32 %pc2.sh to i64
  %pc2.src = lshr i64 %CD56, %pc2.sh64
  %pc2.bit = and i64 %pc2.src, 1
  %pc2.acc.shl = shl i64 %pc2.acc, 1
  %pc2.acc.next = or i64 %pc2.acc.shl, %pc2.bit
  %pc2.i.next = add i32 %pc2.i, 1
  br label %pc2.loop

pc2.done:                                            ; preds = %pc2.loop
  %sk.slot = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %sh.idx64
  store i64 %pc2.acc, i64* %sk.slot, align 8
  %rk.i.next = add i32 %rk.i, 1
  br label %rk.loop

rk.done:                                             ; preds = %rk.loop
  ; Initial Permutation on block
  br label %ip.loop

ip.loop:                                             ; preds = %ip.loop, %rk.done
  %ip.i = phi i32 [ 0, %rk.done ], [ %ip.i.next, %ip.loop ]
  %ip.acc = phi i64 [ 0, %rk.done ], [ %ip.acc.next, %ip.loop ]
  %ip.cmp = icmp sle i32 %ip.i, 63
  br i1 %ip.cmp, label %ip.body, label %ip.done

ip.body:                                             ; preds = %ip.loop
  %ip.idx64 = zext i32 %ip.i to i64
  %ip.ptr = getelementptr inbounds i32, i32* @IP_4, i64 %ip.idx64
  %ip.pos = load i32, i32* %ip.ptr, align 4
  %ip.sh = sub i32 64, %ip.pos
  %ip.sh64 = zext i32 %ip.sh to i64
  %ip.src = lshr i64 %block, %ip.sh64
  %ip.bit = and i64 %ip.src, 1
  %ip.acc.shl = shl i64 %ip.acc, 1
  %ip.acc.next = or i64 %ip.acc.shl, %ip.bit
  %ip.i.next = add i32 %ip.i, 1
  br label %ip.loop

ip.done:                                             ; preds = %ip.loop
  %L0.sh64 = lshr i64 %ip.acc, 32
  %L0.i32 = trunc i64 %L0.sh64 to i32
  %R0.i32 = trunc i64 %ip.acc to i32
  br label %round.loop

round.loop:                                          ; preds = %round.loop, %ip.done
  %r.i = phi i32 [ 0, %ip.done ], [ %r.i.next, %round.loop ]
  %L.phi = phi i32 [ %L0.i32, %ip.done ], [ %L.next, %round.loop ]
  %R.phi = phi i32 [ %R0.i32, %ip.done ], [ %R.next, %round.loop ]
  %r.cmp = icmp sle i32 %r.i, 15
  br i1 %r.cmp, label %round.body, label %round.done

round.body:                                          ; preds = %round.loop
  ; Expansion E on R
  br label %e.loop

e.loop:                                              ; preds = %e.loop, %round.body
  %e.i = phi i32 [ 0, %round.body ], [ %e.i.next, %e.loop ]
  %e.acc = phi i64 [ 0, %round.body ], [ %e.acc.next, %e.loop ]
  %e.cmp = icmp sle i32 %e.i, 47
  br i1 %e.cmp, label %e.body, label %e.done

e.body:                                              ; preds = %e.loop
  %e.idx64 = zext i32 %e.i to i64
  %e.ptr = getelementptr inbounds i32, i32* @E_3, i64 %e.idx64
  %e.pos = load i32, i32* %e.ptr, align 4
  %e.sh = sub i32 32, %e.pos
  %e.src = lshr i32 %R.phi, %e.sh
  %e.bit32 = and i32 %e.src, 1
  %e.bit64 = zext i32 %e.bit32 to i64
  %e.acc.shl = shl i64 %e.acc, 1
  %e.acc.next = or i64 %e.acc.shl, %e.bit64
  %e.i.next = add i32 %e.i, 1
  br label %e.loop

e.done:                                              ; preds = %e.loop
  ; XOR with subkey
  %sk.ptr2 = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 (zext i32 %r.i to i64)
  %sk.val = load i64, i64* %sk.ptr2, align 8
  %A0 = xor i64 %e.acc, %sk.val
  ; S-box substitution
  br label %s.loop

s.loop:                                              ; preds = %s.loop, %e.done
  %s.i = phi i32 [ 0, %e.done ], [ %s.i.next, %s.loop ]
  %s.acc = phi i32 [ 0, %e.done ], [ %s.acc.next, %s.loop ]
  %s.cmp = icmp sle i32 %s.i, 7
  br i1 %s.cmp, label %s.body, label %s.done

s.body:                                              ; preds = %s.loop
  %mul6 = mul i32 %s.i, 6
  %s.sh = sub i32 42, %mul6
  %s.sh64 = zext i32 %s.sh to i64
  %s.src64 = lshr i64 %A0, %s.sh64
  %s.src32 = trunc i64 %s.src64 to i32
  %bits6 = and i32 %s.src32, 63
  %row_hi = lshr i32 %bits6, 4
  %row_hi2 = and i32 %row_hi, 2
  %row_lo = and i32 %bits6, 1
  %row = or i32 %row_hi2, %row_lo
  %col.sh = lshr i32 %bits6, 1
  %col = and i32 %col.sh, 15
  %row4 = shl i32 %row, 4
  %s.idx = add i32 %row4, %col
  %base = mul i32 %s.i, 64
  %s.tot = add i32 %base, %s.idx
  %s.tot64 = zext i32 %s.tot to i64
  %s.ptr = getelementptr inbounds i8, i8* @SBOX_2, i64 %s.tot64
  %s.val8 = load i8, i8* %s.ptr, align 1
  %s.val = zext i8 %s.val8 to i32
  %s.acc.shl = shl i32 %s.acc, 4
  %s.acc.next = or i32 %s.acc.shl, %s.val
  %s.i.next = add i32 %s.i, 1
  br label %s.loop

s.done:                                              ; preds = %s.loop
  ; Permutation P
  br label %p.loop

p.loop:                                              ; preds = %p.loop, %s.done
  %p.i = phi i32 [ 0, %s.done ], [ %p.i.next, %p.loop ]
  %p.acc = phi i32 [ 0, %s.done ], [ %p.acc.next, %p.loop ]
  %p.cmp = icmp sle i32 %p.i, 31
  br i1 %p.cmp, label %p.body, label %p.done

p.body:                                              ; preds = %p.loop
  %p.idx64 = zext i32 %p.i to i64
  %p.ptr = getelementptr inbounds i32, i32* @P_1, i64 %p.idx64
  %p.pos = load i32, i32* %p.ptr, align 4
  %p.sh = sub i32 32, %p.pos
  %p.src = lshr i32 %s.acc, %p.sh
  %p.bit = and i32 %p.src, 1
  %p.acc.shl = shl i32 %p.acc, 1
  %p.acc.next = or i32 %p.acc.shl, %p.bit
  %p.i.next = add i32 %p.i, 1
  br label %p.loop

p.done:                                              ; preds = %p.loop
  %F = xor i32 %L.phi, %p.acc
  %L.next = %R.phi
  %R.next = %F
  %r.i.next = add i32 %r.i, 1
  br label %round.loop

round.done:                                          ; preds = %round.loop
  ; combine R||L
  %R64f = zext i32 %R.phi to i64
  %L64f = zext i32 %L.phi to i64
  %R64f.sh = shl i64 %R64f, 32
  %preout = or i64 %R64f.sh, %L64f
  ; Final Permutation
  br label %fp.loop

fp.loop:                                             ; preds = %fp.loop, %round.done
  %fp.i = phi i32 [ 0, %round.done ], [ %fp.i.next, %fp.loop ]
  %fp.acc = phi i64 [ 0, %round.done ], [ %fp.acc.next, %fp.loop ]
  %fp.cmp = icmp sle i32 %fp.i, 63
  br i1 %fp.cmp, label %fp.body, label %fp.done

fp.body:                                             ; preds = %fp.loop
  %fp.idx64 = zext i32 %fp.i to i64
  %fp.ptr = getelementptr inbounds i32, i32* @FP_0, i64 %fp.idx64
  %fp.pos = load i32, i32* %fp.ptr, align 4
  %fp.sh = sub i32 64, %fp.pos
  %fp.sh64 = zext i32 %fp.sh to i64
  %fp.src = lshr i64 %preout, %fp.sh64
  %fp.bit = and i64 %fp.src, 1
  %fp.acc.shl = shl i64 %fp.acc, 1
  %fp.acc.next = or i64 %fp.acc.shl, %fp.bit
  %fp.i.next = add i32 %fp.i, 1
  br label %fp.loop

fp.done:                                             ; preds = %fp.loop
  ret i64 %fp.acc
}