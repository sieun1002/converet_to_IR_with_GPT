; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt  ; Address: 0x1189
; Intent: DES encryption of a 64-bit block with a 64-bit key (confidence=0.98). Evidence: classic DES tables (PC1, SHIFTS, PC2, IP, E, SBOX, P, FP) and 16 Feistel rounds
; Preconditions: Inputs are 64-bit data block and 64-bit key.
; Postconditions: Returns 64-bit ciphertext.

@PC1_7 = external constant [56 x i32]
@SHIFTS_6 = external constant [16 x i32]
@PC2_5 = external constant [48 x i32]
@IP_4 = external constant [64 x i32]
@E_3 = external constant [48 x i32]
@SBOX_2 = external constant [512 x i8]
@P_1 = external constant [32 x i32]
@FP_0 = external constant [64 x i32]
@__stack_chk_guard = external global i64

declare void @__stack_chk_fail() local_unnamed_addr

define dso_local i64 @des_encrypt(i64 %data, i64 %key) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard, align 8
  %subkeys = alloca [16 x i64], align 8
  ; Build permuted key (PC-1): 56-bit into %permkey
  br label %pc1.loop

pc1.loop:                                          ; preds = %pc1.loop, %entry
  %i.pc1 = phi i32 [ 0, %entry ], [ %i.pc1.next, %pc1.loop ]
  %permkey = phi i64 [ 0, %entry ], [ %permkey.next, %pc1.loop ]
  %i64.pc1 = zext i32 %i.pc1 to i64
  %pc1.ptr = getelementptr inbounds [56 x i32], [56 x i32]* @PC1_7, i64 0, i64 %i64.pc1
  %pc1.val32 = load i32, i32* %pc1.ptr, align 4
  %pc1.val64 = zext i32 %pc1.val32 to i64
  %sh.pc1.tmp = sub nuw nsw i64 64, %pc1.val64
  %bit.pc1.shifted = lshr i64 %key, %sh.pc1.tmp
  %bit.pc1 = and i64 %bit.pc1.shifted, 1
  %permkey.shl = shl i64 %permkey, 1
  %permkey.next = or i64 %permkey.shl, %bit.pc1
  %i.pc1.next = add nuw nsw i32 %i.pc1, 1
  %pc1.cont = icmp sle i32 %i.pc1, 55
  br i1 %pc1.cont, label %pc1.loop, label %pc1.done

pc1.done:                                          ; preds = %pc1.loop
  ; Split into C and D (28 bits each)
  %C64 = and i64 (lshr i64 %permkey, 28), 268435455
  %D64 = and i64 %permkey, 268435455
  %C = trunc i64 %C64 to i32
  %D = trunc i64 %D64 to i32
  ; Key schedule rounds
  br label %ks.loop

ks.loop:                                           ; preds = %pc2.done, %pc1.done
  %round = phi i32 [ 0, %pc1.done ], [ %round.next, %pc2.done ]
  %C.in = phi i32 [ %C, %pc1.done ], [ %C.out, %pc2.done ]
  %D.in = phi i32 [ %D, %pc1.done ], [ %D.out, %pc2.done ]
  %r64 = zext i32 %round to i64
  %shifts.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS_6, i64 0, i64 %r64
  %shift.r = load i32, i32* %shifts.ptr, align 4
  ; rotate C
  %shC = and i32 %shift.r, 31
  %C.shl = shl i32 %C.in, %shC
  %invC.tmp = sub nsw i32 28, %shift.r
  %invC = and i32 %invC.tmp, 31
  %C.shr = lshr i32 %C.in, %invC
  %C.rot = or i32 %C.shl, %C.shr
  %C.masked = and i32 %C.rot, 268435455
  ; rotate D
  %shD = and i32 %shift.r, 31
  %D.shl = shl i32 %D.in, %shD
  %invD.tmp = sub nsw i32 28, %shift.r
  %invD = and i32 %invD.tmp, 31
  %D.shr = lshr i32 %D.in, %invD
  %D.rot = or i32 %D.shl, %D.shr
  %D.masked = and i32 %D.rot, 268435455
  ; combine to 56-bit CD
  %C.z = zext i32 %C.masked to i64
  %D.z = zext i32 %D.masked to i64
  %CD = or i64 (shl i64 %C.z, 28), %D.z
  ; apply PC-2 to get subkey[round] (48-bit)
  br label %pc2.loop

