; ModuleID = 'shift_rows'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: shift_rows  ; Address: 0x12CA
; Intent: In-place AES ShiftRows on 16-byte state (confidence=0.98). Evidence: rotations/swaps over indices {1,5,9,13}, {2,6,10,14}, {3,7,11,15}
; Preconditions: %state points to at least 16 bytes
; Postconditions: state rows shifted by {0,1,2,3} bytes left respectively

; Only the needed extern declarations:

define dso_local void @shift_rows(i8* %state) local_unnamed_addr {
entry:
  ; Row 1: rotate left by 1: [1,5,9,13]
  %p1 = getelementptr inbounds i8, i8* %state, i64 1
  %b1 = load i8, i8* %p1, align 1
  %p5 = getelementptr inbounds i8, i8* %state, i64 5
  %b5 = load i8, i8* %p5, align 1
  store i8 %b5, i8* %p1, align 1
  %p9 = getelementptr inbounds i8, i8* %state, i64 9
  %b9 = load i8, i8* %p9, align 1
  store i8 %b9, i8* %p5, align 1
  %p13 = getelementptr inbounds i8, i8* %state, i64 13
  %b13 = load i8, i8* %p13, align 1
  store i8 %b13, i8* %p9, align 1
  store i8 %b1, i8* %p13, align 1

  ; Row 2: rotate left by 2 via swaps: [2]<->[10], [6]<->[14]
  %p2 = getelementptr inbounds i8, i8* %state, i64 2
  %b2 = load i8, i8* %p2, align 1
  %p10 = getelementptr inbounds i8, i8* %state, i64 10
  %b10 = load i8, i8* %p10, align 1
  store i8 %b10, i8* %p2, align 1
  store i8 %b2, i8* %p10, align 1

  %p6 = getelementptr inbounds i8, i8* %state, i64 6
  %b6 = load i8, i8* %p6, align 1
  %p14 = getelementptr inbounds i8, i8* %state, i64 14
  %b14 = load i8, i8* %p14, align 1
  store i8 %b14, i8* %p6, align 1
  store i8 %b6, i8* %p14, align 1

  ; Row 3: rotate left by 3 (right by 1): [3,7,11,15]
  %p3 = getelementptr inbounds i8, i8* %state, i64 3
  %b3 = load i8, i8* %p3, align 1
  %p15 = getelementptr inbounds i8, i8* %state, i64 15
  %b15 = load i8, i8* %p15, align 1
  store i8 %b15, i8* %p3, align 1
  %p11 = getelementptr inbounds i8, i8* %state, i64 11
  %b11 = load i8, i8* %p11, align 1
  store i8 %b11, i8* %p15, align 1
  %p7 = getelementptr inbounds i8, i8* %state, i64 7
  %b7 = load i8, i8* %p7, align 1
  store i8 %b7, i8* %p11, align 1
  store i8 %b3, i8* %p7, align 1

  ret void
}