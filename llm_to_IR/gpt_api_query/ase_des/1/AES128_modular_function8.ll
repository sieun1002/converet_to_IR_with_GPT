; LLVM 14 IR for function: key_expansion

declare i8 @sbox_lookup(i32)
declare i8 @rcon(i32)

define void @key_expansion(i8* noundef %src, i8* noundef %dst) {
entry:
  br label %copy.loop

copy.loop:                                        ; i from 0..15
  %i = phi i32 [ 0, %entry ], [ %i.next, %copy.next ]
  %cmp.i = icmp sle i32 %i, 15
  br i1 %cmp.i, label %copy.body, label %after.copy

copy.body:
  %src.ptr = getelementptr inbounds i8, i8* %src, i32 %i
  %dst.ptr = getelementptr inbounds i8, i8* %dst, i32 %i
  %b = load i8, i8* %src.ptr, align 1
  store i8 %b, i8* %dst.ptr, align 1
  br label %copy.next

copy.next:
  %i.next = add i32 %i, 1
  br label %copy.loop

after.copy:
  br label %main.loop

main.loop:                                        ; i from 16..175 step 4
  %i2 = phi i32 [ 16, %after.copy ], [ %i2.next, %loop.end ]
  %round = phi i32 [ 0, %after.copy ], [ %round.next, %loop.end ]
  %cmp.i2 = icmp sle i32 %i2, 175
  br i1 %cmp.i2, label %loop.body, label %end

loop.body:
  ; load previous word bytes: b0=[i-4], b1=[i-3], b2=[i-2], b3=[i-1]
  %idx.m4 = add i32 %i2, -4
  %p0 = getelementptr inbounds i8, i8* %dst, i32 %idx.m4
  %b0 = load i8, i8* %p0, align 1

  %idx.m3 = add i32 %i2, -3
  %p1 = getelementptr inbounds i8, i8* %dst, i32 %idx.m3
  %b1 = load i8, i8* %p1, align 1

  %idx.m2 = add i32 %i2, -2
  %p2 = getelementptr inbounds i8, i8* %dst, i32 %idx.m2
  %b2 = load i8, i8* %p2, align 1

  %idx.m1 = add i32 %i2, -1
  %p3 = getelementptr inbounds i8, i8* %dst, i32 %idx.m1
  %b3 = load i8, i8* %p3, align 1

  ; if (i2 & 0xF) == 0
  %and = and i32 %i2, 15
  %iszero = icmp eq i32 %and, 0
  br i1 %iszero, label %rot.sbox, label %no.rot

rot.sbox:
  ; rotate (b0,b1,b2,b3) -> (b1,b2,b3,b0)
  %rb0 = %b1
  %rb1 = %b2
  %rb2 = %b3
  %rb3 = %b0

  ; S-box each
  %rb0.z = zext i8 %rb0 to i32
  %sb0 = call i8 @sbox_lookup(i32 %rb0.z)

  %rb1.z = zext i8 %rb1 to i32
  %sb1 = call i8 @sbox_lookup(i32 %rb1.z)

  %rb2.z = zext i8 %rb2 to i32
  %sb2 = call i8 @sbox_lookup(i32 %rb2.z)

  %rb3.z = zext i8 %rb3 to i32
  %sb3 = call i8 @sbox_lookup(i32 %rb3.z)

  ; Rcon with current round, then round++
  %rval = call i8 @rcon(i32 %round)
  %sb0.x = xor i8 %sb0, %rval
  %round.inc = add i32 %round, 1
  br label %post.rot

no.rot:
  br label %post.rot

post.rot:
  %b0.f = phi i8 [ %sb0.x, %rot.sbox ], [ %b0, %no.rot ]
  %b1.f = phi i8 [ %sb1,   %rot.sbox ], [ %b1, %no.rot ]
  %b2.f = phi i8 [ %sb2,   %rot.sbox ], [ %b2, %no.rot ]
  %b3.f = phi i8 [ %sb3,   %rot.sbox ], [ %b3, %no.rot ]
  %round.out = phi i32 [ %round.inc, %rot.sbox ], [ %round, %no.rot ]

  ; out[i]   = out[i-16] xor b0.f
  %idx.m16 = add i32 %i2, -16
  %q0 = getelementptr inbounds i8, i8* %dst, i32 %idx.m16
  %x0 = load i8, i8* %q0, align 1
  %y0 = xor i8 %x0, %b0.f
  %out.i = getelementptr inbounds i8, i8* %dst, i32 %i2
  store i8 %y0, i8* %out.i, align 1

  ; out[i+1] = out[i-15] xor b1.f
  %idx.m15 = add i32 %i2, -15
  %q1 = getelementptr inbounds i8, i8* %dst, i32 %idx.m15
  %x1 = load i8, i8* %q1, align 1
  %y1 = xor i8 %x1, %b1.f
  %out.i1.idx = add i32 %i2, 1
  %out.i1 = getelementptr inbounds i8, i8* %dst, i32 %out.i1.idx
  store i8 %y1, i8* %out.i1, align 1

  ; out[i+2] = out[i-14] xor b2.f
  %idx.m14 = add i32 %i2, -14
  %q2 = getelementptr inbounds i8, i8* %dst, i32 %idx.m14
  %x2 = load i8, i8* %q2, align 1
  %y2 = xor i8 %x2, %b2.f
  %out.i2.idx = add i32 %i2, 2
  %out.i2 = getelementptr inbounds i8, i8* %dst, i32 %out.i2.idx
  store i8 %y2, i8* %out.i2, align 1

  ; out[i+3] = out[i-13] xor b3.f
  %idx.m13 = add i32 %i2, -13
  %q3 = getelementptr inbounds i8, i8* %dst, i32 %idx.m13
  %x3 = load i8, i8* %q3, align 1
  %y3 = xor i8 %x3, %b3.f
  %out.i3.idx = add i32 %i2, 3
  %out.i3 = getelementptr inbounds i8, i8* %dst, i32 %out.i3.idx
  store i8 %y3, i8* %out.i3, align 1

  ; next iteration
  %i2.next = add i32 %i2, 4
  br label %loop.end

loop.end:
  %round.next = phi i32 [ %round.out, %post.rot ]
  br label %main.loop

end:
  ret void
}