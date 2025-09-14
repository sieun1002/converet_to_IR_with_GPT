; ModuleID = 'shift_rows'
; LLVM IR for LLVM 14

define void @shift_rows(i8* nocapture %state) {
entry:
  ; Row 1: rotate left by 1 (indices 1,5,9,13)
  %p1  = getelementptr inbounds i8, i8* %state, i64 1
  %p5  = getelementptr inbounds i8, i8* %state, i64 5
  %p9  = getelementptr inbounds i8, i8* %state, i64 9
  %p13 = getelementptr inbounds i8, i8* %state, i64 13
  %b1  = load i8, i8* %p1, align 1
  %b5  = load i8, i8* %p5, align 1
  %b9  = load i8, i8* %p9, align 1
  %b13 = load i8, i8* %p13, align 1
  store i8 %b5,  i8* %p1,  align 1
  store i8 %b9,  i8* %p5,  align 1
  store i8 %b13, i8* %p9,  align 1
  store i8 %b1,  i8* %p13, align 1

  ; Row 2: rotate left by 2 (swap 2<->10, 6<->14)
  %p2  = getelementptr inbounds i8, i8* %state, i64 2
  %p10 = getelementptr inbounds i8, i8* %state, i64 10
  %b2  = load i8, i8* %p2,  align 1
  %b10 = load i8, i8* %p10, align 1
  store i8 %b10, i8* %p2,  align 1
  store i8 %b2,  i8* %p10, align 1

  %p6  = getelementptr inbounds i8, i8* %state, i64 6
  %p14 = getelementptr inbounds i8, i8* %state, i64 14
  %b6  = load i8, i8* %p6,  align 1
  %b14 = load i8, i8* %p14, align 1
  store i8 %b14, i8* %p6,  align 1
  store i8 %b6,  i8* %p14, align 1

  ; Row 3: rotate left by 3 (right by 1) (indices 3,7,11,15)
  %p3  = getelementptr inbounds i8, i8* %state, i64 3
  %p7  = getelementptr inbounds i8, i8* %state, i64 7
  %p11 = getelementptr inbounds i8, i8* %state, i64 11
  %p15 = getelementptr inbounds i8, i8* %state, i64 15
  %b3  = load i8, i8* %p3,  align 1
  %b7  = load i8, i8* %p7,  align 1
  %b11 = load i8, i8* %p11, align 1
  %b15 = load i8, i8* %p15, align 1
  store i8 %b15, i8* %p3,  align 1
  store i8 %b11, i8* %p15, align 1
  store i8 %b7,  i8* %p11, align 1
  store i8 %b3,  i8* %p7,  align 1

  ret void
}