; ModuleID = 'shift_rows'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: shift_rows ; Address: 0x12CA
; Intent: AES ShiftRows in-place on 16-byte state (confidence=1.00). Evidence: rotates rows [1,5,9,13], [2,6,10,14], [3,7,11,15]
; Preconditions: state points to at least 16 writable bytes
; Postconditions: state rows rotated as per AES ShiftRows

; Only the necessary external declarations:

define dso_local void @shift_rows(i8* %state) local_unnamed_addr {
entry:
  ; Row 1: [1,5,9,13] <- left rotate by 1
  %p1 = getelementptr inbounds i8, i8* %state, i64 1
  %v1 = load i8, i8* %p1, align 1
  %p5 = getelementptr inbounds i8, i8* %state, i64 5
  %a5 = load i8, i8* %p5, align 1
  store i8 %a5, i8* %p1, align 1
  %p9 = getelementptr inbounds i8, i8* %state, i64 9
  %a9 = load i8, i8* %p9, align 1
  store i8 %a9, i8* %p5, align 1
  %p13 = getelementptr inbounds i8, i8* %state, i64 13
  %a13 = load i8, i8* %p13, align 1
  store i8 %a13, i8* %p9, align 1
  store i8 %v1, i8* %p13, align 1

  ; Row 2: [2,6,10,14] <- left rotate by 2 (swap 2<->10, 6<->14)
  %p2 = getelementptr inbounds i8, i8* %state, i64 2
  %v2 = load i8, i8* %p2, align 1
  %p10 = getelementptr inbounds i8, i8* %state, i64 10
  %a10 = load i8, i8* %p10, align 1
  store i8 %a10, i8* %p2, align 1
  store i8 %v2, i8* %p10, align 1

  %p6 = getelementptr inbounds i8, i8* %state, i64 6
  %v6 = load i8, i8* %p6, align 1
  %p14 = getelementptr inbounds i8, i8* %state, i64 14
  %a14 = load i8, i8* %p14, align 1
  store i8 %a14, i8* %p6, align 1
  store i8 %v6, i8* %p14, align 1

  ; Row 3: [3,7,11,15] <- left rotate by 3
  %p3 = getelementptr inbounds i8, i8* %state, i64 3
  %v3 = load i8, i8* %p3, align 1
  %p15 = getelementptr inbounds i8, i8* %state, i64 15
  %a15 = load i8, i8* %p15, align 1
  store i8 %a15, i8* %p3, align 1
  %p11 = getelementptr inbounds i8, i8* %state, i64 11
  %a11 = load i8, i8* %p11, align 1
  store i8 %a11, i8* %p15, align 1
  %p7 = getelementptr inbounds i8, i8* %state, i64 7
  %a7 = load i8, i8* %p7, align 1
  store i8 %a7, i8* %p11, align 1
  store i8 %v3, i8* %p7, align 1

  ret void
}