; ModuleID = 'add_round_key'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: add_round_key ; Address: 0x121a
; Intent: XOR 16-byte round key into state in-place (AES AddRoundKey) (confidence=0.95). Evidence: 16-iteration bytewise XOR; writes back to first buffer.
; Preconditions: state and roundkey point to at least 16 readable bytes; state is writable for 16 bytes.
; Postconditions: state[i] = state[i] XOR roundkey[i] for i in [0,15].

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local void @add_round_key(i8* nocapture %state, i8* nocapture readonly %roundkey) local_unnamed_addr {
entry:
  br label %check

check:                                            ; preds = %entry, %body
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %check
  %idx = zext i32 %i to i64
  %p_state = getelementptr inbounds i8, i8* %state, i64 %idx
  %p_round = getelementptr inbounds i8, i8* %roundkey, i64 %idx
  %sval = load i8, i8* %p_state, align 1
  %rval = load i8, i8* %p_round, align 1
  %x = xor i8 %sval, %rval
  store i8 %x, i8* %p_state, align 1
  %inc = add nuw nsw i32 %i, 1
  br label %check

exit:                                             ; preds = %check
  ret void
}