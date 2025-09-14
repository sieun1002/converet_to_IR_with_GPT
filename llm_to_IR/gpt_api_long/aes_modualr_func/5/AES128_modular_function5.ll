; ModuleID = '_sub_bytes'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: _sub_bytes  ; Address: 0x1274
; Intent: In-place AES SubBytes over 16-byte state (confidence=0.92). Evidence: 16-iteration byte loop; per-byte call to sbox_lookup and store back.
; Preconditions: %buf points to at least 16 writable bytes.
; Postconditions: For i in [0,15], buf[i] := sbox_lookup(buf[i]).

declare i8 @sbox_lookup(i32)

define dso_local void @_sub_bytes(i8* %buf) local_unnamed_addr {
entry:
  br label %cond

cond:                                             ; preds = %entry, %body
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %cond
  %idx64 = zext i32 %i to i64
  %p = getelementptr inbounds i8, i8* %buf, i64 %idx64
  %b = load i8, i8* %p, align 1
  %b32 = zext i8 %b to i32
  %sb = call i8 @sbox_lookup(i32 %b32)
  store i8 %sb, i8* %p, align 1
  %inc = add nuw nsw i32 %i, 1
  br label %cond

exit:                                             ; preds = %cond
  ret void
}