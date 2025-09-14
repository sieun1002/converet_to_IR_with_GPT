; ModuleID = 'key_expansion'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_expansion  ; Address: 0x000015A0
; Intent: AES-128 key schedule expansion (16-byte key -> 176-byte expanded key) (confidence=0.95). Evidence: copy 16 bytes, iterate to 0xAF with RotWord+SubWord+Rcon and XOR with w[i-16].
; Preconditions: %src points to at least 16 bytes; %dst points to at least 176 bytes.
; Postconditions: %dst contains the expanded key schedule.

declare i8 @sbox_lookup(i32) local_unnamed_addr
declare i8 @rcon(i32) local_unnamed_addr

define dso_local void @key_expansion(i8* %src, i8* %dst) local_unnamed_addr {
entry:
  br label %copy.cond

copy.cond:
  %i.copy = phi i64 [ 0, %entry ], [ %i.copy.next, %copy.body ]
  %copy.cmp = icmp sle i64 %i.copy, 15
  br i1 %copy.cmp, label %copy.body, label %postcopy

copy.body:
  %src.ptr = getelementptr inbounds i8, i8* %src, i64 %i.copy
  %dst.ptr = getelementptr inbounds i8, i8* %dst, i64 %i.copy
  %b = load i8, i8* %src.ptr, align 1
  store i8 %b, i8* %dst.ptr, align 1
  %i.copy.next = add i64 %i.copy, 1
  br label %copy.cond

postcopy:
  br label %loop.cond

loop.cond:
  %idx = phi i64 [ 16, %postcopy ], [ %idx.next, %loop.latch ]
  %c = phi i32 [ 0, %postcopy ], [ %c.next, %loop.latch ]
  %cmp = icmp sle i64 %idx, 175
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  ; t0..t3 = w[i-4..i-1]
  %off_m4 = add i64 %idx, -4
  %p_m4 = getelementptr inbounds i8, i8* %dst, i64 %off_m4
  %t0 = load i8, i8* %p_m4, align 1
  %off_m3 = add i64 %idx, -3
  %p_m3 = getelementptr inbounds i8, i8* %dst, i64 %off_m3
  %t1 = load i8, i8* %p_m3, align 1
  %off_m2 = add i64 %idx, -2
  %p_m2 = getelementptr inbounds i8, i8* %dst, i64 %off_m2
  %t2 = load i8, i8* %p_m2, align 1
  %off_m1 = add i64 %idx, -1
  %p_m1 = getelementptr inbounds i8, i8* %dst, i64 %off_m1
  %t3 = load i8, i8* %p_m1, align 1
  ; if ((i & 0x0F) == 0) apply RotWord+SubWord and Rcon
  %and = and i64 %idx, 15
  %isblock = icmp eq i64 %and, 0
  br i1 %isblock, label %do.sub, label %no.sub

do.sub:
  ; Rotate left by 1 byte
  %r0 = %t1
  %r1 = %t2
  %r2 = %t3
  %r3 = %t0
  ; SubWord via S-box
  %r0.z = zext i8 %r0 to i32
  %s0 = call i8 @sbox_lookup(i32 %r0.z)
  %r1.z = zext i8 %r1 to i32
  %s1 = call i8 @sbox_lookup(i32 %r1.z)
  %r2.z = zext i8 %r2 to i32
  %s2 = call i8 @sbox_lookup(i32 %r2.z)
  %r3.z = zext i8 %r3 to i32
  %s3 = call i8 @sbox_lookup(i32 %r3.z)
  ; Rcon on low 8 bits of old counter, then increment counter
  %c.trunc = trunc i32 %c to i8
  %c.arg = zext i8 %c.trunc to i32
  %rc = call i8 @rcon(i32 %c.arg)
  %u0.sub = xor i8 %s0, %rc
  %u1.sub = %s1
  %u2.sub = %s2
  %u3.sub = %s3
  %c.inc = add i32 %c, 1
  br label %after.sub

no.sub:
  %u0.n = %t0
  %u1.n = %t1
  %u2.n = %t2
  %u3.n = %t3
  br label %after.sub

after.sub:
  %u0 = phi i8 [ %u0.sub, %do.sub ], [ %u0.n, %no.sub ]
  %u1 = phi i8 [ %u1.sub, %do.sub ], [ %u1.n, %no.sub ]
  %u2 = phi i8 [ %u2.sub, %do.sub ], [ %u2.n, %no.sub ]
  %u3 = phi i8 [ %u3.sub, %do.sub ], [ %u3.n, %no.sub ]
  %c.next = phi i32 [ %c.inc, %do.sub ], [ %c, %no.sub ]

  ; w[i+k] = w[i-16+k] XOR u[k] for k=0..3
  %off_b0_src = add i64 %idx, -16
  %p_b0_src = getelementptr inbounds i8, i8* %dst, i64 %off_b0_src
  %b0 = load i8, i8* %p_b0_src, align 1
  %x0 = xor i8 %b0, %u0
  %p_b0_dst = getelementptr inbounds i8, i8* %dst, i64 %idx
  store i8 %x0, i8* %p_b0_dst, align 1

  %off_b1_src = add i64 %off_b0_src, 1
  %p_b1_src = getelementptr inbounds i8, i8* %dst, i64 %off_b1_src
  %b1 = load i8, i8* %p_b1_src, align 1
  %x1 = xor i8 %b1, %u1
  %off_b1_dst = add i64 %idx, 1
  %p_b1_dst = getelementptr inbounds i8, i8* %dst, i64 %off_b1_dst
  store i8 %x1, i8* %p_b1_dst, align 1

  %off_b2_src = add i64 %off_b0_src, 2
  %p_b2_src = getelementptr inbounds i8, i8* %dst, i64 %off_b2_src
  %b2 = load i8, i8* %p_b2_src, align 1
  %x2 = xor i8 %b2, %u2
  %off_b2_dst = add i64 %idx, 2
  %p_b2_dst = getelementptr inbounds i8, i8* %dst, i64 %off_b2_dst
  store i8 %x2, i8* %p_b2_dst, align 1

  %off_b3_src = add i64 %off_b0_src, 3
  %p_b3_src = getelementptr inbounds i8, i8* %dst, i64 %off_b3_src
  %b3 = load i8, i8* %p_b3_src, align 1
  %x3 = xor i8 %b3, %u3
  %off_b3_dst = add i64 %idx, 3
  %p_b3_dst = getelementptr inbounds i8, i8* %dst, i64 %off_b3_dst
  store i8 %x3, i8* %p_b3_dst, align 1

loop.latch:
  %idx.next = add i64 %idx, 4
  br label %loop.cond

exit:
  ret void
}