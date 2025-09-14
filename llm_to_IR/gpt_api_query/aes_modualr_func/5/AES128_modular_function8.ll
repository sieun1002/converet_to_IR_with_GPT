; Declarations for external helpers
declare i8 @sbox_lookup(i32)
declare i8 @rcon(i32)

define void @key_expansion(i8* %src, i8* %dst) {
entry:
  %src.addr = alloca i8*, align 8
  %dst.addr = alloca i8*, align 8
  %i_copy = alloca i32, align 4
  %i = alloca i32, align 4
  %rconi = alloca i32, align 4
  %b0 = alloca i8, align 1
  %b1 = alloca i8, align 1
  %b2 = alloca i8, align 1
  %b3 = alloca i8, align 1
  store i8* %src, i8** %src.addr, align 8
  store i8* %dst, i8** %dst.addr, align 8

  ; copy first 16 bytes from src to dst
  store i32 0, i32* %i_copy, align 4
  br label %copy.cond

copy.cond:                                           ; preds = %copy.body, %entry
  %i_copy.val = load i32, i32* %i_copy, align 4
  %cmp.copy = icmp sle i32 %i_copy.val, 15
  br i1 %cmp.copy, label %copy.body, label %copy.end

copy.body:                                           ; preds = %copy.cond
  %srcp = load i8*, i8** %src.addr, align 8
  %idx64 = sext i32 %i_copy.val to i64
  %src.gep = getelementptr inbounds i8, i8* %srcp, i64 %idx64
  %val = load i8, i8* %src.gep, align 1
  %dstp = load i8*, i8** %dst.addr, align 8
  %dst.gep = getelementptr inbounds i8, i8* %dstp, i64 %idx64
  store i8 %val, i8* %dst.gep, align 1
  %inc = add i32 %i_copy.val, 1
  store i32 %inc, i32* %i_copy, align 4
  br label %copy.cond

copy.end:                                            ; preds = %copy.cond
  store i32 16, i32* %i, align 4
  store i32 0, i32* %rconi, align 4
  br label %loop.cond

loop.cond:                                           ; preds = %if.end, %copy.end
  %i.val = load i32, i32* %i, align 4
  %cmp.loop = icmp sle i32 %i.val, 175
  br i1 %cmp.loop, label %loop.body, label %ret

loop.body:                                           ; preds = %loop.cond
  %dstp2 = load i8*, i8** %dst.addr, align 8
  %i64 = sext i32 %i.val to i64

  ; load previous 4 bytes: b0..b3 = dst[i-4..i-1]
  %i_m4 = add i64 %i64, -4
  %p_m4 = getelementptr inbounds i8, i8* %dstp2, i64 %i_m4
  %v_m4 = load i8, i8* %p_m4, align 1
  store i8 %v_m4, i8* %b0, align 1

  %i_m3 = add i64 %i64, -3
  %p_m3 = getelementptr inbounds i8, i8* %dstp2, i64 %i_m3
  %v_m3 = load i8, i8* %p_m3, align 1
  store i8 %v_m3, i8* %b1, align 1

  %i_m2 = add i64 %i64, -2
  %p_m2 = getelementptr inbounds i8, i8* %dstp2, i64 %i_m2
  %v_m2 = load i8, i8* %p_m2, align 1
  store i8 %v_m2, i8* %b2, align 1

  %i_m1 = add i64 %i64, -1
  %p_m1 = getelementptr inbounds i8, i8* %dstp2, i64 %i_m1
  %v_m1 = load i8, i8* %p_m1, align 1
  store i8 %v_m1, i8* %b3, align 1

  ; if ((i & 0x0F) == 0) { RotWord, SubWord, Rcon }
  %and = and i32 %i.val, 15
  %cond = icmp eq i32 %and, 0
  br i1 %cond, label %if.then, label %if.end

if.then:                                             ; preds = %loop.body
  ; rotate left by 1 byte
  %b0v = load i8, i8* %b0, align 1
  %b1v = load i8, i8* %b1, align 1
  %b2v = load i8, i8* %b2, align 1
  %b3v = load i8, i8* %b3, align 1
  store i8 %b1v, i8* %b0, align 1
  store i8 %b2v, i8* %b1, align 1
  store i8 %b3v, i8* %b2, align 1
  store i8 %b0v, i8* %b3, align 1

  ; S-box on each byte
  %b0v2 = load i8, i8* %b0, align 1
  %b0z = zext i8 %b0v2 to i32
  %sb0 = call i8 @sbox_lookup(i32 %b0z)
  store i8 %sb0, i8* %b0, align 1

  %b1v2 = load i8, i8* %b1, align 1
  %b1z = zext i8 %b1v2 to i32
  %sb1 = call i8 @sbox_lookup(i32 %b1z)
  store i8 %sb1, i8* %b1, align 1

  %b2v2 = load i8, i8* %b2, align 1
  %b2z = zext i8 %b2v2 to i32
  %sb2 = call i8 @sbox_lookup(i32 %b2z)
  store i8 %sb2, i8* %b2, align 1

  %b3v2 = load i8, i8* %b3, align 1
  %b3z = zext i8 %b3v2 to i32
  %sb3 = call i8 @sbox_lookup(i32 %b3z)
  store i8 %sb3, i8* %b3, align 1

  ; Rcon on first byte position
  %rconi_old = load i32, i32* %rconi, align 4
  %rconi_inc = add i32 %rconi_old, 1
  store i32 %rconi_inc, i32* %rconi, align 4
  %old8 = trunc i32 %rconi_old to i8
  %oldz = zext i8 %old8 to i32
  %rc = call i8 @rcon(i32 %oldz)
  %b0v3 = load i8, i8* %b0, align 1
  %b0xor = xor i8 %b0v3, %rc
  store i8 %b0xor, i8* %b0, align 1
  br label %if.end

if.end:                                              ; preds = %if.then, %loop.body
  ; write 4 bytes: dst[i + k] = dst[i - 16 + k] xor b{k}
  %i_m16 = add i64 %i64, -16
  %p_m16 = getelementptr inbounds i8, i8* %dstp2, i64 %i_m16
  %v_m16 = load i8, i8* %p_m16, align 1
  %b0v4 = load i8, i8* %b0, align 1
  %out0 = xor i8 %v_m16, %b0v4
  %p_i = getelementptr inbounds i8, i8* %dstp2, i64 %i64
  store i8 %out0, i8* %p_i, align 1

  %i_m15 = add i64 %i64, -15
  %p_m15 = getelementptr inbounds i8, i8* %dstp2, i64 %i_m15
  %v_m15 = load i8, i8* %p_m15, align 1
  %b1v4 = load i8, i8* %b1, align 1
  %out1 = xor i8 %v_m15, %b1v4
  %i_p1 = add i64 %i64, 1
  %p_i1 = getelementptr inbounds i8, i8* %dstp2, i64 %i_p1
  store i8 %out1, i8* %p_i1, align 1

  %i_m14 = add i64 %i64, -14
  %p_m14 = getelementptr inbounds i8, i8* %dstp2, i64 %i_m14
  %v_m14 = load i8, i8* %p_m14, align 1
  %b2v4 = load i8, i8* %b2, align 1
  %out2 = xor i8 %v_m14, %b2v4
  %i_p2 = add i64 %i64, 2
  %p_i2 = getelementptr inbounds i8, i8* %dstp2, i64 %i_p2
  store i8 %out2, i8* %p_i2, align 1

  %i_m13 = add i64 %i64, -13
  %p_m13 = getelementptr inbounds i8, i8* %dstp2, i64 %i_m13
  %v_m13 = load i8, i8* %p_m13, align 1
  %b3v4 = load i8, i8* %b3, align 1
  %out3 = xor i8 %v_m13, %b3v4
  %i_p3 = add i64 %i64, 3
  %p_i3 = getelementptr inbounds i8, i8* %dstp2, i64 %i_p3
  store i8 %out3, i8* %p_i3, align 1

  ; i += 4
  %i_next = add i32 %i.val, 4
  store i32 %i_next, i32* %i, align 4
  br label %loop.cond

ret:                                                 ; preds = %loop.cond
  ret void
}