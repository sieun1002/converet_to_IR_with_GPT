; ModuleID = 'key_expansion'
target triple = "x86_64-unknown-linux-gnu"

declare dso_local zeroext i8 @sbox_lookup(i32) local_unnamed_addr
declare dso_local zeroext i8 @rcon(i32) local_unnamed_addr

define dso_local void @key_expansion(i8* nocapture readonly %in_key, i8* nocapture %out_expanded) local_unnamed_addr {
entry:
  br label %copy.loop

copy.loop:
  %ci = phi i32 [ 0, %entry ], [ %ci.next, %copy.inc ]
  %cmp.ci = icmp sle i32 %ci, 15
  br i1 %cmp.ci, label %copy.body, label %copy.done

copy.body:
  %ci.z = zext i32 %ci to i64
  %in.ptr = getelementptr inbounds i8, i8* %in_key, i64 %ci.z
  %b = load i8, i8* %in.ptr, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out_expanded, i64 %ci.z
  store i8 %b, i8* %out.ptr, align 1
  br label %copy.inc

copy.inc:
  %ci.next = add nsw i32 %ci, 1
  br label %copy.loop

copy.done:
  br label %loop.header

loop.header:
  %i = phi i32 [ 16, %copy.done ], [ %i.next, %loop.latch ]
  %rci = phi i32 [ 0, %copy.done ], [ %rci.next, %loop.latch ]
  %cmp.i = icmp sle i32 %i, 175
  br i1 %cmp.i, label %loop.body, label %exit

loop.body:
  %i_m4 = add nsw i32 %i, -4
  %i_m3 = add nsw i32 %i, -3
  %i_m2 = add nsw i32 %i, -2
  %i_m1 = add nsw i32 %i, -1
  %i_m4.z = zext i32 %i_m4 to i64
  %i_m3.z = zext i32 %i_m3 to i64
  %i_m2.z = zext i32 %i_m2 to i64
  %i_m1.z = zext i32 %i_m1 to i64
  %p_m4 = getelementptr inbounds i8, i8* %out_expanded, i64 %i_m4.z
  %p_m3 = getelementptr inbounds i8, i8* %out_expanded, i64 %i_m3.z
  %p_m2 = getelementptr inbounds i8, i8* %out_expanded, i64 %i_m2.z
  %p_m1 = getelementptr inbounds i8, i8* %out_expanded, i64 %i_m1.z
  %t0 = load i8, i8* %p_m4, align 1
  %t1 = load i8, i8* %p_m3, align 1
  %t2 = load i8, i8* %p_m2, align 1
  %t3 = load i8, i8* %p_m1, align 1
  %and = and i32 %i, 15
  %needs = icmp eq i32 %and, 0
  br i1 %needs, label %do.sub, label %skip.sub

do.sub:
  %rt0 = or i8 %t1, 0
  %rt1 = or i8 %t2, 0
  %rt2 = or i8 %t3, 0
  %rt3 = or i8 %t0, 0
  %rt0.z = zext i8 %rt0 to i32
  %sb0 = call zeroext i8 @sbox_lookup(i32 %rt0.z)
  %rt1.z = zext i8 %rt1 to i32
  %sb1 = call zeroext i8 @sbox_lookup(i32 %rt1.z)
  %rt2.z = zext i8 %rt2 to i32
  %sb2 = call zeroext i8 @sbox_lookup(i32 %rt2.z)
  %rt3.z = zext i8 %rt3 to i32
  %sb3 = call zeroext i8 @sbox_lookup(i32 %rt3.z)
  %rci.tr = trunc i32 %rci to i8
  %rci.arg = zext i8 %rci.tr to i32
  %rcv = call zeroext i8 @rcon(i32 %rci.arg)
  %sb0.x = xor i8 %sb0, %rcv
  %rci.plus = add i32 %rci, 1
  br label %after.sub

skip.sub:
  br label %after.sub

after.sub:
  %t0.f = phi i8 [ %sb0.x, %do.sub ], [ %t0, %skip.sub ]
  %t1.f = phi i8 [ %sb1, %do.sub ], [ %t1, %skip.sub ]
  %t2.f = phi i8 [ %sb2, %do.sub ], [ %t2, %skip.sub ]
  %t3.f = phi i8 [ %sb3, %do.sub ], [ %t3, %skip.sub ]
  %rci.next = phi i32 [ %rci.plus, %do.sub ], [ %rci, %skip.sub ]
  %i_m16 = add nsw i32 %i, -16
  %i_m15 = add nsw i32 %i, -15
  %i_m14 = add nsw i32 %i, -14
  %i_m13 = add nsw i32 %i, -13
  %i_m16.z = zext i32 %i_m16 to i64
  %i_m15.z = zext i32 %i_m15 to i64
  %i_m14.z = zext i32 %i_m14 to i64
  %i_m13.z = zext i32 %i_m13 to i64
  %p_m16 = getelementptr inbounds i8, i8* %out_expanded, i64 %i_m16.z
  %p_m15 = getelementptr inbounds i8, i8* %out_expanded, i64 %i_m15.z
  %p_m14 = getelementptr inbounds i8, i8* %out_expanded, i64 %i_m14.z
  %p_m13 = getelementptr inbounds i8, i8* %out_expanded, i64 %i_m13.z
  %b_m16 = load i8, i8* %p_m16, align 1
  %b_m15 = load i8, i8* %p_m15, align 1
  %b_m14 = load i8, i8* %p_m14, align 1
  %b_m13 = load i8, i8* %p_m13, align 1
  %o0 = xor i8 %b_m16, %t0.f
  %o1 = xor i8 %b_m15, %t1.f
  %o2 = xor i8 %b_m14, %t2.f
  %o3 = xor i8 %b_m13, %t3.f
  %i.z = zext i32 %i to i64
  %i1 = add nuw nsw i32 %i, 1
  %i2 = add nuw nsw i32 %i, 2
  %i3 = add nuw nsw i32 %i, 3
  %i1.z = zext i32 %i1 to i64
  %i2.z = zext i32 %i2 to i64
  %i3.z = zext i32 %i3 to i64
  %p_i = getelementptr inbounds i8, i8* %out_expanded, i64 %i.z
  %p_i1 = getelementptr inbounds i8, i8* %out_expanded, i64 %i1.z
  %p_i2 = getelementptr inbounds i8, i8* %out_expanded, i64 %i2.z
  %p_i3 = getelementptr inbounds i8, i8* %out_expanded, i64 %i3.z
  store i8 %o0, i8* %p_i, align 1
  store i8 %o1, i8* %p_i1, align 1
  store i8 %o2, i8* %p_i2, align 1
  store i8 %o3, i8* %p_i3, align 1
  br label %loop.latch

loop.latch:
  %i.next = add nuw nsw i32 %i, 4
  br label %loop.header

exit:
  ret void
}