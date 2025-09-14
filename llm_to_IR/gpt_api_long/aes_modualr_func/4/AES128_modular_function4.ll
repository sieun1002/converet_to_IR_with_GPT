; ModuleID = 'add_round_key'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: add_round_key  ; Address: 0x121A
; Intent: XOR 16-byte state buffer with round key in place (AES addRoundKey) (confidence=0.95). Evidence: 16-iteration byte-wise XOR loop; writes back to first buffer.
; Preconditions: %state and %round_key point to at least 16 readable bytes; %state is writable.
; Postconditions: For i in [0,15], %state[i] becomes (%state[i] XOR %round_key[i]).

define dso_local void @add_round_key(i8* %state, i8* %round_key) local_unnamed_addr {
entry:
  br label %for

for:                                              ; preds = %entry, %body
  %i = phi i64 [ 0, %entry ], [ %next, %body ]
  %cond = icmp ule i64 %i, 15
  br i1 %cond, label %body, label %exit

body:                                             ; preds = %for
  %pstate = getelementptr inbounds i8, i8* %state, i64 %i
  %pkey = getelementptr inbounds i8, i8* %round_key, i64 %i
  %bstate = load i8, i8* %pstate, align 1
  %bkey = load i8, i8* %pkey, align 1
  %bxor = xor i8 %bstate, %bkey
  store i8 %bxor, i8* %pstate, align 1
  %next = add i64 %i, 1
  br label %for

exit:                                             ; preds = %for
  ret void
}