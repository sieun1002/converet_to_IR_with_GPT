; ModuleID = 'add_round_key'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: add_round_key ; Address: 0x121A
; Intent: AES AddRoundKey: XOR 16-byte state with 16-byte round key in place (confidence=0.98). Evidence: loop 0..15; bytewise XOR from two buffers writing to first
; Preconditions: state and key each reference at least 16 bytes
; Postconditions: state[i] = state[i] XOR key[i] for i in [0,15]

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @add_round_key(i8* %state, i8* %key) local_unnamed_addr {
entry:
  br label %cond

cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp sle i64 %i, 15
  br i1 %cmp, label %body, label %exit

body:
  %state.ptr = getelementptr inbounds i8, i8* %state, i64 %i
  %key.ptr = getelementptr inbounds i8, i8* %key, i64 %i
  %a = load i8, i8* %state.ptr, align 1
  %b = load i8, i8* %key.ptr, align 1
  %x = xor i8 %a, %b
  store i8 %x, i8* %state.ptr, align 1
  br label %inc

inc:
  %i.next = add nuw nsw i64 %i, 1
  br label %cond

exit:
  ret void
}