pc2.loop:                                          ; preds = %pc2.loop, %ks.loop
  %j.pc2 = phi i32 [ 0, %ks.loop ], [ %j.pc2.next, %pc2.loop ]
  %Kacc = phi i64 [ 0, %ks.loop ], [ %Kacc.next, %pc2.loop ]
  %j64.pc2 = zext i32 %j.pc2 to i64
  %pc2.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @PC2_5, i64 0, i64 %j64.pc2
  %pc2.val32 = load i32, i32* %pc2.ptr, align 4
  %pc2.val64 = zext i32 %pc2.val32 to i64
  %sh.pc2.tmp = sub nuw nsw i64 56, %pc2.val64
  %bit.pc2.shifted = lshr i64 %CD, %sh.pc2.tmp
  %bit.pc2 = and i64 %bit.pc2.shifted, 1
  %Kacc.shl = shl i64 %Kacc, 1
  %Kacc.next = or i64 %Kacc.shl, %bit.pc2
  %j.pc2.next = add nuw nsw i32 %j.pc2, 1
  %pc2.cont = icmp sle i32 %j.pc2, 47
  br i1 %pc2.cont, label %pc2.loop, label %pc2.done

pc2.done:                                          ; preds = %pc2.loop
  %subkeys.ptr.round = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %r64
  store i64 %Kacc.next, i64* %subkeys.ptr.round, align 8
  %C.out = %C.masked
  %D.out = %D.masked
  %round.next = add nuw nsw i32 %round, 1
  %ks.cont = icmp sle i32 %round, 15
  br i1 %ks.cont, label %ks.loop, label %ks.done

ks.done:                                           ; preds = %pc2.done
  ; Initial permutation (IP)
  br label %ip.loop

ip.loop:                                           ; preds = %ip.loop, %ks.done
  %i.ip = phi i32 [ 0, %ks.done ], [ %i.ip.next, %ip.loop ]
  %Bacc = phi i64 [ 0, %ks.done ], [ %Bacc.next, %ip.loop ]
  %i64.ip = zext i32 %i.ip to i64
  %ip.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @IP_4, i64 0, i64 %i64.ip
  %ip.val32 = load i32, i32* %ip.ptr, align 4
  %ip.val64 = zext i32 %ip.val32 to i64
  %sh.ip.tmp = sub nuw nsw i64 64, %ip.val64
  %bit.ip.shifted = lshr i64 %data, %sh.ip.tmp
  %bit.ip = and i64 %bit.ip.shifted, 1
  %Bacc.shl = shl i64 %Bacc, 1
  %Bacc.next = or i64 %Bacc.shl, %bit.ip
  %i.ip.next = add nuw nsw i32 %i.ip, 1
  %ip.cont = icmp sle i32 %i.ip, 63
  br i1 %ip.cont, label %ip.loop, label %ip.done

ip.done:                                           ; preds = %ip.loop
  %L0 = trunc i64 (lshr i64 %Bacc.next, 32) to i32
  %R0 = trunc i64 %Bacc.next to i32
  br label %rounds.loop

rounds.loop:                                       ; preds = %rounds.next, %ip.done
  %r = phi i32 [ 0, %ip.done ], [ %r.next, %rounds.next ]
  %L.in = phi i32 [ %L0, %ip.done ], [ %L.out, %rounds.next ]
  %R.in = phi i32 [ %R0, %ip.done ], [ %R.out, %rounds.next ]
  ; Expansion E on R.in
  br label %E.loop

E.loop:                                            ; preds = %E.loop, %rounds.loop
  %i.E = phi i32 [ 0, %rounds.loop ], [ %i.E.next, %E.loop ]
  %Eacc = phi i64 [ 0, %rounds.loop ], [ %Eacc.next, %E.loop ]
  %i64.E = zext i32 %i.E to i64
  %E.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @E_3, i64 0, i64 %i64.E
  %E.val32 = load i32, i32* %E.ptr, align 4
  %E.val64 = zext i32 %E.val32 to i64
  %R.z = zext i32 %R.in to i64
  %sh.E.tmp = sub nuw nsw i64 32, %E.val64
  %bit.E.shifted = lshr i64 %R.z, %sh.E.tmp
  %bit.E = and i64 %bit.E.shifted, 1
  %Eacc.shl = shl i64 %Eacc, 1
  %Eacc.next = or i64 %Eacc.shl, %bit.E
  %i.E.next = add nuw nsw i32 %i.E, 1
  %E.cont = icmp sle i32 %i.E, 47
  br i1 %E.cont, label %E.loop, label %E.done

E.done:                                            ; preds = %E.loop
  ; XOR with subkey[r]
  %r64.E = zext i32 %r to i64
  %subkey.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %r64.E
  %subkey = load i64, i64* %subkey.ptr, align 8
  %A48 = xor i64 %Eacc.next, %subkey
  ; S-box substitution
  br label %S.loop

