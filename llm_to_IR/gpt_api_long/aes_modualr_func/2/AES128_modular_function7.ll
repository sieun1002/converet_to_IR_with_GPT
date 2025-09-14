; ModuleID = 'mix_columns'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: mix_columns  ; Address: 0x13CD
; Intent: AES MixColumns on 16-byte state in place (confidence=0.95). Evidence: xtime usage; 4-iteration column-wise GF(2^8) mix pattern
; Preconditions: %state points to at least 16 bytes
; Postconditions: %state is transformed by AES MixColumns

; Only the needed extern declarations:
declare i32 @xtime(i32)

define dso_local void @mix_columns(i8* %state) local_unnamed_addr {
entry:
  br label %cond

cond:                                             ; preds = %latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %latch ]
  %cmp = icmp sle i32 %i, 3
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %cond
  %base_off32 = shl i32 %i, 2
  %base_off = sext i32 %base_off32 to i64
  %p0 = getelementptr i8, i8* %state, i64 %base_off
  %off1 = add i64 %base_off, 1
  %p1 = getelementptr i8, i8* %state, i64 %off1
  %off2 = add i64 %base_off, 2
  %p2 = getelementptr i8, i8* %state, i64 %off2
  %off3 = add i64 %base_off, 3
  %p3 = getelementptr i8, i8* %state, i64 %off3

  %a = load i8, i8* %p0, align 1
  %b = load i8, i8* %p1, align 1
  %c = load i8, i8* %p2, align 1
  %d = load i8, i8* %p3, align 1

  %abct = xor i8 %a, %b
  %abct1 = xor i8 %abct, %c
  %t = xor i8 %abct1, %d

  ; r0 = a ^ t ^ xtime(a ^ b)
  %ab0 = xor i8 %a, %b
  %ab0_z = zext i8 %ab0 to i32
  %xt0_i32 = call i32 @xtime(i32 %ab0_z)
  %xt0 = trunc i32 %xt0_i32 to i8
  %r0_tmp = xor i8 %t, %xt0
  %r0 = xor i8 %a, %r0_tmp

  ; r1 = b ^ t ^ xtime(b ^ c)
  %bc1 = xor i8 %b, %c
  %bc1_z = zext i8 %bc1 to i32
  %xt1_i32 = call i32 @xtime(i32 %bc1_z)
  %xt1 = trunc i32 %xt1_i32 to i8
  %r1_tmp = xor i8 %t, %xt1
  %r1 = xor i8 %b, %r1_tmp

  ; r2 = c ^ t ^ xtime(c ^ d)
  %cd2 = xor i8 %c, %d
  %cd2_z = zext i8 %cd2 to i32
  %xt2_i32 = call i32 @xtime(i32 %cd2_z)
  %xt2 = trunc i32 %xt2_i32 to i8
  %r2_tmp = xor i8 %t, %xt2
  %r2 = xor i8 %c, %r2_tmp

  ; r3 = d ^ t ^ xtime(d ^ a)
  %da3 = xor i8 %d, %a
  %da3_z = zext i8 %da3 to i32
  %xt3_i32 = call i32 @xtime(i32 %da3_z)
  %xt3 = trunc i32 %xt3_i32 to i8
  %r3_tmp = xor i8 %t, %xt3
  %r3 = xor i8 %d, %r3_tmp

  store i8 %r0, i8* %p0, align 1
  store i8 %r1, i8* %p1, align 1
  store i8 %r2, i8* %p2, align 1
  store i8 %r3, i8* %p3, align 1
  br label %latch

latch:                                            ; preds = %body
  %i.next = add nsw i32 %i, 1
  br label %cond

exit:                                             ; preds = %cond
  ret void
}