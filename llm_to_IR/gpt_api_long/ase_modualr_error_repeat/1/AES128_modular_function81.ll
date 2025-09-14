; ModuleID = 'key_expansion'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_expansion  ; Address: 0x15A0
; Intent: AES-128 key expansion (confidence=0.95). Evidence: copies 16-byte key; uses S-box and Rcon with 176-byte schedule.
; Preconditions: %key has at least 16 bytes; %out has at least 176 bytes.
; Postconditions: Writes 176-byte expanded key to %out (first 16 bytes copied from %key).

declare zeroext i8 @sbox_lookup(i32) local_unnamed_addr
declare zeroext i8 @rcon(i32) local_unnamed_addr

define dso_local void @key_expansion(i8* %key, i8* %out) local_unnamed_addr {
entry:
  br label %copy.loop

copy.loop:
  %i.c = phi i32 [ 0, %entry ], [ %i.c.next, %copy.body ]
  %cmp.c = icmp sle i32 %i.c, 15
  br i1 %cmp.c, label %copy.body, label %after.copy

copy.body:
  %i.c.i64 = sext i32 %i.c to i64
  %src.ptr = getelementptr inbounds i8, i8* %key, i64 %i.c.i64
  %dst.ptr = getelementptr inbounds i8, i8* %out, i64 %i.c.i64
  %b = load i8, i8* %src.ptr, align 1
  store i8 %b, i8* %dst.ptr, align 1
  %i.c.next = add i32 %i.c, 1
  br label %copy.loop

after.copy:
  br label %loop.header

loop.header:
  %i = phi i32 [ 16, %after.copy ], [ %i.next, %loop.latch ]
  %rc = phi i32 [ 0, %after.copy ], [ %rc.next, %loop.latch ]
  %cond = icmp sle i32 %i, 175
  br i1 %cond, label %loop.body, label %ret

loop.body:
  %i.i64 = sext i32 %i to i64
  %m4 = add i64 %i.i64, -4
  %p0.ptr = getelementptr inbounds i8, i8* %out, i64 %m4
  %b0 = load i8, i8* %p0.ptr, align 1
  %m3 = add i64 %i.i64, -3
  %p1.ptr = getelementptr inbounds i8, i8* %out, i64 %m3
  %b1 = load i8, i8* %p1.ptr, align 1
  %m2 = add i64 %i.i64, -2
  %p2.ptr = getelementptr inbounds i8, i8* %out, i64 %m2
  %b2 = load i8, i8* %p2.ptr, align 1
  %m1 = add i64 %i.i64, -1
  %p3.ptr = getelementptr inbounds i8, i8* %out, i64 %m1
  %b3 = load i8, i8* %p3.ptr, align 1
  %and = and i32 %i, 15
  %is.special = icmp eq i32 %and, 0
  br i1 %is.special, label %special, label %no.special

special:
  %t0 = add i8 %b1, 0
  %t1 = add i8 %b2, 0
  %t2 = add i8 %b3, 0
  %t3 = add i8 %b0, 0
  %t0.z = zext i8 %t0 to i32
  %s0 = call zeroext i8 @sbox_lookup(i32 %t0.z)
  %t1.z = zext i8 %t1 to i32
  %s1 = call zeroext i8 @sbox_lookup(i32 %t1.z)
  %t2.z = zext i8 %t2 to i32
  %s2 = call zeroext i8 @sbox_lookup(i32 %t2.z)
  %t3.z = zext i8 %t3 to i32
  %s3 = call zeroext i8 @sbox_lookup(i32 %t3.z)
  %rc.tr = trunc i32 %rc to i8
  %rc.arg = zext i8 %rc.tr to i32
  %rconb = call zeroext i8 @rcon(i32 %rc.arg)
  %s0.x = xor i8 %s0, %rconb
  br label %after.special

no.special:
  br label %after.special

after.special:
  %p0 = phi i8 [ %s0.x, %special ], [ %b0, %no.special ]
  %p1 = phi i8 [ %s1,   %special ], [ %b1, %no.special ]
  %p2 = phi i8 [ %s2,   %special ], [ %b2, %no.special ]
  %p3 = phi i8 [ %s3,   %special ], [ %b3, %no.special ]
  %rc.inc = add i32 %rc, 1
  %rc.out = phi i32 [ %rc.inc, %special ], [ %rc, %no.special ]
  %i.sub16 = add i32 %i, -16
  %i.sub16.i64 = sext i32 %i.sub16 to i64
  %prev0.ptr = getelementptr inbounds i8, i8* %out, i64 %i.sub16.i64
  %prev0 = load i8, i8* %prev0.ptr, align 1
  %new0 = xor i8 %prev0, %p0
  %cur0.ptr = getelementptr inbounds i8, i8* %out, i64 %i.i64
  store i8 %new0, i8* %cur0.ptr, align 1
  %off1 = add i64 %i.sub16.i64, 1
  %prev1.ptr = getelementptr inbounds i8, i8* %out, i64 %off1
  %prev1 = load i8, i8* %prev1.ptr, align 1
  %new1 = xor i8 %prev1, %p1
  %cur1.off = add i64 %i.i64, 1
  %cur1.ptr = getelementptr inbounds i8, i8* %out, i64 %cur1.off
  store i8 %new1, i8* %cur1.ptr, align 1
  %off2 = add i64 %i.sub16.i64, 2
  %prev2.ptr = getelementptr inbounds i8, i8* %out, i64 %off2
  %prev2 = load i8, i8* %prev2.ptr, align 1
  %new2 = xor i8 %prev2, %p2
  %cur2.off = add i64 %i.i64, 2
  %cur2.ptr = getelementptr inbounds i8, i8* %out, i64 %cur2.off
  store i8 %new2, i8* %cur2.ptr, align 1
  %off3 = add i64 %i.sub16.i64, 3
  %prev3.ptr = getelementptr inbounds i8, i8* %out, i64 %off3
  %prev3 = load i8, i8* %prev3.ptr, align 1
  %new3 = xor i8 %prev3, %p3
  %cur3.off = add i64 %i.i64, 3
  %cur3.ptr = getelementptr inbounds i8, i8* %out, i64 %cur3.off
  store i8 %new3, i8* %cur3.ptr, align 1
  br label %loop.latch

loop.latch:
  %i.next = add i32 %i, 4
  %rc.next = %rc.out
  br label %loop.header

ret:
  ret void
}