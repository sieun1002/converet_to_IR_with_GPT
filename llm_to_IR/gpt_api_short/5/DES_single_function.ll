; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt ; Address: 0x1189
; Intent: DES block encryption (64-bit block, 16 rounds, with key schedule) (confidence=0.93). Evidence: Uses standard DES tables PC1, SHIFTS, PC2, IP, E, SBOX, P, FP and 16-round Feistel structure.
; Preconditions: None
; Postconditions: Returns 64-bit ciphertext of the 64-bit plaintext under the 64-bit key.

; Only the necessary external declarations:
@PC1_7 = external constant [56 x i32], align 4
@SHIFTS_6 = external constant [16 x i32], align 4
@PC2_5 = external constant [48 x i32], align 4
@IP_4 = external constant [64 x i32], align 4
@E_3 = external constant [48 x i32], align 4
@SBOX_2 = external constant [512 x i8], align 1
@P_1 = external constant [32 x i32], align 4
@FP_0 = external constant [64 x i32], align 4
@__stack_chk_guard = external global i64
declare void @___stack_chk_fail() local_unnamed_addr

define dso_local i64 @des_encrypt(i64 %plaintext, i64 %key) local_unnamed_addr {
entry:
  ; stack protector
  %canary0 = load i64, i64* @__stack_chk_guard, align 8

  ; Allocate subkeys storage: 16 round keys (48-bit values in i64)
  %subkeys = alloca [16 x i64], align 16

  ; Key schedule: PC-1 permutation to 56-bit
  %pc1.i0 = alloca i32, align 4
  store i32 0, i32* %pc1.i0, align 4
  %pc1.acc0 = alloca i64, align 8
  store i64 0, i64* %pc1.acc0, align 8
  br label %pc1.loop

pc1.loop:
  %i.pc1 = load i32, i32* %pc1.i0, align 4
  %cmp.pc1 = icmp sle i32 %i.pc1, 55
  br i1 %cmp.pc1, label %pc1.body, label %pc1.done

pc1.body:
  %i64.pc1 = sext i32 %i.pc1 to i64
  %pos.ptr = getelementptr inbounds [56 x i32], [56 x i32]* @PC1_7, i64 0, i64 %i64.pc1
  %pos = load i32, i32* %pos.ptr, align 4
  %pos.z = zext i32 %pos to i64
  %sh.tmp = sub i64 64, %pos.z
  %bit.sh = lshr i64 %key, %sh.tmp
  %bit = and i64 %bit.sh, 1
  %acc = load i64, i64* %pc1.acc0, align 8
  %acc.shl = shl i64 %acc, 1
  %acc.new = or i64 %acc.shl, %bit
  store i64 %acc.new, i64* %pc1.acc0, align 8
  %i.next = add i32 %i.pc1, 1
  store i32 %i.next, i32* %pc1.i0, align 4
  br label %pc1.loop

pc1.done:
  %acc.final = load i64, i64* %pc1.acc0, align 8
  ; split into C (left) and D (right), 28 bits each
  %C64 = lshr i64 %acc.final, 28
  %C32 = trunc i64 %C64 to i32
  %C = and i32 %C32, 268435455 ; 0x0FFFFFFF
  %D32 = trunc i64 %acc.final to i32
  %D = and i32 %D32, 268435455

  ; Generate 16 subkeys
  br label %roundks.loop

roundks.loop:
  %r.phi = phi i32 [ 0, %pc1.done ], [ %r.next, %roundks.next ]
  %C.phi = phi i32 [ %C, %pc1.done ], [ %C.new, %roundks.next ]
  %D.phi = phi i32 [ %D, %pc1.done ], [ %D.new, %roundks.next ]
  %cmp.r = icmp sle i32 %r.phi, 15
  br i1 %cmp.r, label %roundks.body, label %roundks.done

roundks.body:
  ; load shift amount
  %r.idx64 = sext i32 %r.phi to i64
  %sh.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS_6, i64 0, i64 %r.idx64
  %shamt = load i32, i32* %sh.ptr, align 4
  ; rotate C left by shamt within 28 bits
  %C.shl = shl i32 %C.phi, %shamt
  %invsh = sub i32 28, %shamt
  %C.shr = lshr i32 %C.phi, %invsh
  %C.rot = or i32 %C.shl, %C.shr
  %C.new = and i32 %C.rot, 268435455
  ; rotate D
  %D.shl = shl i32 %D.phi, %shamt
  %D.shr = lshr i32 %D.phi, %invsh
  %D.rot = or i32 %D.shl, %D.shr
  %D.new = and i32 %D.rot, 268435455
  ; combine to 56-bit
  %C.new.z = zext i32 %C.new to i64
  %C.new.shl = shl i64 %C.new.z, 28
  %D.new.z = zext i32 %D.new to i64
  %CD56 = or i64 %C.new.shl, %D.new.z
  ; PC-2 to 48-bit subkey
  %pc2.i = alloca i32, align 4
  store i32 0, i32* %pc2.i, align 4
  %sub.acc = alloca i64, align 8
  store i64 0, i64* %sub.acc, align 8
  br label %pc2.loop

pc2.loop:
  %i.pc2 = load i32, i32* %pc2.i, align 4
  %cmp.pc2 = icmp sle i32 %i.pc2, 47
  br i1 %cmp.pc2, label %pc2.body, label %pc2.done

pc2.body:
  %i.pc2.64 = sext i32 %i.pc2 to i64
  %pos2.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @PC2_5, i64 0, i64 %i.pc2.64
  %pos2 = load i32, i32* %pos2.ptr, align 4
  %pos2.z = zext i32 %pos2 to i64
  %sh2 = sub i64 56, %pos2.z
  %bit2.sh = lshr i64 %CD56, %sh2
  %bit2 = and i64 %bit2.sh, 1
  %sub.cur = load i64, i64* %sub.acc, align 8
  %sub.shl = shl i64 %sub.cur, 1
  %sub.new = or i64 %sub.shl, %bit2
  store i64 %sub.new, i64* %sub.acc, align 8
  %i.pc2.next = add i32 %i.pc2, 1
  store i32 %i.pc2.next, i32* %pc2.i, align 4
  br label %pc2.loop

pc2.done:
  %sub.final = load i64, i64* %sub.acc, align 8
  ; store subkey
  %sk.base = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %r.idx64
  store i64 %sub.final, i64* %sk.base, align 8
  br label %roundks.next

roundks.next:
  %r.next = add i32 %r.phi, 1
  br label %roundks.loop

roundks.done:
  ; Initial Permutation on plaintext
  %ip.i = alloca i32, align 4
  store i32 0, i32* %ip.i, align 4
  %ip.acc = alloca i64, align 8
  store i64 0, i64* %ip.acc, align 8
  br label %ip.loop

ip.loop:
  %i.ip = load i32, i32* %ip.i, align 4
  %cmp.ip = icmp sle i32 %i.ip, 63
  br i1 %cmp.ip, label %ip.body, label %ip.done

ip.body:
  %i.ip.64 = sext i32 %i.ip to i64
  %posIP.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @IP_4, i64 0, i64 %i.ip.64
  %posIP = load i32, i32* %posIP.ptr, align 4
  %posIP.z = zext i32 %posIP to i64
  %shIP = sub i64 64, %posIP.z
  %bitIP.sh = lshr i64 %plaintext, %shIP
  %bitIP = and i64 %bitIP.sh, 1
  %ip.cur = load i64, i64* %ip.acc, align 8
  %ip.shl = shl i64 %ip.cur, 1
  %ip.new = or i64 %ip.shl, %bitIP
  store i64 %ip.new, i64* %ip.acc, align 8
  %i.ip.next = add i32 %i.ip, 1
  store i32 %i.ip.next, i32* %ip.i, align 4
  br label %ip.loop

ip.done:
  %ip.final = load i64, i64* %ip.acc, align 8
  %L64 = lshr i64 %ip.final, 32
  %L0 = trunc i64 %L64 to i32
  %R0 = trunc i64 %ip.final to i32

  ; 16 Feistel rounds
  br label %rounds.loop

rounds.loop:
  %r2.phi = phi i32 [ 0, %ip.done ], [ %r2.next, %rounds.next ]
  %L.phi = phi i32 [ %L0, %ip.done ], [ %L.next, %rounds.next ]
  %R.phi = phi i32 [ %R0, %ip.done ], [ %R.next, %rounds.next ]
  %cmp.r2 = icmp sle i32 %r2.phi, 15
  br i1 %cmp.r2, label %rounds.body, label %rounds.done

rounds.body:
  ; E expansion of R to 48 bits
  %e.i = alloca i32, align 4
  store i32 0, i32* %e.i, align 4
  %e.acc = alloca i64, align 8
  store i64 0, i64* %e.acc, align 8
  br label %e.loop

e.loop:
  %i.e = load i32, i32* %e.i, align 4
  %cmp.e = icmp sle i32 %i.e, 47
  br i1 %cmp.e, label %e.body, label %e.done

e.body:
  %i.e.64 = sext i32 %i.e to i64
  %posE.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @E_3, i64 0, i64 %i.e.64
  %posE = load i32, i32* %posE.ptr, align 4
  %posE.z = zext i32 %posE to i64
  %shE = sub i64 32, %posE.z
  %R.z64 = zext i32 %R.phi to i64
  %bitE.sh = lshr i64 %R.z64, %shE
  %bitE = and i64 %bitE.sh, 1
  %e.cur = load i64, i64* %e.acc, align 8
  %e.shl = shl i64 %e.cur, 1
  %e.new = or i64 %e.shl, %bitE
  store i64 %e.new, i64* %e.acc, align 8
  %i.e.next = add i32 %i.e, 1
  store i32 %i.e.next, i32* %e.i, align 4
  br label %e.loop

e.done:
  %E48 = load i64, i64* %e.acc, align 8
  ; XOR with round subkey
  %r2.idx64 = sext i32 %r2.phi to i64
  %sk.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %r2.idx64
  %sk = load i64, i64* %sk.ptr, align 8
  %x = xor i64 %E48, %sk

  ; S-box substitution to 32 bits
  %b.phi.init = alloca i32, align 4
  store i32 0, i32* %b.phi.init, align 4
  %sacc = alloca i32, align 4
  store i32 0, i32* %sacc, align 4
  br label %s.loop

s.loop:
  %b = load i32, i32* %b.phi.init, align 4
  %cmp.b = icmp sle i32 %b, 7
  br i1 %cmp.b, label %s.body, label %s.done

s.body:
  ; group = (x >> (42 - 6*b)) & 0x3f
  %b.z = zext i32 %b to i64
  %mul6 = mul i64 %b.z, 6
  %shgrp = sub i64 42, %mul6
  %grp.sh = lshr i64 %x, %shgrp
  %grp = and i64 %grp.sh, 63
  %grp.i32 = trunc i64 %grp to i32
  ; row = ((grp & 0x20) >> 4) | (grp & 1)
  %grp_hi = and i32 %grp.i32, 32
  %grp_hi_sh = lshr i32 %grp_hi, 4
  %grp_lo = and i32 %grp.i32, 1
  %row = or i32 %grp_hi_sh, %grp_lo
  ; col = (grp >> 1) & 0x0F
  %col.sh = lshr i32 %grp.i32, 1
  %col = and i32 %col.sh, 15
  ; index = b*64 + row*16 + col
  %row16 = mul i32 %row, 16
  %rowcol = add i32 %row16, %col
  %b64 = mul i32 %b, 64
  %sidx = add i32 %b64, %rowcol
  %sidx64 = sext i32 %sidx to i64
  %s.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX_2, i64 0, i64 %sidx64
  %sval.i8 = load i8, i8* %s.ptr, align 1
  %sval = zext i8 %sval.i8 to i32
  ; accumulate 4-bit outputs
  %s.cur = load i32, i32* %sacc, align 4
  %s.shl = shl i32 %s.cur, 4
  %s.new = or i32 %s.shl, %sval
  store i32 %s.new, i32* %sacc, align 4
  %b.next = add i32 %b, 1
  store i32 %b.next, i32* %b.phi.init, align 4
  br label %s.loop

s.done:
  %S32 = load i32, i32* %sacc, align 4

  ; P permutation on S32 to 32 bits
  %p.i = alloca i32, align 4
  store i32 0, i32* %p.i, align 4
  %p.acc = alloca i32, align 4
  store i32 0, i32* %p.acc, align 4
  br label %p.loop

p.loop:
  %i.p = load i32, i32* %p.i, align 4
  %cmp.p = icmp sle i32 %i.p, 31
  br i1 %cmp.p, label %p.body, label %p.done

p.body:
  %i.p.64 = sext i32 %i.p to i64
  %posP.ptr = getelementptr inbounds [32 x i32], [32 x i32]* @P_1, i64 0, i64 %i.p.64
  %posP = load i32, i32* %posP.ptr, align 4
  %posP.z = zext i32 %posP to i64
  %shP = sub i64 32, %posP.z
  %S64 = zext i32 %S32 to i64
  %bitP.sh = lshr i64 %S64, %shP
  %bitP.i64 = and i64 %bitP.sh, 1
  %bitP = trunc i64 %bitP.i64 to i32
  %p.cur = load i32, i32* %p.acc, align 4
  %p.shl = shl i32 %p.cur, 1
  %p.new = or i32 %p.shl, %bitP
  store i32 %p.new, i32* %p.acc, align 4
  %i.p.next = add i32 %i.p, 1
  store i32 %i.p.next, i32* %p.i, align 4
  br label %p.loop

p.done:
  %P32 = load i32, i32* %p.acc, align 4

  ; Feistel combine
  %R.xor = xor i32 %L.phi, %P32
  %L.next = %R.phi
  %R.next = %R.xor
  br label %rounds.next

rounds.next:
  %r2.next = add i32 %r2.phi, 1
  br label %rounds.loop

rounds.done:
  ; Preoutput with final swap: R << 32 | L
  %R.z64 = zext i32 %R.phi to i64
  %L.z64 = zext i32 %L.phi to i64
  %R.shl32 = shl i64 %R.z64, 32
  %preout = or i64 %R.shl32, %L.z64

  ; Final Permutation
  %fp.i = alloca i32, align 4
  store i32 0, i32* %fp.i, align 4
  %fp.acc = alloca i64, align 8
  store i64 0, i64* %fp.acc, align 8
  br label %fp.loop

fp.loop:
  %i.fp = load i32, i32* %fp.i, align 4
  %cmp.fp = icmp sle i32 %i.fp, 63
  br i1 %cmp.fp, label %fp.body, label %fp.done

fp.body:
  %i.fp.64 = sext i32 %i.fp to i64
  %posFP.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @FP_0, i64 0, i64 %i.fp.64
  %posFP = load i32, i32* %posFP.ptr, align 4
  %posFP.z = zext i32 %posFP to i64
  %shFP = sub i64 64, %posFP.z
  %bitFP.sh = lshr i64 %preout, %shFP
  %bitFP = and i64 %bitFP.sh, 1
  %fp.cur = load i64, i64* %fp.acc, align 8
  %fp.shl = shl i64 %fp.cur, 1
  %fp.new = or i64 %fp.shl, %bitFP
  store i64 %fp.new, i64* %fp.acc, align 8
  %i.fp.next = add i32 %i.fp, 1
  store i32 %i.fp.next, i32* %fp.i, align 4
  br label %fp.loop

fp.done:
  %cipher = load i64, i64* %fp.acc, align 8

  ; stack protector check
  %canary1 = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %canary0, %canary1
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @___stack_chk_fail()
  br label %ret

ret:
  ret i64 %cipher
}