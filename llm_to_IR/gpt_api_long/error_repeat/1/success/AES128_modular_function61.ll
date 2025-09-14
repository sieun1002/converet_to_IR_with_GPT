; ModuleID = 'shift_rows'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: shift_rows  ; Address: 0x12CA
; Intent: In-place AES ShiftRows on a 16-byte state (confidence=0.98). Evidence: rotations of indices {1,5,9,13}, pairwise swap of {2,10},{6,14}, right-rotate of {3,7,11,15}.
; Preconditions: %state points to at least 16 bytes (AES state).
; Postconditions: Rows shifted: r1<<1, r2<<2, r3<<3 (r0 unchanged).

define dso_local void @shift_rows(i8* %state) local_unnamed_addr {
entry:
  ; Row 1: positions 1,5,9,13 rotate left by 1
  %p1 = getelementptr inbounds i8, i8* %state, i64 1
  %t1 = load i8, i8* %p1, align 1
  %p5 = getelementptr inbounds i8, i8* %state, i64 5
  %b5 = load i8, i8* %p5, align 1
  store i8 %b5, i8* %p1, align 1
  %p9 = getelementptr inbounds i8, i8* %state, i64 9
  %b9 = load i8, i8* %p9, align 1
  store i8 %b9, i8* %p5, align 1
  %p13 = getelementptr inbounds i8, i8* %state, i64 13
  %b13 = load i8, i8* %p13, align 1
  store i8 %b13, i8* %p9, align 1
  store i8 %t1, i8* %p13, align 1

  ; Row 2: positions 2,6,10,14 rotate left by 2 (swap 2<->10 and 6<->14)
  %p2 = getelementptr inbounds i8, i8* %state, i64 2
  %t2 = load i8, i8* %p2, align 1
  %p10 = getelementptr inbounds i8, i8* %state, i64 10
  %b10 = load i8, i8* %p10, align 1
  store i8 %b10, i8* %p2, align 1
  store i8 %t2, i8* %p10, align 1

  %p6 = getelementptr inbounds i8, i8* %state, i64 6
  %t3 = load i8, i8* %p6, align 1
  %p14 = getelementptr inbounds i8, i8* %state, i64 14
  %b14 = load i8, i8* %p14, align 1
  store i8 %b14, i8* %p6, align 1
  store i8 %t3, i8* %p14, align 1

  ; Row 3: positions 3,7,11,15 rotate right by 1 (left by 3)
  %p3 = getelementptr inbounds i8, i8* %state, i64 3
  %t4 = load i8, i8* %p3, align 1
  %p15 = getelementptr inbounds i8, i8* %state, i64 15
  %b15 = load i8, i8* %p15, align 1
  store i8 %b15, i8* %p3, align 1
  %p11 = getelementptr inbounds i8, i8* %state, i64 11
  %b11 = load i8, i8* %p11, align 1
  store i8 %b11, i8* %p15, align 1
  %p7 = getelementptr inbounds i8, i8* %state, i64 7
  %b7 = load i8, i8* %p7, align 1
  store i8 %b7, i8* %p11, align 1
  store i8 %t4, i8* %p7, align 1

  ret void
}