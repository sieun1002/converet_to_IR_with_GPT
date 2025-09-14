; ModuleID = '_sub_bytes'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: _sub_bytes ; Address: 0x1274
; Intent: In-place AES SubBytes on 16-byte state (confidence=0.95). Evidence: loops 16 bytes; calls sbox_lookup on each byte and stores result
; Preconditions: state points to at least 16 writable bytes
; Postconditions: state[0..15] replaced by sbox_lookup(state[i])

; Only the necessary external declarations:
declare zeroext i8 @sbox_lookup(i32)

define dso_local void @_sub_bytes(i8* nocapture %state) local_unnamed_addr {
entry:
  br label %loop.body

loop.body:                                           ; preds = %entry, %loop.latch
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %idx.ext = sext i32 %i to i64
  %ptr = getelementptr inbounds i8, i8* %state, i64 %idx.ext
  %val = load i8, i8* %ptr, align 1
  %val.z = zext i8 %val to i32
  %sb = call zeroext i8 @sbox_lookup(i32 %val.z)
  store i8 %sb, i8* %ptr, align 1
  br label %loop.latch

loop.latch:                                          ; preds = %loop.body
  %i.next = add nuw nsw i32 %i, 1
  %cond = icmp sle i32 %i.next, 15
  br i1 %cond, label %loop.body, label %exit

exit:                                                ; preds = %loop.latch
  ret void
}