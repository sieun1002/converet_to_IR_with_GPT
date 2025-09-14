; ModuleID = 'add_round_key'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: add_round_key ; Address: 0x121A
; Intent: In-place XOR of 16-byte buffer with another (AES AddRoundKey) (confidence=0.98). Evidence: loop i=0..15, byte-wise XOR from src into dst
; Preconditions: dst and src each valid for at least 16 bytes
; Postconditions: for i in [0,15], dst[i] = dst[i] XOR src[i]

; Only the necessary external declarations:

define dso_local void @add_round_key(i8* %dst, i8* %src) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop ]
  %cmp = icmp sle i64 %i, 15
  br i1 %cmp, label %body, label %done

body:
  %p1 = getelementptr inbounds i8, i8* %dst, i64 %i
  %v1 = load i8, i8* %p1, align 1
  %p2 = getelementptr inbounds i8, i8* %src, i64 %i
  %v2 = load i8, i8* %p2, align 1
  %xor = xor i8 %v1, %v2
  store i8 %xor, i8* %p1, align 1
  %i.next = add i64 %i, 1
  br label %loop

done:
  ret void
}