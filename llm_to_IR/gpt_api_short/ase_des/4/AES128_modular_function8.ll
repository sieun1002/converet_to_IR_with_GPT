; ModuleID = 'key_expansion'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_expansion ; Address: 0x15A0
; Intent: AES-128 key expansion (confidence=0.99). Evidence: 176-byte output, S-box and Rcon usage with byte-rotation at 16-byte intervals.
; Preconditions: - key points to at least 16 bytes; expanded points to at least 176 bytes. - sbox_lookup and rcon are provided.
; Postconditions: expanded contains the 176-byte expanded key for AES-128 derived from key.

; Only the necessary external declarations:
declare i32 @sbox_lookup(i32)
declare i32 @rcon(i32)

define dso_local void @key_expansion(i8* nocapture readonly %key, i8* nocapture %expanded) local_unnamed_addr {
entry:
  br label %copy.cond

copy.cond:                                          ; i in [0..15]
  %i = phi i32 [ 0, %entry ], [ %inc, %copy.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %copy.body, label %copy.end

copy.body:
  %i.z = zext i32 %i to i64
  %src.ptr = getelementptr inbounds i8, i8* %key, i64 %i.z
  %src.val = load i8, i8* %src.ptr, align 1
  %dst.ptr = getelementptr inbounds i8, i8* %expanded, i64 %i.z
  store i8 %src.val, i8* %dst.ptr, align 1
  %inc = add i32 %i, 1
  br label %copy.cond

copy.end:
  br label %loop.cond

loop.cond:                                           ; idx in [16..175] step 4
  %idx = phi i32 [ 16, %copy.end ], [ %idx.next, %loop.inc ]
  %round = phi i32 [ 0, %copy.end ], [ %round.out, %loop.inc ]
  %cmp2 = icmp sle i32 %idx, 175
  br i1 %cmp2, label %loop.body, label %exit

loop.body:
  ; load previous 4 bytes: t0..t3
  %idx_m4 = add i32 %idx, -4
  %idx_m3 = add i32 %idx, -3
  %idx_m2 = add i32 %idx, -2
  %idx_m1 = add i32 %idx, -1

  %idx_m4.z = zext i32 %idx_m4 to i64
  %idx_m3.z = zext i32 %idx_m3 to i64
  %idx_m2.z = zext i32 %idx_m2 to i64
  %idx_m1.z = zext i32 %idx_m1 to i64

  %p_m4 = getelementptr inbounds i8, i8* %expanded, i64 %idx_m4.z
  %p_m3 = getelementptr inbounds i8, i8* %expanded, i64 %idx_m3.z
  %p_m2 = getelementptr inbounds i8, i8* %expanded, i64 %idx_m2.z
  %p_m1 = getelementptr inbounds i8, i8* %expanded, i64 %idx_m1.z

  %t0 = load i8, i8* %p_m4, align 1
  %t1 = load i8, i8* %p_m3, align 1
  %t2 = load i8, i8* %p_m2, align 1
  %t3 = load i8, i8* %p_m1, align 1

  %and = and i32 %idx, 15
  %is0 = icmp eq i32 %and, 0
  br i1 %is0, label %core, label %nocore

core:
  ; rotate left by 1 byte
  %rot0 = %t1
  %rot1 = %t2
  %rot2 = %t3
  %rot3 = %t0
  ; S-box substitutions
  %rot0.z = zext i8 %rot0 to i32
  %s0.i = call i32 @sbox_lookup(i32 %rot0.z)
  %s0 = trunc i32 %s0.i to i8

  %rot1.z = zext i8 %rot1 to i32
  %s1.i = call i32 @sbox_lookup(i32 %rot1.z)
  %s1 = trunc i32 %s1.i to i8

  %rot2.z = zext i8 %rot2 to i32
  %s2.i = call i32 @sbox_lookup(i32 %rot2.z)
  %s2 = trunc i32 %s2.i to i8

  %rot3.z = zext i8 %rot3 to i32
  %s3.i = call i32 @sbox_lookup(i32 %rot3.z)
  %s3 = trunc i32 %s3.i to i8

  ; Rcon on current round, then increment round
  %rc.i = call i32 @rcon(i32 %round)
  %rc = trunc i32 %rc.i to i8
  %s0r = xor i8 %s0, %rc
  %round.next = add i32 %round, 1
  br label %aftercore

nocore:
  %s0.nc = %t0
  %s1.nc = %t1
  %s2.nc = %t2
  %s3.nc = %t3
  br label %aftercore

aftercore:
  ; merge temps and round
  %temp0 = phi i8 [ %s0r, %core ], [ %s0.nc, %nocore ]
  %temp1 = phi i8 [ %s1,  %core ], [ %s1.nc, %nocore ]
  %temp2 = phi i8 [ %s2,  %core ], [ %s2.nc, %nocore ]
  %temp3 = phi i8 [ %s3,  %core ], [ %s3.nc, %nocore ]
  %round.sel = phi i32 [ %round.next, %core ], [ %round, %nocore ]

  ; out[idx + j] = out[idx - 16 + j] XOR temp[j] for j=0..3
  %idx_m16 = add i32 %idx, -16
  %idx_m16.z = zext i32 %idx_m16 to i64
  %base_m16 = getelementptr inbounds i8, i8* %expanded, i64 %idx_m16.z

  %idx.z = zext i32 %idx to i64
  %base = getelementptr inbounds i8, i8* %expanded, i64 %idx.z

  ; j = 0
  %m16_0_ptr = %base_m16
  %in0 = load i8, i8* %m16_0_ptr, align 1
  %out0 = xor i8 %in0, %temp0
  %idx_0_ptr = %base
  store i8 %out0, i8* %idx_0_ptr, align 1

  ; j = 1
  %m16_1_ptr = getelementptr inbounds i8, i8* %base_m16, i64 1
  %in1 = load i8, i8* %m16_1_ptr, align 1
  %out1 = xor i8 %in1, %temp1
  %idx_1_ptr = getelementptr inbounds i8, i8* %base, i64 1
  store i8 %out1, i8* %idx_1_ptr, align 1

  ; j = 2
  %m16_2_ptr = getelementptr inbounds i8, i8* %base_m16, i64 2
  %in2 = load i8, i8* %m16_2_ptr, align 1
  %out2 = xor i8 %in2, %temp2
  %idx_2_ptr = getelementptr inbounds i8, i8* %base, i64 2
  store i8 %out2, i8* %idx_2_ptr, align 1

  ; j = 3
  %m16_3_ptr = getelementptr inbounds i8, i8* %base_m16, i64 3
  %in3 = load i8, i8* %m16_3_ptr, align 1
  %out3 = xor i8 %in3, %temp3
  %idx_3_ptr = getelementptr inbounds i8, i8* %base, i64 3
  store i8 %out3, i8* %idx_3_ptr, align 1

  br label %loop.inc

loop.inc:
  %idx.next = add i32 %idx, 4
  %round.out = %round.sel
  br label %loop.cond

exit:
  ret void
}