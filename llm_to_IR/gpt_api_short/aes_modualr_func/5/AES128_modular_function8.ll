; ModuleID = 'key_expansion'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: key_expansion ; Address: 0x15A0
; Intent: AES-128 key schedule expansion (confidence=0.95). Evidence: 16-byte copy, RotWord+SubWord+Rcon on 16-byte boundaries.
; Preconditions: src has at least 16 bytes, dst has at least 176 bytes
; Postconditions: dst contains 176-byte expanded key

; Only the necessary external declarations:
declare zeroext i8 @sbox_lookup(i32)
declare zeroext i8 @rcon(i32)

define dso_local void @key_expansion(i8* %src, i8* %dst) local_unnamed_addr {
entry:
  br label %copy.cond

copy.cond:                                           ; copy initial 16 bytes
  %ci = phi i32 [ 0, %entry ], [ %ci.next, %copy.body ]
  %cmp.ci = icmp sle i32 %ci, 15
  br i1 %cmp.ci, label %copy.body, label %after.copy

copy.body:
  %ci64 = sext i32 %ci to i64
  %src.p = getelementptr inbounds i8, i8* %src, i64 %ci64
  %v = load i8, i8* %src.p, align 1
  %dst.p = getelementptr inbounds i8, i8* %dst, i64 %ci64
  store i8 %v, i8* %dst.p, align 1
  %ci.next = add i32 %ci, 1
  br label %copy.cond

after.copy:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 16, %after.copy ], [ %i.next, %loop.latch ]
  %cnt = phi i32 [ 0, %after.copy ], [ %cnt.next, %loop.latch ]
  %cont = icmp sle i32 %i, 175
  br i1 %cont, label %loop.body, label %exit

loop.body:
  %i64 = sext i32 %i to i64
  %idx_i_m4 = add i64 %i64, -4
  %idx_i_m3 = add i64 %i64, -3
  %idx_i_m2 = add i64 %i64, -2
  %idx_i_m1 = add i64 %i64, -1
  %p_i_m4 = getelementptr inbounds i8, i8* %dst, i64 %idx_i_m4
  %p_i_m3 = getelementptr inbounds i8, i8* %dst, i64 %idx_i_m3
  %p_i_m2 = getelementptr inbounds i8, i8* %dst, i64 %idx_i_m2
  %p_i_m1 = getelementptr inbounds i8, i8* %dst, i64 %idx_i_m1
  %t0 = load i8, i8* %p_i_m4, align 1
  %t1 = load i8, i8* %p_i_m3, align 1
  %t2 = load i8, i8* %p_i_m2, align 1
  %t3 = load i8, i8* %p_i_m1, align 1
  %i_and_15 = and i32 %i, 15
  %is16 = icmp eq i32 %i_and_15, 0
  br i1 %is16, label %transform, label %noTransform

transform:                                           ; RotWord + SubWord + Rcon
  %rot0 = %t1
  %rot1 = %t2
  %rot2 = %t3
  %rot3 = %t0
  %rot0.z = zext i8 %rot0 to i32
  %sb0 = call zeroext i8 @sbox_lookup(i32 %rot0.z)
  %rot1.z = zext i8 %rot1 to i32
  %sb1 = call zeroext i8 @sbox_lookup(i32 %rot1.z)
  %rot2.z = zext i8 %rot2 to i32
  %sb2 = call zeroext i8 @sbox_lookup(i32 %rot2.z)
  %rot3.z = zext i8 %rot3 to i32
  %sb3 = call zeroext i8 @sbox_lookup(i32 %rot3.z)
  %cnt.old8 = trunc i32 %cnt to i8
  %cnt.old32 = zext i8 %cnt.old8 to i32
  %rc = call zeroext i8 @rcon(i32 %cnt.old32)
  %t0.x = xor i8 %sb0, %rc
  %cnt.inc = add i32 %cnt, 1
  br label %afterTransform

noTransform:
  %t0.keep = %t0
  %t1.keep = %t1
  %t2.keep = %t2
  %t3.keep = %t3
  br label %afterTransform

afterTransform:
  %u0 = phi i8 [ %t0.x, %transform ], [ %t0.keep, %noTransform ]
  %u1 = phi i8 [ %sb1, %transform ], [ %t1.keep, %noTransform ]
  %u2 = phi i8 [ %sb2, %transform ], [ %t2.keep, %noTransform ]
  %u3 = phi i8 [ %sb3, %transform ], [ %t3.keep, %noTransform ]
  %cnt.sel = phi i32 [ %cnt.inc, %transform ], [ %cnt, %noTransform ]

  %idx_i_m16 = add i64 %i64, -16
  %p_i_m16 = getelementptr inbounds i8, i8* %dst, i64 %idx_i_m16
  %p_i_m15 = getelementptr inbounds i8, i8* %dst, i64 (add i64 %idx_i_m16, 1)
  %p_i_m14 = getelementptr inbounds i8, i8* %dst, i64 (add i64 %idx_i_m16, 2)
  %p_i_m13 = getelementptr inbounds i8, i8* %dst, i64 (add i64 %idx_i_m16, 3)
  %b0 = load i8, i8* %p_i_m16, align 1
  %b1 = load i8, i8* %p_i_m15, align 1
  %b2 = load i8, i8* %p_i_m14, align 1
  %b3 = load i8, i8* %p_i_m13, align 1

  %x0 = xor i8 %b0, %u0
  %x1 = xor i8 %b1, %u1
  %x2 = xor i8 %b2, %u2
  %x3 = xor i8 %b3, %u3

  %p_i = getelementptr inbounds i8, i8* %dst, i64 %i64
  %p_i1 = getelementptr inbounds i8, i8* %dst, i64 (add i64 %i64, 1)
  %p_i2 = getelementptr inbounds i8, i8* %dst, i64 (add i64 %i64, 2)
  %p_i3 = getelementptr inbounds i8, i8* %dst, i64 (add i64 %i64, 3)
  store i8 %x0, i8* %p_i, align 1
  store i8 %x1, i8* %p_i1, align 1
  store i8 %x2, i8* %p_i2, align 1
  store i8 %x3, i8* %p_i3, align 1

  br label %loop.latch

loop.latch:
  %i.next = add i32 %i, 4
  %cnt.next = %cnt.sel
  br label %loop.cond

exit:
  ret void
}