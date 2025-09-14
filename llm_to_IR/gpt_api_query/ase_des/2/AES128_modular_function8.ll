; ModuleID = 'key_expansion'
source_filename = "key_expansion"

declare i8 @sbox_lookup(i32) local_unnamed_addr
declare i8 @rcon(i32) local_unnamed_addr

define void @key_expansion(i8* noundef %in, i8* noundef %out) local_unnamed_addr {
entry:
  br label %copy.loop

copy.loop:
  %i0 = phi i32 [ 0, %entry ], [ %i0.next, %copy.body ]
  %cmp0 = icmp sle i32 %i0, 15
  br i1 %cmp0, label %copy.body, label %post.copy

copy.body:
  %in.ptr = getelementptr inbounds i8, i8* %in, i32 %i0
  %val = load i8, i8* %in.ptr, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i32 %i0
  store i8 %val, i8* %out.ptr, align 1
  %i0.next = add nsw i32 %i0, 1
  br label %copy.loop

post.copy:
  br label %outer.loop

outer.loop:
  %idx = phi i32 [ 16, %post.copy ], [ %idx.next, %latch ]
  %rc = phi i32 [ 0, %post.copy ], [ %rc.next, %latch ]
  %cmp1 = icmp sle i32 %idx, 175
  br i1 %cmp1, label %loop.body, label %exit

loop.body:
  %m4 = add nsw i32 %idx, -4
  %m3 = add nsw i32 %idx, -3
  %m2 = add nsw i32 %idx, -2
  %m1 = add nsw i32 %idx, -1
  %p_m4 = getelementptr inbounds i8, i8* %out, i32 %m4
  %p_m3 = getelementptr inbounds i8, i8* %out, i32 %m3
  %p_m2 = getelementptr inbounds i8, i8* %out, i32 %m2
  %p_m1 = getelementptr inbounds i8, i8* %out, i32 %m1
  %t0 = load i8, i8* %p_m4, align 1
  %t1 = load i8, i8* %p_m3, align 1
  %t2 = load i8, i8* %p_m2, align 1
  %t3 = load i8, i8* %p_m1, align 1
  %and = and i32 %idx, 15
  %cond = icmp eq i32 %and, 0
  br i1 %cond, label %do.transform, label %after.transform

do.transform:
  %z0 = zext i8 %t1 to i32
  %sb0 = call i8 @sbox_lookup(i32 %z0)
  %z1 = zext i8 %t2 to i32
  %sb1 = call i8 @sbox_lookup(i32 %z1)
  %z2 = zext i8 %t3 to i32
  %sb2 = call i8 @sbox_lookup(i32 %z2)
  %z3 = zext i8 %t0 to i32
  %sb3 = call i8 @sbox_lookup(i32 %z3)
  %rc_old = and i32 %rc, 255
  %r = call i8 @rcon(i32 %rc_old)
  %sb0x = xor i8 %sb0, %r
  %rc_inc = add i32 %rc, 1
  br label %after.transform

after.transform:
  %out_t0 = phi i8 [ %sb0x, %do.transform ], [ %t0, %loop.body ]
  %out_t1 = phi i8 [ %sb1,  %do.transform ], [ %t1, %loop.body ]
  %out_t2 = phi i8 [ %sb2,  %do.transform ], [ %t2, %loop.body ]
  %out_t3 = phi i8 [ %sb3,  %do.transform ], [ %t3, %loop.body ]
  %rc.new  = phi i32 [ %rc_inc, %do.transform ], [ %rc, %loop.body ]

  %m16 = add nsw i32 %idx, -16

  %src0 = getelementptr inbounds i8, i8* %out, i32 %m16
  %v0 = load i8, i8* %src0, align 1
  %dst0 = getelementptr inbounds i8, i8* %out, i32 %idx
  %x0 = xor i8 %v0, %out_t0
  store i8 %x0, i8* %dst0, align 1

  %m16p1 = add nsw i32 %m16, 1
  %src1 = getelementptr inbounds i8, i8* %out, i32 %m16p1
  %v1 = load i8, i8* %src1, align 1
  %idxp1 = add nsw i32 %idx, 1
  %dst1 = getelementptr inbounds i8, i8* %out, i32 %idxp1
  %x1 = xor i8 %v1, %out_t1
  store i8 %x1, i8* %dst1, align 1

  %m16p2 = add nsw i32 %m16, 2
  %src2 = getelementptr inbounds i8, i8* %out, i32 %m16p2
  %v2 = load i8, i8* %src2, align 1
  %idxp2 = add nsw i32 %idx, 2
  %dst2 = getelementptr inbounds i8, i8* %out, i32 %idxp2
  %x2 = xor i8 %v2, %out_t2
  store i8 %x2, i8* %dst2, align 1

  %m16p3 = add nsw i32 %m16, 3
  %src3 = getelementptr inbounds i8, i8* %out, i32 %m16p3
  %v3 = load i8, i8* %src3, align 1
  %idxp3 = add nsw i32 %idx, 3
  %dst3 = getelementptr inbounds i8, i8* %out, i32 %idxp3
  %x3 = xor i8 %v3, %out_t3
  store i8 %x3, i8* %dst3, align 1

  br label %latch

latch:
  %idx.next = add nsw i32 %idx, 4
  %rc.next = %rc.new
  br label %outer.loop

exit:
  ret void
}