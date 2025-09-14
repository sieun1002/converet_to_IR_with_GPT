; ModuleID = '_sub_bytes'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: _sub_bytes ; Address: 0x1274
; Intent: In-place S-box substitution over 16 bytes (AES-like) (confidence=0.98). Evidence: loop over indices 0..15, call to sbox_lookup(byte) with result stored back.
; Preconditions: buf points to at least 16 writable bytes.
; Postconditions: For i in [0,15], buf[i] = sbox_lookup(buf[i]).

; Only the necessary external declarations:
declare zeroext i8 @sbox_lookup(i32)

define dso_local void @_sub_bytes(i8* nocapture noundef %buf) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:                                           ; i in [0..15]
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %exit

loop.body:
  %idx = zext i32 %i to i64
  %p = getelementptr inbounds i8, i8* %buf, i64 %idx
  %b = load i8, i8* %p, align 1
  %b32 = zext i8 %b to i32
  %sb = call zeroext i8 @sbox_lookup(i32 %b32)
  store i8 %sb, i8* %p, align 1
  %inc = add nsw i32 %i, 1
  br label %loop.cond

exit:
  ret void
}