S.loop:                                            ; preds = %S.loop, %E.done
  %b = phi i32 [ 0, %E.done ], [ %b.next, %S.loop ]
  %Sacc = phi i32 [ 0, %E.done ], [ %Sacc.next, %S.loop ]
  %b.mul6 = mul nsw i32 %b, 6
  %cl32 = sub nsw i32 42, %b.mul6
  %cl64 = zext i32 %cl32 to i64
  %sixbits.shifted = lshr i64 %A48, %cl64
  %sixbits = and i64 %sixbits.shifted, 63
  %row.hi = and i64 (lshr i64 %sixbits, 4), 2
  %row.lo = and i64 %sixbits, 1
  %row = or i64 %row.hi, %row.lo
  %col = and i64 (lshr i64 %sixbits, 1), 15
  %b64 = zext i32 %b to i64
  %blk.off = shl i64 %b64, 6
  %row.off = shl i64 %row, 4
  %sidx.tmp = add i64 %blk.off, %row.off
  %sidx = add i64 %sidx.tmp, %col
  %s.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX_2, i64 0, i64 %sidx
  %s.val8 = load i8, i8* %s.ptr, align 1
  %s.val32 = zext i8 %s.val8 to i32
  %Sacc.shl = shl i32 %Sacc, 4
  %Sacc.next = or i32 %Sacc.shl, %s.val32
  %b.next = add nuw nsw i32 %b, 1
  %S.cont = icmp sle i32 %b, 7
  br i1 %S.cont, label %S.loop, label %S.done

S.done:                                            ; preds = %S.loop
  ; Permutation P on Sacc
  br label %P.loop

P.loop:                                            ; preds = %P.loop, %S.done
  %i.P = phi i32 [ 0, %S.done ], [ %i.P.next, %P.loop ]
  %Pacc = phi i32 [ 0, %S.done ], [ %Pacc.next, %P.loop ]
  %i64.P = zext i32 %i.P to i64
  %P.ptr = getelementptr inbounds [32 x i32], [32 x i32]* @P_1, i64 0, i64 %i64.P
  %P.val32 = load i32, i32* %P.ptr, align 4
  %P.val64 = zext i32 %P.val32 to i64
  %Sacc.z = zext i32 %Sacc.next to i64
  %sh.P.tmp = sub nuw nsw i64 32, %P.val64
  %bit.P.shifted = lshr i64 %Sacc.z, %sh.P.tmp
  %bit.P = trunc i64 (and i64 %bit.P.shifted, 1) to i32
  %Pacc.shl = shl i32 %Pacc, 1
  %Pacc.next = or i32 %Pacc.shl, %bit.P
  %i.P.next = add nuw nsw i32 %i.P, 1
  %P.cont = icmp sle i32 %i.P, 31
  br i1 %P.cont, label %P.loop, label %rounds.next

rounds.next:                                       ; preds = %P.loop
  %L.out = %R.in
  %newR.xor = xor i32 %L.in, %Pacc.next
  %R.out = %newR.xor
  %r.next = add nuw nsw i32 %r, 1
  %rounds.cont = icmp sle i32 %r, 15
  br i1 %rounds.cont, label %rounds.loop, label %rounds.done

rounds.done:                                       ; preds = %rounds.next
  ; Pre-output swap and combine
  %R.z.final = zext i32 %R.out to i64
  %L.z.final = zext i32 %L.out to i64
  %preout.hi = shl i64 %R.z.final, 32
  %preout = or i64 %preout.hi, %L.z.final
  ; Final permutation (FP)
  br label %fp.loop

fp.loop:                                           ; preds = %fp.loop, %rounds.done
  %i.fp = phi i32 [ 0, %rounds.done ], [ %i.fp.next, %fp.loop ]
  %Oacc = phi i64 [ 0, %rounds.done ], [ %Oacc.next, %fp.loop ]
  %i64.fp = zext i32 %i.fp to i64
  %fp.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @FP_0, i64 0, i64 %i64.fp
  %fp.val32 = load i32, i32* %fp.ptr, align 4
  %fp.val64 = zext i32 %fp.val32 to i64
  %sh.fp.tmp = sub nuw nsw i64 64, %fp.val64
  %bit.fp.shifted = lshr i64 %preout, %sh.fp.tmp
  %bit.fp = and i64 %bit.fp.shifted, 1
  %Oacc.shl = shl i64 %Oacc, 1
  %Oacc.next = or i64 %Oacc.shl, %bit.fp
  %i.fp.next = add nuw nsw i32 %i.fp, 1
  %fp.cont = icmp sle i32 %i.fp, 63
  br i1 %fp.cont, label %fp.loop, label %stackchk

stackchk:                                          ; preds = %fp.loop
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %guard, %guard2
  br i1 %ok, label %ret, label %fail

fail:                                              ; preds = %stackchk
  call void @__stack_chk_fail()
  unreachable

ret:                                               ; preds = %stackchk
  ret i64 %Oacc.next
}