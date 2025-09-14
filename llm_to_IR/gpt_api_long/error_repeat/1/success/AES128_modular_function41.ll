; ModuleID = 'add_round_key'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: add_round_key  ; Address: 0x121A
; Intent: XOR 16-byte state with 16-byte round key in-place (AES AddRoundKey) (confidence=0.95). Evidence: loop 0..15, byte-wise xor from two buffers, store back to first.
; Preconditions: %state and %roundkey each point to at least 16 valid bytes.
; Postconditions: bytes state[i] := state[i] XOR roundkey[i] for i in [0,15].

define dso_local void @add_round_key(i8* %state, i8* %roundkey) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx = zext i32 %i to i64
  %p_state = getelementptr inbounds i8, i8* %state, i64 %idx
  %v_state = load i8, i8* %p_state, align 1
  %p_key = getelementptr inbounds i8, i8* %roundkey, i64 %idx
  %v_key = load i8, i8* %p_key, align 1
  %x = xor i8 %v_state, %v_key
  store i8 %x, i8* %p_state, align 1
  %inc = add nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}