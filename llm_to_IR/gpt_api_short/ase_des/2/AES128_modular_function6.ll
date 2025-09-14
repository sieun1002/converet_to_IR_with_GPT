; ModuleID = 'shift_rows'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: shift_rows ; Address: 0x12CA
; Intent: AES ShiftRows on 16-byte state (in-place) (confidence=0.98). Evidence: rotations of indices {1,5,9,13}, {2,6,10,14}
; Preconditions: state points to at least 16 writable bytes
; Postconditions: state bytes rearranged per AES ShiftRows

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @shift_rows(i8* nocapture %state) local_unnamed_addr {
entry:
  ; Row 1: indices 1,5,9,13 rotate left by 1
  %p1 = getelementptr inbounds i8, i8* %state, i64 1
  %t1 = load i8, i8* %p1, align 1
  %p5 = getelementptr inbounds i8, i8* %state, i64 5
  %v5 = load i8, i8* %p5, align 1
  store i8 %v5, i8* %p1, align 1
  %p9 = getelementptr inbounds i8, i8* %state, i64 9
  %v9 = load i8, i8* %p9, align 1
  store i8 %v9, i8* %p5, align 1
  %p13 = getelementptr inbounds i8, i8* %state, i64 13
  %v13 = load i8, i8* %p13, align 1
  store i8 %v13, i8* %p9, align 1
  store i8 %t1, i8* %p13, align 1

  ; Row 2: indices 2,6,10,14 rotate left by 2 (two swaps)
  %p2 = getelementptr inbounds i8, i8* %state, i64 2
  %t2 = load i8, i8* %p2, align 1
  %p10 = getelementptr inbounds i8, i8* %state, i64 10
  %v10 = load i8, i8* %p10, align 1
  store i8 %v10, i8* %p2, align 1
  store i8 %t2, i8* %p10, align 1

  %p6 = getelementptr inbounds i8, i8* %state, i64 6
  %t6 = load i8, i8* %p6, align 1
  %p14 = getelementptr inbounds i8, i8* %state, i64 14
  %v14 = load i8, i8* %p14, align 1
  store i8 %v14, i8* %p6, align 1
  store i8 %t6, i8* %p14, align 1

  ; Row 3: indices 3,7,11,15 rotate left by 3
  %p3 = getelementptr inbounds i8, i8* %state, i64 3
  %t3 = load i8, i8* %p3, align 1
  %p15 = getelementptr inbounds i8, i8* %state, i64 15
  %v15 = load i8, i8* %p15, align 1
  store i8 %v15, i8* %p3, align 1
  %p11 = getelementptr inbounds i8, i8* %state, i64 11
  %v11 = load i8, i8* %p11, align 1
  store i8 %v11, i8* %p15, align 1
  %p7 = getelementptr inbounds i8, i8* %state, i64 7
  %v7 = load i8, i8* %p7, align 1
  store i8 %v7, i8* %p11, align 1
  store i8 %t3, i8* %p7, align 1

  ret void
}