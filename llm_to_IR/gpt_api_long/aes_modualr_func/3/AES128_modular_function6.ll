; ModuleID = 'shift_rows'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: shift_rows  ; Address: 0x12CA
; Intent: AES ShiftRows in-place on 16-byte state (confidence=0.95). Evidence: cyclic moves of indices {1,5,9,13}, pairwise swaps {2,10},{6,14}, rotation of {3,7,11,15}.
; Preconditions: %state points to at least 16 bytes of writable memory.
; Postconditions: Row-wise rotations applied: row1<<1, row2<<2, row3<<3 (row0 unchanged).

define dso_local void @shift_rows(i8* %state) local_unnamed_addr {
entry:
  ; Precompute element pointers
  %p1 = getelementptr inbounds i8, i8* %state, i64 1
  %p2 = getelementptr inbounds i8, i8* %state, i64 2
  %p3 = getelementptr inbounds i8, i8* %state, i64 3
  %p5 = getelementptr inbounds i8, i8* %state, i64 5
  %p6 = getelementptr inbounds i8, i8* %state, i64 6
  %p7 = getelementptr inbounds i8, i8* %state, i64 7
  %p9 = getelementptr inbounds i8, i8* %state, i64 9
  %p10 = getelementptr inbounds i8, i8* %state, i64 10
  %p11 = getelementptr inbounds i8, i8* %state, i64 11
  %p13 = getelementptr inbounds i8, i8* %state, i64 13
  %p14 = getelementptr inbounds i8, i8* %state, i64 14
  %p15 = getelementptr inbounds i8, i8* %state, i64 15

  ; Row 1: rotate left by 1 (indices 1,5,9,13)
  %t1 = load i8, i8* %p1, align 1
  %v5 = load i8, i8* %p5, align 1
  store i8 %v5, i8* %p1, align 1
  %v9 = load i8, i8* %p9, align 1
  store i8 %v9, i8* %p5, align 1
  %v13 = load i8, i8* %p13, align 1
  store i8 %v13, i8* %p9, align 1
  store i8 %t1, i8* %p13, align 1

  ; Row 2: rotate left by 2 via swaps (indices 2,6,10,14)
  %t2 = load i8, i8* %p2, align 1
  %v10 = load i8, i8* %p10, align 1
  store i8 %v10, i8* %p2, align 1
  store i8 %t2, i8* %p10, align 1

  %t6 = load i8, i8* %p6, align 1
  %v14 = load i8, i8* %p14, align 1
  store i8 %v14, i8* %p6, align 1
  store i8 %t6, i8* %p14, align 1

  ; Row 3: rotate left by 3 (right by 1) (indices 3,7,11,15)
  %t3 = load i8, i8* %p3, align 1
  %v15 = load i8, i8* %p15, align 1
  store i8 %v15, i8* %p3, align 1
  %v11 = load i8, i8* %p11, align 1
  store i8 %v11, i8* %p15, align 1
  %v7 = load i8, i8* %p7, align 1
  store i8 %v7, i8* %p11, align 1
  store i8 %t3, i8* %p7, align 1

  ret void
}