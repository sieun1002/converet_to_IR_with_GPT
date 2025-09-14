; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt  ; Address: 0x1189
; Intent: DES block encryption of a 64-bit block with a 64-bit key (confidence=0.93). Evidence: Uses standard DES tables (PC1, SHIFTS, PC2, IP, E, SBOX, P, FP) and 16 Feistel rounds.
; Preconditions: %block and %key are 64-bit values; permutation tables are correctly defined externally
; Postconditions: returns the 64-bit DES ciphertext of %block under %key

@PC1_7 = external dso_local constant [56 x i32], align 4
@SHIFTS_6 = external dso_local constant [16 x i32], align 4
@PC2_5 = external dso_local constant [48 x i32], align 4
@IP_4 = external dso_local constant [64 x i32], align 4
@E_3 = external dso_local constant [48 x i32], align 4
@SBOX_2 = external dso_local constant [512 x i8], align 1
@P_1 = external dso_local constant [32 x i32], align 4
@FP_0 = external dso_local constant [64 x i32], align 4

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 8
  br label %pc1.loop

pc1.loop:                                          ; build 56-bit from PC1
  %i_pc1 = phi i32 [ 0, %entry ], [ %i_pc1.next, %pc1.body ]
  %acc56 = phi i64 [ 0, %entry ], [ %acc56.next, %pc1.body ]
  %cmp_pc1 = icmp sle i32 %i_pc1, 55
  br i1 %cmp_pc1, label %pc1.body, label %pc1.done

pc1.body:
  %i64 = zext i32 %i_pc1 to i64
  %pc1.ptr = getelementptr inbounds [56 x i32], [56 x i32]* @PC1_7, i64 0, i64 %i64
  %pc1.val = load i32, i32* %pc1.ptr, align 4
  %t64 = zext i32 %pc1.val to i64
  %shamt64 = sub i64 64, %t64
  %keyshr = lshr i64 %key, %shamt64
  %bit = and i64 %keyshr, 1
  %acc_shift = shl i64 %acc56, 1
  %acc56.next = or i64 %acc_shift, %bit
  %i_pc1.next = add i32 %i_pc1, 1
  br label %pc1.loop

pc1.done:
  %c_tmp = lshr i64 %acc56, 28
  %Cfull32 = trunc i64 %c_tmp to i32
  %C = and i32 %Cfull32, 268435455
  %Dfull32 = trunc i64 %acc56 to i32
  %D = and i32 %Dfull32, 268435455
  br label %round.loop

round.loop:                                        ; key schedule rounds
  %r = phi i32 [ 0, %pc1.done ], [ %r.next, %save.subkey ]
  %C.round = phi i32 [ %C, %pc1.done ], [ %C.new.masked, %save.subkey ]
  %D.round = phi i32 [ %D, %pc1.done ], [ %D.new.masked, %save.subkey ]
  %cmp_r = icmp sle i32 %r, 15
  br i1 %cmp_r, label %round.body, label %rounds.done

round.body:
  %r64 = zext i32 %r to i64
  %shifts.ptr = getelementptr inbounds [16 x i32], [16 x i32]* @SHIFTS_6, i64 0, i64 %r64
  %s = load i32, i32* %shifts.ptr, align 4
  %lsr_amtC = sub i32 28, %s
  %Cshl = shl i32 %C.round, %s
  %Cshr = lshr i32 %C.round, %lsr_amtC
  %C.new = or i32 %Cshl, %Cshr
  %C.new.masked = and i32 %C.new, 268435455
  %lsr_amtD = sub i32 28, %s
  %Dshl = shl i32 %D.round, %s
  %Dshr = lshr i32 %D.round, %lsr_amtD
  %D.new = or i32 %Dshl, %Dshr
  %D.new.masked = and i32 %D.new, 268435455
  %C64 = zext i32 %C.new.masked to i64
  %C64shl = shl i64 %C64, 28
  %D64 = zext i32 %D.new.masked to i64
  %CD56 = or i64 %C64shl, %D64
  br label %pc2.loop

pc2.loop:                                          ; build 48-bit subkey (PC2)
  %i_pc2 = phi i32 [ 0, %round.body ], [ %i_pc2.next, %pc2.body ]
  %acc48 = phi i64 [ 0, %round.body ], [ %acc48.next, %pc2.body ]
  %cmp_pc2 = icmp sle i32 %i_pc2, 47
  br i1 %cmp_pc2, label %pc2.body, label %save.subkey

