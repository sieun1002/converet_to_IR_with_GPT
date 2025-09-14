; ModuleID = 'mix_columns'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: mix_columns ; Address: 0x13CD
; Intent: AES MixColumns on 16-byte state in-place (confidence=0.98). Evidence: 4-byte column processing; xtime(sX^sY) ^ (s0^s1^s2^s3) pattern
; Preconditions: state points to at least 16 writable bytes
; Postconditions: state transformed by AES MixColumns

; Only the necessary external declarations:
declare zeroext i8 @xtime(i32)

define dso_local void @mix_columns(i8* nocapture %state) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %latch ]
  %cmp = icmp sle i32 %i, 3
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx0 = shl i32 %i, 2
  %idx0.z = zext i32 %idx0 to i64
  %p0 = getelementptr inbounds i8, i8* %state, i64 %idx0.z
  %p1 = getelementptr inbounds i8, i8* %p0, i64 1
  %p2 = getelementptr inbounds i8, i8* %p0, i64 2
  %p3 = getelementptr inbounds i8, i8* %p0, i64 3
  %s0 = load i8, i8* %p0, align 1
  %s1 = load i8, i8* %p1, align 1
  %s2 = load i8, i8* %p2, align 1
  %s3 = load i8, i8* %p3, align 1
  %t01 = xor i8 %s0, %s1
  %t23 = xor i8 %s2, %s3
  %t = xor i8 %t01, %t23
  ; byte 0
  %x01 = xor i8 %s0, %s1
  %x01.z = zext i8 %x01 to i32
  %r0 = call zeroext i8 @xtime(i32 %x01.z)
  %tmp0 = xor i8 %r0, %t
  %new0 = xor i8 %s0, %tmp0
  store i8 %new0, i8* %p0, align 1
  ; byte 1
  %x12 = xor i8 %s1, %s2
  %x12.z = zext i8 %x12 to i32
  %r1 = call zeroext i8 @xtime(i32 %x12.z)
  %tmp1 = xor i8 %r1, %t
  %new1 = xor i8 %s1, %tmp1
  store i8 %new1, i8* %p1, align 1
  ; byte 2
  %x23 = xor i8 %s2, %s3
  %x23.z = zext i8 %x23 to i32
  %r2 = call zeroext i8 @xtime(i32 %x23.z)
  %tmp2 = xor i8 %r2, %t
  %new2 = xor i8 %s2, %tmp2
  store i8 %new2, i8* %p2, align 1
  ; byte 3
  %x30 = xor i8 %s3, %s0
  %x30.z = zext i8 %x30 to i32
  %r3 = call zeroext i8 @xtime(i32 %x30.z)
  %tmp3 = xor i8 %r3, %t
  %new3 = xor i8 %s3, %tmp3
  store i8 %new3, i8* %p3, align 1
  br label %latch

latch:                                            ; preds = %body
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}