; ModuleID = 'key_expansion'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_expansion ; Address: 0x15A0
; Intent: AES-128 key expansion (176-byte schedule) (confidence=0.95). Evidence: copies 16-byte key, every 16 bytes rotates word, applies sbox_lookup and rcon, XORs with bytes 16 back.
; Preconditions: %key points to at least 16 bytes; %exp points to at least 176 bytes; externs sbox_lookup(i32) and rcon(i32) available.
; Postconditions: exp[0..15] = key[0..15]; exp[16..175] filled per AES-128 key schedule.

; Only the necessary external declarations:
declare i32 @sbox_lookup(i32)
declare i32 @rcon(i32)

define dso_local void @key_expansion(i8* %key, i8* %exp) local_unnamed_addr {
entry:
  br label %copy.loop

copy.loop:                                           ; copy 16-byte key
  %ci = phi i32 [ 0, %entry ], [ %ci.next, %copy.body ]
  %ccond = icmp sle i32 %ci, 15
  br i1 %ccond, label %copy.body, label %after.copy

copy.body:
  %ci.z = zext i32 %ci to i64
  %ksrc.ptr = getelementptr inbounds i8, i8* %key, i64 %ci.z
  %kval = load i8, i8* %ksrc.ptr, align 1
  %kdst.ptr = getelementptr inbounds i8, i8* %exp, i64 %ci.z
  store i8 %kval, i8* %kdst.ptr, align 1
  %ci.next = add nsw i32 %ci, 1
  br label %copy.loop

after.copy:
  br label %main.loop

main.loop:
  %i = phi i32 [ 16, %after.copy ], [ %i.next, %main.tail ]
  %rcidx = phi i32 [ 0, %after.copy ], [ %rcidx.next, %main.tail ]
  %cond = icmp sle i32 %i, 175
  br i1 %cond, label %main.body, label %exit

main.body:
  %i.z = zext i32 %i to i64
  %i_m4 = add i64 %i.z, -4
  %i_m3 = add i64 %i.z, -3
  %i_m2 = add i64 %i.z, -2
  %i_m1 = add i64 %i.z, -1
  %p_m4 = getelementptr inbounds i8, i8* %exp, i64 %i_m4
  %p_m3 = getelementptr inbounds i8, i8* %exp, i64 %i_m3
  %p_m2 = getelementptr inbounds i8, i8* %exp, i64 %i_m2
  %p_m1 = getelementptr inbounds i8, i8* %exp, i64 %i_m1
  %b0 = load i8, i8* %p_m4, align 1
  %b1 = load i8, i8* %p_m3, align 1
  %b2 = load i8, i8* %p_m2, align 1
  %b3 = load i8, i8* %p_m1, align 1
  %i_and = and i32 %i, 15
  %is0 = icmp eq i32 %i_and, 0
  br i1 %is0, label %doSub, label %noSub

doSub:                                               ; RotWord + SubWord + Rcon
  ; rotate left by 1 byte
  %rb0 = %b1
  %rb1 = %b2
  %rb2 = %b3
  %rb3 = %b0
  ; SubWord via sbox_lookup
  %rb0.z = zext i8 %rb0 to i32
  %sb0.i32 = call i32 @sbox_lookup(i32 %rb0.z)
  %sb0 = trunc i32 %sb0.i32 to i8
  %rb1.z = zext i8 %rb1 to i32
  %sb1.i32 = call i32 @sbox_lookup(i32 %rb1.z)
  %sb1 = trunc i32 %sb1.i32 to i8
  %rb2.z = zext i8 %rb2 to i32
  %sb2.i32 = call i32 @sbox_lookup(i32 %rb2.z)
  %sb2 = trunc i32 %sb2.i32 to i8
  %rb3.z = zext i8 %rb3 to i32
  %sb3.i32 = call i32 @sbox_lookup(i32 %rb3.z)
  %sb3 = trunc i32 %sb3.i32 to i8
  ; Rcon on first byte
  %rcinc = add i32 %rcidx, 1
  %rcbyte = and i32 %rcinc, 255
  %rcon.i32 = call i32 @rcon(i32 %rcbyte)
  %rcon.b = trunc i32 %rcon.i32 to i8
  %sb0.x = xor i8 %sb0, %rcon.b
  br label %after.sub

noSub:
  br label %after.sub

after.sub:
  ; select modified vs unmodified bytes, and updated rcon index
  %nb0 = phi i8 [ %sb0.x, %doSub ], [ %b0, %noSub ]
  %nb1 = phi i8 [ %sb1, %doSub ], [ %b1, %noSub ]
  %nb2 = phi i8 [ %sb2, %doSub ], [ %b2, %noSub ]
  %nb3 = phi i8 [ %sb3, %doSub ], [ %b3, %noSub ]
  %rcidx.next = phi i32 [ %rcinc, %doSub ], [ %rcidx, %noSub ]
  ; exp[i + k] = exp[i - 16 + k] ^ nbk
  %i_m16 = add i64 %i.z, -16
  %src0 = getelementptr inbounds i8, i8* %exp, i64 %i_m16
  %src1 = getelementptr inbounds i8, i8* %exp, i64 (add i64 %i_m16, 1)
  ; LLVM requires concrete ops: compute offsets explicitly
  %i_m15 = add i64 %i_m16, 1
  %i_m14 = add i64 %i_m16, 2
  %i_m13 = add i64 %i_m16, 3
  %s0 = getelementptr inbounds i8, i8* %exp, i64 %i_m16
  %s1 = getelementptr inbounds i8, i8* %exp, i64 %i_m15
  %s2 = getelementptr inbounds i8, i8* %exp, i64 %i_m14
  %s3 = getelementptr inbounds i8, i8* %exp, i64 %i_m13
  %v0 = load i8, i8* %s0, align 1
  %v1 = load i8, i8* %s1, align 1
  %v2 = load i8, i8* %s2, align 1
  %v3 = load i8, i8* %s3, align 1
  %x0 = xor i8 %v0, %nb0
  %x1 = xor i8 %v1, %nb1
  %x2 = xor i8 %v2, %nb2
  %x3 = xor i8 %v3, %nb3
  %d0 = getelementptr inbounds i8, i8* %exp, i64 %i.z
  %i_p1 = add i64 %i.z, 1
  %i_p2 = add i64 %i.z, 2
  %i_p3 = add i64 %i.z, 3
  %d1 = getelementptr inbounds i8, i8* %exp, i64 %i_p1
  %d2 = getelementptr inbounds i8, i8* %exp, i64 %i_p2
  %d3 = getelementptr inbounds i8, i8* %exp, i64 %i_p3
  store i8 %x0, i8* %d0, align 1
  store i8 %x1, i8* %d1, align 1
  store i8 %x2, i8* %d2, align 1
  store i8 %x3, i8* %d3, align 1
  br label %main.tail

main.tail:
  %i.next = add i32 %i, 4
  br label %main.loop

exit:
  ret void
}