pc2.body:
  %i_pc2_64 = zext i32 %i_pc2 to i64
  %pc2.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @PC2_5, i64 0, i64 %i_pc2_64
  %pc2.val = load i32, i32* %pc2.ptr, align 4
  %pc2.val64 = zext i32 %pc2.val to i64
  %shamt_pc2 = sub i64 56, %pc2.val64
  %cdshr = lshr i64 %CD56, %shamt_pc2
  %bit_pc2 = and i64 %cdshr, 1
  %acc48_shl = shl i64 %acc48, 1
  %acc48.next = or i64 %acc48_shl, %bit_pc2
  %i_pc2.next = add i32 %i_pc2, 1
  br label %pc2.loop

save.subkey:
  %subkeys.ptr0 = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %r64
  store i64 %acc48, i64* %subkeys.ptr0, align 8
  %r.next = add i32 %r, 1
  br label %round.loop

rounds.done:
  br label %ip.loop

ip.loop:                                           ; initial permutation (IP)
  %i_ip = phi i32 [ 0, %rounds.done ], [ %i_ip.next, %ip.body ]
  %acc64 = phi i64 [ 0, %rounds.done ], [ %acc64.next, %ip.body ]
  %cmp_ip = icmp sle i32 %i_ip, 63
  br i1 %cmp_ip, label %ip.body, label %ip.done

ip.body:
  %i_ip64 = zext i32 %i_ip to i64
  %ip.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @IP_4, i64 0, i64 %i_ip64
  %ip.val = load i32, i32* %ip.ptr, align 4
  %ip.val64 = zext i32 %ip.val to i64
  %shamt_ip = sub i64 64, %ip.val64
  %blkshr = lshr i64 %block, %shamt_ip
  %bit_ip = and i64 %blkshr, 1
  %acc64_shl = shl i64 %acc64, 1
  %acc64.next = or i64 %acc64_shl, %bit_ip
  %i_ip.next = add i32 %i_ip, 1
  br label %ip.loop

ip.done:
  %L64tmp = lshr i64 %acc64, 32
  %L32tmp = trunc i64 %L64tmp to i32
  %R32tmp = trunc i64 %acc64 to i32
  br label %enc.rounds

enc.rounds:                                        ; 16 Feistel rounds
  %round = phi i32 [ 0, %ip.done ], [ %round.next, %enc.next ]
  %L = phi i32 [ %L32tmp, %ip.done ], [ %L.next, %enc.next ]
  %R = phi i32 [ %R32tmp, %ip.done ], [ %R.next, %enc.next ]
  %cmp_round = icmp sle i32 %round, 15
  br i1 %cmp_round, label %enc.body, label %after.rounds

enc.body:
  br label %e.loop

e.loop:                                            ; expansion E
  %i_e = phi i32 [ 0, %enc.body ], [ %i_e.next, %e.body ]
  %accE = phi i64 [ 0, %enc.body ], [ %accE.next, %e.body ]
  %cmp_e = icmp sle i32 %i_e, 47
  br i1 %cmp_e, label %e.body, label %e.done

e.body:
  %i_e64 = zext i32 %i_e to i64
  %e.ptr = getelementptr inbounds [48 x i32], [48 x i32]* @E_3, i64 0, i64 %i_e64
  %e.val = load i32, i32* %e.ptr, align 4
  %sh_e = sub i32 32, %e.val
  %Rsh = lshr i32 %R, %sh_e
  %bit_e32 = and i32 %Rsh, 1
  %bit_e64 = zext i32 %bit_e32 to i64
  %accE_shl = shl i64 %accE, 1
  %accE.next = or i64 %accE_shl, %bit_e64
  %i_e.next = add i32 %i_e, 1
  br label %e.loop

e.done:
  %round64 = zext i32 %round to i64
  %subkey.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %round64
  %subkey = load i64, i64* %subkey.ptr, align 8
  %A0 = xor i64 %subkey, %accE
  br label %sbox.loop

sbox.loop:
  %i_sb = phi i32 [ 0, %e.done ], [ %i_sb.next, %sbox.body ]
  %accS = phi i32 [ 0, %e.done ], [ %accS.next, %sbox.body ]
  %cmp_sb = icmp sle i32 %i_sb, 7
  br i1 %cmp_sb, label %sbox.body, label %sbox.done

