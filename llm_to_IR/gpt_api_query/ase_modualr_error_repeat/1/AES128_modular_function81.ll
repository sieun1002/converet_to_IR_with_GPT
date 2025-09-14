; LLVM IR (LLVM 14) for function: key_expansion
; Semantics recovered from the provided x86-64 disassembly.
; Signature: void key_expansion(const uint8_t* key, uint8_t* expanded)

declare i8 @sbox_lookup(i32 noundef) local_unnamed_addr
declare i8 @rcon(i32 noundef) local_unnamed_addr

define dso_local void @key_expansion(i8* nocapture noundef readonly %key, i8* nocapture noundef %exp) local_unnamed_addr {
entry:
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %rc_iter = alloca i32, align 4
  store i32 0, i32* %j, align 4
  br label %copy.loop

copy.loop:                                        ; preds = %copy.body, %entry
  %jv = load i32, i32* %j, align 4
  %cmpj = icmp sle i32 %jv, 15
  br i1 %cmpj, label %copy.body, label %copy.end

copy.body:                                        ; preds = %copy.loop
  %jv64 = sext i32 %jv to i64
  %srcp = getelementptr inbounds i8, i8* %key, i64 %jv64
  %dstp = getelementptr inbounds i8, i8* %exp, i64 %jv64
  %b = load i8, i8* %srcp, align 1
  store i8 %b, i8* %dstp, align 1
  %jn = add nsw i32 %jv, 1
  store i32 %jn, i32* %j, align 4
  br label %copy.loop

copy.end:                                         ; preds = %copy.loop
  store i32 16, i32* %i, align 4
  store i32 0, i32* %rc_iter, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.inc, %copy.end
  %iv = load i32, i32* %i, align 4
  %cmpi = icmp sle i32 %iv, 175
  br i1 %cmpi, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.cond
  %iv64 = sext i32 %iv to i64
  %i_m4 = add nsw i64 %iv64, -4
  %i_m3 = add nsw i64 %iv64, -3
  %i_m2 = add nsw i64 %iv64, -2
  %i_m1 = add nsw i64 %iv64, -1
  %p0 = getelementptr inbounds i8, i8* %exp, i64 %i_m4
  %p1 = getelementptr inbounds i8, i8* %exp, i64 %i_m3
  %p2 = getelementptr inbounds i8, i8* %exp, i64 %i_m2
  %p3 = getelementptr inbounds i8, i8* %exp, i64 %i_m1
  %t0 = load i8, i8* %p0, align 1
  %t1 = load i8, i8* %p1, align 1
  %t2 = load i8, i8* %p2, align 1
  %t3 = load i8, i8* %p3, align 1
  %andi = and i32 %iv, 15
  %is0 = icmp eq i32 %andi, 0
  br i1 %is0, label %do.special, label %normal

do.special:                                       ; preds = %loop.body
  %t0_old = %t0
  %t0r = %t1
  %t1r = %t2
  %t2r = %t3
  %t3r = %t0_old
  %t0r.z = zext i8 %t0r to i32
  %s0 = call i8 @sbox_lookup(i32 %t0r.z)
  %t1r.z = zext i8 %t1r to i32
  %s1 = call i8 @sbox_lookup(i32 %t1r.z)
  %t2r.z = zext i8 %t2r to i32
  %s2 = call i8 @sbox_lookup(i32 %t2r.z)
  %t3r.z = zext i8 %t3r to i32
  %s3 = call i8 @sbox_lookup(i32 %t3r.z)
  %rcv = load i32, i32* %rc_iter, align 4
  %rcv_inc = add nsw i32 %rcv, 1
  store i32 %rcv_inc, i32* %rc_iter, align 4
  %rc_arg8 = trunc i32 %rcv to i8
  %rc_arg32 = zext i8 %rc_arg8 to i32
  %rc_val = call i8 @rcon(i32 %rc_arg32)
  %s0x = xor i8 %s0, %rc_val
  br label %after.special

normal:                                           ; preds = %loop.body
  br label %after.special

after.special:                                    ; preds = %normal, %do.special
  %u0 = phi i8 [ %s0x, %do.special ], [ %t0, %normal ]
  %u1 = phi i8 [ %s1,  %do.special ], [ %t1, %normal ]
  %u2 = phi i8 [ %s2,  %do.special ], [ %t2, %normal ]
  %u3 = phi i8 [ %s3,  %do.special ], [ %t3, %normal ]

  %i_m16 = add nsw i64 %iv64, -16
  %i_m15 = add nsw i64 %iv64, -15
  %i_m14 = add nsw i64 %iv64, -14
  %i_m13 = add nsw i64 %iv64, -13
  %q0 = getelementptr inbounds i8, i8* %exp, i64 %i_m16
  %q1 = getelementptr inbounds i8, i8* %exp, i64 %i_m15
  %q2 = getelementptr inbounds i8, i8* %exp, i64 %i_m14
  %q3 = getelementptr inbounds i8, i8* %exp, i64 %i_m13
  %b0 = load i8, i8* %q0, align 1
  %b1 = load i8, i8* %q1, align 1
  %b2 = load i8, i8* %q2, align 1
  %b3 = load i8, i8* %q3, align 1
  %o0 = xor i8 %b0, %u0
  %o1 = xor i8 %b1, %u1
  %o2 = xor i8 %b2, %u2
  %o3 = xor i8 %b3, %u3
  %dst0 = getelementptr inbounds i8, i8* %exp, i64 %iv64
  store i8 %o0, i8* %dst0, align 1
  %iv64p1 = add nsw i64 %iv64, 1
  %dst1 = getelementptr inbounds i8, i8* %exp, i64 %iv64p1
  store i8 %o1, i8* %dst1, align 1
  %iv64p2 = add nsw i64 %iv64, 2
  %dst2 = getelementptr inbounds i8, i8* %exp, i64 %iv64p2
  store i8 %o2, i8* %dst2, align 1
  %iv64p3 = add nsw i64 %iv64, 3
  %dst3 = getelementptr inbounds i8, i8* %exp, i64 %iv64p3
  store i8 %o3, i8* %dst3, align 1
  br label %loop.inc

loop.inc:                                         ; preds = %after.special
  %iv.next = add nsw i32 %iv, 4
  store i32 %iv.next, i32* %i, align 4
  br label %loop.cond

exit:                                             ; preds = %loop.cond
  ret void
}