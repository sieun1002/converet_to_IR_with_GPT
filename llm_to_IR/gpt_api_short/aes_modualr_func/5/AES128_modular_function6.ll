; ModuleID = 'shift_rows'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: shift_rows ; Address: 0x12CA
; Intent: AES ShiftRows in-place on 16-byte state (confidence=1.00). Evidence: rotates of indices {1,5,9,13}, swaps {2,10},{6,14}, rotates {3,7,11,15}
; Preconditions: state points to at least 16 bytes
; Postconditions: state rows shifted: row0 unchanged; row1<<1; row2<<2; row3<<3

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local void @shift_rows(i8* %state) local_unnamed_addr {
entry:
  ; Row 1: indices 1,5,9,13 rotate left by 1
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

  ; Row 2: indices 2,6,10,14 rotate left by 2 (swap 2<->10)
  %p2 = getelementptr inbounds i8, i8* %state, i64 2
  %t2 = load i8, i8* %p2, align 1
  %p10 = getelementptr inbounds i8, i8* %state, i64 10
  %b10 = load i8, i8* %p10, align 1
  store i8 %b10, i8* %p2, align 1
  store i8 %t2, i8* %p10, align 1

  ; Row 2 continued: swap 6<->14
  %p6 = getelementptr inbounds i8, i8* %state, i64 6
  %t6 = load i8, i8* %p6, align 1
  %p14 = getelementptr inbounds i8, i8* %state, i64 14
  %b14 = load i8, i8* %p14, align 1
  store i8 %b14, i8* %p6, align 1
  store i8 %t6, i8* %p14, align 1

  ; Row 3: indices 3,7,11,15 rotate left by 3
  %p3 = getelementptr inbounds i8, i8* %state, i64 3
  %t3 = load i8, i8* %p3, align 1
  %p15 = getelementptr inbounds i8, i8* %state, i64 15
  %b15 = load i8, i8* %p15, align 1
  store i8 %b15, i8* %p3, align 1
  %p11 = getelementptr inbounds i8, i8* %state, i64 11
  %b11 = load i8, i8* %p11, align 1
  store i8 %b11, i8* %p15, align 1
  %p7 = getelementptr inbounds i8, i8* %state, i64 7
  %b7 = load i8, i8* %p7, align 1
  store i8 %b7, i8* %p11, align 1
  store i8 %t3, i8* %p7, align 1

  ret void
}