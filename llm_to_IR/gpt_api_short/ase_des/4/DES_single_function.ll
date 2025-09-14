; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt ; Address: 0x1189
; Intent: DES 64-bit block encryption with 64-bit key (confidence=0.98). Evidence: PC1/PC2/IP/E/SBOX/P/FP tables, 16-round Feistel.
; Preconditions: block/key are 64-bit values; DES tables PC1_7, SHIFTS_6, PC2_5, IP_4, E_3, SBOX_2, P_1, FP_0 are defined.
; Postconditions: returns the 64-bit ciphertext of the input block under the key.

@PC1_7 = external local_unnamed_addr global [56 x i32]
@SHIFTS_6 = external local_unnamed_addr global [16 x i32]
@PC2_5 = external local_unnamed_addr global [48 x i32]
@IP_4 = external local_unnamed_addr global [64 x i32]
@E_3 = external local_unnamed_addr global [48 x i32]
@SBOX_2 = external local_unnamed_addr global [512 x i8]
@P_1 = external local_unnamed_addr global [32 x i32]
@FP_0 = external local_unnamed_addr global [64 x i32]

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 8
  br label %pc1.loop

pc1.loop:                                         ; build 56-bit key via PC-1
  %i = phi i32 [ 0, %entry ], [ %i.next, %pc1.bodyend ]
  %acc = phi i64 [ 0, %entry ], [ %acc.new, %pc1.bodyend ]
  %cond = icmp sle i32 %i, 55
  br i1 %cond, label %pc1.body, label %pc1.done

pc1.body:
  %idx64 = zext i32 %i to i64
  %pc1.gep = getelementptr inbounds [56 x i32], [56 x i32]* @PC1_7, i64 0, i64 %idx64
  %p = load i32, i32* %pc1.gep, align 4
  %p64 = zext i32 %p to i64
  %pc1shift = sub i64 64, %p64
  %tmp = lshr i64 %key, %pc1shift
  %bit = and i64 %tmp, 1
  %acc2 = shl i64 %acc, 1
  %acc.new = or i64 %acc2, %bit
  %i.next = add i32 %i, 1
  br label %pc1.bodyend

pc1.bodyend:
  br label %pc1.loop

pc1.done:
  %left64 = lshr i64 %acc, 28
  %leftmask = and i64 %left64, 268435455
  %right64 = and i64 %acc, 268435455
  %left32 = trunc i64 %leftmask to i32
  %right32 = trunc i64 %right64 to i32
  br label %ks.loop

ks.loop:                                          ; key schedule 16 rounds
  %round = phi i32 [ 0, %pc1.done ], [ %round.next, %ks.end ]
  %L = phi i32 [ %left32, %pc1.done ], [ %L.next, %ks.end ]
  %R = phi i32 [ %right32, %pc1.done ], [ %R.next, %ks.end ]
  %ks.cond = icmp sle i32 %round, 15
  br i1 %ks.cond, label %ks.body, label %ks.done

ks.body:
  %r64 = zext i32 %round to i64
  %sh.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS_6, i64 0, i64 %r64
  %shift = load i32, i32* %sh.ptr, align 4
  %shift32 = and i32 %shift, 31
  ; rotate L by shift within 28 bits
  %shL = shl i32 %L, %shift32
  %negshift = sub i32 28, %shift32
  %shrL = lshr i32 %L, %negshift
  %Lrot = or i32 %shL, %shrL
  %L28 = and i32 %Lrot, 268435455
  ; rotate R by shift within 28 bits
  %shR = shl i32 %R, %shift32
  %negshiftR = sub i32 28, %shift32
  %shrR = lshr i32 %R, %negshiftR
  %Rrot = or i32 %shR, %shrR
  %R28 = and i32 %Rrot, 268435455
  ; combine and apply PC-2 to get 48-bit subkey
  %L64z = zext i32 %L28 to i64
  %comb_left = shl i64 %L64z, 28
  %R64z = zext i32 %R28 to i64
  %combine = or i64 %comb_left, %R64z
  br label %pc2.loop

pc2.loop:
  %j = phi i32 [ 0, %ks.body ], [ %j.next, %pc2.bodyend ]
  %sk = phi i64 [ 0, %ks.body ], [ %sk.new, %pc2.bodyend ]
  %condpc2 = icmp sle i32 %j, 47
  br i1 %condpc2, label %pc2.body, label %pc2.done

