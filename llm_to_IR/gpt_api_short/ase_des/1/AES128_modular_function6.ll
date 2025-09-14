; ModuleID = 'shift_rows'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: shift_rows ; Address: 0x12CA
; Intent: AES ShiftRows in-place on 16-byte state (confidence=0.99). Evidence: rotates indices {1,5,9,13} by 1; swaps {2,10} and {6,14}; rotates {3,7,11,15} by 3.
; Preconditions: %state points to at least 16 writable bytes.
; Postconditions: state rows shifted left by row index (0..3).

; Only the necessary external declarations:

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local void @shift_rows(i8* noundef nocapture %state) local_unnamed_addr {
entry:
  ; row 1: rotate left by 1 among [1,5,9,13]
  %p1 = getelementptr inbounds i8, i8* %state, i64 1
  %b1 = load i8, i8* %p1, align 1
  %p5 = getelementptr inbounds i8, i8* %state, i64 5
  %v5 = load i8, i8* %p5, align 1
  store i8 %v5, i8* %p1, align 1
  %p9 = getelementptr inbounds i8, i8* %state, i64 9
  %v9 = load i8, i8* %p9, align 1
  store i8 %v9, i8* %p5, align 1
  %p13 = getelementptr inbounds i8, i8* %state, i64 13
  %v13 = load i8, i8* %p13, align 1
  store i8 %v13, i8* %p9, align 1
  store i8 %b1, i8* %p13, align 1

  ; row 2: rotate left by 2 via swaps (2<->10) and (6<->14)
  %p2 = getelementptr inbounds i8, i8* %state, i64 2
  %b2 = load i8, i8* %p2, align 1
  %p10 = getelementptr inbounds i8, i8* %state, i64 10
  %v10 = load i8, i8* %p10, align 1
  store i8 %v10, i8* %p2, align 1
  store i8 %b2, i8* %p10, align 1

  %p6 = getelementptr inbounds i8, i8* %state, i64 6
  %b6 = load i8, i8* %p6, align 1
  %p14 = getelementptr inbounds i8, i8* %state, i64 14
  %v14 = load i8, i8* %p14, align 1
  store i8 %v14, i8* %p6, align 1
  store i8 %b6, i8* %p14, align 1

  ; row 3: rotate left by 3 among [3,7,11,15]
  %p3 = getelementptr inbounds i8, i8* %state, i64 3
  %b3 = load i8, i8* %p3, align 1
  %p15 = getelementptr inbounds i8, i8* %state, i64 15
  %v15 = load i8, i8* %p15, align 1
  store i8 %v15, i8* %p3, align 1
  %p11 = getelementptr inbounds i8, i8* %state, i64 11
  %v11 = load i8, i8* %p11, align 1
  store i8 %v11, i8* %p15, align 1
  %p7 = getelementptr inbounds i8, i8* %state, i64 7
  %v7 = load i8, i8* %p7, align 1
  store i8 %v7, i8* %p11, align 1
  store i8 %b3, i8* %p7, align 1

  ret void
}