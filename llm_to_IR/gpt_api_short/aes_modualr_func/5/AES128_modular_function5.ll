; ModuleID = '_sub_bytes'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: _sub_bytes ; Address: 0x1274
; Intent: In-place S-box substitution on 16-byte buffer (confidence=0.9). Evidence: loop over indices 0..15; call to sbox_lookup on each byte and store back.
; Preconditions: buf points to at least 16 writable bytes
; Postconditions: buf[i] = sbox_lookup(buf[i]) for i in [0,15]

; Only the necessary external declarations:
declare i32 @sbox_lookup(i32) local_unnamed_addr

define dso_local void @_sub_bytes(i8* noundef %buf) local_unnamed_addr {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %i.ext = sext i32 %i to i64
  %ptr = getelementptr inbounds i8, i8* %buf, i64 %i.ext
  %val = load i8, i8* %ptr, align 1
  %val.z = zext i8 %val to i32
  %sb = call i32 @sbox_lookup(i32 %val.z)
  %sb.trunc = trunc i32 %sb to i8
  store i8 %sb.trunc, i8* %ptr, align 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}