pc2.body:
  %j64 = zext i32 %j to i64
  %pc2.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @PC2_5, i64 0, i64 %j64
  %pp = load i32, i32* %pc2.ptr, align 4
  %pp64 = zext i32 %pp to i64
  %shamt = sub i64 56, %pp64
  %combine.shift = lshr i64 %combine, %shamt
  %bit2 = and i64 %combine.shift, 1
  %sk2 = shl i64 %sk, 1
  %sk.new = or i64 %sk2, %bit2
  %j.next = add i32 %j, 1
  br label %pc2.bodyend

pc2.bodyend:
  br label %pc2.loop

pc2.done:
  %subkeys.idxptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %r64
  store i64 %sk, i64* %subkeys.idxptr, align 8
  %L.next = %L28
  %R.next = %R28
  %round.next = add i32 %round, 1
  br label %ks.end

ks.end:
  br label %ks.loop

ks.done:
  br label %ip.loop

ip.loop:                                          ; initial permutation on block
  %i2 = phi i32 [ 0, %ks.done ], [ %i2.next, %ip.bodyend ]
  %ipacc = phi i64 [ 0, %ks.done ], [ %ipacc.new, %ip.bodyend ]
  %ip.cond = icmp sle i32 %i2, 63
  br i1 %ip.cond, label %ip.body, label %ip.done

ip.body:
  %i2_64 = zext i32 %i2 to i64
  %ip.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @IP_4, i64 0, i64 %i2_64
  %pp3 = load i32, i32* %ip.ptr, align 4
  %pp3_64 = zext i32 %pp3 to i64
  %shamt3 = sub i64 64, %pp3_64
  %block.shift = lshr i64 %block, %shamt3
  %bit3 = and i64 %block.shift, 1
  %accsh = shl i64 %ipacc, 1
  %ipacc.new = or i64 %accsh, %bit3
  %i2.next = add i32 %i2, 1
  br label %ip.bodyend

ip.bodyend:
  br label %ip.loop

ip.done:
  %L0_64 = lshr i64 %ipacc, 32
  %L0_32 = trunc i64 %L0_64 to i32
  %R0_32 = trunc i64 %ipacc to i32
  br label %rounds.loop

rounds.loop:                                      ; 16 Feistel rounds
  %rnum = phi i32 [ 0, %ip.done ], [ %rnum.next, %rounds.end ]
  %Lr = phi i32 [ %L0_32, %ip.done ], [ %Lr.next, %rounds.end ]
  %Rr = phi i32 [ %R0_32, %ip.done ], [ %Rr.next, %rounds.end ]
  %cond.round = icmp sle i32 %rnum, 15
  br i1 %cond.round, label %round.body, label %rounds.done

round.body:
  br label %E.loop

E.loop:                                           ; expansion E(R)
  %eidx = phi i32 [ 0, %round.body ], [ %eidx.next, %E.bodyend ]
  %Eacc = phi i64 [ 0, %round.body ], [ %Eacc.new, %E.bodyend ]
  %E.cond = icmp sle i32 %eidx, 47
  br i1 %E.cond, label %E.body, label %E.done

E.body:
  %e64 = zext i32 %eidx to i64
  %Eptr = getelementptr inbounds [48 x i32], [48 x i32]* @E_3, i64 0, i64 %e64
  %Epos = load i32, i32* %Eptr, align 4
  %Epos64 = zext i32 %Epos to i64
  %shamtE = sub i64 32, %Epos64
  %Rr64 = zext i32 %Rr to i64
  %R.shift = lshr i64 %Rr64, %shamtE
  %bitE = and i64 %R.shift, 1
  %Eacc2 = shl i64 %Eacc, 1
  %Eacc.new = or i64 %Eacc2, %bitE
  %eidx.next = add i32 %eidx, 1
  br label %E.bodyend

E.bodyend:
  br label %E.loop

E.done:
  %rnum64 = zext i32 %rnum to i64
  %sk.ptr.r = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %rnum64
  %skload = load i64, i64* %sk.ptr.r, align 8
  %A0 = xor i64 %skload, %Eacc
  br label %sbox.loop

sbox.loop:                                        ; S-box substitution
  %sidx = phi i32 [ 0, %E.done ], [ %sidx.next, %sbox.bodyend ]
  %out32 = phi i32 [ 0, %E.done ], [ %out32.new, %sbox.bodyend ]
  %s.cond = icmp sle i32 %sidx, 7
  br i1 %s.cond, label %sbox.body, label %sbox.done

