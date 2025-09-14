; ModuleID = 'key_expansion'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_expansion ; Address: 0x15A0
; Intent: AES-128 key expansion (key schedule) (confidence=0.98). Evidence: copies 16-byte key, expands to 176 bytes using RotWord/SubWord, Rcon, and XOR with word 4 back.
; Preconditions: src points to at least 16 bytes; dst points to at least 176 bytes.
; Postconditions: dst contains the 176-byte expanded key schedule.

; Only the necessary external declarations:
declare i8 @sbox_lookup(i32)
declare i8 @rcon(i32)

define dso_local void @key_expansion(i8* nocapture readonly %src, i8* nocapture %dst) local_unnamed_addr {
entry:
  br label %copy.cond

copy.cond:                                        ; i in [0..15]
  %i = phi i64 [ 0, %entry ], [ %i.next, %copy.body ]
  %cmp = icmp sle i64 %i, 15
  br i1 %cmp, label %copy.body, label %copy.end

copy.body:
  %src.ptr = getelementptr inbounds i8, i8* %src, i64 %i
  %byte = load i8, i8* %src.ptr, align 1
  %dst.ptr = getelementptr inbounds i8, i8* %dst, i64 %i
  store i8 %byte, i8* %dst.ptr, align 1
  %i.next = add nuw nsw i64 %i, 1
  br label %copy.cond

copy.end:
  br label %loop.cond

loop.cond:                                        ; idx in [16..175] step 4
  %idx = phi i64 [ 16, %copy.end ], [ %idx.next, %loop.latch ]
  %round = phi i32 [ 0, %copy.end ], [ %round.next, %loop.latch ]
  %cmp2 = icmp sle i64 %idx, 175
  br i1 %cmp2, label %loop.body, label %ret

loop.body:
  ; load previous word (w[i-1])
  %m4 = add nsw i64 %idx, -4
  %p0 = getelementptr inbounds i8, i8* %dst, i64 %m4
  %b0 = load i8, i8* %p0, align 1
  %m3 = add nsw i64 %idx, -3
  %p1 = getelementptr inbounds i8, i8* %dst, i64 %m3
  %b1 = load i8, i8* %p1, align 1
  %m2 = add nsw i64 %idx, -2
  %p2 = getelementptr inbounds i8, i8* %dst, i64 %m2
  %b2 = load i8, i8* %p2, align 1
  %m1 = add nsw i64 %idx, -1
  %p3 = getelementptr inbounds i8, i8* %dst, i64 %m1
  %b3 = load i8, i8* %p3, align 1

  ; if ((idx & 0xF) == 0) then RotWord/SubWord and Rcon
  %and = and i64 %idx, 15
  %is0 = icmp eq i64 %and, 0
  br i1 %is0, label %if.true, label %if.false

if.true:
  ; rotate: (b1,b2,b3,b0)
  %t0.rot = %b1
  %t1.rot = %b2
  %t2.rot = %b3
  %t3.rot = %b0
  ; SubWord via S-box
  %t0.z = zext i8 %t0.rot to i32
  %sb0 = call i8 @sbox_lookup(i32 %t0.z)
  %t1.z = zext i8 %t1.rot to i32
  %sb1 = call i8 @sbox_lookup(i32 %t1.z)
  %t2.z = zext i8 %t2.rot to i32
  %sb2 = call i8 @sbox_lookup(i32 %t2.z)
  %t3.z = zext i8 %t3.rot to i32
  %sb3 = call i8 @sbox_lookup(i32 %t3.z)
  ; rcon with previous round counter (low 8 bits), then increment counter
  %round.trunc8 = trunc i32 %round to i8
  %round.z = zext i8 %round.trunc8 to i32
  %rc = call i8 @rcon(i32 %round.z)
  %t0.final = xor i8 %sb0, %rc
  %round.inc = add nuw nsw i32 %round, 1
  br label %if.end

if.false:
  br label %if.end

if.end:
  %t0 = phi i8 [ %t0.final, %if.true ], [ %b0, %if.false ]
  %t1 = phi i8 [ %sb1, %if.true ], [ %b1, %if.false ]
  %t2 = phi i8 [ %sb2, %if.true ], [ %b2, %if.false ]
  %t3 = phi i8 [ %sb3, %if.true ], [ %b3, %if.false ]
  %round.next = phi i32 [ %round.inc, %if.true ], [ %round, %if.false ]

  ; XOR with word 4 back (w[i-4])
  %m16 = add nsw i64 %idx, -16
  %q0 = getelementptr inbounds i8, i8* %dst, i64 %m16
  %w4_0 = load i8, i8* %q0, align 1
  %x0 = xor i8 %w4_0, %t0
  %out0.ptr = getelementptr inbounds i8, i8* %dst, i64 %idx
  store i8 %x0, i8* %out0.ptr, align 1

  %m16p1 = add nsw i64 %m16, 1
  %q1 = getelementptr inbounds i8, i8* %dst, i64 %m16p1
  %w4_1 = load i8, i8* %q1, align 1
  %x1 = xor i8 %w4_1, %t1
  %out1.off = add nsw i64 %idx, 1
  %out1.ptr = getelementptr inbounds i8, i8* %dst, i64 %out1.off
  store i8 %x1, i8* %out1.ptr, align 1

  %m16p2 = add nsw i64 %m16, 2
  %q2 = getelementptr inbounds i8, i8* %dst, i64 %m16p2
  %w4_2 = load i8, i8* %q2, align 1
  %x2 = xor i8 %w4_2, %t2
  %out2.off = add nsw i64 %idx, 2
  %out2.ptr = getelementptr inbounds i8, i8* %dst, i64 %out2.off
  store i8 %x2, i8* %out2.ptr, align 1

  %m16p3 = add nsw i64 %m16, 3
  %q3 = getelementptr inbounds i8, i8* %dst, i64 %m16p3
  %w4_3 = load i8, i8* %q3, align 1
  %x3 = xor i8 %w4_3, %t3
  %out3.off = add nsw i64 %idx, 3
  %out3.ptr = getelementptr inbounds i8, i8* %dst, i64 %out3.off
  store i8 %x3, i8* %out3.ptr, align 1

  br label %loop.latch

loop.latch:
  %idx.next = add nsw i64 %idx, 4
  br label %loop.cond

ret:
  ret void
}