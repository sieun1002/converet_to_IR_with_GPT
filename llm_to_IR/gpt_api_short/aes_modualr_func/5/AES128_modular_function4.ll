; ModuleID = 'add_round_key'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: add_round_key ; Address: 0x121A
; Intent: XOR 16 bytes of state with round key in place (confidence=0.98). Evidence: loop i=0..15, byte-wise load/xor/store to first pointer.
; Preconditions: state and round_key each valid for at least 16 bytes; state writable.
; Postconditions: for i in [0,15], state[i] = state[i] xor round_key[i].

; Only the necessary external declarations:
; (none)

define dso_local void @add_round_key(i8* %state, i8* %round_key) local_unnamed_addr {
entry:
  br label %check

check:
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:
  %state_ptr_i = getelementptr inbounds i8, i8* %state, i32 %i
  %s = load i8, i8* %state_ptr_i, align 1
  %rk_ptr_i = getelementptr inbounds i8, i8* %round_key, i32 %i
  %k = load i8, i8* %rk_ptr_i, align 1
  %x = xor i8 %s, %k
  store i8 %x, i8* %state_ptr_i, align 1
  %inc = add nsw i32 %i, 1
  br label %check

exit:
  ret void
}