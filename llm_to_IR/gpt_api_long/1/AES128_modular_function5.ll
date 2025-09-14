; ModuleID = '_sub_bytes'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: _sub_bytes  ; Address: 0x1274
; Intent: In-place AES SubBytes on a 16-byte state buffer (confidence=0.95). Evidence: loop over 16 bytes; call to sbox_lookup; write back each byte.
; Preconditions: %state points to at least 16 writable bytes.
; Postconditions: For i in [0,15], state[i] := sbox_lookup(state[i]).

declare zeroext i8 @sbox_lookup(i32)

define dso_local void @_sub_bytes(i8* %state) local_unnamed_addr {
entry:
  br label %loop.body

loop.body:                                           ; preds = %entry, %loop.body
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %idx64 = sext i32 %i to i64
  %p = getelementptr inbounds i8, i8* %state, i64 %idx64
  %b = load i8, i8* %p, align 1
  %b32 = zext i8 %b to i32
  %sb = call zeroext i8 @sbox_lookup(i32 %b32)
  store i8 %sb, i8* %p, align 1
  %i.next = add nuw nsw i32 %i, 1
  %cont = icmp sle i32 %i.next, 15
  br i1 %cont, label %loop.body, label %exit

exit:
  ret void
}