; ModuleID = 'add_round_key'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: add_round_key  ; Address: 0x121a
; Intent: XOR 16-byte state with 16-byte round key in place (AES AddRoundKey) (confidence=0.95). Evidence: 16-iteration bytewise XOR loop; writes back to first buffer
; Preconditions: %state and %rk each reference at least 16 bytes.
; Postconditions: For i in [0,15], state[i] = state[i] XOR rk[i].

; Only the needed extern declarations:
; (none)

define dso_local void @add_round_key(i8* %state, i8* %rk) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %idx = zext i32 %i to i64
  %ps = getelementptr inbounds i8, i8* %state, i64 %idx
  %pk = getelementptr inbounds i8, i8* %rk, i64 %idx
  %bs = load i8, i8* %ps, align 1
  %bk = load i8, i8* %pk, align 1
  %x = xor i8 %bs, %bk
  store i8 %x, i8* %ps, align 1
  %i.next = add nuw nsw i32 %i, 1
  br label %loop.cond

exit:
  ret void
}