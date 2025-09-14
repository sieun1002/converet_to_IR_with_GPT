; ModuleID = 'key_expansion'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_expansion ; Address: 0x000015A0
; Intent: AES-128 key expansion (176-byte schedule) (confidence=0.96). Evidence: copies 16-byte key, applies RotWord/SubWord + rcon every 16 bytes, expands until offset 0xAF.
; Preconditions: src points to at least 16 bytes; dst points to at least 176 bytes; externs sbox_lookup(i32)->i8 and rcon(i32)->i8 provided.
; Postconditions: dst[0..15]=src[0..15]; dst[16..175] filled with AES-128 expanded round keys.

; Only the necessary external declarations:
declare i8 @sbox_lookup(i32)
declare i8 @rcon(i32)

define dso_local void @key_expansion(i8* %src, i8* %dst) local_unnamed_addr {
entry:
  br label %copy.cond

copy.cond:                                        ; i in [0..15]
  %i.copy = phi i32 [ 0, %entry ], [ %inc.copy, %copy.body ]
  %cmp.copy = icmp sle i32 %i.copy, 15
  br i1 %cmp.copy, label %copy.body, label %copy.end

copy.body:
  %idx64.copy = sext i32 %i.copy to i64
  %sptr = getelementptr inbounds i8, i8* %src, i64 %idx64.copy
  %val = load i8, i8* %sptr, align 1
  %dptr = getelementptr inbounds i8, i8* %dst, i64 %idx64.copy
  store i8 %val, i8* %dptr, align 1
  %inc.copy = add i32 %i.copy, 1
  br label %copy.cond

copy.end:
  br label %loop.cond

loop.cond:                                        ; i in [16..175] step 4
  %i = phi i32 [ 16, %copy.end ], [ %i.next, %after.body ]
  %round = phi i32 [ 0, %copy.end ], [ %round.next, %after.body ]
  %cmp.loop = icmp sle i32 %i, 175
  br i1 %cmp.loop, label %loop.body, label %exit

loop.body:
  ; Load previous 4 bytes (w = dst[i-4..i-1])
  %im4 = add i32 %i, -4
  %im3 = add i32 %i, -3
  %im2 = add i32 %i, -2
  %im1 = add i32 %i, -1
  %im4_64 = sext i32 %im4 to i64
  %im3_64 = sext i32 %im3 to i64
  %im2_64 = sext i32 %im2 to i64
  %im1_64 = sext i32 %im1 to i64
  %p_m4 = getelementptr inbounds i8, i8* %dst, i64 %im4_64
  %p_m3 = getelementptr inbounds i8, i8* %dst, i64 %im3_64
  %p_m2 = getelementptr inbounds i8, i8* %dst, i64 %im2_64
  %p_m1 = getelementptr inbounds i8, i8* %dst, i64 %im1_64
  %t0 = load i8, i8* %p_m4, align 1
  %t1 = load i8, i8* %p_m3, align 1
  %t2 = load i8, i8* %p_m2, align 1
  %t3 = load i8, i8* %p_m1, align 1

  ; if ((i & 0x0F) == 0) do RotWord, SubWord, and Rcon
  %and = and i32 %i, 15
  %is_block_start = icmp eq i32 %and, 0
  br i1 %is_block_start, label %special, label %normal

special:
  ; Rotate left: (t0,t1,t2,t3) -> (t1,t2,t3,t0)
  %rot0 = %t1
  %rot1 = %t2
  %rot2 = %t3
  %rot3 = %t0
  ; SubWord using S-box
  %rot0_i32 = zext i8 %rot0 to i32
  %s0 = call i8 @sbox_lookup(i32 %rot0_i32)
  %rot1_i32 = zext i8 %rot1 to i32
  %s1 = call i8 @sbox_lookup(i32 %rot1_i32)
  %rot2_i32 = zext i8 %rot2 to i32
  %s2 = call i8 @sbox_lookup(i32 %rot2_i32)
  %rot3_i32 = zext i8 %rot3 to i32
  %s3 = call i8 @sbox_lookup(i32 %rot3_i32)
  ; Rcon with old round counter (then increment)
  %rcarg8 = trunc i32 %round to i8
  %rcargi32 = zext i8 %rcarg8 to i32
  %rc = call i8 @rcon(i32 %rcargi32)
  %s0r = xor i8 %s0, %rc
  %round.inc = add i32 %round, 1
  br label %merge

normal:
  ; No change
  %s0r.n = %t0
  %s1.n = %t1
  %s2.n = %t2
  %s3.n = %t3
  br label %merge

merge:
  %temp0 = phi i8 [ %s0r, %special ], [ %s0r.n, %normal ]
  %temp1 = phi i8 [ %s1,  %special ], [ %s1.n,  %normal ]
  %temp2 = phi i8 [ %s2,  %special ], [ %s2.n,  %normal ]
  %temp3 = phi i8 [ %s3,  %special ], [ %s3.n,  %normal ]
  %round.next.pre = phi i32 [ %round.inc, %special ], [ %round, %normal ]

  ; dst[i..i+3] = dst[i-16..i-13] XOR temp[0..3]
  %im16 = add i32 %i, -16
  %im15 = add i32 %i, -15
  %im14 = add i32 %i, -14
  %im13 = add i32 %i, -13
  %im16_64 = sext i32 %im16 to i64
  %im15_64 = sext i32 %im15 to i64
  %im14_64 = sext i32 %im14 to i64
  %im13_64 = sext i32 %im13 to i64
  %p_m16 = getelementptr inbounds i8, i8* %dst, i64 %im16_64
  %p_m15 = getelementptr inbounds i8, i8* %dst, i64 %im15_64
  %p_m14 = getelementptr inbounds i8, i8* %dst, i64 %im14_64
  %p_m13 = getelementptr inbounds i8, i8* %dst, i64 %im13_64
  %prev0 = load i8, i8* %p_m16, align 1
  %prev1 = load i8, i8* %p_m15, align 1
  %prev2 = load i8, i8* %p_m14, align 1
  %prev3 = load i8, i8* %p_m13, align 1
  %out0 = xor i8 %prev0, %temp0
  %out1 = xor i8 %prev1, %temp1
  %out2 = xor i8 %prev2, %temp2
  %out3 = xor i8 %prev3, %temp3

  %i64 = sext i32 %i to i64
  %p_i   = getelementptr inbounds i8, i8* %dst, i64 %i64
  %p_i1  = getelementptr inbounds i8, i8* %dst, i64 (add i64 %i64, 1)
  %p_i2  = getelementptr inbounds i8, i8* %dst, i64 (add i64 %i64, 2)
  %p_i3  = getelementptr inbounds i8, i8* %dst, i64 (add i64 %i64, 3)
  store i8 %out0, i8* %p_i,  align 1
  store i8 %out1, i8* %p_i1, align 1
  store i8 %out2, i8* %p_i2, align 1
  store i8 %out3, i8* %p_i3, align 1

  br label %after.body

after.body:
  %i.next = add i32 %i, 4
  %round.next = %round.next.pre
  br label %loop.cond

exit:
  ret void
}