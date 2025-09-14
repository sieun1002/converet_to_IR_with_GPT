; ModuleID = '_sub_bytes'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: _sub_bytes  ; Address: 0x1274
; Intent: In-place AES SubBytes on a 16-byte buffer (confidence=0.95). Evidence: loop over 16 bytes; calls sbox_lookup and writes back.
; Preconditions: %buf points to at least 16 writable bytes.
; Postconditions: For i in [0,15], buf[i] := sbox_lookup(buf[i]).

; Only the needed extern declarations:
declare i8 @sbox_lookup(i32)

define dso_local void @_sub_bytes(i8* %buf) local_unnamed_addr {
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:
  %idx.ext = sext i32 %i to i64
  %p = getelementptr inbounds i8, i8* %buf, i64 %idx.ext
  %v = load i8, i8* %p, align 1
  %v.z = zext i8 %v to i32
  %s = call i8 @sbox_lookup(i32 %v.z)
  store i8 %s, i8* %p, align 1
  %inc = add nsw i32 %i, 1
  br label %loop

exit:
  ret void
}