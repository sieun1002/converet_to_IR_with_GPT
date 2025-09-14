; ModuleID = '_sub_bytes'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: _sub_bytes  ; Address: 0x1274
; Intent: Apply AES SubBytes (S-box) in-place to 16-byte state (confidence=0.95). Evidence: name "_sub_bytes"; loop over 16 bytes calling sbox_lookup.
; Preconditions: %buf points to at least 16 writable bytes.
; Postconditions: For i in [0,15], buf[i] = sbox_lookup(buf[i]) & 0xFF.

; Only the needed extern declarations:
declare i32 @sbox_lookup(i32)

define dso_local void @_sub_bytes(i8* %buf) local_unnamed_addr {
entry:
  br label %cond

cond:                                             ; preds = %body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %body ]
  %cmp = icmp sle i64 %i, 15
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %cond
  %ptr = getelementptr inbounds i8, i8* %buf, i64 %i
  %byte = load i8, i8* %ptr, align 1
  %ext = zext i8 %byte to i32
  %call = call i32 @sbox_lookup(i32 %ext)
  %res8 = trunc i32 %call to i8
  store i8 %res8, i8* %ptr, align 1
  %i.next = add nuw nsw i64 %i, 1
  br label %cond

exit:                                             ; preds = %cond
  ret void
}