; ModuleID = '_sub_bytes'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: _sub_bytes  ; Address: 0x1274
; Intent: Apply AES S-box (SubBytes) in-place to a 16-byte state (confidence=0.95). Evidence: call to sbox_lookup; loop over 16 bytes.
; Preconditions: %state points to at least 16 writable bytes.
; Postconditions: Each of the 16 bytes at %state is replaced by sbox_lookup(old_byte).

declare zeroext i8 @sbox_lookup(i32)

define dso_local void @_sub_bytes(i8* %state) local_unnamed_addr {
entry:
  br label %cond

cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:
  %idx64 = zext i32 %i to i64
  %p = getelementptr inbounds i8, i8* %state, i64 %idx64
  %b = load i8, i8* %p, align 1
  %b32 = zext i8 %b to i32
  %sb = call zeroext i8 @sbox_lookup(i32 %b32)
  store i8 %sb, i8* %p, align 1
  %inc = add nuw nsw i32 %i, 1
  br label %cond

exit:
  ret void
}