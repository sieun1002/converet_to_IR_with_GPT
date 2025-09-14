; ModuleID = 'add_round_key'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: add_round_key  ; Address: 0x121A
; Intent: XOR 16-byte state with 16-byte round key (AES AddRoundKey) (confidence=0.95). Evidence: name; 16-iteration bytewise XOR into first pointer
; Preconditions: %state and %round_key each point to at least 16 accessible bytes
; Postconditions: For i=0..15: state[i] = state[i] XOR round_key[i]

; Only the needed extern declarations:
; (none)

define dso_local void @add_round_key(i8* %state, i8* %round_key) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:                                         ; preds = %loop.body, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                         ; preds = %loop.cond
  %idx = sext i32 %i to i64
  %sptr = getelementptr inbounds i8, i8* %state, i64 %idx
  %b_state = load i8, i8* %sptr, align 1
  %kptr = getelementptr inbounds i8, i8* %round_key, i64 %idx
  %b_key = load i8, i8* %kptr, align 1
  %x = xor i8 %b_state, %b_key
  store i8 %x, i8* %sptr, align 1
  %inc = add nsw i32 %i, 1
  br label %loop.cond

exit:                                              ; preds = %loop.cond
  ret void
}