sbox.body:
  %i_sb_mul6 = mul i32 %i_sb, 6
  %shift6_tmp = sub i32 42, %i_sb_mul6
  %shift6 = zext i32 %shift6_tmp to i64
  %chunk = lshr i64 %A0, %shift6
  %val6 = and i64 %chunk, 63
  %val6_32 = trunc i64 %val6 to i32
  %row_hi = lshr i32 %val6_32, 4
  %row_hi2 = and i32 %row_hi, 2
  %row_lo = and i32 %val6_32, 1
  %row = or i32 %row_hi2, %row_lo
  %col_tmp = lshr i32 %val6_32, 1
  %col = and i32 %col_tmp, 15
  %row_mul16 = shl i32 %row, 4
  %sbox_index = add i32 %row_mul16, %col
  %i_sb64 = zext i32 %i_sb to i64
  %i_sb64_shl6 = shl i64 %i_sb64, 6
  %sbox_index64 = zext i32 %sbox_index to i64
  %sbox_off = add i64 %i_sb64_shl6, %sbox_index64
  %sbox.ptr = getelementptr inbounds [512 x i8], [512 x i8]* @SBOX_2, i64 0, i64 %sbox_off
  %sbox_val8 = load i8, i8* %sbox.ptr, align 1
  %sbox_val32 = zext i8 %sbox_val8 to i32
  %accS_shl = shl i32 %accS, 4
  %accS.next = or i32 %accS_shl, %sbox_val32
  %i_sb.next = add i32 %i_sb, 1
  br label %sbox.loop

sbox.done:
  br label %p.loop

p.loop:                                            ; permutation P
  %i_p = phi i32 [ 0, %sbox.done ], [ %i_p.next, %p.body ]
  %accP = phi i32 [ 0, %sbox.done ], [ %accP.next, %p.body ]
  %cmp_p = icmp sle i32 %i_p, 31
  br i1 %cmp_p, label %p.body, label %p.done

p.body:
  %i_p64 = zext i32 %i_p to i64
  %p.ptr = getelementptr inbounds [32 x i32], [32 x i32]* @P_1, i64 0, i64 %i_p64
  %p.val = load i32, i32* %p.ptr, align 4
  %sh_p = sub i32 32, %p.val
  %accS_sh = lshr i32 %accS, %sh_p
  %bit_p32 = and i32 %accS_sh, 1
  %accP_shl = shl i32 %accP, 1
  %accP.next = or i32 %accP_shl, %bit_p32
  %i_p.next = add i32 %i_p, 1
  br label %p.loop

p.done:
  %L.next = %R
  %tmp_xor = xor i32 %L, %accP
  %R.next = %tmp_xor
  %round.next = add i32 %round, 1
  br label %enc.rounds

enc.next:
  br label %enc.rounds

after.rounds:
  %R64c = zext i32 %R to i64
  %R64shl = shl i64 %R64c, 32
  %L64c = zext i32 %L to i64
  %preout = or i64 %R64shl, %L64c
  br label %fp.loop

fp.loop:                                           ; final permutation (FP)
  %i_fp = phi i32 [ 0, %after.rounds ], [ %i_fp.next, %fp.body ]
  %accFP = phi i64 [ 0, %after.rounds ], [ %accFP.next, %fp.body ]
  %cmp_fp = icmp sle i32 %i_fp, 63
  br i1 %cmp_fp, label %fp.body, label %ret

fp.body:
  %i_fp64 = zext i32 %i_fp to i64
  %fp.ptr = getelementptr inbounds [64 x i32], [64 x i32]* @FP_0, i64 0, i64 %i_fp64
  %fp.val = load i32, i32* %fp.ptr, align 4
  %fp.val64 = zext i32 %fp.val to i64
  %sh_fp = sub i64 64, %fp.val64
  %preout_sh = lshr i64 %preout, %sh_fp
  %bit_fp = and i64 %preout_sh, 1
  %accFP_shl = shl i64 %accFP, 1
  %accFP.next = or i64 %accFP_shl, %bit_fp
  %i_fp.next = add i32 %i_fp, 1
  br label %fp.loop

ret:
  ret i64 %accFP
}