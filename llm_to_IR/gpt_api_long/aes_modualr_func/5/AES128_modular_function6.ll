; ModuleID = 'shift_rows'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: shift_rows  ; Address: 0x12CA
; Intent: AES ShiftRows transform on a 16-byte state in column-major order (confidence=0.98). Evidence: rotates indices {1,5,9,13} by 1, swaps {2,10} and {6,14}, rotates {3,7,11,15}.
; Preconditions: %state points to at least 16 bytes, writable.
; Postconditions: In-place AES ShiftRows applied; bytes at indices {1,5,9,13} rotate left by 1, {2,6,10,14} rotate left by 2, {3,7,11,15} rotate left by 3.

define dso_local void @shift_rows(i8* %state) local_unnamed_addr {
entry:
  ; row 1: rotate left by 1 (1 <- 5 <- 9 <- 13 <- 1)
  %p1 = getelementptr inbounds i8, i8* %state, i64 1
  %b1 = load i8, i8* %p1
  %p5 = getelementptr inbounds i8, i8* %state, i64 5
  %b5 = load i8, i8* %p5
  store i8 %b5, i8* %p1
  %p9 = getelementptr inbounds i8, i8* %state, i64 9
  %b9 = load i8, i8* %p9
  store i8 %b9, i8* %p5
  %p13 = getelementptr inbounds i8, i8* %state, i64 13
  %b13 = load i8, i8* %p13
  store i8 %b13, i8* %p9
  store i8 %b1, i8* %p13

  ; row 2: rotate left by 2 (2 <-> 10, 6 <-> 14)
  %p2 = getelementptr inbounds i8, i8* %state, i64 2
  %b2 = load i8, i8* %p2
  %p10 = getelementptr inbounds i8, i8* %state, i64 10
  %b10 = load i8, i8* %p10
  store i8 %b10, i8* %p2
  store i8 %b2, i8* %p10

  %p6 = getelementptr inbounds i8, i8* %state, i64 6
  %b6 = load i8, i8* %p6
  %p14 = getelementptr inbounds i8, i8* %state, i64 14
  %b14 = load i8, i8* %p14
  store i8 %b14, i8* %p6
  store i8 %b6, i8* %p14

  ; row 3: rotate left by 3 (right by 1): 3 <- 15 <- 11 <- 7 <- 3
  %p3 = getelementptr inbounds i8, i8* %state, i64 3
  %b3 = load i8, i8* %p3
  %p15 = getelementptr inbounds i8, i8* %state, i64 15
  %b15 = load i8, i8* %p15
  store i8 %b15, i8* %p3
  %p11 = getelementptr inbounds i8, i8* %state, i64 11
  %b11 = load i8, i8* %p11
  store i8 %b11, i8* %p15
  %p7 = getelementptr inbounds i8, i8* %state, i64 7
  %b7 = load i8, i8* %p7
  store i8 %b7, i8* %p11
  store i8 %b3, i8* %p7

  ret void
}