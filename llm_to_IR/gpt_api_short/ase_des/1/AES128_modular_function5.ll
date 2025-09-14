; ModuleID = '_sub_bytes'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: _sub_bytes ; Address: 0x1274
; Intent: In-place S-box substitution on a 16-byte buffer (confidence=0.85). Evidence: call to sbox_lookup with each byte; loop over indices 0..15 inclusive
; Preconditions: buf points to at least 16 writable bytes
; Postconditions: For i in [0,15], buf[i] = trunc_i8(sbox_lookup(zext_i32(buf[i])))

; Only the necessary external declarations:
declare i32 @sbox_lookup(i32) local_unnamed_addr

define dso_local void @_sub_bytes(i8* nocapture %buf) local_unnamed_addr {
entry:
  br label %cond

cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:
  %idx64 = sext i32 %i to i64
  %p = getelementptr inbounds i8, i8* %buf, i64 %idx64
  %b = load i8, i8* %p, align 1
  %bext = zext i8 %b to i32
  %r = call i32 @sbox_lookup(i32 %bext)
  %r8 = trunc i32 %r to i8
  store i8 %r8, i8* %p, align 1
  %inc = add nsw i32 %i, 1
  br label %cond

exit:
  ret void
}