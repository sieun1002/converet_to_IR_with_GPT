; ModuleID = 'key_expansion'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_expansion  ; Address: 0x15A0
; Intent: AES-128 key expansion (confidence=0.98). Evidence: copies 16-byte key, uses S-box and Rcon, produces 176-byte expanded key.
; Preconditions: %key must point to at least 16 bytes; %out must point to at least 176 bytes. sbox_lookup and rcon implement AES tables.
; Postconditions: %out contains 176 bytes (11 round keys) of AES-128 key schedule.

; Only the needed extern declarations:
declare i8 @sbox_lookup(i32)
declare i8 @rcon(i32)

define dso_local void @key_expansion(i8* %key, i8* %out) local_unnamed_addr {
entry:
  br label %copy.cond

copy.cond:                                            ; i64 %cidx
  %cidx = phi i64 [ 0, %entry ], [ %cidx.next, %copy.body ]
  %copy.more = icmp ule i64 %cidx, 15
  br i1 %copy.more, label %copy.body, label %copy.done

copy.body:
  %key.ptr = getelementptr inbounds i8, i8* %key, i64 %cidx
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %cidx
  %byte = load i8, i8* %key.ptr, align 1
  store i8 %byte, i8* %out.ptr, align 1
  %cidx.next = add i64 %cidx, 1
  br label %copy.cond

copy.done:
  br label %loop.cond

loop.cond:                                            ; i32 %i, i32 %rcnt
  %i = phi i32 [ 16, %copy.done ], [ %i.next, %loop.body.end ]
  %rcnt = phi i32 [ 0, %copy.done ], [ %rcnt.next, %loop.body.end ]
  %cmp = icmp sle i32 %i, 175
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  ; Load last 4 bytes (w[i-4]..w[i-1])
  %i_minus_4 = sub i32 %i, 4
  %i_minus_3 = add i32 %i_minus_4, 1
  %i_minus_2 = add i32 %i_minus_4, 2
  %i_minus_1 = add i32 %i_minus_4, 3
  %i_m4_64 = zext i32 %i_minus_4 to i64
  %i_m3_64 = zext i32 %i_minus_3 to i64
  %i_m2_64 = zext i32 %i_minus_2 to i64
  %i_m1_64 = zext i32 %i_minus_1 to i64
  %p_m4 = getelementptr inbounds i8, i8* %out, i64 %i_m4_64
  %p_m3 = getelementptr inbounds i8, i8* %out, i64 %i_m3_64
  %p_m2 = getelementptr inbounds i8, i8* %out, i64 %i_m2_64
  %p_m1 = getelementptr inbounds i8, i8* %out, i64 %i_m1_64
  %b0 = load i8, i8* %p_m4, align 1
  %b1 = load i8, i8* %p_m3, align 1
  %b2 = load i8, i8* %p_m2, align 1
  %b3 = load i8, i8* %p_m1, align 1

  ; if ((i & 0xF) == 0) apply RotWord, SubWord, and Rcon
  %and = and i32 %i, 15
  %is_zero = icmp eq i32 %and, 0
  br i1 %is_zero, label %if.then, label %if.else

if.then:
  ; Rotate left: (b0,b1,b2,b3) = (b1,b2,b3,b0)
  %t0 = %b0
  ; SubWord: apply S-box to each byte
  %b0r = %b1
  %b1r = %b2
  %b2r = %b3
  %b3r = %t0
  %b0r.i32 = zext i8 %b0r to i32
  %b1r.i32 = zext i8 %b1r to i32
  %b2r.i32 = zext i8 %b2r to i32
  %b3r.i32 = zext i8 %b3r to i32
  %sb0 = call i8 @sbox_lookup(i32 %b0r.i32)
  %sb1 = call i8 @sbox_lookup(i32 %b1r.i32)
  %sb2 = call i8 @sbox_lookup(i32 %b2r.i32)
  %sb3 = call i8 @sbox_lookup(i32 %b3r.i32)
  ; Rcon: use old rcnt (low 8 bits), then increment
  %rc.arg = and i32 %rcnt, 255
  %rval = call i8 @rcon(i32 %rc.arg)
  %sb0r = xor i8 %sb0, %rval
  %rcnt.inc = add i32 %rcnt, 1
  br label %if.end

if.else:
  br label %if.end

if.end:
  %b0.sel = phi i8 [ %sb0r, %if.then ], [ %b0, %if.else ]
  %b1.sel = phi i8 [ %sb1,  %if.then ], [ %b1, %if.else ]
  %b2.sel = phi i8 [ %sb2,  %if.then ], [ %b2, %if.else ]
  %b3.sel = phi i8 [ %sb3,  %if.then ], [ %b3, %if.else ]
  %rcnt.next = phi i32 [ %rcnt.inc, %if.then ], [ %rcnt, %if.else ]

  ; out[i + k] = out[i - 16 + k] XOR b[k], for k=0..3
  %i64 = zext i32 %i to i64
  %i_minus_16 = sub i32 %i, 16
  %i_m16_64 = zext i32 %i_minus_16 to i64

  ; k = 0
  %p_prev0 = getelementptr inbounds i8, i8* %out, i64 %i_m16_64
  %vprev0 = load i8, i8* %p_prev0, align 1
  %x0 = xor i8 %vprev0, %b0.sel
  %p_dst0 = getelementptr inbounds i8, i8* %out, i64 %i64
  store i8 %x0, i8* %p_dst0, align 1

  ; k = 1
  %idx_prev1 = add i64 %i_m16_64, 1
  %p_prev1 = getelementptr inbounds i8, i8* %out, i64 %idx_prev1
  %vprev1 = load i8, i8* %p_prev1, align 1
  %x1 = xor i8 %vprev1, %b1.sel
  %idx_dst1 = add i64 %i64, 1
  %p_dst1 = getelementptr inbounds i8, i8* %out, i64 %idx_dst1
  store i8 %x1, i8* %p_dst1, align 1

  ; k = 2
  %idx_prev2 = add i64 %i_m16_64, 2
  %p_prev2 = getelementptr inbounds i8, i8* %out, i64 %idx_prev2
  %vprev2 = load i8, i8* %p_prev2, align 1
  %x2 = xor i8 %vprev2, %b2.sel
  %idx_dst2 = add i64 %i64, 2
  %p_dst2 = getelementptr inbounds i8, i8* %out, i64 %idx_dst2
  store i8 %x2, i8* %p_dst2, align 1

  ; k = 3
  %idx_prev3 = add i64 %i_m16_64, 3
  %p_prev3 = getelementptr inbounds i8, i8* %out, i64 %idx_prev3
  %vprev3 = load i8, i8* %p_prev3, align 1
  %x3 = xor i8 %vprev3, %b3.sel
  %idx_dst3 = add i64 %i64, 3
  %p_dst3 = getelementptr inbounds i8, i8* %out, i64 %idx_dst3
  store i8 %x3, i8* %p_dst3, align 1

  %i.next = add i32 %i, 4
  br label %loop.body.end

loop.body.end:
  br label %loop.cond

exit:
  ret void
}