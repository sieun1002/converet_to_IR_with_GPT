; ModuleID = '_sub_bytes'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: _sub_bytes  ; Address: 0x1274
; Intent: Apply S-box substitution to 16-byte buffer in place (AES SubBytes) (confidence=0.95). Evidence: loop over 16 bytes; call to sbox_lookup and byte-wise store.
; Preconditions: %buf points to at least 16 writable bytes.
; Postconditions: For i in [0,15], buf[i] = sbox_lookup(buf[i]).

declare zeroext i8 @sbox_lookup(i32)

define dso_local void @_sub_bytes(i8* %buf) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %idx64 = zext i32 %i to i64
  %ptr = getelementptr inbounds i8, i8* %buf, i64 %idx64
  %val = load i8, i8* %ptr, align 1
  %val.z = zext i8 %val to i32
  %sub = call zeroext i8 @sbox_lookup(i32 %val.z)
  store i8 %sub, i8* %ptr, align 1
  %i.next = add nsw i32 %i, 1
  br label %loop.cond

exit:
  ret void
}