; ModuleID = 'add_round_key'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: add_round_key ; Address: 0x121A
; Intent: In-place XOR of 16-byte buffer with 16-byte key (AES AddRoundKey) (confidence=0.95). Evidence: loop 0..15, byte-wise XOR, write back to first pointer
; Preconditions: Both pointers valid for at least 16 bytes
; Postconditions: For i in [0,15], dst[i] := dst[i] XOR src[i]

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @add_round_key(i8* %dst, i8* %src) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %body ]
  %cmp = icmp ule i64 %i, 15
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %p_dst = getelementptr inbounds i8, i8* %dst, i64 %i
  %v_dst = load i8, i8* %p_dst, align 1
  %p_src = getelementptr inbounds i8, i8* %src, i64 %i
  %v_src = load i8, i8* %p_src, align 1
  %xor = xor i8 %v_dst, %v_src
  store i8 %xor, i8* %p_dst, align 1
  %inc = add nuw nsw i64 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}