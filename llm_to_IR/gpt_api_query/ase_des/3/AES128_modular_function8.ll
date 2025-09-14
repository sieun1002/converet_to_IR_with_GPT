; ModuleID = 'key_expansion.ll'
target triple = "x86_64-unknown-linux-gnu"

declare i8 @sbox_lookup(i32)
declare i8 @rcon(i32)

define void @key_expansion(i8* %src, i8* %dst) {
entry:
  br label %copy.cond

copy.cond:
  %cidx = phi i32 [ 0, %entry ], [ %cidx.next, %copy.body ]
  %ccond = icmp sle i32 %cidx, 15
  br i1 %ccond, label %copy.body, label %after.copy

copy.body:
  %cidx.i64 = sext i32 %cidx to i64
  %src.ptr = getelementptr inbounds i8, i8* %src, i64 %cidx.i64
  %dst.ptr = getelementptr inbounds i8, i8* %dst, i64 %cidx.i64
  %b = load i8, i8* %src.ptr, align 1
  store i8 %b, i8* %dst.ptr, align 1
  %cidx.next = add nsw i32 %cidx, 1
  br label %copy.cond

after.copy:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 16, %after.copy ], [ %i.next, %loop.iter.done ]
  %rc = phi i32 [ 0, %after.copy ], [ %rc.next, %loop.iter.done ]
  %cmp176 = icmp sle i32 %i, 175
  br i1 %cmp176, label %loop.iter, label %exit

loop.iter:
  %i_m4 = add nsw i32 %i, -4
  %i_m3 = add nsw i32 %i, -3
  %i_m2 = add nsw i32 %i, -2
  %i_m1 = add nsw i32 %i, -1
  %i_m4.i64 = sext i32 %i_m4 to i64
  %i_m3.i64 = sext i32 %i_m3 to i64
  %i_m2.i64 = sext i32 %i_m2 to i64
  %i_m1.i64 = sext i32 %i_m1 to i64
  %p_m4 = getelementptr inbounds i8, i8* %dst, i64 %i_m4.i64
  %p_m3 = getelementptr inbounds i8, i8* %dst, i64 %i_m3.i64
  %p_m2 = getelementptr inbounds i8, i8* %dst, i64 %i_m2.i64
  %p_m1 = getelementptr inbounds i8, i8* %dst, i64 %i_m1.i64
  %b0 = load i8, i8* %p_m4, align 1
  %b1 = load i8, i8* %p_m3, align 1
  %b2 = load i8, i8* %p_m2, align 1
  %b3 = load i8, i8* %p_m1, align 1

  %and = and i32 %i, 15
  %is0 = icmp eq i32 %and, 0
  br i1 %is0, label %rot.sub, label %no.sub

rot.sub:
  %z0 = zext i8 %b1 to i32
  %s0 = call i8 @sbox_lookup(i32 %z0)
  %z1 = zext i8 %b2 to i32
  %s1 = call i8 @sbox_lookup(i32 %z1)
  %z2 = zext i8 %b3 to i32
  %s2 = call i8 @sbox_lookup(i32 %z2)
  %z3 = zext i8 %b0 to i32
  %s3 = call i8 @sbox_lookup(i32 %z3)
  %rc.trunc = trunc i32 %rc to i8
  %rc.z = zext i8 %rc.trunc to i32
  %rv = call i8 @rcon(i32 %rc.z)
  %b0.x = xor i8 %s0, %rv
  %rc.inc = add nsw i32 %rc, 1
  br label %post.sub

no.sub:
  br label %post.sub

post.sub:
  %b0.sel = phi i8 [ %b0.x, %rot.sub ], [ %b0, %no.sub ]
  %b1.sel = phi i8 [ %s1,   %rot.sub ], [ %b1, %no.sub ]
  %b2.sel = phi i8 [ %s2,   %rot.sub ], [ %b2, %no.sub ]
  %b3.sel = phi i8 [ %s3,   %rot.sub ], [ %b3, %no.sub ]
  %rc.next = phi i32 [ %rc.inc, %rot.sub ], [ %rc, %no.sub ]

  %i_m16 = add nsw i32 %i, -16
  %i_m15 = add nsw i32 %i, -15
  %i_m14 = add nsw i32 %i, -14
  %i_m13 = add nsw i32 %i, -13
  %i_m16.i64 = sext i32 %i_m16 to i64
  %i_m15.i64 = sext i32 %i_m15 to i64
  %i_m14.i64 = sext i32 %i_m14 to i64
  %i_m13.i64 = sext i32 %i_m13 to i64
  %p_m16 = getelementptr inbounds i8, i8* %dst, i64 %i_m16.i64
  %p_m15 = getelementptr inbounds i8, i8* %dst, i64 %i_m15.i64
  %p_m14 = getelementptr inbounds i8, i8* %dst, i64 %i_m14.i64
  %p_m13 = getelementptr inbounds i8, i8* %dst, i64 %i_m13.i64
  %v_m16 = load i8, i8* %p_m16, align 1
  %v_m15 = load i8, i8* %p_m15, align 1
  %v_m14 = load i8, i8* %p_m14, align 1
  %v_m13 = load i8, i8* %p_m13, align 1

  %o0 = xor i8 %v_m16, %b0.sel
  %o1 = xor i8 %v_m15, %b1.sel
  %o2 = xor i8 %v_m14, %b2.sel
  %o3 = xor i8 %v_m13, %b3.sel

  %i.i64   = sext i32 %i to i64
  %i1 = add nsw i32 %i, 1
  %i2 = add nsw i32 %i, 2
  %i3 = add nsw i32 %i, 3
  %i1.i64 = sext i32 %i1 to i64
  %i2.i64 = sext i32 %i2 to i64
  %i3.i64 = sext i32 %i3 to i64

  %p_i   = getelementptr inbounds i8, i8* %dst, i64 %i.i64
  %p_i1  = getelementptr inbounds i8, i8* %dst, i64 %i1.i64
  %p_i2  = getelementptr inbounds i8, i8* %dst, i64 %i2.i64
  %p_i3  = getelementptr inbounds i8, i8* %dst, i64 %i3.i64

  store i8 %o0, i8* %p_i,  align 1
  store i8 %o1, i8* %p_i1, align 1
  store i8 %o2, i8* %p_i2, align 1
  store i8 %o3, i8* %p_i3, align 1

  %i.next = add nsw i32 %i, 4
  br label %loop.iter.done

loop.iter.done:
  br label %loop.cond

exit:
  ret void
}