; ModuleID = '_sub_bytes'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: _sub_bytes ; Address: 0x1274
; Intent: AES SubBytes transform on a 16-byte state (in-place) (confidence=0.95). Evidence: calls sbox_lookup; iterates indices 0..15
; Preconditions: arg points to at least 16 writable bytes
; Postconditions: for i in [0,15], arg[i] = sbox_lookup(arg[i])

; Only the necessary external declarations:
declare i8 @sbox_lookup(i32)

define dso_local void @_sub_bytes(i8* noundef %p) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %entry, %body
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx.ext = zext i32 %i to i64
  %ptr = getelementptr inbounds i8, i8* %p, i64 %idx.ext
  %b = load i8, i8* %ptr, align 1
  %bext = zext i8 %b to i32
  %res = call i8 @sbox_lookup(i32 %bext)
  store i8 %res, i8* %ptr, align 1
  %inc = add nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}