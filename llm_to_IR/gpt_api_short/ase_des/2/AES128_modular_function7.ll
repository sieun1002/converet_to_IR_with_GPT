; ModuleID = 'mix_columns'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: mix_columns ; Address: 0x13CD
; Intent: AES MixColumns on 16-byte state in place (confidence=0.98). Evidence: 4x4-byte columns, xtime calls, XOR pattern matching AES mix.
; Preconditions: state points to at least 16 bytes.
; Postconditions: state mutated with MixColumns transform.

; Only the necessary external declarations:
declare i8 @xtime(i32)

define dso_local void @mix_columns(i8* %state) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; i in [0,3]
  %i = phi i32 [ 0, %entry ], [ %i.next, %body_end ]
  %cmp = icmp sle i32 %i, 3
  br i1 %cmp, label %body, label %exit

body:
  %off = mul i32 %i, 4
  %base = getelementptr inbounds i8, i8* %state, i32 %off
  %p0 = %base
  %p1 = getelementptr inbounds i8, i8* %base, i32 1
  %p2 = getelementptr inbounds i8, i8* %base, i32 2
  %p3 = getelementptr inbounds i8, i8* %base, i32 3

  %s0 = load i8, i8* %p0, align 1
  %s1 = load i8, i8* %p1, align 1
  %s2 = load i8, i8* %p2, align 1
  %s3 = load i8, i8* %p3, align 1

  %t01 = xor i8 %s0, %s1
  %t012 = xor i8 %t01, %s2
  %t = xor i8 %t012, %s3

  ; out0 = s0 ^ xtime(s0 ^ s1) ^ t
  %x01 = xor i8 %s0, %s1
  %x01.z = zext i8 %x01 to i32
  %xt01 = call i8 @xtime(i32 %x01.z)
  %tmp0 = xor i8 %xt01, %t
  %out0 = xor i8 %tmp0, %s0
  store i8 %out0, i8* %p0, align 1

  ; out1 = s1 ^ xtime(s1 ^ s2) ^ t
  %x12 = xor i8 %s1, %s2
  %x12.z = zext i8 %x12 to i32
  %xt12 = call i8 @xtime(i32 %x12.z)
  %tmp1 = xor i8 %xt12, %t
  %out1 = xor i8 %tmp1, %s1
  store i8 %out1, i8* %p1, align 1

  ; out2 = s2 ^ xtime(s2 ^ s3) ^ t
  %x23 = xor i8 %s2, %s3
  %x23.z = zext i8 %x23 to i32
  %xt23 = call i8 @xtime(i32 %x23.z)
  %tmp2 = xor i8 %xt23, %t
  %out2 = xor i8 %tmp2, %s2
  store i8 %out2, i8* %p2, align 1

  ; out3 = s3 ^ xtime(s3 ^ s0) ^ t
  %x30 = xor i8 %s3, %s0
  %x30.z = zext i8 %x30 to i32
  %xt30 = call i8 @xtime(i32 %x30.z)
  %tmp3 = xor i8 %xt30, %t
  %out3 = xor i8 %tmp3, %s3
  store i8 %out3, i8* %p3, align 1

body_end:
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:
  ret void
}