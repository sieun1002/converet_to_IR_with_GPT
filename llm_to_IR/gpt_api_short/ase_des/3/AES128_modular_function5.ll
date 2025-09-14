; ModuleID = '_sub_bytes'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: _sub_bytes ; Address: 0x1274
; Intent: Apply AES S-box substitution to 16-byte state in place (confidence=0.95). Evidence: loop over 16 bytes; call to sbox_lookup on each byte
; Preconditions: state points to at least 16 writable bytes
; Postconditions: For i=0..15, state[i] = sbox_lookup(state[i])

; Only the necessary external declarations:
declare zeroext i8 @sbox_lookup(i32)

define dso_local void @_sub_bytes(i8* nocapture %state) local_unnamed_addr {
entry:
  br label %check

check:
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:
  %idx.ext = zext i32 %i to i64
  %ptr = getelementptr inbounds i8, i8* %state, i64 %idx.ext
  %b = load i8, i8* %ptr, align 1
  %b.ext = zext i8 %b to i32
  %sb = call zeroext i8 @sbox_lookup(i32 %b.ext)
  store i8 %sb, i8* %ptr, align 1
  %i.next = add nuw nsw i32 %i, 1
  br label %check

exit:
  ret void
}