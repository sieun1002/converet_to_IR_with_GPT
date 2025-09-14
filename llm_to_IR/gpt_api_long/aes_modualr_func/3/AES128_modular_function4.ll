; ModuleID = 'add_round_key'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: add_round_key  ; Address: 0x121A
; Intent: XOR 16-byte state with 16-byte round key (AES AddRoundKey) (confidence=0.95). Evidence: 16-iteration bytewise XOR loop, in-place store to first buffer.
; Preconditions: %state and %roundkey point to at least 16 accessible bytes; may alias.
; Postconditions: For i in [0,15], state[i] := state[i] XOR roundkey[i].

define dso_local void @add_round_key(i8* %state, i8* %roundkey) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:                                        ; preds = %entry, %loop.body
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.cond
  %idx64 = sext i32 %i to i64
  %p_state_i = getelementptr inbounds i8, i8* %state, i64 %idx64
  %p_rk_i = getelementptr inbounds i8, i8* %roundkey, i64 %idx64
  %s = load i8, i8* %p_state_i, align 1
  %k = load i8, i8* %p_rk_i, align 1
  %x = xor i8 %s, %k
  store i8 %x, i8* %p_state_i, align 1
  %i.next = add nsw i32 %i, 1
  br label %loop.cond

exit:                                             ; preds = %loop.cond
  ret void
}