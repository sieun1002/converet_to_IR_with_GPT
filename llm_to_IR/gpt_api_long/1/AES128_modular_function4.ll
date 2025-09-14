; ModuleID = 'add_round_key'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: add_round_key  ; Address: 0x121A
; Intent: XOR 16-byte state with 16-byte round key in place (AES AddRoundKey) (confidence=0.95). Evidence: 16-iteration bytewise XOR loop, store back to first buffer.
; Preconditions: %state and %roundkey each point to at least 16 valid bytes.
; Postconditions: For i=0..15: state[i] = state[i] XOR roundkey[i].

define dso_local void @add_round_key(i8* %state, i8* %roundkey) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; do-while style
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop ]
  %s.ptr = getelementptr inbounds i8, i8* %state, i64 %i
  %r.ptr = getelementptr inbounds i8, i8* %roundkey, i64 %i
  %sv = load i8, i8* %s.ptr, align 1
  %rv = load i8, i8* %r.ptr, align 1
  %x = xor i8 %sv, %rv
  store i8 %x, i8* %s.ptr, align 1
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp ule i64 %i.next, 15
  br i1 %cond, label %loop, label %exit

exit:
  ret void
}