sbox.body:
  %sidx64 = zext i32 %sidx to i64
  %mul6 = mul i64 %sidx64, 6
  %shamt6 = sub i64 42, %mul6
  %A0.shift = lshr i64 %A0, %shamt6
  %six = and i64 %A0.shift, 63
  %six32 = trunc i64 %six to i32
  %six_shr4 = lshr i32 %six32, 4
  %row_hi = and i32 %six_shr4, 2
  %row_lo = and i32 %six32, 1
  %row_full = or i32 %row_hi, %row_lo
  %six_shr1 = lshr i32 %six32, 1
  %col = and i32 %six_shr1, 15
  %row_shl4 = shl i32 %row_full, 4
  %offset = add i32 %col, %row_shl4
  %offset64 = zext i32 %offset to i64
  %sbox_base = shl i64 %sidx64, 6
  %index = add i64 %sbox_base, %offset64
  %sbptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX_2, i64 0, i64 %index
  %sbval8 = load i8, i8* %sbptr, align 1
  %sbval32 = zext i8 %sbval8 to i32
  %outshl = shl i32 %out32, 4
  %out32.new = or i32 %outshl, %sbval32
  %sidx.next = add i32 %sidx, 1
  br label %sbox.bodyend

sbox.bodyend:
  br label %sbox.loop

sbox.done:
  br label %P.loop

P.loop:                                           ; P permutation
  %pidx = phi i32 [ 0, %sbox.done ], [ %pidx.next, %P.bodyend ]
  %Pacc = phi i32 [ 0, %sbox.done ], [ %Pacc.new, %P.bodyend ]
  %P.cond = icmp sle i32 %pidx, 31
  br i1 %P.cond, label %P.body, label %P.done

P.body:
  %pidx64 = zext i32 %pidx to i64
  %Pptr = getelementptr inbounds [32 x i32], [32 x i32]* @P_1, i64 0, i64 %pidx64
  %Ppos = load i32, i32* %Pptr, align 4
  %Ppos64 = zext i32 %Ppos to i64
  %shamtP = sub i64 32, %Ppos64
  %out64 = zext i32 %out32 to i64
  %out.shift = lshr i64 %out64, %shamtP
  %bitP64 = and i64 %out.shift, 1
  %Pacc64 = zext i32 %Pacc to i64
  %Pacc_shift = shl i64 %Pacc64, 1
  %newP64 = or i64 %Pacc_shift, %bitP64
  %Pacc.new = trunc i64 %newP64 to i32
  %pidx.next = add i32 %pidx, 1
  br label %P.bodyend

P.bodyend:
  br label %P.loop

P.done:
  %newR32 = xor i32 %Lr, %Pacc
  %Lr.next = %Rr
  %Rr.next = %newR32
  %rnum.next = add i32 %rnum, 1
  br label %rounds.end

rounds.end:
  br label %rounds.loop

rounds.done:
  %Rfinal64 = zext i32 %Rr to i64
  %Rshifted = shl i64 %Rfinal64, 32
  %Lfinal64 = zext i32 %Lr to i64
  %preOut = or i64 %Rshifted, %Lfinal64
  br label %fp.loop

fp.loop:                                          ; final permutation FP
  %fidx = phi i32 [ 0, %rounds.done ], [ %fidx.next, %fp.bodyend ]
  %FPacc = phi i64 [ 0, %rounds.done ], [ %FPacc.new, %fp.bodyend ]
  %fp.cond = icmp sle i32 %fidx, 63
  br i1 %fp.cond, label %fp.body, label %fp.done

fp.body:
  %fidx64 = zext i32 %fidx to i64
  %FPptr = getelementptr inbounds [64 x i32], [64 x i32]* @FP_0, i64 0, i64 %fidx64
  %FPpos = load i32, i32* %FPptr, align 4
  %FPpos64 = zext i32 %FPpos to i64
  %shamtF = sub i64 64, %FPpos64
  %preOut.shift = lshr i64 %preOut, %shamtF
  %bitF = and i64 %preOut.shift, 1
  %FPacc_sh = shl i64 %FPacc, 1
  %FPacc.new = or i64 %FPacc_sh, %bitF
  %fidx.next = add i32 %fidx, 1
  br label %fp.bodyend

fp.bodyend:
  br label %fp.loop

fp.done:
  ret i64 %FPacc
}