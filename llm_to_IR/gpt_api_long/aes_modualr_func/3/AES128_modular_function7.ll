; ModuleID = 'mix_columns'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: mix_columns  ; Address: 0x13CD
; Intent: AES MixColumns transform in-place on 16-byte state (confidence=0.95). Evidence: 4-column loop with xtime-based GF(2^8) mixing pattern.
; Preconditions: %state points to at least 16 bytes.
; Postconditions: %state is transformed per AES MixColumns.

declare i32 @xtime(i32) local_unnamed_addr

define dso_local void @mix_columns(i8* %state) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, entry ], [ %i.next, %after ]
  %base = mul nuw nsw i32 %i, 4

  %idx0 = zext i32 %base to i64
  %p0 = getelementptr inbounds i8, i8* %state, i64 %idx0
  %a0 = load i8, i8* %p0, align 1

  %base1 = add i32 %base, 1
  %idx1 = zext i32 %base1 to i64
  %p1 = getelementptr inbounds i8, i8* %state, i64 %idx1
  %a1 = load i8, i8* %p1, align 1

  %base2 = add i32 %base, 2
  %idx2 = zext i32 %base2 to i64
  %p2 = getelementptr inbounds i8, i8* %state, i64 %idx2
  %a2 = load i8, i8* %p2, align 1

  %base3 = add i32 %base, 3
  %idx3 = zext i32 %base3 to i64
  %p3 = getelementptr inbounds i8, i8* %state, i64 %idx3
  %a3 = load i8, i8* %p3, align 1

  %t01 = xor i8 %a0, %a1
  %t012 = xor i8 %t01, %a2
  %t = xor i8 %t012, %a3

  ; out0 = a0 ^ t ^ xtime(a0 ^ a1)
  %x0in8 = xor i8 %a0, %a1
  %x0in32 = zext i8 %x0in8 to i32
  %x0r = call i32 @xtime(i32 %x0in32)
  %x0b = trunc i32 %x0r to i8
  %r0t = xor i8 %a0, %t
  %r0 = xor i8 %r0t, %x0b
  store i8 %r0, i8* %p0, align 1

  ; out1 = a1 ^ t ^ xtime(a1 ^ a2)
  %x1in8 = xor i8 %a1, %a2
  %x1in32 = zext i8 %x1in8 to i32
  %x1r = call i32 @xtime(i32 %x1in32)
  %x1b = trunc i32 %x1r to i8
  %r1t = xor i8 %a1, %t
  %r1 = xor i8 %r1t, %x1b
  store i8 %r1, i8* %p1, align 1

  ; out2 = a2 ^ t ^ xtime(a2 ^ a3)
  %x2in8 = xor i8 %a2, %a3
  %x2in32 = zext i8 %x2in8 to i32
  %x2r = call i32 @xtime(i32 %x2in32)
  %x2b = trunc i32 %x2r to i8
  %r2t = xor i8 %a2, %t
  %r2 = xor i8 %r2t, %x2b
  store i8 %r2, i8* %p2, align 1

  ; out3 = a3 ^ t ^ xtime(a3 ^ a0)
  %x3in8 = xor i8 %a3, %a0
  %x3in32 = zext i8 %x3in8 to i32
  %x3r = call i32 @xtime(i32 %x3in32)
  %x3b = trunc i32 %x3r to i8
  %r3t = xor i8 %a3, %t
  %r3 = xor i8 %r3t, %x3b
  store i8 %r3, i8* %p3, align 1

  br label %after

after:
  %i.next = add nuw nsw i32 %i, 1
  %cmp = icmp sle i32 %i.next, 3
  br i1 %cmp, label %loop, label %exit

exit:
  ret void
}