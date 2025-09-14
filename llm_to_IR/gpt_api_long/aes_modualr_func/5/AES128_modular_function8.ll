; ModuleID = 'key_expansion'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_expansion  ; Address: 0x15A0
; Intent: AES-128 key expansion (confidence=0.95). Evidence: 16-byte seed copy; S-box and rcon usage with 176-byte schedule
; Preconditions: %key points to at least 16 bytes; %out points to at least 176 bytes (11 round keys)
; Postconditions: %out[0..15] = %key[0..15]; %out[16..175] filled with expanded key schedule

declare zeroext i8 @sbox_lookup(i32)
declare zeroext i8 @rcon(i32)

define dso_local void @key_expansion(i8* %key, i8* %out) local_unnamed_addr {
entry:
  br label %copy.loop

copy.loop:                                            ; copy 16 bytes from key to out
  %ci = phi i32 [ 0, %entry ], [ %ci.next, %copy.loop.body ]
  %cmp.copy = icmp sle i32 %ci, 15
  br i1 %cmp.copy, label %copy.loop.body, label %after_copy

copy.loop.body:
  %ci64 = sext i32 %ci to i64
  %src.ptr = getelementptr inbounds i8, i8* %key, i64 %ci64
  %b = load i8, i8* %src.ptr, align 1
  %dst.ptr = getelementptr inbounds i8, i8* %out, i64 %ci64
  store i8 %b, i8* %dst.ptr, align 1
  %ci.next = add i32 %ci, 1
  br label %copy.loop

after_copy:
  br label %expand.cond

expand.cond:
  %i = phi i32 [ 16, %after_copy ], [ %i.next, %after_gfun ]
  %rc = phi i32 [ 0, %after_copy ], [ %rc.updated, %after_gfun ]
  %cmp.expand = icmp sle i32 %i, 175
  br i1 %cmp.expand, label %expand.body, label %exit

expand.body:
  %i64 = sext i32 %i to i64
  %i64m4 = add i64 %i64, -4
  %i64m3 = add i64 %i64, -3
  %i64m2 = add i64 %i64, -2
  %i64m1 = add i64 %i64, -1
  %p_b0 = getelementptr inbounds i8, i8* %out, i64 %i64m4
  %p_b1 = getelementptr inbounds i8, i8* %out, i64 %i64m3
  %p_b2 = getelementptr inbounds i8, i8* %out, i64 %i64m2
  %p_b3 = getelementptr inbounds i8, i8* %out, i64 %i64m1
  %b0 = load i8, i8* %p_b0, align 1
  %b1 = load i8, i8* %p_b1, align 1
  %b2 = load i8, i8* %p_b2, align 1
  %b3 = load i8, i8* %p_b3, align 1
  %i_and = and i32 %i, 15
  %is0 = icmp eq i32 %i_and, 0
  br i1 %is0, label %do_gfun, label %skip_gfun

do_gfun:                                              ; RotWord, SubBytes, Rcon on first byte
  ; rotate left by one byte
  %rb0 = select i1 true, i8 %b1, i8 0
  %rb1 = select i1 true, i8 %b2, i8 0
  %rb2 = select i1 true, i8 %b3, i8 0
  %rb3 = select i1 true, i8 %b0, i8 0
  ; S-box
  %rb0.z = zext i8 %rb0 to i32
  %sb0 = call zeroext i8 @sbox_lookup(i32 %rb0.z)
  %rb1.z = zext i8 %rb1 to i32
  %sb1 = call zeroext i8 @sbox_lookup(i32 %rb1.z)
  %rb2.z = zext i8 %rb2 to i32
  %sb2 = call zeroext i8 @sbox_lookup(i32 %rb2.z)
  %rb3.z = zext i8 %rb3 to i32
  %sb3 = call zeroext i8 @sbox_lookup(i32 %rb3.z)
  ; rcon with previous rc value's low byte, then increment rc
  %oldrc8 = and i32 %rc, 255
  %rbyte = call zeroext i8 @rcon(i32 %oldrc8)
  %sb0.x = xor i8 %sb0, %rbyte
  %rc.inc = add i32 %rc, 1
  br label %after_gfun

skip_gfun:
  br label %after_gfun

after_gfun:
  %v0 = phi i8 [ %sb0.x, %do_gfun ], [ %b0, %skip_gfun ]
  %v1 = phi i8 [ %sb1, %do_gfun ], [ %b1, %skip_gfun ]
  %v2 = phi i8 [ %sb2, %do_gfun ], [ %b2, %skip_gfun ]
  %v3 = phi i8 [ %sb3, %do_gfun ], [ %b3, %skip_gfun ]
  %rc.updated = phi i32 [ %rc.inc, %do_gfun ], [ %rc, %skip_gfun ]

  ; out[i + j] = out[i - 16 + j] xor vj, for j=0..3
  %i64m16 = add i64 %i64, -16
  %p_prev0 = getelementptr inbounds i8, i8* %out, i64 %i64m16
  %prev0 = load i8, i8* %p_prev0, align 1
  %x0 = xor i8 %prev0, %v0
  %p_cur0 = getelementptr inbounds i8, i8* %out, i64 %i64
  store i8 %x0, i8* %p_cur0, align 1

  %i64p1 = add i64 %i64, 1
  %i64m15 = add i64 %i64, -15
  %p_prev1 = getelementptr inbounds i8, i8* %out, i64 %i64m15
  %prev1 = load i8, i8* %p_prev1, align 1
  %x1 = xor i8 %prev1, %v1
  %p_cur1 = getelementptr inbounds i8, i8* %out, i64 %i64p1
  store i8 %x1, i8* %p_cur1, align 1

  %i64p2 = add i64 %i64, 2
  %i64m14 = add i64 %i64, -14
  %p_prev2 = getelementptr inbounds i8, i8* %out, i64 %i64m14
  %prev2 = load i8, i8* %p_prev2, align 1
  %x2 = xor i8 %prev2, %v2
  %p_cur2 = getelementptr inbounds i8, i8* %out, i64 %i64p2
  store i8 %x2, i8* %p_cur2, align 1

  %i64p3 = add i64 %i64, 3
  %i64m13 = add i64 %i64, -13
  %p_prev3 = getelementptr inbounds i8, i8* %out, i64 %i64m13
  %prev3 = load i8, i8* %p_prev3, align 1
  %x3 = xor i8 %prev3, %v3
  %p_cur3 = getelementptr inbounds i8, i8* %out, i64 %i64p3
  store i8 %x3, i8* %p_cur3, align 1

  %i.next = add i32 %i, 4
  br label %expand.cond

exit:
  ret void
}